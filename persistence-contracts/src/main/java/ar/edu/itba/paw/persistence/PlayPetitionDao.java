package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.PetitionFieldFeedback;
import ar.edu.itba.paw.models.PetitionStatus;
import ar.edu.itba.paw.models.PlayPetition;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface PlayPetitionDao {

    PlayPetition create(String title, String synopsis, int durationMinutes,
                        String theater, String theaterAddress, LocalDate startDate,
                        LocalDate endDate, Long coverImageId, String director,
                        long petitionerUserId, String petitionerEmail, String schedule,
                        String ticketUrl, String language, Long sourceObraId,
                        Long sourceProductionId);

    void updateDraft(long petitionId, String title, String synopsis, int durationMinutes,
                     String theater, String theaterAddress, LocalDate startDate,
                     LocalDate endDate, Long coverImageId, String director,
                     long petitionerUserId, String petitionerEmail, String schedule,
                     String ticketUrl, String language, Long sourceObraId,
                     Long sourceProductionId);

    void addGenres(long petitionId, List<Long> genreIds);

    void replaceGenres(long petitionId, List<Long> genreIds);

    void addShowDates(long petitionId, List<LocalDate> dates);

    void replaceShowDates(long petitionId, List<LocalDate> dates);

    List<LocalDate> findShowDates(long petitionId);

    List<PetitionFieldFeedback> findFieldFeedback(long petitionId);

    void replaceFieldFeedback(long petitionId, Map<String, String> fieldFeedback);

    Optional<PlayPetition> findById(long id);

    Optional<PlayPetition> findByIdAndPetitionerUserId(long id, long petitionerUserId);

    Optional<PlayPetition> findLatestByPetitionerUserIdAndStatus(long petitionerUserId, PetitionStatus status);

    List<PlayPetition> findByPetitionerUserId(long petitionerUserId);

    List<PlayPetition> findAll(int page, int pageSize);

    List<PlayPetition> findByStatus(PetitionStatus status, int page, int pageSize);

    void updateStatus(long id, PetitionStatus status, String adminNotes);

    void setCreatedEntities(long id, long obraId, long productionId);

    int countByStatus(PetitionStatus status);

    int countAll();
}
