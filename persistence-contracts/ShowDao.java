package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.Show;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

public interface ShowDao {
    Optional<Show> findById(long id);
    List<Show> findByProductionId(long productionId);
    List<Show> findFutureByProductionId(long productionId);
    Show create(long productionId, LocalDate showDate, LocalTime showTime, String theater);
}
