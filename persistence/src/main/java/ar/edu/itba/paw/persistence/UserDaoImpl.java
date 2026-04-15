package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.UserDao;
import ar.edu.itba.paw.models.User;
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
public class UserDaoImpl implements UserDao {

    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert jdbcInsert;

    private static final RowMapper<User> USER_MAPPER = (rs, rowNum) -> {
        final Object imgId = rs.getObject("image_id");
        return new User(rs.getLong("id"), rs.getString("email"), rs.getString("password"),
                rs.getString("role"), rs.getString("username"),
                imgId != null ? rs.getLong("image_id") : null,
                rs.getString("bio"));
    };

    @Autowired
    public UserDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcInsert = new SimpleJdbcInsert(dataSource)
                .withTableName("users")
                .usingGeneratedKeyColumns("id");
    }

    @Override
    public Optional<User> findById(final long id) {
        final List<User> users = jdbcTemplate.query(
                "SELECT id, email, password, role, username, image_id, bio FROM users WHERE id = ?",
                new Object[]{ id },
                USER_MAPPER
        );
        return users.isEmpty() ? Optional.empty() : Optional.of(users.get(0));
    }

    @Override
    public Optional<User> findByEmail(final String email) {
        final List<User> users = jdbcTemplate.query(
                "SELECT id, email, password, role, username, image_id, bio FROM users WHERE email = ?",
                new Object[]{ email },
                USER_MAPPER
        );
        return users.isEmpty() ? Optional.empty() : Optional.of(users.get(0));
    }

    @Override
    public User create(final String email, final String password, final String username) {
        final Map<String, Object> params = new HashMap<>();
        params.put("email", email);
        params.put("password", password);
        params.put("role", "ROLE_USER");
        params.put("username", username != null ? username : "");
        final Number key = jdbcInsert.executeAndReturnKey(params);
        return new User(key.longValue(), email, password, "ROLE_USER", username != null ? username : "");
    }

    @Override
    public Optional<User> findByUsername(final String username) {
        final List<User> users = jdbcTemplate.query(
                "SELECT id, email, password, role, username, image_id, bio FROM users WHERE username = ?",
                new Object[]{ username },
                USER_MAPPER
        );
        return users.isEmpty() ? Optional.empty() : Optional.of(users.get(0));
    }

    @Override
    public void updatePassword(final long userId, final String password) {
        jdbcTemplate.update(
                "UPDATE users SET password = ? WHERE id = ?",
                password,
                userId
        );
    }

    @Override
    public void updateUsername(final long userId, final String username) {
        jdbcTemplate.update(
                "UPDATE users SET username = ? WHERE id = ?",
                username,
                userId
        );
    }

    @Override
    public void updateImage(final long userId, final long imageId) {
        jdbcTemplate.update(
                "UPDATE users SET image_id = ? WHERE id = ?",
                imageId,
                userId
        );
    }

    @Override
    public void updateBio(final long userId, final String bio) {
        jdbcTemplate.update(
                "UPDATE users SET bio = ? WHERE id = ?",
                bio != null ? bio : "",
                userId
        );
    }
}
