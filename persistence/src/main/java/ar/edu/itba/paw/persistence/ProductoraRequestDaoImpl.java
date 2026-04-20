package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.ProductoraRequestDao;
import ar.edu.itba.paw.models.ProductoraRequest;
import ar.edu.itba.paw.models.ProductoraRequestStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
public class ProductoraRequestDaoImpl implements ProductoraRequestDao {

    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert jdbcInsert;

    private static final String COLS =
            "id, user_id, contact_email, name, cuit, bio, instagram, website, " +
            "cover_image_id, team_description, team_size, previous_works, supporting_doc_id, " +
            "status, admin_notes, created_at, resolved_at, created_productora_id";

    private static final RowMapper<ProductoraRequest> REQUEST_MAPPER = (rs, rowNum) -> {
        final ProductoraRequest r = new ProductoraRequest();
        r.setId(rs.getLong("id"));
        r.setUserId(rs.getLong("user_id"));
        r.setContactEmail(rs.getString("contact_email"));
        r.setName(rs.getString("name"));
        r.setCuit(rs.getString("cuit"));
        r.setBio(rs.getString("bio"));
        r.setInstagram(rs.getString("instagram"));
        r.setWebsite(rs.getString("website"));
        final long coverId = rs.getLong("cover_image_id");
        r.setCoverImageId(rs.wasNull() ? null : coverId);
        r.setTeamDescription(rs.getString("team_description"));
        final int teamSize = rs.getInt("team_size");
        r.setTeamSize(rs.wasNull() ? null : teamSize);
        r.setPreviousWorks(rs.getString("previous_works"));
        final long supportingId = rs.getLong("supporting_doc_id");
        r.setSupportingDocId(rs.wasNull() ? null : supportingId);
        r.setStatus(ProductoraRequestStatus.fromString(rs.getString("status")));
        r.setAdminNotes(rs.getString("admin_notes"));
        final Timestamp created = rs.getTimestamp("created_at");
        r.setCreatedAt(created != null ? created.toLocalDateTime() : null);
        final Timestamp resolved = rs.getTimestamp("resolved_at");
        r.setResolvedAt(resolved != null ? resolved.toLocalDateTime() : null);
        final long producedId = rs.getLong("created_productora_id");
        r.setCreatedProductoraId(rs.wasNull() ? null : producedId);
        return r;
    };

