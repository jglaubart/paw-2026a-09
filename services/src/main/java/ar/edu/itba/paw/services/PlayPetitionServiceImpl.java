package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.GenreDao;
import ar.edu.itba.paw.interfaces.persistence.ObraDao;
import ar.edu.itba.paw.interfaces.persistence.PlayPetitionDao;
import ar.edu.itba.paw.interfaces.persistence.ProductionDao;
import ar.edu.itba.paw.interfaces.persistence.ProductoraMemberDao;
import ar.edu.itba.paw.interfaces.persistence.ShowDao;
import ar.edu.itba.paw.interfaces.services.ImageService;
import ar.edu.itba.paw.interfaces.services.MailService;
import ar.edu.itba.paw.interfaces.services.PlayPetitionService;
import ar.edu.itba.paw.models.Genre;
import ar.edu.itba.paw.models.Image;
import ar.edu.itba.paw.models.Obra;
import ar.edu.itba.paw.models.PetitionFieldFeedback;
import ar.edu.itba.paw.models.PetitionObraPrefill;
import ar.edu.itba.paw.models.PetitionObraSuggestion;
import ar.edu.itba.paw.models.PetitionStatus;
import ar.edu.itba.paw.models.PlayPetition;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.ProductionSearchCriteria;
import ar.edu.itba.paw.models.ProductoraMember;
import ar.edu.itba.paw.models.Show;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

@Service
public class PlayPetitionServiceImpl implements PlayPetitionService {

    private static final String DEFAULT_LANGUAGE = "Castellano";
    private static final String DEFAULT_IMAGE_CONTENT_TYPE = "image/jpeg";
    private static final LocalTime DEFAULT_SHOW_TIME = LocalTime.of(20, 0);
    private static final int DEFAULT_AUTOCOMPLETE_LIMIT = 8;

    private static final Set<String> REVIEWABLE_FIELDS;

    static {
        final Set<String> fields = new LinkedHashSet<>();
        fields.add("title");
        fields.add("synopsis");
        fields.add("genreIds");
        fields.add("durationMinutes");
        fields.add("language");
        fields.add("theater");
        fields.add("theaterAddress");
        fields.add("startDate");
        fields.add("endDate");
        fields.add("additionalShowDates");
        fields.add("director");
        fields.add("coverImage");
        fields.add("schedule");
        fields.add("ticketUrl");
        REVIEWABLE_FIELDS = Collections.unmodifiableSet(fields);
    }

    private final PlayPetitionDao playPetitionDao;
    private final GenreDao genreDao;
    private final ImageService imageService;
    private final ObraDao obraDao;
    private final ProductionDao productionDao;
    private final ShowDao showDao;
    private final MailService mailService;
    private final ProductoraMemberDao productoraMemberDao;

    @Autowired
    public PlayPetitionServiceImpl(final PlayPetitionDao playPetitionDao,
                                   final GenreDao genreDao,
                                   final ImageService imageService,
                                   final ObraDao obraDao,
                                   final ProductionDao productionDao,
                                   final ShowDao showDao,
                                   final MailService mailService,
                                   final ProductoraMemberDao productoraMemberDao) {
        this.playPetitionDao = playPetitionDao;
        this.genreDao = genreDao;
        this.imageService = imageService;
        this.obraDao = obraDao;
        this.productionDao = productionDao;
        this.showDao = showDao;
        this.mailService = mailService;
        this.productoraMemberDao = productoraMemberDao;
    }

