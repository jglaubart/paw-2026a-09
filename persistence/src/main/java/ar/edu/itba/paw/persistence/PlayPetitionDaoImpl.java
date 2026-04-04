package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.PlayPetitionDao;
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
                rs.getString("petitioner_email"),
                rs.getString("schedule"),
                rs.getString("ticket_url"),
                rs.getString("language"),
                PetitionStatus.valueOf(rs.getString("status")),
                rs.getString("admin_notes"),
                rs.getTimestamp("created_at").toLocalDateTime(),
                resolvedAtTs != null ? resolvedAtTs.toLocalDateTime() : null,
                createdObraId,
                createdProductionId,
                Collections.emptyList(),
                Collections.emptyList()
        );
    };

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
                               final String petitionerEmail, final String schedule, final String ticketUrl,
                               final String language) {

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
        params.put("petitioner_email", petitionerEmail);
        params.put("schedule", schedule);
        params.put("ticket_url", ticketUrl);
        params.put("language", language);
        params.put("status", PetitionStatus.PENDING.name());
        params.put("created_at", Timestamp.valueOf(LocalDateTime.now()));

        final Number key = petitionInsert.executeAndReturnKey(params);

        return new PlayPetition(
                key.longValue(), title, synopsis, durationMinutes, theater, theaterAddress,
                startDate, endDate, coverImageId, director, petitionerEmail, schedule,
                ticketUrl, language, PetitionStatus.PENDING, null,
                LocalDateTime.now(), null, null, null, Collections.emptyList(), Collections.emptyList()
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
    public Optional<PlayPetition> findById(final long id) {
        final List<PlayPetition> results = jdbcTemplate.query(
                "SELECT * FROM play_petitions WHERE id = ?",
                new Object[]{ id },
                PETITION_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
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
