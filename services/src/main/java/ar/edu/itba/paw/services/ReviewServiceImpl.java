package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.ReviewDao;
import ar.edu.itba.paw.interfaces.persistence.UserDao;
import ar.edu.itba.paw.interfaces.services.ReviewService;
import ar.edu.itba.paw.models.Review;
import ar.edu.itba.paw.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ReviewServiceImpl implements ReviewService {

    private final ReviewDao reviewDao;
    private final UserDao userDao;

    @Autowired
    public ReviewServiceImpl(final ReviewDao reviewDao, final UserDao userDao) {
        this.reviewDao = reviewDao;
        this.userDao = userDao;
    }

    @Override
    public Review createOrUpdate(final long userId, final long productionId, final String body) {
        return reviewDao.findByUserAndProduction(userId, productionId)
                .map(existing -> reviewDao.update(userId, productionId, body))
                .orElseGet(() -> reviewDao.create(userId, productionId, body));
    }

    @Override
    public Review createOrUpdateByEmail(final String email, final long productionId, final String body) {
        final User user = userDao.findByEmail(email)
                .orElseGet(() -> userDao.create(email, null, ""));
        return createOrUpdate(user.getId(), productionId, body);
    }

    @Override
    public Review createOrUpdateForObra(final long userId, final long obraId,
                                        final long productionId, final String body) {
        return reviewDao.findByUserAndObra(userId, obraId)
                .map(existing -> reviewDao.updateForObra(userId, obraId, productionId, body))
                .orElseGet(() -> reviewDao.createForObra(userId, obraId, productionId, body));
    }

    @Override
    public Review createOrUpdateByEmailForObra(final String email, final long obraId,
                                               final long productionId, final String body) {
        final User user = userDao.findByEmail(email)
                .orElseGet(() -> userDao.create(email, null, ""));
        return createOrUpdateForObra(user.getId(), obraId, productionId, body);
    }

    @Override
    public Optional<Review> findByUserAndProduction(final long userId, final long productionId) {
        return reviewDao.findByUserAndProduction(userId, productionId);
    }

    @Override
    public Optional<Review> findByUserAndObra(final long userId, final long obraId) {
        return reviewDao.findByUserAndObra(userId, obraId);
    }

    @Override
    public Optional<Review> findByEmailAndProduction(final String email, final long productionId) {
        return userDao.findByEmail(email)
                .flatMap(user -> reviewDao.findByUserAndProduction(user.getId(), productionId));
    }

    @Override
    public Optional<Review> findByEmailAndObra(final String email, final long obraId) {
        return userDao.findByEmail(email)
                .flatMap(user -> reviewDao.findByUserAndObra(user.getId(), obraId));
    }

    @Override
    public List<Review> findByProduction(final long productionId) {
        return reviewDao.findByProduction(productionId);
    }

    @Override
    public List<Review> findByObra(final long obraId) {
        return reviewDao.findByObra(obraId);
    }

    @Override
    public List<Review> findByUser(final long userId) {
        return reviewDao.findByUser(userId);
    }

    @Override
    public void deleteByUserAndObra(final long userId, final long obraId) {
        reviewDao.deleteByUserAndObra(userId, obraId);
    }

    @Override
    public void deleteByEmailAndObra(final String email, final long obraId) {
        userDao.findByEmail(email)
                .ifPresent(user -> deleteByUserAndObra(user.getId(), obraId));
    }
}
