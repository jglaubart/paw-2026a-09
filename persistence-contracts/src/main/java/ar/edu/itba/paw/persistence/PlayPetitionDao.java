package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.PetitionStatus;
import ar.edu.itba.paw.models.PlayPetition;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface PlayPetitionDao {

    PlayPetition create(String title, String synopsis, int durationMinutes,
                        String theater, String theaterAddress, LocalDate startDate,
                        LocalDate endDate, Long coverImageId, String director,
                        String petitionerEmail, String schedule, String ticketUrl,
                        String language);

    void addGenres(long petitionId, List<Long> genreIds);

    void addShowDates(long petitionId, List<LocalDate> dates);

    List<LocalDate> findShowDates(long petitionId);

    Optional<PlayPetition> findById(long id);

    List<PlayPetition> findAll(int page, int pageSize);

    List<PlayPetition> findByStatus(PetitionStatus status, int page, int pageSize);

    void updateStatus(long id, PetitionStatus status, String adminNotes);

    void setCreatedEntities(long id, long obraId, long productionId);

    int countByStatus(PetitionStatus status);

    int countAll();
}
