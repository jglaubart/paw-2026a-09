package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.PlayRatingDao;
import ar.edu.itba.paw.interfaces.persistence.ProductionDao;
import ar.edu.itba.paw.interfaces.persistence.ProductionRatingDao;
import ar.edu.itba.paw.interfaces.persistence.SeenDao;
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
    private final SeenDao seenDao;

    @Autowired
    public RatingServiceImpl(final PlayRatingDao playRatingDao,
                             final ProductionDao productionDao,
                             final ProductionRatingDao productionRatingDao,
                             final UserDao userDao,
                             final SeenDao seenDao) {
        this.playRatingDao = playRatingDao;
        this.productionDao = productionDao;
        this.productionRatingDao = productionRatingDao;
        this.userDao = userDao;
        this.seenDao = seenDao;
    }

    @Override
    public PlayRating rateObra(final long userId, final long obraId, final int score) {
        final PlayRating rating = playRatingDao.findByUserAndObra(userId, obraId)
                .map(existing -> playRatingDao.update(userId, obraId, score))
                .orElseGet(() -> playRatingDao.create(userId, obraId, score));
        if (!seenDao.hasSeen(userId, obraId)) {
            seenDao.markSeen(userId, obraId);
        }
        return rating;
    }

    @Override
    public PlayRating rateObraByEmail(final String email, final long obraId, final int score) {
        final User user = userDao.findByEmail(email)
                .orElseGet(() -> userDao.create(email, null, "", true));
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
        if (productionIds == null || productionIds.isEmpty()) {
            return labels;
        }

        final Map<Long, Double> averages = playRatingDao.findAveragesByProductionIds(productionIds);

        for (final Long productionId : productionIds) {
            if (productionId == null || labels.containsKey(productionId)) {
                continue;
            }
            final Double avg = averages.get(productionId);
            final String ratingLabel = avg != null ? String.format(Locale.US, "%.1f", avg) : "N/A";
            labels.put(productionId, ratingLabel);
        }
        return labels;
    }

    @Override
    public Map<Long, Integer> getUserObraScores(final long userId, final Collection<Long> obraIds) {
        if (obraIds == null || obraIds.isEmpty()) {
            return new HashMap<>();
        }
        return playRatingDao.findScoresByUserAndObraIds(userId, obraIds);
    }

    @Override
    public int[] getUserScoreDistribution(final long userId) {
        final int[] dist = new int[11];
        final Map<Integer, Long> raw = playRatingDao.findScoreDistributionByUser(userId);
        for (final Map.Entry<Integer, Long> e : raw.entrySet()) {
            final int score = e.getKey();
            if (score >= 1 && score <= 10) {
                dist[score] = e.getValue().intValue();
            }
        }
        return dist;
    }

    @Override
    public Optional<Double> getUserAverageRating(final long userId) {
        return playRatingDao.findAverageByUser(userId);
    }

    @Override
    public Map<Long, String> getUserObraRatingLabels(final long userId, final Collection<Long> obraIds) {
        final Map<Long, String> labels = new HashMap<>();
        if (obraIds == null || obraIds.isEmpty()) {
            return labels;
        }

        final Map<Long, Integer> scores = playRatingDao.findScoresByUserAndObraIds(userId, obraIds);

        for (final Map.Entry<Long, Integer> entry : scores.entrySet()) {
            final Integer rawScore = entry.getValue();
            if (rawScore == null) {
                continue;
            }
            labels.put(entry.getKey(), Integer.toString(rawScore));
        }
        return labels;
    }
}
