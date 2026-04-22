package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.ProductionDao;
import ar.edu.itba.paw.interfaces.persistence.ProductoraDao;
import ar.edu.itba.paw.interfaces.persistence.ProductoraMemberDao;
import ar.edu.itba.paw.interfaces.persistence.ReviewDao;
import ar.edu.itba.paw.interfaces.persistence.UserDao;
import ar.edu.itba.paw.interfaces.services.ProductoraService;
import ar.edu.itba.paw.interfaces.services.exception.ProductoraAccessDeniedException;
import ar.edu.itba.paw.models.Productora;
import ar.edu.itba.paw.models.ProductoraMember;
import ar.edu.itba.paw.models.ProductoraMemberRole;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.Review;
import ar.edu.itba.paw.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class ProductoraServiceImpl implements ProductoraService {

    private final ProductoraDao productoraDao;
    private final ProductoraMemberDao memberDao;
    private final UserDao userDao;
    private final ProductionDao productionDao;
    private final ReviewDao reviewDao;

    @Autowired
    public ProductoraServiceImpl(final ProductoraDao productoraDao,
                                 final ProductoraMemberDao memberDao,
                                 final UserDao userDao,
                                 final ProductionDao productionDao,
                                 final ReviewDao reviewDao) {
        this.productoraDao = productoraDao;
        this.memberDao = memberDao;
        this.userDao = userDao;
        this.productionDao = productionDao;
        this.reviewDao = reviewDao;
    }

    @Override
    public Optional<Productora> findById(final long id) {
        return productoraDao.findById(id);
    }

    @Override
    public List<Productora> findAll() {
        return productoraDao.findAll();
    }

    @Override
    public Productora create(final String name, final String bio, final Long imageId,
                             final String instagram, final String website) {
        return productoraDao.create(name, bio, imageId, instagram, website);
    }

    @Override
    public List<Productora> findMineByUser(final long userId) {
        final List<ProductoraMember> memberships = memberDao.findByUser(userId);
        final List<Productora> result = new ArrayList<>(memberships.size());
        for (final ProductoraMember pm : memberships) {
            productoraDao.findById(pm.getProductoraId()).ifPresent(result::add);
        }
        return result;
    }

    @Override
    public List<ProductoraMember> listMembers(final long productoraId) {
        return memberDao.findByProductora(productoraId);
    }

    @Override
    public boolean canManage(final long userId, final long productoraId) {
        return memberDao.exists(userId, productoraId);
    }

    @Override
    public void updateDetails(final long productoraId, final long actingUserId,
                              final String name, final String bio, final Long imageId,
                              final String instagram, final String website) {
        requireOwner(actingUserId, productoraId);
        productoraDao.update(productoraId, name, bio, imageId, instagram, website);
    }

    @Override
    public void addMemberByEmail(final long productoraId, final long actingUserId, final String email) {
        requireOwner(actingUserId, productoraId);
        final User target = userDao.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + email));
        memberDao.add(target.getId(), productoraId, ProductoraMemberRole.MEMBER);
    }

    @Override
    public void removeMember(final long productoraId, final long actingUserId, final long memberUserId) {
        requireOwner(actingUserId, productoraId);
        if (actingUserId == memberUserId) {
            throw new IllegalArgumentException("Owner cannot remove themselves");
        }
        memberDao.remove(memberUserId, productoraId);
    }

    @Override
    public List<Production> findProductionsByProductora(final long productoraId) {
        return productionDao.findByProductoraId(productoraId);
    }

    @Override
    public ProductoraDashboardStats getDashboardStats(final long productoraId) {
        final ProductoraDao.DashboardStats s = productoraDao.findDashboardStats(productoraId);
        return new ProductoraDashboardStats(
                s.getObraCount(), s.getProductionCount(),
                s.getWatchlistCount(), s.getSeenCount(),
                s.getReviewCount(), s.getRatingCount(),
                s.getRatingAverage()
        );
    }

    @Override
    public List<Review> findRecentReviewsByProductora(final long productoraId, final int limit) {
        return reviewDao.findRecentByProductora(productoraId, limit);
    }

    private void requireOwner(final long actingUserId, final long productoraId) {
        final Optional<ProductoraMember> me = memberDao.find(actingUserId, productoraId);
        if (!me.isPresent() || !me.get().isOwner()) {
            throw new ProductoraAccessDeniedException(actingUserId, productoraId);
        }
    }
}
