package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.WatchlistDao;
import ar.edu.itba.paw.models.Production;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Date;
import java.util.List;

@Repository
public class WatchlistDaoImpl implements WatchlistDao {

    private final JdbcTemplate jdbcTemplate;

    private static final RowMapper<Production> PRODUCTION_MAPPER = (rs, rowNum) -> {
        final Date startDate = rs.getDate("start_date");
        final Date endDate = rs.getDate("end_date");
        final long productoraId = rs.getLong("productora_id");
        final boolean productoraNull = rs.wasNull();
        final long imageId = rs.getLong("image_id");
        final boolean imageNull = rs.wasNull();
        return new Production(
                rs.getLong("id"),
                rs.getString("name"),
                rs.getLong("obra_id"),
                productoraNull ? null : productoraId,
                rs.getString("synopsis"),
                rs.getString("direction"),
                rs.getString("theater"),
                startDate != null ? startDate.toLocalDate() : null,
                endDate != null ? endDate.toLocalDate() : null,
                imageNull ? null : imageId,
                rs.getString("genre"),
                rs.getString("instagram"),
                rs.getString("website")
        );
    };

    @Autowired
    public WatchlistDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public List<Production> findByUser(final long userId) {
        return jdbcTemplate.query(
                "SELECT p.* FROM productions p " +
                "JOIN watchlist w ON p.id = w.production_id " +
                "WHERE w.user_id = ? ORDER BY p.name",
                new Object[]{ userId },
                PRODUCTION_MAPPER
        );
    }

    @Override
    public boolean isInWatchlist(final long userId, final long productionId) {
        final Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM watchlist WHERE user_id = ? AND production_id = ?",
                new Object[]{ userId, productionId },
                Integer.class
        );
        return count != null && count > 0;
    }

    @Override
    public void add(final long userId, final long productionId) {
        jdbcTemplate.update(
                "INSERT INTO watchlist (user_id, production_id) VALUES (?, ?) ON CONFLICT DO NOTHING",
                userId, productionId
        );
    }

    @Override
    public void remove(final long userId, final long productionId) {
        jdbcTemplate.update(
                "DELETE FROM watchlist WHERE user_id = ? AND production_id = ?",
                userId, productionId
        );
    }
}
