package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.PlayRatingDao;
import ar.edu.itba.paw.interfaces.persistence.ProductionRatingDao;
import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.models.PlayRating;
import ar.edu.itba.paw.models.ProductionRating;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class RatingServiceImpl implements RatingService {

    private final PlayRatingDao playRatingDao;
    private final ProductionRatingDao productionRatingDao;

    @Autowired
    public RatingServiceImpl(final PlayRatingDao playRatingDao,
                             final ProductionRatingDao productionRatingDao) {
        this.playRatingDao = playRatingDao;
        this.productionRatingDao = productionRatingDao;
    }

    @Override
    public PlayRating rateObra(final long userId, final long obraId, final int score) {
        return playRatingDao.findByUserAndObra(userId, obraId)
                .map(existing -> playRatingDao.update(userId, obraId, score))
                .orElseGet(() -> playRatingDao.create(userId, obraId, score));
    }

    @Override
    public ProductionRating rateProduction(final long userId, final long productionId, final int score) {
        return productionRatingDao.findByUserAndProduction(userId, productionId)
                .map(existing -> productionRatingDao.update(userId, productionId, score))
                .orElseGet(() -> productionRatingDao.create(userId, productionId, score));
    }

    @Override
    public Optional<PlayRating> getObraRating(final long userId, final long obraId) {
        return playRatingDao.findByUserAndObra(userId, obraId);
    }

    @Override
    public Optional<ProductionRating> getProductionRating(final long userId, final long productionId) {
        return productionRatingDao.findByUserAndProduction(userId, productionId);
    }

    @Override
    public Optional<Double> getObraAverageRating(final long obraId) {
        return playRatingDao.findAverageByObra(obraId);
    }

    @Override
    public Optional<Double> getProductionAverageRating(final long productionId) {
        return productionRatingDao.findAverageByProduction(productionId);
    }
}
