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
    public Review createOrUpdateByEmail(final String email, final long productionId, final String body) {
        final User user = userDao.findByEmail(email)
                .orElseGet(() -> userDao.create(email, null));
        return reviewDao.findByUserAndProduction(user.getId(), productionId)
                .map(existing -> reviewDao.update(user.getId(), productionId, body))
                .orElseGet(() -> reviewDao.create(user.getId(), productionId, body));
    }

    @Override
    public Review createOrUpdateByEmailForObra(final String email, final long obraId,
                                               final long productionId, final String body) {
        final User user = userDao.findByEmail(email)
                .orElseGet(() -> userDao.create(email, null));
        return reviewDao.findByUserAndObra(user.getId(), obraId)
                .map(existing -> reviewDao.updateForObra(user.getId(), obraId, productionId, body))
                .orElseGet(() -> reviewDao.createForObra(user.getId(), obraId, productionId, body));
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
    public void deleteByEmailAndObra(final String email, final long obraId) {
        userDao.findByEmail(email)
                .ifPresent(user -> reviewDao.deleteByUserAndObra(user.getId(), obraId));
    }
}
