package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.Productora;
import ar.edu.itba.paw.models.ProductoraMember;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.Review;

import java.util.List;
import java.util.Optional;

public interface ProductoraService {

    Optional<Productora> findById(long id);
    List<Productora> findAll();
    Productora create(String name, String bio, Long imageId, String instagram, String website);

    List<Productora> findMineByUser(long userId);

    List<ProductoraMember> listMembers(long productoraId);

    boolean canManage(long userId, long productoraId);

    void updateDetails(long productoraId, long actingUserId,
                       String name, String bio, Long imageId,
                       String instagram, String website);

    void addMemberByEmail(long productoraId, long actingUserId, String email);

    void removeMember(long productoraId, long actingUserId, long memberUserId);

    List<Production> findProductionsByProductora(long productoraId);

    ProductoraDashboardStats getDashboardStats(long productoraId);

    List<Review> findRecentReviewsByProductora(long productoraId, int limit);

    class ProductoraDashboardStats {
        private final int obraCount;
        private final int productionCount;
        private final int watchlistCount;
        private final int seenCount;
        private final int reviewCount;
        private final int ratingCount;
        private final Double ratingAverage;

        public ProductoraDashboardStats(final int obraCount, final int productionCount,
                                        final int watchlistCount, final int seenCount,
                                        final int reviewCount, final int ratingCount,
                                        final Double ratingAverage) {
            this.obraCount = obraCount;
            this.productionCount = productionCount;
            this.watchlistCount = watchlistCount;
            this.seenCount = seenCount;
            this.reviewCount = reviewCount;
            this.ratingCount = ratingCount;
            this.ratingAverage = ratingAverage;
        }

        public int getObraCount() { return obraCount; }
        public int getProductionCount() { return productionCount; }
        public int getWatchlistCount() { return watchlistCount; }
        public int getSeenCount() { return seenCount; }
        public int getReviewCount() { return reviewCount; }
        public int getRatingCount() { return ratingCount; }
        public Double getRatingAverage() { return ratingAverage; }
    }
}