    @Override
    public PlayPetition create(final String title, final String synopsis, final int durationMinutes,
                               final List<Long> genreIds, final String theater, final String theaterAddress,
                               final LocalDate startDate, final LocalDate endDate,
                               final String coverImageContentType, final byte[] coverImage,
                               final Long existingCoverImageId, final List<LocalDate> additionalShowDates,
                               final String director, final long petitionerUserId,
                               final String petitionerEmail, final String schedule,
                               final String ticketUrl, final String language,
                               final Long sourceObraId, final Long sourceProductionId) {
        final List<Long> normalizedGenreIds = new ArrayList<>(genreIds != null ? genreIds : Collections.<Long>emptyList());
        final List<Genre> genres = resolveGenres(normalizedGenreIds);
        validateSaveRequest(title, synopsis, durationMinutes, normalizedGenreIds, theater, theaterAddress,
                startDate, endDate, coverImage, existingCoverImageId, director, petitionerUserId,
                petitionerEmail, sourceObraId, sourceProductionId);

        final Long coverImageId = resolveCoverImageId(coverImageContentType, coverImage, existingCoverImageId);
        final List<LocalDate> normalizedShowDates = normalizeAdditionalShowDates(startDate, endDate, additionalShowDates);
        final PlayPetition created = playPetitionDao.create(
                title.trim(),
                synopsis.trim(),
                durationMinutes,
                theater.trim(),
                theaterAddress.trim(),
                startDate,
                endDate,
                coverImageId,
                director.trim(),
                petitionerUserId,
                petitionerEmail.trim(),
                trimToNull(schedule),
                trimToNull(ticketUrl),
                normalizeLanguage(language),
                sourceObraId,
                sourceProductionId
        );

        playPetitionDao.replaceGenres(created.getId(), normalizedGenreIds);
        playPetitionDao.replaceShowDates(created.getId(), normalizedShowDates);
        playPetitionDao.replaceFieldFeedback(created.getId(), Collections.<String, String>emptyMap());

        final PlayPetition petitionWithDetails = withDetails(created, genres, normalizedShowDates, Collections.<PetitionFieldFeedback>emptyList());
        mailService.sendPetitionConfirmation(petitionWithDetails);
        return petitionWithDetails;
    }

    @Override
    public PlayPetition resubmit(final long petitionId, final String title, final String synopsis,
                                 final int durationMinutes, final List<Long> genreIds,
                                 final String theater, final String theaterAddress,
                                 final LocalDate startDate, final LocalDate endDate,
                                 final String coverImageContentType, final byte[] coverImage,
                                 final Long existingCoverImageId, final List<LocalDate> additionalShowDates,
                                 final String director, final long petitionerUserId,
                                 final String petitionerEmail, final String schedule,
                                 final String ticketUrl, final String language,
                                 final Long sourceObraId, final Long sourceProductionId) {
        final PlayPetition editable = findExistingEditablePetition(petitionId, petitionerUserId);
        final List<Long> normalizedGenreIds = new ArrayList<>(genreIds != null ? genreIds : Collections.<Long>emptyList());
        final List<Genre> genres = resolveGenres(normalizedGenreIds);
        final Long resolvedExistingCoverImageId = existingCoverImageId != null ? existingCoverImageId : editable.getCoverImageId();

        validateSaveRequest(title, synopsis, durationMinutes, normalizedGenreIds, theater, theaterAddress,
                startDate, endDate, coverImage, resolvedExistingCoverImageId, director, petitionerUserId,
                petitionerEmail, sourceObraId, sourceProductionId);

        final Long coverImageId = resolveCoverImageId(coverImageContentType, coverImage, resolvedExistingCoverImageId);
        final List<LocalDate> normalizedShowDates = normalizeAdditionalShowDates(startDate, endDate, additionalShowDates);

        playPetitionDao.updateDraft(
                petitionId,
                title.trim(),
                synopsis.trim(),
                durationMinutes,
                theater.trim(),
                theaterAddress.trim(),
                startDate,
                endDate,
                coverImageId,
                director.trim(),
                petitionerUserId,
                petitionerEmail.trim(),
                trimToNull(schedule),
                trimToNull(ticketUrl),
                normalizeLanguage(language),
                sourceObraId,
                sourceProductionId
        );
        playPetitionDao.replaceGenres(petitionId, normalizedGenreIds);
        playPetitionDao.replaceShowDates(petitionId, normalizedShowDates);
        playPetitionDao.replaceFieldFeedback(petitionId, Collections.<String, String>emptyMap());
        playPetitionDao.updateStatus(petitionId, PetitionStatus.PENDING, null);

        final PlayPetition updated = findById(petitionId)
                .orElseThrow(() -> new IllegalStateException("Petition not found after resubmission"));
        mailService.sendPetitionConfirmation(updated);
        return withDetails(updated, genres, normalizedShowDates, Collections.<PetitionFieldFeedback>emptyList());
    }

    @Override
    public Optional<PlayPetition> findById(final long id) {
        return playPetitionDao.findById(id).map(this::loadDetails);
    }

    @Override
    public Optional<PlayPetition> findLatestEditableByPetitionerUserId(final long petitionerUserId) {
        return playPetitionDao.findLatestByPetitionerUserIdAndStatus(petitionerUserId, PetitionStatus.CHANGES_REQUESTED)
                .map(this::loadDetails);
    }

