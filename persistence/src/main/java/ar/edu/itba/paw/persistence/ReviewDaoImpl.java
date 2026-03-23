package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.ReviewDao;
import ar.edu.itba.paw.models.Review;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
public class ReviewDaoImpl implements ReviewDao {

    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert jdbcInsert;

    // user_id and production_id come from the JOIN with production_ratings (not stored in production_reviews)
    private static final RowMapper<Review> REVIEW_MAPPER = (rs, rowNum) ->
            new Review(rs.getLong("id"), rs.getLong("user_id"),
                    rs.getLong("production_id"), rs.getString("body"), rs.getLong("rating_id"));

    private static final String SELECT_WITH_JOIN =
            "SELECT r.id, r.body, r.rating_id, pr.user_id, pr.production_id " +
            "FROM production_reviews r " +
            "JOIN production_ratings pr ON r.rating_id = pr.id ";

    @Autowired
    public ReviewDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcInsert = new SimpleJdbcInsert(dataSource)
                .withTableName("production_reviews")
                .usingColumns("rating_id", "body")
                .usingGeneratedKeyColumns("id");
    }

    @Override
    public Optional<Review> findByUserAndProduction(final long userId, final long productionId) {
        final List<Review> results = jdbcTemplate.query(
                SELECT_WITH_JOIN + "WHERE pr.user_id = ? AND pr.production_id = ?",
                new Object[]{ userId, productionId },
                REVIEW_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public List<Review> findByProduction(final long productionId) {
        return jdbcTemplate.query(
                SELECT_WITH_JOIN + "WHERE pr.production_id = ?",
                new Object[]{ productionId },
                REVIEW_MAPPER
        );
    }

    @Override
    public List<Review> findByUser(final long userId) {
        return jdbcTemplate.query(
                SELECT_WITH_JOIN + "WHERE pr.user_id = ?",
                new Object[]{ userId },
                REVIEW_MAPPER
        );
    }

    @Override
    public Review create(final long userId, final long productionId, final String body, final long ratingId) {
        final Map<String, Object> params = new HashMap<>();
        params.put("rating_id", ratingId);
        params.put("body", body);
        final Number key = jdbcInsert.executeAndReturnKey(params);
        return new Review(key.longValue(), userId, productionId, body, ratingId);
    }
}
