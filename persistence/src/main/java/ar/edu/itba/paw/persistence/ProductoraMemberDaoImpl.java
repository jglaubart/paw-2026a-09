package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.ProductoraMemberDao;
import ar.edu.itba.paw.models.ProductoraMember;
import ar.edu.itba.paw.models.ProductoraMemberRole;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

@Repository
public class ProductoraMemberDaoImpl implements ProductoraMemberDao {

    private final JdbcTemplate jdbcTemplate;

    private static final RowMapper<ProductoraMember> MEMBER_MAPPER = (rs, rowNum) -> {
        final Timestamp joined = rs.getTimestamp("joined_at");
        final ProductoraMember m = new ProductoraMember(
                rs.getLong("user_id"),
                rs.getLong("productora_id"),
                ProductoraMemberRole.fromString(rs.getString("role")),
                joined != null ? joined.toLocalDateTime() : null
        );
        return m;
    };

    private static final RowMapper<ProductoraMember> MEMBER_JOIN_MAPPER = (rs, rowNum) -> {
        final Timestamp joined = rs.getTimestamp("joined_at");
        final ProductoraMember m = new ProductoraMember(
                rs.getLong("user_id"),
                rs.getLong("productora_id"),
                ProductoraMemberRole.fromString(rs.getString("role")),
                joined != null ? joined.toLocalDateTime() : null
        );
        m.setUserEmail(rs.getString("user_email"));
        m.setUsername(rs.getString("username"));
        return m;
    };

    @Autowired
    public ProductoraMemberDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public List<ProductoraMember> findByProductora(final long productoraId) {
        return jdbcTemplate.query(
                "SELECT pm.user_id, pm.productora_id, pm.role, pm.joined_at, " +
                        "u.email AS user_email, u.username AS username " +
                        "FROM productora_members pm JOIN users u ON u.id = pm.user_id " +
                        "WHERE pm.productora_id = ? ORDER BY pm.role DESC, pm.joined_at ASC",
                new Object[]{ productoraId },
                MEMBER_JOIN_MAPPER
        );
    }

    @Override
    public List<ProductoraMember> findByUser(final long userId) {
        return jdbcTemplate.query(
                "SELECT user_id, productora_id, role, joined_at FROM productora_members WHERE user_id = ?",
                new Object[]{ userId },
                MEMBER_MAPPER
        );
    }

    @Override
    public Optional<ProductoraMember> find(final long userId, final long productoraId) {
        final List<ProductoraMember> results = jdbcTemplate.query(
                "SELECT user_id, productora_id, role, joined_at FROM productora_members " +
                        "WHERE user_id = ? AND productora_id = ?",
                new Object[]{ userId, productoraId },
                MEMBER_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public boolean exists(final long userId, final long productoraId) {
        final Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM productora_members WHERE user_id = ? AND productora_id = ?",
                new Object[]{ userId, productoraId },
                Integer.class
        );
        return count != null && count > 0;
    }

    @Override
    public boolean isOwnerOfAnyProductora(final long userId) {
        final Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM productora_members pm " +
                        "JOIN productoras p ON p.id = pm.productora_id " +
                        "WHERE pm.user_id = ? AND pm.role = 'OWNER' AND p.status = 'APPROVED'",
                new Object[]{ userId },
                Integer.class
        );
        return count != null && count > 0;
    }

    @Override
    public void add(final long userId, final long productoraId, final ProductoraMemberRole role) {
        jdbcTemplate.update(
                "INSERT INTO productora_members (user_id, productora_id, role) VALUES (?, ?, ?) " +
                        "ON CONFLICT (user_id, productora_id) DO NOTHING",
                userId, productoraId, role.name()
        );
    }

    @Override
    public void remove(final long userId, final long productoraId) {
        jdbcTemplate.update(
                "DELETE FROM productora_members WHERE user_id = ? AND productora_id = ?",
                userId, productoraId
        );
    }

    @Override
    public void updateRole(final long userId, final long productoraId, final ProductoraMemberRole role) {
        jdbcTemplate.update(
                "UPDATE productora_members SET role = ? WHERE user_id = ? AND productora_id = ?",
                role.name(), userId, productoraId
        );
    }
}
