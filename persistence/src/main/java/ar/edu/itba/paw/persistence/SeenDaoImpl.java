package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.SeenDao;
import ar.edu.itba.paw.models.Obra;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.List;

@Repository
public class SeenDaoImpl implements SeenDao {

    private final JdbcTemplate jdbcTemplate;

    private static final RowMapper<Obra> OBRA_MAPPER = (rs, rowNum) ->
            new Obra(rs.getLong("id"), rs.getString("title"),
                    rs.getString("synopsis"), rs.getString("genre"));

    @Autowired
    public SeenDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public List<Obra> findByUser(final long userId) {
        return jdbcTemplate.query(
                "SELECT o.* FROM obras o " +
                "JOIN seen_obras s ON o.id = s.obra_id " +
                "WHERE s.user_id = ? ORDER BY s.seen_at DESC",
                new Object[]{ userId },
                OBRA_MAPPER
        );
    }

    @Override
    public boolean hasSeen(final long userId, final long obraId) {
        final Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM seen_obras WHERE user_id = ? AND obra_id = ?",
                new Object[]{ userId, obraId },
                Integer.class
        );
        return count != null && count > 0;
    }

    @Override
    public void markSeen(final long userId, final long obraId) {
        jdbcTemplate.update(
                "INSERT INTO seen_obras (user_id, obra_id) VALUES (?, ?) ON CONFLICT DO NOTHING",
                userId, obraId
        );
    }

    @Override
    public void unmarkSeen(final long userId, final long obraId) {
        jdbcTemplate.update(
                "DELETE FROM seen_obras WHERE user_id = ? AND obra_id = ?",
                userId, obraId
        );
    }
}
