package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.PetitionObraPrefill;
import ar.edu.itba.paw.models.PetitionObraSuggestion;
import ar.edu.itba.paw.models.PetitionStatus;
import ar.edu.itba.paw.models.PlayPetition;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface PlayPetitionService {

    PlayPetition create(String title, String synopsis, int durationMinutes,
                        List<Long> genreIds, String theater, String theaterAddress,
                        LocalDate startDate, LocalDate endDate, String coverImageContentType, byte[] coverImage,
                        Long existingCoverImageId, List<LocalDate> additionalShowDates,
                        String director, long petitionerUserId, String petitionerEmail,
                        String schedule, String ticketUrl, String language,
                        Long sourceObraId, Long sourceProductionId);

    PlayPetition resubmit(long petitionId, String title, String synopsis, int durationMinutes,
                          List<Long> genreIds, String theater, String theaterAddress,
                          LocalDate startDate, LocalDate endDate, String coverImageContentType, byte[] coverImage,
                          Long existingCoverImageId, List<LocalDate> additionalShowDates,
                          String director, long petitionerUserId, String petitionerEmail,
                          String schedule, String ticketUrl, String language,
                          Long sourceObraId, Long sourceProductionId);

    Optional<PlayPetition> findById(long id);

    Optional<PlayPetition> findLatestEditableByPetitionerUserId(long petitionerUserId);

    List<PlayPetition> findByPetitionerUserId(long petitionerUserId);

    List<PlayPetition> findAll(int page, int pageSize);

    List<PlayPetition> findByStatus(PetitionStatus status, int page, int pageSize);

    void approve(long petitionId, String adminNotes);

    void requestChanges(long petitionId, String adminNotes, Map<String, String> fieldFeedback);

    List<PetitionObraSuggestion> searchSourceObras(String query, int limit);

    Optional<PetitionObraPrefill> getSourceObraPrefill(long obraId);

    int countByStatus(PetitionStatus status);

    int countAll();
}
