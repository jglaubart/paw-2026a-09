package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.Review;
import java.util.List;
import java.util.Optional;

public interface ReviewDao {
    Optional<Review> findByUserAndProduction(long userId, long productionId);
    Optional<Review> findByUserAndObra(long userId, long obraId);
    List<Review> findByProduction(long productionId);
    List<Review> findByObra(long obraId);
    List<Review> findByUser(long userId);
    Review create(long userId, long productionId, String body);
    Review createForObra(long userId, long obraId, long productionId, String body);
    Review update(long userId, long productionId, String body);
    Review updateForObra(long userId, long obraId, long productionId, String body);
    void deleteByUserAndObra(long userId, long obraId);
}
