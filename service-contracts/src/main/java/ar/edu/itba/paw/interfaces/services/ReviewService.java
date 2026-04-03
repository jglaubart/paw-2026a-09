package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.Review;
import java.util.List;
import java.util.Optional;

public interface ReviewService {
    Review createOrUpdateByEmail(String email, long productionId, String body);
    Optional<Review> findByUserAndProduction(long userId, long productionId);
    Optional<Review> findByEmailAndProduction(String email, long productionId);
    List<Review> findByProduction(long productionId);
    List<Review> findByUser(long userId);
}
