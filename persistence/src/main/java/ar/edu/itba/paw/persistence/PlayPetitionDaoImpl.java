package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.PlayPetitionDao;
import ar.edu.itba.paw.models.PetitionFieldFeedback;
import ar.edu.itba.paw.models.PetitionStatus;
import ar.edu.itba.paw.models.PlayPetition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Repository
public class PlayPetitionDaoImpl implements PlayPetitionDao {

    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert petitionInsert;

    private static final RowMapper<PlayPetition> PETITION_MAPPER = (rs, rowNum) -> {
        final Date endDateSql = rs.getDate("end_date");
        final Timestamp resolvedAtTs = rs.getTimestamp("resolved_at");
        final long createdObraIdRaw = rs.getLong("created_obra_id");
        final Long createdObraId = rs.wasNull() ? null : createdObraIdRaw;
        final long createdProductionIdRaw = rs.getLong("created_production_id");
        final Long createdProductionId = rs.wasNull() ? null : createdProductionIdRaw;
        final long coverImageIdRaw = rs.getLong("cover_image_id");
        final Long coverImageId = rs.wasNull() ? null : coverImageIdRaw;
        final long petitionerUserIdRaw = rs.getLong("petitioner_user_id");
        final Long petitionerUserId = rs.wasNull() ? null : petitionerUserIdRaw;
        final long sourceObraIdRaw = rs.getLong("source_obra_id");
        final Long sourceObraId = rs.wasNull() ? null : sourceObraIdRaw;
        final long sourceProductionIdRaw = rs.getLong("source_production_id");
        final Long sourceProductionId = rs.wasNull() ? null : sourceProductionIdRaw;

        return new PlayPetition(
                rs.getLong("id"),
                rs.getString("title"),
                rs.getString("synopsis"),
                rs.getInt("duration_minutes"),
                rs.getString("theater"),
                rs.getString("theater_address"),
                rs.getDate("start_date").toLocalDate(),
                endDateSql != null ? endDateSql.toLocalDate() : null,
                coverImageId,
                rs.getString("director"),
                petitionerUserId,
                rs.getString("petitioner_email"),
                rs.getString("schedule"),
                rs.getString("ticket_url"),
                rs.getString("language"),
                PetitionStatus.valueOf(rs.getString("status")),
                rs.getString("admin_notes"),
                rs.getTimestamp("created_at").toLocalDateTime(),
                resolvedAtTs != null ? resolvedAtTs.toLocalDateTime() : null,
                sourceObraId,
                sourceProductionId,
                createdObraId,
                createdProductionId,
                Collections.emptyList(),
                Collections.emptyList(),
                Collections.emptyList()
        );
    };

    private static final RowMapper<PetitionFieldFeedback> FIELD_FEEDBACK_MAPPER = (rs, rowNum) ->
            new PetitionFieldFeedback(rs.getLong("petition_id"), rs.getString("field_key"), rs.getString("comment"));

