package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.GenreDao;
import ar.edu.itba.paw.models.Genre;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Repository
public class GenreDaoImpl implements GenreDao {

    private final JdbcTemplate jdbcTemplate;

    private static final RowMapper<Genre> GENRE_MAPPER = (rs, rowNum) ->
            new Genre(rs.getLong("id"), rs.getString("name"));

    @Autowired
    public GenreDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public List<Genre> findAll() {
        return jdbcTemplate.query(
                "SELECT id, name FROM genres ORDER BY name",
                GENRE_MAPPER
        );
    }

    @Override
    public Optional<Genre> findById(final long id) {
        final List<Genre> results = jdbcTemplate.query(
                "SELECT id, name FROM genres WHERE id = ?",
                new Object[]{ id },
                GENRE_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public List<Genre> findByIds(final List<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return Collections.emptyList();
        }
        final String placeholders = String.join(",", Collections.nCopies(ids.size(), "?"));
        final String sql = "SELECT id, name FROM genres WHERE id IN (" + placeholders + ") ORDER BY name";
        return jdbcTemplate.query(sql, ids.toArray(), GENRE_MAPPER);
    }

    @Override
    public List<Genre> findByPetitionId(final long petitionId) {
        return jdbcTemplate.query(
                "SELECT g.id, g.name FROM genres g " +
                "INNER JOIN petition_genres pg ON g.id = pg.genre_id " +
                "WHERE pg.petition_id = ? ORDER BY g.name",
                new Object[]{ petitionId },
                GENRE_MAPPER
        );
    }
}
