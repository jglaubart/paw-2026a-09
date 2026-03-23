package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.ObraDao;
import ar.edu.itba.paw.models.Obra;
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
public class ObraDaoImpl implements ObraDao {

    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert jdbcInsert;

    private static final RowMapper<Obra> OBRA_MAPPER = (rs, rowNum) ->
            new Obra(rs.getLong("id"), rs.getString("title"),
                    rs.getString("synopsis"), rs.getString("genre"));

    @Autowired
    public ObraDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcInsert = new SimpleJdbcInsert(dataSource)
                .withTableName("obras")
                .usingGeneratedKeyColumns("id");
    }

    @Override
    public Optional<Obra> findById(final long id) {
        final List<Obra> results = jdbcTemplate.query(
                "SELECT id, title, synopsis, genre FROM obras WHERE id = ?",
                new Object[]{ id },
                OBRA_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public List<Obra> findAll(final int page, final int pageSize) {
        return jdbcTemplate.query(
                "SELECT id, title, synopsis, genre FROM obras ORDER BY title LIMIT ? OFFSET ?",
                new Object[]{ pageSize, (long) page * pageSize },
                OBRA_MAPPER
        );
    }

    @Override
    public Obra create(final String title, final String synopsis, final String genre) {
        final Map<String, Object> params = new HashMap<>();
        params.put("title", title);
        params.put("synopsis", synopsis);
        params.put("genre", genre);
        final Number key = jdbcInsert.executeAndReturnKey(params);
        return new Obra(key.longValue(), title, synopsis, genre);
    }
}
