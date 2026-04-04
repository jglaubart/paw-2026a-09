package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.PlayRating;
import ar.edu.itba.paw.models.ProductionRating;
import java.util.Collection;
import java.util.Map;
import java.util.Optional;

public interface RatingService {
    PlayRating rateObra(long userId, long obraId, int score);
    PlayRating rateObraByEmail(String email, long obraId, int score);
    ProductionRating rateProduction(long userId, long productionId, int score);
    Optional<PlayRating> getObraRating(long userId, long obraId);
    Optional<PlayRating> getObraRatingByEmail(String email, long obraId);
    Optional<ProductionRating> getProductionRating(long userId, long productionId);
    Optional<Double> getObraAverageRating(long obraId);
    Optional<Double> getProductionAverageRating(long productionId);
    Map<Long, String> getProductionRatingLabels(Collection<Long> productionIds);
}
