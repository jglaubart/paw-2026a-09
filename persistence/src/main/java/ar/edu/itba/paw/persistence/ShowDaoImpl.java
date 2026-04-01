package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.ShowDao;
import ar.edu.itba.paw.models.Show;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
public class ShowDaoImpl implements ShowDao {

    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert jdbcInsert;

    private static final RowMapper<Show> SHOW_MAPPER = (rs, rowNum) ->
            new Show(
                    rs.getLong("id"),
                    rs.getLong("production_id"),
                    rs.getDate("show_date").toLocalDate(),
                    rs.getTime("show_time").toLocalTime(),
                    rs.getString("theater"),
                    rs.getString("address"),
                    rs.getString("barrio"),
                    rs.getString("ciudad_partido"),
                    rs.getString("provincia")
            );

    @Autowired
    public ShowDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcInsert = new SimpleJdbcInsert(dataSource)
                .withTableName("shows")
                .usingGeneratedKeyColumns("id");
    }

    @Override
    public Optional<Show> findById(final long id) {
        final List<Show> results = jdbcTemplate.query(
                "SELECT id, production_id, show_date, show_time, theater, address, barrio, ciudad_partido, provincia FROM shows WHERE id = ?",
                new Object[]{ id },
                SHOW_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public List<Show> findByProductionId(final long productionId) {
        return jdbcTemplate.query(
                "SELECT id, production_id, show_date, show_time, theater, address, barrio, ciudad_partido, provincia FROM shows " +
                "WHERE production_id = ? ORDER BY show_date, show_time",
                new Object[]{ productionId },
                SHOW_MAPPER
        );
    }

    @Override
    public List<Show> findFutureByProductionId(final long productionId) {
        return jdbcTemplate.query(
                "SELECT id, production_id, show_date, show_time, theater, address, barrio, ciudad_partido, provincia FROM shows " +
                "WHERE production_id = ? AND show_date >= CURRENT_DATE ORDER BY show_date, show_time",
                new Object[]{ productionId },
                SHOW_MAPPER
        );
    }

    @Override
    public Show create(final long productionId, final LocalDate showDate,
                       final LocalTime showTime, final String theater) {
        final Map<String, Object> params = new HashMap<>();
        params.put("production_id", productionId);
        params.put("show_date", Date.valueOf(showDate));
        params.put("show_time", Time.valueOf(showTime));
        params.put("theater", theater);
        final Number key = jdbcInsert.executeAndReturnKey(params);
        return new Show(key.longValue(), productionId, showDate, showTime, theater);
    }
}
