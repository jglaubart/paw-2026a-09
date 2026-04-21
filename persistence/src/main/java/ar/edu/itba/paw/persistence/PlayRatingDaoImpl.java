package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.PlayRatingDao;
import ar.edu.itba.paw.models.PlayRating;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
public class PlayRatingDaoImpl implements PlayRatingDao {

    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert jdbcInsert;

    private static final RowMapper<PlayRating> RATING_MAPPER = (rs, rowNum) ->
            new PlayRating(rs.getLong("id"), rs.getLong("user_id"),
                    rs.getLong("obra_id"), rs.getInt("score"));

    @Autowired
    public PlayRatingDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcInsert = new SimpleJdbcInsert(dataSource)
                .withTableName("play_ratings")
                .usingColumns("user_id", "obra_id", "score")
                .usingGeneratedKeyColumns("id");
    }

    @Override
    public Optional<PlayRating> findByUserAndObra(final long userId, final long obraId) {
        final List<PlayRating> results = jdbcTemplate.query(
                "SELECT id, user_id, obra_id, score FROM play_ratings WHERE user_id = ? AND obra_id = ?",
                new Object[]{ userId, obraId },
                RATING_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public Optional<Double> findAverageByObra(final long obraId) {
        final Double avg = jdbcTemplate.queryForObject(
                "SELECT AVG(score) FROM play_ratings WHERE obra_id = ?",
                new Object[]{ obraId },
                Double.class
        );
        return Optional.ofNullable(avg);
    }

    @Override
    public Map<Long, Double> findAveragesByProductionIds(final Collection<Long> productionIds) {
        final Map<Long, Double> result = new HashMap<>();
        if (productionIds == null || productionIds.isEmpty()) {
            return result;
        }

        final String inSql = String.join(",", java.util.Collections.nCopies(productionIds.size(), "?"));
        final String sql = "SELECT p.id AS production_id, AVG(pr.score) AS avg_score " +
                "FROM productions p " +
                "JOIN play_ratings pr ON p.obra_id = pr.obra_id " +
                "WHERE p.id IN (" + inSql + ") " +
                "GROUP BY p.id";

        jdbcTemplate.query(sql, productionIds.toArray(), (rs) -> {
            final double avgScore = rs.getDouble("avg_score");
            if (!rs.wasNull()) {
                result.put(rs.getLong("production_id"), avgScore);
            }
        });
        return result;
    }

    @Override
    public Map<Long, Integer> findScoresByUserAndObraIds(final long userId, final Collection<Long> obraIds) {
        final Map<Long, Integer> result = new HashMap<>();
        if (obraIds == null || obraIds.isEmpty()) {
            return result;
        }

        final String inSql = String.join(",", java.util.Collections.nCopies(obraIds.size(), "?"));
        final String sql = "SELECT obra_id, score FROM play_ratings " +
                "WHERE user_id = ? AND obra_id IN (" + inSql + ")";

        final Object[] args = new Object[obraIds.size() + 1];
        args[0] = userId;
        int idx = 1;
        for (final Long obraId : obraIds) {
            args[idx++] = obraId;
        }

        jdbcTemplate.query(sql, args, (rs) -> {
            result.put(rs.getLong("obra_id"), rs.getInt("score"));
        });
        return result;
    }

    @Override
    public Map<Integer, Long> findScoreDistributionByUser(final long userId) {
        final Map<Integer, Long> result = new HashMap<>();
        jdbcTemplate.query(
                "SELECT score, COUNT(*) AS cnt FROM play_ratings WHERE user_id = ? GROUP BY score",
                new Object[]{ userId },
                (org.springframework.jdbc.core.RowCallbackHandler) rs ->
                        result.put(rs.getInt("score"), rs.getLong("cnt"))
        );
        return result;
    }

    @Override
    public Optional<Double> findAverageByUser(final long userId) {
        final Double avg = jdbcTemplate.queryForObject(
                "SELECT AVG(score) FROM play_ratings WHERE user_id = ?",
                new Object[]{ userId },
                Double.class
        );
        return Optional.ofNullable(avg);
    }

    @Override
    public PlayRating create(final long userId, final long obraId, final int score) {
        final Map<String, Object> params = new HashMap<>();
        params.put("user_id", userId);
        params.put("obra_id", obraId);
        params.put("score", score);
        final Number key = jdbcInsert.executeAndReturnKey(params);
        return new PlayRating(key.longValue(), userId, obraId, score);
    }

    @Override
    public PlayRating update(final long userId, final long obraId, final int score) {
        jdbcTemplate.update(
                "UPDATE play_ratings SET score = ? WHERE user_id = ? AND obra_id = ?",
                score, userId, obraId
        );
        return findByUserAndObra(userId, obraId).orElseThrow();
    }
}
