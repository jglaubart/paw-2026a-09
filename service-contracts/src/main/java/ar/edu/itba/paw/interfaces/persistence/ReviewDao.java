package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.Review;
import java.util.List;
import java.util.Optional;

public interface ReviewDao {
    Optional<Review> findByUserAndObra(long userId, long obraId);
    List<Review> findByObra(long obraId);
    List<Review> findByUser(long userId);
    Review create(long userId, long obraId, String body, long ratingId);
}
