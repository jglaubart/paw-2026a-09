package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.PlayRatingDao;
import ar.edu.itba.paw.models.PlayRating;
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
