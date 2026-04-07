package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.UserDao;
import ar.edu.itba.paw.interfaces.services.UserService;
import ar.edu.itba.paw.models.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserServiceImpl.class);

    private final UserDao userDao;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public UserServiceImpl(final UserDao userDao, final PasswordEncoder passwordEncoder) {
        this.userDao = userDao;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public Optional<User> findById(final long id) {
        LOGGER.debug("Looking up user by id: {}", id);
        return userDao.findById(id);
    }

    @Override
    public Optional<User> findByEmail(final String email) {
        LOGGER.debug("Looking up user by email: {}", email);
        return userDao.findByEmail(email);
    }

    @Override
    public User create(final String email, final String password) {
        LOGGER.info("Creating new user with email: {}", email);
        final User user = userDao.create(email, passwordEncoder.encode(password));
        LOGGER.info("User created successfully with id: {}", user.getId());
        return user;
    }
}
