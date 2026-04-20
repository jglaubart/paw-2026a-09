package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.UserDao;
import ar.edu.itba.paw.interfaces.services.MailService;
import ar.edu.itba.paw.interfaces.services.UserService;
import ar.edu.itba.paw.interfaces.services.exception.UserAlreadyExistsException;
import ar.edu.itba.paw.interfaces.services.exception.UsernameAlreadyExistsException;
import ar.edu.itba.paw.models.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Locale;
import java.util.Optional;
import java.util.UUID;

@Service
public class UserServiceImpl implements UserService {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserServiceImpl.class);
    private static final int CODE_TTL_MINUTES = 15;
    private static final int RESET_TTL_MINUTES = 30;
    private static final SecureRandom RANDOM = new SecureRandom();

    private final UserDao userDao;
    private final PasswordEncoder passwordEncoder;
    private final MailService mailService;

    @Autowired
    public UserServiceImpl(final UserDao userDao,
                           final PasswordEncoder passwordEncoder,
                           final MailService mailService) {
        this.userDao = userDao;
        this.passwordEncoder = passwordEncoder;
        this.mailService = mailService;
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
    public Optional<User> findByUsername(final String username) {
        return userDao.findByUsername(username);
    }

    @Override
    public void updateUsername(final long userId, final String username) {
        userDao.updateUsername(userId, username != null ? username.trim() : "");
    }

    @Override
    public void updateImage(final long userId, final long imageId) {
        userDao.updateImage(userId, imageId);
    }

    @Override
    public void updateBio(final long userId, final String bio) {
        userDao.updateBio(userId, bio != null ? bio.trim() : "");
    }

    @Override
    public User create(final String email, final String password, final String username) {
        final String normalizedEmail = normalizeEmail(email);
        final String normalizedUsername = username != null ? username.trim() : "";
        final String encodedPassword = passwordEncoder.encode(password);

        if (!normalizedUsername.isEmpty()) {
            final Optional<User> existingByUsername = userDao.findByUsername(normalizedUsername);
            if (existingByUsername.isPresent() && !existingByUsername.get().getEmail().equalsIgnoreCase(normalizedEmail)) {
                throw new UsernameAlreadyExistsException(normalizedUsername);
            }
        }

        final Optional<User> existingUser = userDao.findByEmail(normalizedEmail);

        if (!existingUser.isPresent()) {
            return userDao.create(normalizedEmail, encodedPassword, normalizedUsername, false);
        }

        final User user = existingUser.get();
        if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
            throw new UserAlreadyExistsException(normalizedEmail);
        }

        userDao.updatePassword(user.getId(), encodedPassword);
        return new User(user.getId(), user.getEmail(), encodedPassword, user.getRole(), user.getUsername(),
                user.getImageId(), user.getBio(), user.isEmailVerified());
    }

    @Override
    public void issueVerificationCode(final long userId) {
        final Optional<User> userOpt = userDao.findById(userId);
        if (!userOpt.isPresent()) {
            LOGGER.warn("Tried to issue verification code for missing user {}", userId);
            return;
        }
        final User user = userOpt.get();
        final String code = generateFourDigitCode();
        final Timestamp expiresAt = Timestamp.from(Instant.now().plus(CODE_TTL_MINUTES, ChronoUnit.MINUTES));
        userDao.setVerificationCode(userId, code, expiresAt);
        try {
            mailService.sendVerificationCode(user.getEmail(), user.getUsername(), code);
            LOGGER.info("Verification code issued for user {}", userId);
        } catch (final RuntimeException e) {
            LOGGER.error("Failed to send verification email for user {}: {}", userId, e.getMessage());
        }
    }

    @Override
    public VerificationResult verifyEmailCode(final long userId, final String code) {
        final Optional<User> userOpt = userDao.findById(userId);
        if (!userOpt.isPresent()) {
            return VerificationResult.USER_NOT_FOUND;
        }
        if (userOpt.get().isEmailVerified()) {
            return VerificationResult.ALREADY_VERIFIED;
        }
        if (code == null || code.trim().isEmpty()) {
            return VerificationResult.INVALID_CODE;
        }

        final Optional<UserDao.VerificationRecord> recordOpt = userDao.findVerification(userId);
        if (!recordOpt.isPresent()) {
            return VerificationResult.INVALID_CODE;
        }
        final UserDao.VerificationRecord record = recordOpt.get();

        if (record.getExpiresAt() != null && record.getExpiresAt().toInstant().isBefore(Instant.now())) {
            return VerificationResult.EXPIRED;
        }
        if (!record.getCode().equals(code.trim())) {
            return VerificationResult.INVALID_CODE;
        }

        userDao.markEmailVerified(userId);
        return VerificationResult.VERIFIED;
    }

    @Override
    public void requestPasswordReset(final String email) {
        if (email == null || email.trim().isEmpty()) {
            return;
        }
        final String normalizedEmail = email.trim().toLowerCase(Locale.ROOT);
        final Optional<User> userOpt = userDao.findByEmail(normalizedEmail);
        if (!userOpt.isPresent()) {
            LOGGER.info("Password reset requested for unknown email (silently ignored)");
            return;
        }
        final User user = userOpt.get();
        final String token = generateResetToken();
        final Timestamp expiresAt = Timestamp.from(Instant.now().plus(RESET_TTL_MINUTES, ChronoUnit.MINUTES));
        userDao.setPasswordResetToken(user.getId(), token, expiresAt);
        try {
            mailService.sendPasswordResetLink(user.getEmail(), user.getUsername(), token);
            LOGGER.info("Password reset link issued for user {}", user.getId());
        } catch (final RuntimeException e) {
            LOGGER.error("Failed to send password reset email for user {}: {}", user.getId(), e.getMessage());
        }
    }

    @Override
    public boolean isPasswordResetTokenValid(final String token) {
        if (token == null || token.trim().isEmpty()) {
            return false;
        }
        final Optional<UserDao.PasswordResetRecord> recordOpt = userDao.findByPasswordResetToken(token.trim());
        if (!recordOpt.isPresent()) {
            return false;
        }
        final Timestamp expiresAt = recordOpt.get().getExpiresAt();
        return expiresAt == null || !expiresAt.toInstant().isBefore(Instant.now());
    }

    @Override
    public ResetPasswordResult resetPassword(final String token, final String newPassword) {
        if (token == null || token.trim().isEmpty()) {
            return ResetPasswordResult.INVALID_TOKEN;
        }
        final Optional<UserDao.PasswordResetRecord> recordOpt = userDao.findByPasswordResetToken(token.trim());
        if (!recordOpt.isPresent()) {
            return ResetPasswordResult.INVALID_TOKEN;
        }
        final UserDao.PasswordResetRecord record = recordOpt.get();
        if (record.getExpiresAt() != null && record.getExpiresAt().toInstant().isBefore(Instant.now())) {
            return ResetPasswordResult.EXPIRED;
        }
        final String encoded = passwordEncoder.encode(newPassword);
        userDao.updatePassword(record.getUserId(), encoded);
        userDao.clearPasswordResetToken(record.getUserId());
        LOGGER.info("Password reset completed for user {}", record.getUserId());
        return ResetPasswordResult.RESET;
    }

    private String generateResetToken() {
        return UUID.randomUUID().toString().replace("-", "")
                + UUID.randomUUID().toString().replace("-", "");
    }

    private String generateFourDigitCode() {
        final int value = RANDOM.nextInt(10000);
        return String.format("%04d", value);
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