    @Autowired
    public ProductoraRequestDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcInsert = new SimpleJdbcInsert(dataSource)
                .withTableName("productora_requests")
                .usingGeneratedKeyColumns("id");
    }

    @Override
    public Optional<ProductoraRequest> findById(final long id) {
        final List<ProductoraRequest> results = jdbcTemplate.query(
                "SELECT " + COLS + " FROM productora_requests WHERE id = ?",
                new Object[]{ id },
                REQUEST_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public List<ProductoraRequest> findByUser(final long userId) {
        return jdbcTemplate.query(
                "SELECT " + COLS + " FROM productora_requests WHERE user_id = ? ORDER BY created_at DESC",
                new Object[]{ userId },
                REQUEST_MAPPER
        );
    }

    @Override
    public Optional<ProductoraRequest> findActiveByUser(final long userId) {
        final List<ProductoraRequest> results = jdbcTemplate.query(
                "SELECT " + COLS + " FROM productora_requests " +
                        "WHERE user_id = ? AND status IN ('PENDING', 'CHANGES_REQUESTED') " +
                        "ORDER BY created_at DESC LIMIT 1",
                new Object[]{ userId },
                REQUEST_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public List<ProductoraRequest> findForAdmin(final ProductoraRequestStatus statusFilter) {
        if (statusFilter == null) {
            return jdbcTemplate.query(
                    "SELECT " + COLS + " FROM productora_requests ORDER BY created_at DESC",
                    REQUEST_MAPPER
            );
        }
        return jdbcTemplate.query(
                "SELECT " + COLS + " FROM productora_requests WHERE status = ? ORDER BY created_at DESC",
                new Object[]{ statusFilter.name() },
                REQUEST_MAPPER
        );
    }

    @Override
    public Map<ProductoraRequestStatus, Integer> countByStatus() {
        final Map<ProductoraRequestStatus, Integer> result = new EnumMap<>(ProductoraRequestStatus.class);
        for (final ProductoraRequestStatus s : ProductoraRequestStatus.values()) {
            result.put(s, 0);
        }
        jdbcTemplate.query(
                "SELECT status, COUNT(*) AS total FROM productora_requests GROUP BY status",
                (rs) -> {
                    final ProductoraRequestStatus s = ProductoraRequestStatus.fromString(rs.getString("status"));
                    result.put(s, rs.getInt("total"));
                }
        );
        return result;
    }

    @Override
    public ProductoraRequest create(final ProductoraRequest request) {
        final LocalDateTime now = request.getCreatedAt() != null ? request.getCreatedAt() : LocalDateTime.now();
        final Map<String, Object> params = new HashMap<>();
        params.put("user_id", request.getUserId());
        params.put("contact_email", request.getContactEmail());
        params.put("name", request.getName());
        params.put("cuit", request.getCuit());
        params.put("bio", request.getBio());
        params.put("instagram", request.getInstagram());
        params.put("website", request.getWebsite());
        params.put("cover_image_id", request.getCoverImageId());
        params.put("team_description", request.getTeamDescription());
        params.put("team_size", request.getTeamSize());
        params.put("previous_works", request.getPreviousWorks());
        params.put("supporting_doc_id", request.getSupportingDocId());
        params.put("status", ProductoraRequestStatus.PENDING.name());
        params.put("created_at", Timestamp.valueOf(now));
        final Number key = jdbcInsert.executeAndReturnKey(params);
        request.setId(key.longValue());
        request.setStatus(ProductoraRequestStatus.PENDING);
        request.setCreatedAt(now);
        return request;
    }

    @Override
    public void updateContent(final ProductoraRequest request) {
        jdbcTemplate.update(
                "UPDATE productora_requests SET contact_email = ?, name = ?, cuit = ?, bio = ?, " +
                        "instagram = ?, website = ?, cover_image_id = ?, team_description = ?, " +
                        "team_size = ?, previous_works = ?, supporting_doc_id = ?, " +
                        "status = 'PENDING', admin_notes = NULL, resolved_at = NULL " +
                        "WHERE id = ?",
                request.getContactEmail(), request.getName(), request.getCuit(), request.getBio(),
                request.getInstagram(), request.getWebsite(), request.getCoverImageId(),
                request.getTeamDescription(), request.getTeamSize(), request.getPreviousWorks(),
                request.getSupportingDocId(), request.getId()
        );
    }

    @Override
    public void updateStatus(final long requestId, final ProductoraRequestStatus status,
                             final String adminNotes, final Long createdProductoraId) {
        final Timestamp resolvedAt = (status == ProductoraRequestStatus.APPROVED
                || status == ProductoraRequestStatus.REJECTED)
                ? new Timestamp(System.currentTimeMillis())
                : null;
        jdbcTemplate.update(
                "UPDATE productora_requests SET status = ?, admin_notes = ?, resolved_at = ?, " +
                        "created_productora_id = COALESCE(?, created_productora_id) WHERE id = ?",
                status.name(), adminNotes, resolvedAt, createdProductoraId, requestId
        );
    }

    @Override
    public Map<String, String> findFieldFeedback(final long requestId) {
        final Map<String, String> result = new HashMap<>();
        jdbcTemplate.query(
                "SELECT field_name, feedback FROM productora_request_field_feedback WHERE request_id = ?",
                new Object[]{ requestId },
                (RowCallbackHandler) (rs) -> result.put(rs.getString("field_name"), rs.getString("feedback"))
        );
        return result;
    }

    @Override
    public void replaceFieldFeedback(final long requestId, final Map<String, String> feedbackByField) {
        clearFieldFeedback(requestId);
        if (feedbackByField == null || feedbackByField.isEmpty()) {
            return;
        }
        final List<Object[]> batch = new ArrayList<>();
        for (final Map.Entry<String, String> e : feedbackByField.entrySet()) {
            if (e.getValue() == null || e.getValue().trim().isEmpty()) continue;
            batch.add(new Object[]{ requestId, e.getKey(), e.getValue() });
        }
        if (batch.isEmpty()) return;
        jdbcTemplate.batchUpdate(
                "INSERT INTO productora_request_field_feedback (request_id, field_name, feedback) " +
                        "VALUES (?, ?, ?)",
                batch
        );
    }

    @Override
    public void clearFieldFeedback(final long requestId) {
        jdbcTemplate.update(
                "DELETE FROM productora_request_field_feedback WHERE request_id = ?",
                requestId
        );
    }
}
