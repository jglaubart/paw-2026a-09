package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.ProductionDao;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.ProductionSearchCriteria;
import ar.edu.itba.paw.models.SearchDateOption;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
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
        final long imageId = rs.getLong("image_id");
        final boolean imageIdNull = rs.wasNull();
        final String resolvedImageUrl = imageIdNull ? rs.getString("image_url") : "/images/" + imageId;
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
                resolvedImageUrl,
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
    public List<Production> findAll() {
        return jdbcTemplate.query(
                "SELECT * FROM productions ORDER BY name",
                PRODUCTION_MAPPER
        );
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
    public List<Production> findAvailable() {
        return jdbcTemplate.query(
                "SELECT * FROM productions p WHERE p.start_date IS NOT NULL AND p.start_date <= CURRENT_DATE " +
                "AND (p.end_date IS NULL OR p.end_date >= CURRENT_DATE) ORDER BY p.name",
                PRODUCTION_MAPPER
        );
    }

    @Override
    public List<Production> findAvailable(final int page, final int pageSize) {
        return jdbcTemplate.query(
                "SELECT * FROM productions p WHERE p.start_date IS NOT NULL AND p.start_date <= CURRENT_DATE " +
                "AND (p.end_date IS NULL OR p.end_date >= CURRENT_DATE) ORDER BY p.name LIMIT ? OFFSET ?",
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
        return search(new ProductionSearchCriteria(query, null, null, null, null, false), page, pageSize);
    }

    @Override
    public List<Production> search(final ProductionSearchCriteria criteria, final int page, final int pageSize) {
        final StringBuilder sql = new StringBuilder(
                "SELECT p.* FROM productions p " +
                "JOIN obras o ON p.obra_id = o.id " +
                "LEFT JOIN productoras pr ON p.productora_id = pr.id " +
                "WHERE 1 = 1"
        );
        final List<Object> params = new ArrayList<>();

        appendSharedSearchFilters(sql, params, criteria);

        if (criteria.getDate() != null) {
            sql.append(
                    " AND EXISTS (" +
                    "  SELECT 1 FROM shows s_date " +
                    "  WHERE s_date.production_id = p.id"
            );
            sql.append(" AND s_date.show_date = ?");
            params.add(Date.valueOf(criteria.getDate()));
            sql.append(" )");
        }

        sql.append(" ORDER BY p.name LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((long) page * pageSize);

        return jdbcTemplate.query(sql.toString(), params.toArray(), PRODUCTION_MAPPER);
    }

    @Override
    public List<SearchDateOption> findNearbyDates(final ProductionSearchCriteria criteria,
                                                  final LocalDate selectedDate,
                                                  final int windowDays) {
        if (selectedDate == null || windowDays < 0) {
            return java.util.Collections.emptyList();
        }

        final StringBuilder sql = new StringBuilder(
                "SELECT s.show_date, COUNT(DISTINCT o.id) AS production_count FROM productions p " +
                "JOIN obras o ON p.obra_id = o.id " +
                "LEFT JOIN productoras pr ON p.productora_id = pr.id " +
                "JOIN shows s ON s.production_id = p.id " +
                "WHERE 1 = 1"
        );
        final List<Object> params = new ArrayList<>();

        appendSharedSearchFilters(sql, params, criteria);

        sql.append(" AND s.show_date BETWEEN ? AND ?");
        params.add(Date.valueOf(selectedDate.minusDays(windowDays)));
        params.add(Date.valueOf(selectedDate.plusDays(windowDays)));

        sql.append(" GROUP BY s.show_date ORDER BY s.show_date");

        return jdbcTemplate.query(
                sql.toString(),
                params.toArray(),
                (rs, rowNum) -> new SearchDateOption(rs.getDate("show_date").toLocalDate(), rs.getInt("production_count"))
        );
    }

    @Override
    public List<Production> findByGenre(final String genre, final int page, final int pageSize) {
        return search(new ProductionSearchCriteria(null, genre, null, null, null, false), page, pageSize);
    }

    private void appendSharedSearchFilters(final StringBuilder sql,
                                           final List<Object> params,
                                           final ProductionSearchCriteria criteria) {
        if (criteria.getQuery() != null) {
            final String pattern = "%" + criteria.getQuery().toLowerCase() + "%";
            sql.append(" AND (LOWER(p.name) LIKE ? OR LOWER(o.title) LIKE ? OR LOWER(pr.name) LIKE ? OR LOWER(p.theater) LIKE ?)");
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
        }

        if (criteria.getGenre() != null) {
            sql.append(" AND LOWER(o.genre) = LOWER(?)");
            params.add(criteria.getGenre());
        }

        if (criteria.getTheater() != null) {
            sql.append(" AND LOWER(p.theater) = LOWER(?)");
            params.add(criteria.getTheater());
        }

        if (criteria.getLocation() != null) {
            sql.append(
                    " AND EXISTS (" +
                    "  SELECT 1 FROM shows s_location " +
                    "  WHERE s_location.production_id = p.id " +
                    "    AND LOWER(CASE " +
                    "      WHEN UPPER(s_location.ciudad_partido) = 'CABA' AND s_location.barrio IS NOT NULL AND s_location.barrio <> '' " +
                    "      THEN s_location.barrio || ' - CABA' " +
                    "      ELSE s_location.ciudad_partido " +
                    "    END) = LOWER(?)" +
                    " )"
            );
            params.add(criteria.getLocation());
        }

        if (criteria.isAvailableOnly()) {
            sql.append(
                    " AND p.start_date IS NOT NULL AND p.start_date <= CURRENT_DATE" +
                    " AND (p.end_date IS NULL OR p.end_date >= CURRENT_DATE)"
            );
        }
    }

    @Override
    public List<String> findAvailableGenres() {
        return jdbcTemplate.queryForList(
                "SELECT DISTINCT o.genre FROM productions p " +
                "JOIN obras o ON p.obra_id = o.id " +
                "WHERE o.genre IS NOT NULL AND o.genre <> '' " +
                "ORDER BY o.genre",
                String.class
        );
    }

    @Override
    public List<String> findAvailableTheaters() {
        return jdbcTemplate.queryForList(
                "SELECT DISTINCT theater FROM productions " +
                "WHERE theater IS NOT NULL AND theater <> '' " +
                "ORDER BY theater",
                String.class
        );
    }

    @Override
    public List<String> findAvailableLocations() {
        return jdbcTemplate.queryForList(
                "SELECT DISTINCT CASE " +
                "  WHEN UPPER(s.ciudad_partido) = 'CABA' AND s.barrio IS NOT NULL AND s.barrio <> '' " +
                "  THEN s.barrio || ' - CABA' " +
                "  ELSE s.ciudad_partido " +
                "END AS location " +
                "FROM shows s " +
                "WHERE s.ciudad_partido IS NOT NULL AND s.ciudad_partido <> '' " +
                "ORDER BY location",
                String.class
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
