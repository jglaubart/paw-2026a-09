package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.Show;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface ShowService {
    List<Show> findByProductionId(long productionId);
    List<Show> findFutureByProductionId(long productionId);
    Show create(long productionId, LocalDate showDate, LocalTime showTime, String theater);
}
