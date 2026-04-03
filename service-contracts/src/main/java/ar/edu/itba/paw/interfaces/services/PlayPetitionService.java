package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.PetitionStatus;
import ar.edu.itba.paw.models.PlayPetition;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface PlayPetitionService {

    PlayPetition create(String title, String synopsis, int durationMinutes,
                        List<Long> genreIds, String theater, String theaterAddress,
                        LocalDate startDate, LocalDate endDate, String coverImageContentType, byte[] coverImage,
                        String director, String petitionerEmail, String schedule,
                        String ticketUrl, String language);

    Optional<PlayPetition> findById(long id);

    List<PlayPetition> findAll(int page, int pageSize);

    List<PlayPetition> findByStatus(PetitionStatus status, int page, int pageSize);

    void approve(long petitionId, String adminNotes);

    void reject(long petitionId, String adminNotes);

    int countByStatus(PetitionStatus status);

    int countAll();
}
