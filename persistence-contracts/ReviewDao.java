package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.Review;
import java.util.List;
import java.util.Optional;

public interface ReviewDao {
    Optional<Review> findByUserAndProduction(long userId, long productionId);
    List<Review> findByProduction(long productionId);
    List<Review> findByUser(long userId);
    Review create(long userId, long productionId, String body, long ratingId);
}
