package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.Productora;
import java.util.List;
import java.util.Optional;

public interface ProductoraDao {
    Optional<Productora> findById(long id);
    List<Productora> findAll();
    Productora create(String name, String bio, Long imageId, String instagram, String website);

    Productora createApproved(String name, String bio, Long imageId,
                              String instagram, String website,
                              String cuit, String contactEmail);

    void update(long productoraId, String name, String bio, Long imageId,
                String instagram, String website);

    boolean existsByNameIgnoreCase(String name, Long excludeId);

    /**
     * Aggregated dashboard stats for a productora computed with a single
     * query across obras, productions, watchlist, seen, ratings and reviews.
     * Returns an array ordered:
     *   [0] obraCount, [1] productionCount, [2] watchlistCount,
     *   [3] seenCount, [4] reviewCount, [5] ratingCount
     * and the rating average as the second element (may be null).
     */
    DashboardStats findDashboardStats(long productoraId);

    class DashboardStats {
        private final int obraCount;
        private final int productionCount;
        private final int watchlistCount;
        private final int seenCount;
        private final int reviewCount;
        private final int ratingCount;
        private final Double ratingAverage;

        public DashboardStats(final int obraCount, final int productionCount,
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
