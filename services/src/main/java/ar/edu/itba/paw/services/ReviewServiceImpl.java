package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.PlayRatingDao;
import ar.edu.itba.paw.interfaces.persistence.ReviewDao;
import ar.edu.itba.paw.interfaces.services.ReviewService;
import ar.edu.itba.paw.models.PlayRating;
import ar.edu.itba.paw.models.Review;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ReviewServiceImpl implements ReviewService {

    private final ReviewDao reviewDao;
    private final PlayRatingDao playRatingDao;

    @Autowired
    public ReviewServiceImpl(final ReviewDao reviewDao, final PlayRatingDao playRatingDao) {
        this.reviewDao = reviewDao;
        this.playRatingDao = playRatingDao;
    }

    @Override
    public Review create(final long userId, final long obraId, final String body) {
        final PlayRating rating = playRatingDao.findByUserAndObra(userId, obraId)
                .orElseThrow(() -> new IllegalStateException(
                        "Cannot write a review without rating the obra first"));
        return reviewDao.create(userId, obraId, body, rating.getId());
    }

    @Override
    public Optional<Review> findByUserAndObra(final long userId, final long obraId) {
        return reviewDao.findByUserAndObra(userId, obraId);
    }

    @Override
    public List<Review> findByObra(final long obraId) {
        return reviewDao.findByObra(obraId);
    }

    @Override
    public List<Review> findByUser(final long userId) {
        return reviewDao.findByUser(userId);
    }
}