    @Override
    public List<PlayPetition> findByPetitionerUserId(final long petitionerUserId) {
        return loadDetails(playPetitionDao.findByPetitionerUserId(petitionerUserId));
    }

    @Override
    public List<PlayPetition> findAll(final int page, final int pageSize) {
        return loadDetails(playPetitionDao.findAll(page, pageSize));
    }

    @Override
    public List<PlayPetition> findByStatus(final PetitionStatus status, final int page, final int pageSize) {
        return loadDetails(playPetitionDao.findByStatus(status, page, pageSize));
    }

    @Override
    public void approve(final long petitionId, final String adminNotes) {
        final PlayPetition petition = findExistingPendingPetition(petitionId);
        final Obra obra = petition.getSourceObraId() != null
                ? obraDao.findById(petition.getSourceObraId()).orElseThrow(() -> new IllegalArgumentException("Petition source obra not found"))
                : obraDao.create(petition.getTitle(), petition.getSynopsis(), joinGenres(petition.getGenres()));

        final Long productoraId = resolveProductoraId(petition.getPetitionerUserId());
        final Production production = productionDao.create(
                petition.getTitle(),
                obra.getId(),
                productoraId,
                petition.getSynopsis(),
                petition.getDirector(),
                petition.getTheater(),
                petition.getStartDate(),
                petition.getEndDate(),
                petition.getCoverImageId(),
                petition.getDurationMinutes(),
                petition.getLanguage(),
                null,
                petition.getTicketUrl()
        );

        for (final LocalDate showDate : buildShowDates(petition)) {
            showDao.create(production.getId(), showDate, DEFAULT_SHOW_TIME, petition.getTheater());
        }

        playPetitionDao.replaceFieldFeedback(petitionId, Collections.<String, String>emptyMap());
        playPetitionDao.updateStatus(petitionId, PetitionStatus.APPROVED, trimToNull(adminNotes));
        playPetitionDao.setCreatedEntities(petitionId, obra.getId(), production.getId());
        final PlayPetition updated = findById(petitionId)
                .orElseThrow(() -> new IllegalStateException("Petition not found after approval"));
        mailService.sendPetitionApproved(updated);
    }

    @Override
    public void requestChanges(final long petitionId, final String adminNotes, final Map<String, String> fieldFeedback) {
        findExistingPendingPetition(petitionId);
        final Map<String, String> normalizedFeedback = normalizeFieldFeedback(fieldFeedback);
        if (normalizedFeedback.isEmpty()) {
            throw new IllegalArgumentException("Seleccioná al menos un campo observado.");
        }
        playPetitionDao.replaceFieldFeedback(petitionId, normalizedFeedback);
        playPetitionDao.updateStatus(petitionId, PetitionStatus.CHANGES_REQUESTED, trimToNull(adminNotes));
        final PlayPetition updated = findById(petitionId)
                .orElseThrow(() -> new IllegalStateException("Petition not found after requesting changes"));
        mailService.sendPetitionChangesRequested(updated);
    }

    @Override
    public List<PetitionObraSuggestion> searchSourceObras(final String query, final int limit) {
        final String normalizedQuery = trimToNull(query);
        if (!hasText(normalizedQuery)) {
            return Collections.emptyList();
        }

        final int normalizedLimit = limit > 0 ? limit : DEFAULT_AUTOCOMPLETE_LIMIT;
        final List<Production> matches = productionDao.search(
                new ProductionSearchCriteria(normalizedQuery, null, null, null, null, true),
                0,
                normalizedLimit * 3
        );
        if (matches.isEmpty()) {
            return Collections.emptyList();
        }

        final Map<Long, List<Production>> productionsByObra = new LinkedHashMap<>();
        for (final Production match : matches) {
            productionsByObra.computeIfAbsent(match.getObraId(), ignored -> new ArrayList<Production>()).add(match);
        }

        final List<PetitionObraSuggestion> suggestions = new ArrayList<>();
        for (final Map.Entry<Long, List<Production>> entry : productionsByObra.entrySet()) {
            if (suggestions.size() >= normalizedLimit) {
                break;
            }

            final Optional<Obra> obra = obraDao.findById(entry.getKey());
            if (!obra.isPresent()) {
                continue;
            }

            final Production representative = selectRepresentative(entry.getValue());
            suggestions.add(new PetitionObraSuggestion(
                    obra.get().getId(),
                    representative != null ? representative.getId() : null,
                    obra.get().getTitle(),
                    representative != null ? representative.getTheater() : null,
                    representative != null ? representative.getImageUrl() : null
            ));
        }

        return suggestions;
    }

