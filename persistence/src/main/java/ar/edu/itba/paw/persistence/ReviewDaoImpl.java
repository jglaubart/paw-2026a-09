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
            new Review(rs.getLong("id"), rs.getLong("user_id"),
                    rs.getLong("obra_id"), rs.getString("body"), rs.getLong("rating_id"));

    @Autowired
    public ReviewDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcInsert = new SimpleJdbcInsert(dataSource)
                .withTableName("reviews")
                .usingColumns("user_id", "obra_id", "body", "rating_id")
                .usingGeneratedKeyColumns("id");
    }

    @Override
    public Optional<Review> findByUserAndObra(final long userId, final long obraId) {
        final List<Review> results = jdbcTemplate.query(
                "SELECT id, user_id, obra_id, body, rating_id FROM reviews " +
                "WHERE user_id = ? AND obra_id = ?",
                new Object[]{ userId, obraId },
                REVIEW_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public List<Review> findByObra(final long obraId) {
        return jdbcTemplate.query(
                "SELECT id, user_id, obra_id, body, rating_id FROM reviews WHERE obra_id = ?",
                new Object[]{ obraId },
                REVIEW_MAPPER
        );
    }

    @Override
    public List<Review> findByUser(final long userId) {
        return jdbcTemplate.query(
                "SELECT id, user_id, obra_id, body, rating_id FROM reviews WHERE user_id = ?",
                new Object[]{ userId },
                REVIEW_MAPPER
        );
    }

    @Override
    public Review create(final long userId, final long obraId, final String body, final long ratingId) {
        final Map<String, Object> params = new HashMap<>();
        params.put("user_id", userId);
        params.put("obra_id", obraId);
        params.put("body", body);
        params.put("rating_id", ratingId);
        final Number key = jdbcInsert.executeAndReturnKey(params);
        return new Review(key.longValue(), userId, obraId, body, ratingId);
    }
}