    @Autowired
    public PlayPetitionDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.petitionInsert = new SimpleJdbcInsert(dataSource)
                .withTableName("play_petitions")
                .usingGeneratedKeyColumns("id");
    }

    @Override
    public PlayPetition create(final String title, final String synopsis, final int durationMinutes,
                               final String theater, final String theaterAddress, final LocalDate startDate,
                               final LocalDate endDate, final Long coverImageId, final String director,
                               final long petitionerUserId, final String petitionerEmail,
                               final String schedule, final String ticketUrl,
                               final String language, final Long sourceObraId,
                               final Long sourceProductionId) {

        final LocalDateTime createdAt = LocalDateTime.now();
        final Map<String, Object> params = new HashMap<>();
        params.put("title", title);
        params.put("synopsis", synopsis);
        params.put("duration_minutes", durationMinutes);
        params.put("theater", theater);
        params.put("theater_address", theaterAddress);
        params.put("start_date", Date.valueOf(startDate));
        params.put("end_date", endDate != null ? Date.valueOf(endDate) : null);
        params.put("cover_image_id", coverImageId);
        params.put("director", director);
        params.put("petitioner_user_id", petitionerUserId);
        params.put("petitioner_email", petitionerEmail);
        params.put("schedule", schedule);
        params.put("ticket_url", ticketUrl);
        params.put("language", language);
        params.put("status", PetitionStatus.PENDING.name());
        params.put("created_at", Timestamp.valueOf(createdAt));
        params.put("source_obra_id", sourceObraId);
        params.put("source_production_id", sourceProductionId);

        final Number key = petitionInsert.executeAndReturnKey(params);

        return new PlayPetition(
                key.longValue(), title, synopsis, durationMinutes, theater, theaterAddress,
                startDate, endDate, coverImageId, director, petitionerUserId, petitionerEmail, schedule,
                ticketUrl, language, PetitionStatus.PENDING, null,
                createdAt, null, sourceObraId, sourceProductionId,
                null, null, Collections.emptyList(), Collections.emptyList(), Collections.emptyList()
        );
    }

    @Override
    public void updateDraft(final long petitionId, final String title, final String synopsis,
                            final int durationMinutes, final String theater, final String theaterAddress,
                            final LocalDate startDate, final LocalDate endDate, final Long coverImageId,
                            final String director, final long petitionerUserId,
                            final String petitionerEmail, final String schedule,
                            final String ticketUrl, final String language,
                            final Long sourceObraId, final Long sourceProductionId) {
        jdbcTemplate.update(
                "UPDATE play_petitions SET title = ?, synopsis = ?, duration_minutes = ?, theater = ?, theater_address = ?, start_date = ?, end_date = ?, cover_image_id = ?, director = ?, petitioner_user_id = ?, petitioner_email = ?, schedule = ?, ticket_url = ?, language = ?, source_obra_id = ?, source_production_id = ? WHERE id = ?",
                title,
                synopsis,
                durationMinutes,
                theater,
                theaterAddress,
                Date.valueOf(startDate),
                endDate != null ? Date.valueOf(endDate) : null,
                coverImageId,
                director,
                petitionerUserId,
                petitionerEmail,
                schedule,
                ticketUrl,
                language,
                sourceObraId,
                sourceProductionId,
                petitionId
        );
    }

    @Override
    public void addGenres(final long petitionId, final List<Long> genreIds) {
        if (genreIds == null || genreIds.isEmpty()) {
            return;
        }
        final String sql = "INSERT INTO petition_genres (petition_id, genre_id) VALUES (?, ?)";
        final List<Object[]> batchArgs = new ArrayList<>();
        for (final Long genreId : genreIds) {
            batchArgs.add(new Object[]{ petitionId, genreId });
        }
        jdbcTemplate.batchUpdate(sql, batchArgs);
    }

    @Override
    public void replaceGenres(final long petitionId, final List<Long> genreIds) {
        jdbcTemplate.update("DELETE FROM petition_genres WHERE petition_id = ?", petitionId);
        addGenres(petitionId, genreIds);
    }

    @Override
    public void addShowDates(final long petitionId, final List<LocalDate> dates) {
        if (dates == null || dates.isEmpty()) {
            return;
        }
        final String sql = "INSERT INTO petition_show_dates (petition_id, show_date) VALUES (?, ?) ON CONFLICT DO NOTHING";
        final List<Object[]> batchArgs = new ArrayList<>();
        for (final LocalDate date : dates) {
            batchArgs.add(new Object[]{ petitionId, Date.valueOf(date) });
        }
        jdbcTemplate.batchUpdate(sql, batchArgs);
    }

    @Override
    public void replaceShowDates(final long petitionId, final List<LocalDate> dates) {
        jdbcTemplate.update("DELETE FROM petition_show_dates WHERE petition_id = ?", petitionId);
        addShowDates(petitionId, dates);
    }

    @Override
    public List<LocalDate> findShowDates(final long petitionId) {
        final List<Date> dates = jdbcTemplate.queryForList(
                "SELECT show_date FROM petition_show_dates WHERE petition_id = ? ORDER BY show_date",
                new Object[]{ petitionId },
                Date.class
        );
        final List<LocalDate> mapped = new ArrayList<>();
        for (final Date date : dates) {
            mapped.add(date.toLocalDate());
        }
        return mapped;
    }

    @Override
    public List<PetitionFieldFeedback> findFieldFeedback(final long petitionId) {
        return jdbcTemplate.query(
                "SELECT petition_id, field_key, comment FROM petition_field_feedback WHERE petition_id = ? ORDER BY field_key",
                new Object[]{ petitionId },
                FIELD_FEEDBACK_MAPPER
        );
    }

    @Override
    public void replaceFieldFeedback(final long petitionId, final Map<String, String> fieldFeedback) {
        jdbcTemplate.update("DELETE FROM petition_field_feedback WHERE petition_id = ?", petitionId);
        if (fieldFeedback == null || fieldFeedback.isEmpty()) {
            return;
        }

        final List<Object[]> batchArgs = new ArrayList<>();
        for (final Map.Entry<String, String> entry : fieldFeedback.entrySet()) {
            batchArgs.add(new Object[]{ petitionId, entry.getKey(), entry.getValue() });
        }
        jdbcTemplate.batchUpdate(
                "INSERT INTO petition_field_feedback (petition_id, field_key, comment, created_at, updated_at) VALUES (?, ?, ?, NOW(), NOW())",
                batchArgs
        );
    }

    @Override
    public Optional<PlayPetition> findById(final long id) {
        final List<PlayPetition> results = jdbcTemplate.query(
                "SELECT * FROM play_petitions WHERE id = ?",
                new Object[]{ id },
                PETITION_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public Optional<PlayPetition> findByIdAndPetitionerUserId(final long id, final long petitionerUserId) {
        final List<PlayPetition> results = jdbcTemplate.query(
                "SELECT * FROM play_petitions WHERE id = ? AND petitioner_user_id = ?",
                new Object[]{ id, petitionerUserId },
                PETITION_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public Optional<PlayPetition> findLatestByPetitionerUserIdAndStatus(final long petitionerUserId,
                                                                         final PetitionStatus status) {
        final List<PlayPetition> results = jdbcTemplate.query(
                "SELECT * FROM play_petitions WHERE petitioner_user_id = ? AND status = ? ORDER BY created_at DESC, id DESC LIMIT 1",
                new Object[]{ petitionerUserId, status.name() },
                PETITION_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public List<PlayPetition> findByPetitionerUserId(final long petitionerUserId) {
        return jdbcTemplate.query(
                "SELECT * FROM play_petitions WHERE petitioner_user_id = ? ORDER BY created_at DESC, id DESC",
                new Object[]{ petitionerUserId },
                PETITION_MAPPER
        );
    }

    @Override
    public List<PlayPetition> findAll(final int page, final int pageSize) {
        return jdbcTemplate.query(
                "SELECT * FROM play_petitions ORDER BY created_at DESC LIMIT ? OFFSET ?",
                new Object[]{ pageSize, (long) page * pageSize },
                PETITION_MAPPER
        );
    }

    @Override
    public List<PlayPetition> findByStatus(final PetitionStatus status, final int page, final int pageSize) {
        return jdbcTemplate.query(
                "SELECT * FROM play_petitions WHERE status = ? ORDER BY created_at DESC LIMIT ? OFFSET ?",
                new Object[]{ status.name(), pageSize, (long) page * pageSize },
                PETITION_MAPPER
        );
    }

    @Override
    public void updateStatus(final long id, final PetitionStatus status, final String adminNotes) {
        if (status == PetitionStatus.PENDING) {
            jdbcTemplate.update(
                    "UPDATE play_petitions SET status = ?, admin_notes = ?, resolved_at = NULL WHERE id = ?",
                    status.name(), adminNotes, id
            );
            return;
        }

        jdbcTemplate.update(
                "UPDATE play_petitions SET status = ?, admin_notes = ?, resolved_at = NOW() WHERE id = ?",
                status.name(), adminNotes, id
        );
    }

    @Override
    public void setCreatedEntities(final long id, final long obraId, final long productionId) {
        jdbcTemplate.update(
                "UPDATE play_petitions SET created_obra_id = ?, created_production_id = ? WHERE id = ?",
                obraId, productionId, id
        );
    }

    @Override
    public int countByStatus(final PetitionStatus status) {
        final Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM play_petitions WHERE status = ?",
                new Object[]{ status.name() },
                Integer.class
        );
        return count != null ? count : 0;
    }

    @Override
    public int countAll() {
        final Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM play_petitions",
                Integer.class
        );
        return count != null ? count : 0;
    }
}
