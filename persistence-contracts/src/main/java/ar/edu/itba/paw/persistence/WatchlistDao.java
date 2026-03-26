package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.Production;
import java.util.List;

public interface WatchlistDao {
    List<Production> findByUser(long userId);
    boolean isInWatchlist(long userId, long productionId);
    void add(long userId, long productionId);
    void remove(long userId, long productionId);
}
