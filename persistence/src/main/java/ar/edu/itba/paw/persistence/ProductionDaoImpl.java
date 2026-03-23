package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.ProductionDao;
import ar.edu.itba.paw.models.Production;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Date;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
public class ProductionDaoImpl implements ProductionDao {

    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert jdbcInsert;

    private static final RowMapper<Production> PRODUCTION_MAPPER = (rs, rowNum) -> {
        final Date startDate = rs.getDate("start_date");
        final Date endDate   = rs.getDate("end_date");
        final long productoraId = rs.getLong("productora_id");
        final boolean productoraNull = rs.wasNull();
        return new Production(
                rs.getLong("id"),
                rs.getString("name"),
                rs.getLong("obra_id"),
                productoraNull ? null : productoraId,
                rs.getString("synopsis"),
                rs.getString("direction"),
                rs.getString("theater"),
                startDate != null ? startDate.toLocalDate() : null,
                endDate   != null ? endDate.toLocalDate()   : null,
                rs.getString("image_url"),
                rs.getString("instagram"),
                rs.getString("website")
        );
    };

    @Autowired
    public ProductionDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcInsert = new SimpleJdbcInsert(dataSource)
                .withTableName("productions")
                .usingGeneratedKeyColumns("id");
    }

    @Override
    public Optional<Production> findById(final long id) {
        final List<Production> results = jdbcTemplate.query(
                "SELECT * FROM productions WHERE id = ?",
                new Object[]{ id },
                PRODUCTION_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public List<Production> findAll(final int page, final int pageSize) {
        return jdbcTemplate.query(
                "SELECT * FROM productions ORDER BY name LIMIT ? OFFSET ?",
                new Object[]{ pageSize, (long) page * pageSize },
                PRODUCTION_MAPPER
        );
    }

    @Override
    public List<Production> findAvailable(final int page, final int pageSize) {
        return jdbcTemplate.query(
                "SELECT * FROM productions p WHERE EXISTS (" +
                "  SELECT 1 FROM shows s WHERE s.production_id = p.id AND s.show_date >= CURRENT_DATE" +
                ") ORDER BY p.name LIMIT ? OFFSET ?",
                new Object[]{ pageSize, (long) page * pageSize },
                PRODUCTION_MAPPER
        );
    }

    @Override
    public List<Production> findByObraId(final long obraId) {
        return jdbcTemplate.query(
                "SELECT * FROM productions WHERE obra_id = ? ORDER BY start_date DESC",
                new Object[]{ obraId },
                PRODUCTION_MAPPER
        );
    }

    @Override
    public List<Production> findByProductoraId(final long productoraId) {
        return jdbcTemplate.query(
                "SELECT * FROM productions WHERE productora_id = ? ORDER BY name",
                new Object[]{ productoraId },
                PRODUCTION_MAPPER
        );
    }

    @Override
    public List<Production> search(final String query, final int page, final int pageSize) {
        final String pattern = "%" + query.toLowerCase() + "%";
        return jdbcTemplate.query(
                "SELECT p.* FROM productions p " +
                "JOIN obras o ON p.obra_id = o.id " +
                "LEFT JOIN productoras pr ON p.productora_id = pr.id " +
                "WHERE LOWER(p.name) LIKE ? " +
                "   OR LOWER(o.title) LIKE ? " +
                "   OR LOWER(pr.name) LIKE ? " +
                "   OR LOWER(p.theater) LIKE ? " +
                "ORDER BY p.name LIMIT ? OFFSET ?",
                new Object[]{ pattern, pattern, pattern, pattern, pageSize, (long) page * pageSize },
                PRODUCTION_MAPPER
        );
    }

    @Override
    public List<Production> findByGenre(final String genre, final int page, final int pageSize) {
        return jdbcTemplate.query(
                "SELECT p.* FROM productions p " +
                "JOIN obras o ON p.obra_id = o.id " +
                "WHERE LOWER(o.genre) = LOWER(?) ORDER BY p.name LIMIT ? OFFSET ?",
                new Object[]{ genre, pageSize, (long) page * pageSize },
                PRODUCTION_MAPPER
        );
    }

    @Override
    public Production create(final String name, final long obraId, final Long productoraId,
                             final String synopsis, final String direction, final String theater,
                             final LocalDate startDate, final LocalDate endDate, final String imageUrl,
                             final String instagram, final String website) {
        final Map<String, Object> params = new HashMap<>();
        params.put("name", name);
        params.put("obra_id", obraId);
        params.put("productora_id", productoraId);
        params.put("synopsis", synopsis);
        params.put("direction", direction);
        params.put("theater", theater);
        params.put("start_date", startDate != null ? Date.valueOf(startDate) : null);
        params.put("end_date",   endDate   != null ? Date.valueOf(endDate)   : null);
        params.put("image_url", imageUrl);
        params.put("instagram", instagram);
        params.put("website", website);
        final Number key = jdbcInsert.executeAndReturnKey(params);
        return new Production(key.longValue(), name, obraId, productoraId, synopsis, direction,
                theater, startDate, endDate, imageUrl, instagram, website);
    }
}
