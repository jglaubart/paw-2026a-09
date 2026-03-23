package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.ProductionRating;
import java.util.Optional;

public interface ProductionRatingDao {
    Optional<ProductionRating> findByUserAndProduction(long userId, long productionId);
    Optional<Double> findAverageByProduction(long productionId);
    ProductionRating create(long userId, long productionId, int score);
    ProductionRating update(long userId, long productionId, int score);
}
