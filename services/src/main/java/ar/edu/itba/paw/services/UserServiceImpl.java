package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.UserDao;
import ar.edu.itba.paw.interfaces.services.UserService;
import ar.edu.itba.paw.interfaces.services.exception.UserAlreadyExistsException;
import ar.edu.itba.paw.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Locale;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {

    private final UserDao userDao;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public UserServiceImpl(final UserDao userDao,
                           final PasswordEncoder passwordEncoder) {
        this.userDao = userDao;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public Optional<User> findById(final long id) {
        return userDao.findById(id);
    }

    @Override
    public Optional<User> findByEmail(final String email) {
        return userDao.findByEmail(email);
    }

    @Override
    public User create(final String email, final String password) {
        final String normalizedEmail = normalizeEmail(email);
        final String encodedPassword = passwordEncoder.encode(password);
        final Optional<User> existingUser = userDao.findByEmail(normalizedEmail);

        if (!existingUser.isPresent()) {
            return userDao.create(normalizedEmail, encodedPassword);
        }

        final User user = existingUser.get();
        if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
            throw new UserAlreadyExistsException(normalizedEmail);
        }

        userDao.updatePassword(user.getId(), encodedPassword);
        return new User(user.getId(), user.getEmail(), encodedPassword, user.getRole());
    }

    private String normalizeEmail(final String email) {
        if (email == null) {
            throw new IllegalArgumentException("Email is required");
        }

        final String normalizedEmail = email.trim().toLowerCase(Locale.ROOT);
        if (normalizedEmail.isEmpty()) {
            throw new IllegalArgumentException("Email is required");
        }
        return normalizedEmail;
    }
}
