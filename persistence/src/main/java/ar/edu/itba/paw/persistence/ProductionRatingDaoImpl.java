package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.ProductionRatingDao;
import ar.edu.itba.paw.models.ProductionRating;
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
public class ProductionRatingDaoImpl implements ProductionRatingDao {

    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert jdbcInsert;

    private static final RowMapper<ProductionRating> RATING_MAPPER = (rs, rowNum) ->
            new ProductionRating(rs.getLong("id"), rs.getLong("user_id"),
                    rs.getLong("production_id"), rs.getInt("score"));

    @Autowired
    public ProductionRatingDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcInsert = new SimpleJdbcInsert(dataSource)
                .withTableName("production_ratings")
                .usingColumns("user_id", "production_id", "score")
                .usingGeneratedKeyColumns("id");
    }

    @Override
    public Optional<ProductionRating> findByUserAndProduction(final long userId, final long productionId) {
        final List<ProductionRating> results = jdbcTemplate.query(
                "SELECT id, user_id, production_id, score FROM production_ratings " +
                "WHERE user_id = ? AND production_id = ?",
                new Object[]{ userId, productionId },
                RATING_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public Optional<Double> findAverageByProduction(final long productionId) {
        final Double avg = jdbcTemplate.queryForObject(
                "SELECT AVG(score) FROM production_ratings WHERE production_id = ?",
                new Object[]{ productionId },
                Double.class
        );
        return Optional.ofNullable(avg);
    }

    @Override
    public ProductionRating create(final long userId, final long productionId, final int score) {
        final Map<String, Object> params = new HashMap<>();
        params.put("user_id", userId);
        params.put("production_id", productionId);
        params.put("score", score);
        final Number key = jdbcInsert.executeAndReturnKey(params);
        return new ProductionRating(key.longValue(), userId, productionId, score);
    }

    @Override
    public ProductionRating update(final long userId, final long productionId, final int score) {
        jdbcTemplate.update(
                "UPDATE production_ratings SET score = ? WHERE user_id = ? AND production_id = ?",
                score, userId, productionId
        );
        return findByUserAndProduction(userId, productionId).orElseThrow();
    }
}
