package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.interfaces.persistence.UserDao;
import ar.edu.itba.paw.models.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

    private static final Logger LOGGER = LoggerFactory.getLogger(UserDaoImpl.class);

    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert jdbcInsert;

    private static final RowMapper<User> USER_MAPPER = (rs, rowNum) ->
            new User(rs.getLong("id"), rs.getString("email"), rs.getString("password"), rs.getString("role"));

    @Autowired
    public UserDaoImpl(final DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcInsert = new SimpleJdbcInsert(dataSource)
                .withTableName("users")
                .usingGeneratedKeyColumns("id");
    }

    @Override
    public Optional<User> findById(final long id) {
        LOGGER.debug("Querying user by id: {}", id);
        final List<User> users = jdbcTemplate.query(
                "SELECT id, email, password, role FROM users WHERE id = ?",
                new Object[]{ id },
                USER_MAPPER
        );
        if (users.isEmpty()) {
            LOGGER.debug("No user found with id: {}", id);
        }
        return users.isEmpty() ? Optional.empty() : Optional.of(users.get(0));
    }

    @Override
    public Optional<User> findByEmail(final String email) {
        LOGGER.debug("Querying user by email: {}", email);
        final List<User> users = jdbcTemplate.query(
                "SELECT id, email, password, role FROM users WHERE email = ?",
                new Object[]{ email },
                USER_MAPPER
        );
        if (users.isEmpty()) {
            LOGGER.debug("No user found with email: {}", email);
        }
        return users.isEmpty() ? Optional.empty() : Optional.of(users.get(0));
    }

    @Override
    public User create(final String email, final String password) {
        LOGGER.debug("Inserting new user with email: {}", email);
        final Map<String, Object> params = new HashMap<>();
        params.put("email", email);
        params.put("password", password);
        params.put("role", "ROLE_USER");
        final Number key = jdbcInsert.executeAndReturnKey(params);
        LOGGER.debug("Inserted user with generated id: {}", key.longValue());
        return new User(key.longValue(), email, password, "ROLE_USER");
    }
}