    @Override
    public Optional<PetitionObraPrefill> getSourceObraPrefill(final long obraId) {
        final Optional<Obra> obra = obraDao.findById(obraId);
        if (!obra.isPresent()) {
            return Optional.empty();
        }

        final List<Production> productions = productionDao.findByObraId(obraId);
        final Production representative = productions.isEmpty() ? null : selectRepresentative(productions);
        final List<Show> shows = representative != null ? showDao.findByProductionId(representative.getId()) : Collections.<Show>emptyList();
        final String synopsis = hasText(obra.get().getSynopsis())
                ? obra.get().getSynopsis()
                : (representative != null ? trimToNull(representative.getSynopsis()) : null);

        return Optional.of(new PetitionObraPrefill(
                obra.get().getId(),
                representative != null ? representative.getId() : null,
                obra.get().getTitle(),
                synopsis,
                mapGenreIds(obra.get().getGenre()),
                representative != null && representative.getDurationMinutes() != null
                        ? String.valueOf(representative.getDurationMinutes())
                        : null,
                representative != null ? representative.getTheater() : firstShowTheater(shows),
                firstShowAddress(shows),
                representative != null ? formatDate(representative.getStartDate()) : null,
                representative != null ? formatDate(representative.getEndDate()) : null,
                mapAdditionalShowDates(shows, representative != null ? representative.getStartDate() : null,
                        representative != null ? representative.getEndDate() : null),
                representative != null ? trimToNull(representative.getDirection()) : null,
                null,
                representative != null ? trimToNull(representative.getWebsite()) : null,
                representative != null && hasText(representative.getLanguage()) ? representative.getLanguage() : DEFAULT_LANGUAGE,
                representative != null ? representative.getImageId() : null,
                representative != null ? representative.getImageUrl() : null
        ));
    }

    @Override
    public int countByStatus(final PetitionStatus status) {
        return playPetitionDao.countByStatus(status);
    }

    @Override
    public int countAll() {
        return playPetitionDao.countAll();
    }

    private void validateSaveRequest(final String title, final String synopsis, final int durationMinutes,
                                     final List<Long> genreIds, final String theater, final String theaterAddress,
                                     final LocalDate startDate, final LocalDate endDate, final byte[] coverImage,
                                     final Long existingCoverImageId, final String director,
                                     final long petitionerUserId, final String petitionerEmail,
                                     final Long sourceObraId, final Long sourceProductionId) {
        if (!hasText(title) || !hasText(synopsis) || durationMinutes <= 0 || !hasText(theater)
                || !hasText(theaterAddress) || startDate == null || endDate == null || !hasText(director)
                || petitionerUserId <= 0 || !hasText(petitionerEmail) || genreIds == null || genreIds.isEmpty()) {
            throw new IllegalArgumentException("Missing required petition fields");
        }
        if (endDate.isBefore(startDate)) {
            throw new IllegalArgumentException("End date cannot be before start date");
        }
        if ((coverImage == null || coverImage.length == 0) && existingCoverImageId == null) {
            throw new IllegalArgumentException("Missing required petition fields");
        }
        validateSourceSelection(sourceObraId, sourceProductionId);
    }

    private void validateSourceSelection(final Long sourceObraId, final Long sourceProductionId) {
        if (sourceProductionId != null && sourceObraId == null) {
            throw new IllegalArgumentException("Selected source production is invalid");
        }
        if (sourceObraId == null) {
            return;
        }

        obraDao.findById(sourceObraId).orElseThrow(() -> new IllegalArgumentException("Selected source obra is invalid"));
        if (sourceProductionId != null) {
            final Production production = productionDao.findById(sourceProductionId)
                    .orElseThrow(() -> new IllegalArgumentException("Selected source production is invalid"));
            if (production.getObraId() != sourceObraId.longValue()) {
                throw new IllegalArgumentException("Selected source production is invalid");
            }
        }
    }

    private List<Genre> resolveGenres(final List<Long> normalizedGenreIds) {
        final List<Genre> genres = genreDao.findByIds(normalizedGenreIds);
        if (genres.size() != normalizedGenreIds.size()) {
            throw new IllegalArgumentException("Selected genres are invalid");
        }
        return genres;
    }

