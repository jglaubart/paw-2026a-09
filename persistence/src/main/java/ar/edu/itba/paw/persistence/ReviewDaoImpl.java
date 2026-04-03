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

    private static final RowMapper<Review> REVIEW_MAPPER = (rs, rowNum) ->
            new Review(
                    rs.getLong("id"),
                    rs.getLong("user_id"),
                    rs.getString("user_email"),
                    rs.getLong("production_id"),
                    rs.getLong("obra_id"),
                    rs.getString("body"),
                    rs.getObject("rating_id") != null ? rs.getLong("rating_id") : null
            );

    private static final String SELECT_WITH_JOIN =
            "SELECT r.id, r.body, r.rating_id, r.user_id, r.production_id, p.obra_id, u.email AS user_email " +
            "FROM production_reviews r " +
            "JOIN users u ON r.user_id = u.id " +
            "JOIN productions p ON r.production_id = p.id ";

    @Autowired
    public ReviewDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcInsert = new SimpleJdbcInsert(dataSource)
                .withTableName("production_reviews")
                .usingColumns("user_id", "production_id", "body")
                .usingGeneratedKeyColumns("id");
    }

    @Override
    public Optional<Review> findByUserAndProduction(final long userId, final long productionId) {
        final List<Review> results = jdbcTemplate.query(
                SELECT_WITH_JOIN + "WHERE r.user_id = ? AND r.production_id = ?",
                new Object[]{ userId, productionId },
                REVIEW_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public List<Review> findByProduction(final long productionId) {
        return jdbcTemplate.query(
                SELECT_WITH_JOIN + "WHERE r.production_id = ? ORDER BY r.created_at DESC",
                new Object[]{ productionId },
                REVIEW_MAPPER
        );
    }

    @Override
    public List<Review> findByUser(final long userId) {
        return jdbcTemplate.query(
                SELECT_WITH_JOIN + "WHERE r.user_id = ? ORDER BY r.created_at DESC",
                new Object[]{ userId },
                REVIEW_MAPPER
        );
    }

    @Override
    public Review create(final long userId, final long productionId, final String body) {
        final Map<String, Object> params = new HashMap<>();
        params.put("user_id", userId);
        params.put("production_id", productionId);
        params.put("body", body);
        final Number key = jdbcInsert.executeAndReturnKey(params);
        return findByUserAndProduction(userId, productionId).orElseThrow();
    }

    @Override
    public Review update(final long userId, final long productionId, final String body) {
        jdbcTemplate.update(
                "UPDATE production_reviews SET body = ?, created_at = NOW() WHERE user_id = ? AND production_id = ?",
                body, userId, productionId
        );
        return findByUserAndProduction(userId, productionId).orElseThrow();
    }
}
