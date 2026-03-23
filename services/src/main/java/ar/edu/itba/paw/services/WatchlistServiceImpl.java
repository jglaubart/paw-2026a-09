package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.WatchlistDao;
import ar.edu.itba.paw.interfaces.services.WatchlistService;
import ar.edu.itba.paw.models.Production;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WatchlistServiceImpl implements WatchlistService {

    private final WatchlistDao watchlistDao;

    @Autowired
    public WatchlistServiceImpl(final WatchlistDao watchlistDao) {
        this.watchlistDao = watchlistDao;
    }

    @Override
    public List<Production> findByUser(final long userId) {
        return watchlistDao.findByUser(userId);
    }

    @Override
    public boolean isInWatchlist(final long userId, final long productionId) {
        return watchlistDao.isInWatchlist(userId, productionId);
    }

    @Override
    public void add(final long userId, final long productionId) {
        watchlistDao.add(userId, productionId);
    }

    @Override
    public void remove(final long userId, final long productionId) {
        watchlistDao.remove(userId, productionId);
    }
}
