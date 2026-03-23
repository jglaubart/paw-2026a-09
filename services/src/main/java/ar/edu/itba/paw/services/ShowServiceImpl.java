package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.ShowDao;
import ar.edu.itba.paw.interfaces.services.ShowService;
import ar.edu.itba.paw.models.Show;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Service
public class ShowServiceImpl implements ShowService {

    private final ShowDao showDao;

    @Autowired
    public ShowServiceImpl(final ShowDao showDao) {
        this.showDao = showDao;
    }

    @Override
    public List<Show> findByProductionId(final long productionId) {
        return showDao.findByProductionId(productionId);
    }

    @Override
    public List<Show> findFutureByProductionId(final long productionId) {
        return showDao.findFutureByProductionId(productionId);
    }

    @Override
    public Show create(final long productionId, final LocalDate showDate,
                       final LocalTime showTime, final String theater) {
        return showDao.create(productionId, showDate, showTime, theater);
    }
}
