package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.PlayRatingDao;
import ar.edu.itba.paw.interfaces.persistence.ProductionDao;
import ar.edu.itba.paw.interfaces.persistence.ProductionRatingDao;
import ar.edu.itba.paw.interfaces.persistence.UserDao;
import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.models.PlayRating;
import ar.edu.itba.paw.models.ProductionRating;
import ar.edu.itba.paw.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;

@Service
public class RatingServiceImpl implements RatingService {

    private final PlayRatingDao playRatingDao;
    private final ProductionDao productionDao;
    private final ProductionRatingDao productionRatingDao;
    private final UserDao userDao;

    @Autowired
    public RatingServiceImpl(final PlayRatingDao playRatingDao,
                             final ProductionDao productionDao,
                             final ProductionRatingDao productionRatingDao,
                             final UserDao userDao) {
        this.playRatingDao = playRatingDao;
        this.productionDao = productionDao;
        this.productionRatingDao = productionRatingDao;
        this.userDao = userDao;
    }

    @Override
    public PlayRating rateObra(final long userId, final long obraId, final int score) {
        return playRatingDao.findByUserAndObra(userId, obraId)
                .map(existing -> playRatingDao.update(userId, obraId, score))
                .orElseGet(() -> playRatingDao.create(userId, obraId, score));
    }

    @Override
    public PlayRating rateObraByEmail(final String email, final long obraId, final int score) {
        final User user = userDao.findByEmail(email)
                .orElseGet(() -> userDao.create(email, null));
        return rateObra(user.getId(), obraId, score);
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
    public Optional<PlayRating> getObraRatingByEmail(final String email, final long obraId) {
        return userDao.findByEmail(email)
                .flatMap(user -> playRatingDao.findByUserAndObra(user.getId(), obraId));
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

    @Override
    public Map<Long, String> getProductionRatingLabels(final Collection<Long> productionIds) {
        final Map<Long, String> labels = new HashMap<>();
        for (final Long productionId : productionIds) {
            if (productionId == null || labels.containsKey(productionId)) {
                continue;
            }
            final String ratingLabel = productionDao.findById(productionId)
                    .flatMap(production -> playRatingDao.findAverageByObra(production.getObraId()))
                    .map(avg -> String.format(Locale.US, "%.1f", avg))
                    .orElse("N/A");
            labels.put(productionId, ratingLabel);
        }
        return labels;
    }
}