    private Long resolveCoverImageId(final String coverImageContentType, final byte[] coverImage,
                                     final Long existingCoverImageId) {
        if (coverImage != null && coverImage.length > 0) {
            final Image image = imageService.create(
                    hasText(coverImageContentType) ? coverImageContentType : DEFAULT_IMAGE_CONTENT_TYPE,
                    coverImage
            );
            return image.getId();
        }
        return existingCoverImageId;
    }

    private PlayPetition findExistingPendingPetition(final long petitionId) {
        final PlayPetition petition = findById(petitionId)
                .orElseThrow(() -> new IllegalArgumentException("Petition not found"));
        if (petition.getStatus() != PetitionStatus.PENDING) {
            throw new IllegalStateException("Petition was already resolved");
        }
        return petition;
    }

    private PlayPetition findExistingEditablePetition(final long petitionId, final long petitionerUserId) {
        final PlayPetition petition = playPetitionDao.findByIdAndPetitionerUserId(petitionId, petitionerUserId)
                .map(this::loadDetails)
                .orElseThrow(() -> new IllegalArgumentException("Petition not found"));
        if (petition.getStatus() != PetitionStatus.CHANGES_REQUESTED) {
            throw new IllegalStateException("Petition is not editable");
        }
        return petition;
    }

    private List<PlayPetition> loadDetails(final List<PlayPetition> petitions) {
        final List<PlayPetition> loaded = new ArrayList<>(petitions.size());
        for (final PlayPetition petition : petitions) {
            loaded.add(loadDetails(petition));
        }
        return loaded;
    }

    private PlayPetition loadDetails(final PlayPetition petition) {
        return withDetails(
                petition,
                genreDao.findByPetitionId(petition.getId()),
                playPetitionDao.findShowDates(petition.getId()),
                playPetitionDao.findFieldFeedback(petition.getId())
        );
    }

