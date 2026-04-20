package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.ProductoraDao;
import ar.edu.itba.paw.models.Productora;
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
public class ProductoraDaoImpl implements ProductoraDao {

    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert jdbcInsert;
    private final SimpleJdbcInsert jdbcInsertApproved;

    private static final RowMapper<Productora> PRODUCTORA_MAPPER = (rs, rowNum) ->
            new Productora(
                    rs.getLong("id"),
                    rs.getString("name"),
                    rs.getString("bio"),
                    resolveImageUrl(rs.getLong("image_id"), rs.wasNull()),
                    rs.getString("instagram"),
                    rs.getString("website")
            );

    @Autowired
    public ProductoraDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcInsert = new SimpleJdbcInsert(dataSource)
                .withTableName("productoras")
                .usingColumns("name", "bio", "image_id", "instagram", "website")
                .usingGeneratedKeyColumns("id");
        this.jdbcInsertApproved = new SimpleJdbcInsert(dataSource)
                .withTableName("productoras")
                .usingColumns("name", "bio", "image_id", "instagram", "website",
                        "cuit", "contact_email", "status", "approved_at")
                .usingGeneratedKeyColumns("id");
    }

    @Override
    public Optional<Productora> findById(final long id) {
        final List<Productora> results = jdbcTemplate.query(
                "SELECT id, name, bio, image_id, instagram, website FROM productoras WHERE id = ?",
                new Object[]{ id },
                PRODUCTORA_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public List<Productora> findAll() {
        return jdbcTemplate.query(
                "SELECT id, name, bio, image_id, instagram, website FROM productoras ORDER BY name",
                PRODUCTORA_MAPPER
        );
    }

    @Override
    public Productora create(final String name, final String bio, final Long imageId,
                             final String instagram, final String website) {
        final Map<String, Object> params = new HashMap<>();
        params.put("name", name);
        params.put("bio", bio);
        params.put("image_id", imageId);
        params.put("instagram", instagram);
        params.put("website", website);
        final Number key = jdbcInsert.executeAndReturnKey(params);
        return new Productora(key.longValue(), name, bio, imageId != null ? "/images/" + imageId : null, instagram, website);
    }

    @Override
    public Productora createApproved(final String name, final String bio, final Long imageId,
                                     final String instagram, final String website,
                                     final String cuit, final String contactEmail) {
        final Map<String, Object> params = new HashMap<>();
        params.put("name", name);
        params.put("bio", bio);
        params.put("image_id", imageId);
        params.put("instagram", instagram);
        params.put("website", website);
        params.put("cuit", cuit);
        params.put("contact_email", contactEmail);
        params.put("status", "APPROVED");
        params.put("approved_at", new java.sql.Timestamp(System.currentTimeMillis()));
        final Number key = jdbcInsertApproved.executeAndReturnKey(params);
        return new Productora(key.longValue(), name, bio, imageId != null ? "/images/" + imageId : null, instagram, website);
    }

    @Override
    public void update(final long productoraId, final String name, final String bio, final Long imageId,
                       final String instagram, final String website) {
        jdbcTemplate.update(
                "UPDATE productoras SET name = ?, bio = ?, image_id = ?, instagram = ?, website = ? WHERE id = ?",
                name, bio, imageId, instagram, website, productoraId
        );
    }

    @Override
    public boolean existsByNameIgnoreCase(final String name, final Long excludeId) {
        if (name == null) {
            return false;
        }
        final String sql;
        final Object[] args;
        if (excludeId == null) {
            sql = "SELECT COUNT(*) FROM productoras WHERE LOWER(name) = LOWER(?)";
            args = new Object[]{ name };
        } else {
            sql = "SELECT COUNT(*) FROM productoras WHERE LOWER(name) = LOWER(?) AND id <> ?";
            args = new Object[]{ name, excludeId };
        }
        final Integer count = jdbcTemplate.queryForObject(sql, args, Integer.class);
        return count != null && count > 0;
    }

    private static String resolveImageUrl(final long imageId, final boolean imageIdNull) {
        return imageIdNull ? null : "/images/" + imageId;
    }
}
