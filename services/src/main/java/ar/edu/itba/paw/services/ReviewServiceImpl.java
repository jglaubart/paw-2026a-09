package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.ProductionRatingDao;
import ar.edu.itba.paw.interfaces.persistence.ReviewDao;
import ar.edu.itba.paw.interfaces.services.ReviewService;
import ar.edu.itba.paw.models.ProductionRating;
import ar.edu.itba.paw.models.Review;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ReviewServiceImpl implements ReviewService {

    private final ReviewDao reviewDao;
    private final ProductionRatingDao productionRatingDao;

    @Autowired
    public ReviewServiceImpl(final ReviewDao reviewDao, final ProductionRatingDao productionRatingDao) {
        this.reviewDao = reviewDao;
        this.productionRatingDao = productionRatingDao;
    }

    @Override
    public Review create(final long userId, final long productionId, final String body) {
        final ProductionRating rating = productionRatingDao.findByUserAndProduction(userId, productionId)
                .orElseThrow(() -> new IllegalStateException(
                        "Cannot write a review without rating the production first"));
        return reviewDao.create(userId, productionId, body, rating.getId());
    }

    @Override
    public Optional<Review> findByUserAndProduction(final long userId, final long productionId) {
        return reviewDao.findByUserAndProduction(userId, productionId);
    }

    @Override
    public List<Review> findByProduction(final long productionId) {
        return reviewDao.findByProduction(productionId);
    }

    @Override
    public List<Review> findByUser(final long userId) {
        return reviewDao.findByUser(userId);
    }
}
