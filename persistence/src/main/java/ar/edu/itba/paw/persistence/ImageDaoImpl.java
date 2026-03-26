package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.ImageDao;
import ar.edu.itba.paw.models.Image;
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
public class ImageDaoImpl implements ImageDao {

    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert jdbcInsert;

    private static final RowMapper<Image> IMAGE_MAPPER = (rs, rowNum) ->
            new Image(rs.getLong("id"), rs.getBytes("content"));

    @Autowired
    public ImageDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcInsert = new SimpleJdbcInsert(dataSource)
                .withTableName("images")
                .usingGeneratedKeyColumns("id");
    }

    @Override
    public Optional<Image> findById(final long id) {
        final List<Image> results = jdbcTemplate.query(
                "SELECT id, content FROM images WHERE id = ?",
                new Object[]{ id },
                IMAGE_MAPPER
        );
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public Image create(final byte[] content) {
        final Map<String, Object> params = new HashMap<>();
        params.put("content", content);
        final Number key = jdbcInsert.executeAndReturnKey(params);
        return new Image(key.longValue(), content);
    }
}
