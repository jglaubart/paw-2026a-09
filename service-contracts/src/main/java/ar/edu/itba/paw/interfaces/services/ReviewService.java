package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.Review;
import java.util.List;
import java.util.Optional;

public interface ReviewService {
    Review createOrUpdateByEmail(String email, long productionId, String body);
    Review createOrUpdateByEmailForObra(String email, long obraId, long productionId, String body);
    Optional<Review> findByUserAndProduction(long userId, long productionId);
    Optional<Review> findByUserAndObra(long userId, long obraId);
    Optional<Review> findByEmailAndProduction(String email, long productionId);
    Optional<Review> findByEmailAndObra(String email, long obraId);
    List<Review> findByProduction(long productionId);
    List<Review> findByObra(long obraId);
    List<Review> findByUser(long userId);
    void deleteByEmailAndObra(String email, long obraId);
}
