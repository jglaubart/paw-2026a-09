package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.PlayRating;
import java.util.Collection;
import java.util.Map;
import java.util.Optional;

public interface PlayRatingDao {
    Optional<PlayRating> findByUserAndObra(long userId, long obraId);
    Optional<Double> findAverageByObra(long obraId);
    Map<Long, Double> findAveragesByProductionIds(Collection<Long> productionIds);
    Map<Long, Integer> findScoresByUserAndObraIds(long userId, Collection<Long> obraIds);
    PlayRating create(long userId, long obraId, int score);
    PlayRating update(long userId, long obraId, int score);
}
