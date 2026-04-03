package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.GenreDao;
import ar.edu.itba.paw.interfaces.persistence.ObraDao;
import ar.edu.itba.paw.interfaces.persistence.PlayPetitionDao;
import ar.edu.itba.paw.interfaces.persistence.ProductionDao;
import ar.edu.itba.paw.interfaces.services.ImageService;
import ar.edu.itba.paw.interfaces.services.MailService;
import ar.edu.itba.paw.interfaces.services.PlayPetitionService;
import ar.edu.itba.paw.models.Genre;
import ar.edu.itba.paw.models.Image;
import ar.edu.itba.paw.models.Obra;
import ar.edu.itba.paw.models.PetitionStatus;
import ar.edu.itba.paw.models.PlayPetition;
import ar.edu.itba.paw.models.Production;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Service
public class PlayPetitionServiceImpl implements PlayPetitionService {

    private static final String DEFAULT_LANGUAGE = "Castellano";
    private static final String DEFAULT_IMAGE_CONTENT_TYPE = "image/jpeg";

    private final PlayPetitionDao playPetitionDao;
    private final GenreDao genreDao;
    private final ImageService imageService;
    private final ObraDao obraDao;
    private final ProductionDao productionDao;
    private final MailService mailService;

    @Autowired
    public PlayPetitionServiceImpl(final PlayPetitionDao playPetitionDao,
                                   final GenreDao genreDao,
                                   final ImageService imageService,
                                   final ObraDao obraDao,
                                   final ProductionDao productionDao,
                                   final MailService mailService) {
        this.playPetitionDao = playPetitionDao;
        this.genreDao = genreDao;
        this.imageService = imageService;
        this.obraDao = obraDao;
        this.productionDao = productionDao;
        this.mailService = mailService;
    }

    @Override
    public PlayPetition create(final String title, final String synopsis, final int durationMinutes,
                               final List<Long> genreIds, final String theater, final String theaterAddress,
                               final LocalDate startDate, final LocalDate endDate, final String coverImageContentType,
                               final byte[] coverImage, final String director, final String petitionerEmail,
                               final String schedule, final String ticketUrl, final String language) {
        validateCreateRequest(title, synopsis, durationMinutes, genreIds, theater, theaterAddress,
                startDate, endDate, coverImage, director, petitionerEmail);

        final List<Long> normalizedGenreIds = new ArrayList<>(genreIds);
        final List<Genre> genres = genreDao.findByIds(normalizedGenreIds);
        if (genres.size() != normalizedGenreIds.size()) {
            throw new IllegalArgumentException("Selected genres are invalid");
        }

        final Image image = imageService.create(
                hasText(coverImageContentType) ? coverImageContentType : DEFAULT_IMAGE_CONTENT_TYPE,
                coverImage
        );

        final PlayPetition created = playPetitionDao.create(
                title.trim(),
                synopsis.trim(),
                durationMinutes,
                theater.trim(),
                theaterAddress.trim(),
                startDate,
                endDate,
                image.getId(),
                director.trim(),
                petitionerEmail.trim(),
                trimToNull(schedule),
                trimToNull(ticketUrl),
                hasText(language) ? language.trim() : DEFAULT_LANGUAGE
        );

        playPetitionDao.addGenres(created.getId(), normalizedGenreIds);
        final PlayPetition petitionWithGenres = withGenres(created, genres);
        mailService.sendPetitionConfirmation(petitionWithGenres);
        return petitionWithGenres;
    }

    @Override
    public Optional<PlayPetition> findById(final long id) {
        return playPetitionDao.findById(id).map(this::loadGenres);
    }

    @Override
    public List<PlayPetition> findAll(final int page, final int pageSize) {
        return loadGenres(playPetitionDao.findAll(page, pageSize));
    }

    @Override
    public List<PlayPetition> findByStatus(final PetitionStatus status, final int page, final int pageSize) {
        return loadGenres(playPetitionDao.findByStatus(status, page, pageSize));
    }