    private PlayPetition withDetails(final PlayPetition petition, final List<Genre> genres,
                                     final List<LocalDate> additionalShowDates,
                                     final List<PetitionFieldFeedback> fieldFeedback) {
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
                petition.getPetitionerUserId(),
                petition.getPetitionerEmail(),
                petition.getSchedule(),
                petition.getTicketUrl(),
                petition.getLanguage(),
                petition.getStatus(),
                petition.getAdminNotes(),
                petition.getCreatedAt(),
                petition.getResolvedAt(),
                petition.getSourceObraId(),
                petition.getSourceProductionId(),
                petition.getCreatedObraId(),
                petition.getCreatedProductionId(),
                Collections.unmodifiableList(new ArrayList<LocalDate>(additionalShowDates)),
                Collections.unmodifiableList(new ArrayList<Genre>(genres)),
                Collections.unmodifiableList(new ArrayList<PetitionFieldFeedback>(fieldFeedback))
        );
    }

    private List<LocalDate> normalizeAdditionalShowDates(final LocalDate startDate, final LocalDate endDate,
                                                         final List<LocalDate> additionalShowDates) {
        final Set<LocalDate> dates = new LinkedHashSet<>();
        if (additionalShowDates != null) {
            for (final LocalDate additionalShowDate : additionalShowDates) {
                if (additionalShowDate != null && !additionalShowDate.equals(startDate) && !additionalShowDate.equals(endDate)) {
                    dates.add(additionalShowDate);
                }
            }
        }
        return new ArrayList<>(dates);
    }

    private List<LocalDate> buildShowDates(final PlayPetition petition) {
        final Set<LocalDate> dates = new LinkedHashSet<>();
        dates.add(petition.getStartDate());
        dates.add(petition.getEndDate());
        if (petition.getAdditionalShowDates() != null) {
            dates.addAll(petition.getAdditionalShowDates());
        }

        final List<LocalDate> normalized = new ArrayList<>();
        for (final LocalDate date : dates) {
            if (date != null) {
                normalized.add(date);
            }
        }
        Collections.sort(normalized);
        return normalized;
    }

    private Long resolveProductoraId(final Long petitionerUserId) {
        if (petitionerUserId == null) {
            return null;
        }
        final List<ProductoraMember> memberships = productoraMemberDao.findByUser(petitionerUserId);
        if (memberships.isEmpty()) {
            return null;
        }
        return memberships.get(0).getProductoraId();
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

    private Map<String, String> normalizeFieldFeedback(final Map<String, String> fieldFeedback) {
        if (fieldFeedback == null || fieldFeedback.isEmpty()) {
            return Collections.emptyMap();
        }

        final Map<String, String> normalized = new LinkedHashMap<>();
        for (final Map.Entry<String, String> entry : fieldFeedback.entrySet()) {
            if (!REVIEWABLE_FIELDS.contains(entry.getKey())) {
                continue;
            }
            final String comment = trimToNull(entry.getValue());
            if (comment != null) {
                normalized.put(entry.getKey(), comment);
            }
        }
        return normalized;
    }

    private List<Long> mapGenreIds(final String genreLabel) {
        if (!hasText(genreLabel)) {
            return Collections.emptyList();
        }

        final Map<String, Long> genreIdsByName = new LinkedHashMap<>();
        for (final Genre genre : genreDao.findAll()) {
            genreIdsByName.put(genre.getName().trim().toLowerCase(Locale.ROOT), genre.getId());
        }

        final Set<Long> ids = new LinkedHashSet<>();
        final String[] rawTokens = genreLabel.split(",");
        for (final String rawToken : rawTokens) {
            final String token = rawToken != null ? rawToken.trim().toLowerCase(Locale.ROOT) : "";
            if (token.isEmpty()) {
                continue;
            }
            final Long genreId = genreIdsByName.get(token);
            if (genreId != null) {
                ids.add(genreId);
            }
        }
        return new ArrayList<>(ids);
    }

    private String firstShowTheater(final List<Show> shows) {
        for (final Show show : shows) {
            if (hasText(show.getTheater())) {
                return show.getTheater();
            }
        }
        return null;
    }

    private String firstShowAddress(final List<Show> shows) {
        for (final Show show : shows) {
            if (hasText(show.getAddress())) {
                return show.getAddress();
            }
        }
        return null;
    }

    private List<String> mapAdditionalShowDates(final List<Show> shows,
                                                final LocalDate startDate,
                                                final LocalDate endDate) {
        final Set<String> dates = new LinkedHashSet<>();
        for (final Show show : shows) {
            final LocalDate showDate = show.getShowDate();
            if (showDate != null && !showDate.equals(startDate) && !showDate.equals(endDate)) {
                dates.add(showDate.toString());
            }
        }
        final List<String> orderedDates = new ArrayList<>(dates);
        Collections.sort(orderedDates);
        return orderedDates;
    }

    private String formatDate(final LocalDate value) {
        return value != null ? value.toString() : null;
    }

    private String normalizeLanguage(final String language) {
        return hasText(language) ? language.trim() : DEFAULT_LANGUAGE;
    }

    private Production selectRepresentative(final List<Production> productions) {
        if (productions == null || productions.isEmpty()) {
            return null;
        }

        Production representative = productions.get(0);
        for (int i = 1; i < productions.size(); i++) {
            final Production candidate = productions.get(i);
            if (isBetterRepresentative(candidate, representative)) {
                representative = candidate;
            }
        }
        return representative;
    }

    private boolean isBetterRepresentative(final Production candidate, final Production current) {
        final boolean candidateActive = isActive(candidate);
        final boolean currentActive = isActive(current);
        if (candidateActive != currentActive) {
            return candidateActive;
        }

        final int startComparison = compareDates(candidate.getStartDate(), current.getStartDate());
        if (startComparison != 0) {
            return startComparison > 0;
        }

        final int endComparison = compareDates(candidate.getEndDate(), current.getEndDate());
        if (endComparison != 0) {
            return endComparison > 0;
        }

        return candidate.getId() > current.getId();
    }

    private boolean isActive(final Production production) {
        if (production.getStartDate() == null) {
            return false;
        }
        final LocalDate today = LocalDate.now();
        return !production.getStartDate().isAfter(today)
                && (production.getEndDate() == null || !production.getEndDate().isBefore(today));
    }

    private int compareDates(final LocalDate left, final LocalDate right) {
        if (left == null && right == null) {
            return 0;
        }
        if (left == null) {
            return -1;
        }
        if (right == null) {
            return 1;
        }
        return left.compareTo(right);
    }

    private boolean hasText(final String value) {
        return value != null && !value.trim().isEmpty();
    }

    private String trimToNull(final String value) {
        return hasText(value) ? value.trim() : null;
    }
}
