package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.Production;
import java.util.List;

public interface WatchlistService {
    List<Production> findByUser(long userId);
    boolean isInWatchlist(long userId, long productionId);
    void add(long userId, long productionId);
    void remove(long userId, long productionId);
}