    @Override
    public void approve(final long petitionId, final String adminNotes) {
        final PlayPetition petition = findExistingPendingPetition(petitionId);
        final String genreLabel = joinGenres(petition.getGenres());
        final Obra obra = obraDao.create(petition.getTitle(), petition.getSynopsis(), genreLabel);
        final Production production = productionDao.create(
                petition.getTitle(),
                obra.getId(),
                null,
                petition.getSynopsis(),
                petition.getDirector(),
                petition.getTheater(),
                petition.getStartDate(),
                petition.getEndDate(),
                petition.getCoverImageId() != null ? "/petition-images/" + petition.getCoverImageId() : null,
                null,
                petition.getTicketUrl()
        );

        playPetitionDao.updateStatus(petitionId, PetitionStatus.APPROVED, trimToNull(adminNotes));
        playPetitionDao.setCreatedEntities(petitionId, obra.getId(), production.getId());
        final PlayPetition updated = findById(petitionId).orElseThrow(() -> new IllegalStateException("Petition not found after approval"));
        mailService.sendPetitionApproved(updated);
    }

    @Override
    public void reject(final long petitionId, final String adminNotes) {
        findExistingPendingPetition(petitionId);
        playPetitionDao.updateStatus(petitionId, PetitionStatus.REJECTED, trimToNull(adminNotes));
        final PlayPetition updated = findById(petitionId).orElseThrow(() -> new IllegalStateException("Petition not found after rejection"));
        mailService.sendPetitionRejected(updated);
    }

    @Override
    public int countByStatus(final PetitionStatus status) {
        return playPetitionDao.countByStatus(status);
    }

    @Override
    public int countAll() {
        return playPetitionDao.countAll();
    }

    private void validateCreateRequest(final String title, final String synopsis, final int durationMinutes,
                                       final List<Long> genreIds, final String theater, final String theaterAddress,
                                       final LocalDate startDate, final LocalDate endDate, final byte[] coverImage,
                                       final String director, final String petitionerEmail) {
        if (!hasText(title) || !hasText(synopsis) || durationMinutes <= 0 || !hasText(theater)
                || !hasText(theaterAddress) || startDate == null || !hasText(director)
                || !hasText(petitionerEmail) || genreIds == null || genreIds.isEmpty()
                || coverImage == null || coverImage.length == 0) {
            throw new IllegalArgumentException("Missing required petition fields");
        }
        if (endDate != null && endDate.isBefore(startDate)) {
            throw new IllegalArgumentException("End date cannot be before start date");
        }
    }

    private PlayPetition findExistingPendingPetition(final long petitionId) {
        final PlayPetition petition = findById(petitionId)
                .orElseThrow(() -> new IllegalArgumentException("Petition not found"));
        if (petition.getStatus() != PetitionStatus.PENDING) {
            throw new IllegalStateException("Petition was already resolved");
        }
        return petition;
    }

    private List<PlayPetition> loadGenres(final List<PlayPetition> petitions) {
        final List<PlayPetition> loaded = new ArrayList<>(petitions.size());
        for (final PlayPetition petition : petitions) {
            loaded.add(loadGenres(petition));
        }
        return loaded;
    }

    private PlayPetition loadGenres(final PlayPetition petition) {
        return withGenres(petition, genreDao.findByPetitionId(petition.getId()));
    }

    private PlayPetition withGenres(final PlayPetition petition, final List<Genre> genres) {
        return new PlayPetition(
                petition.getId(),
                petition.getTitle(),
                petition.getSynopsis(),
                petition.getDurationMinutes(),
                petition.getTheater(),
                petition.getTheaterAddress(),
                petition.getStartDate(),
                petition.getEndDate(),
                petition.getCoverImageId(),
                petition.getDirector(),
                petition.getPetitionerEmail(),
                petition.getSchedule(),
                petition.getTicketUrl(),
                petition.getLanguage(),
                petition.getStatus(),
                petition.getAdminNotes(),
                petition.getCreatedAt(),
                petition.getResolvedAt(),
                petition.getCreatedObraId(),
                petition.getCreatedProductionId(),
                Collections.unmodifiableList(new ArrayList<>(genres))
        );
    }

    private String joinGenres(final List<Genre> genres) {
        final StringBuilder builder = new StringBuilder();
        for (final Genre genre : genres) {
            if (builder.length() > 0) {
                builder.append(", ");
            }
            builder.append(genre.getName());
        }
        return builder.toString();
    }

    private boolean hasText(final String value) {
        return value != null && !value.trim().isEmpty();
    }

    private String trimToNull(final String value) {
        return hasText(value) ? value.trim() : null;
    }
}
