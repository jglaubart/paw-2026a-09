package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.User;

import java.sql.Timestamp;
import java.util.Optional;

public interface UserDao {
    Optional<User> findById(long id);
    Optional<User> findByEmail(String email);
    Optional<User> findByUsername(String username);
    User create(String email, String password, String username, boolean emailVerified);
    void updatePassword(long userId, String password);
    void updateUsername(long userId, String username);
    void updateImage(long userId, long imageId);
    void updateBio(long userId, String bio);
    void setVerificationCode(long userId, String code, Timestamp expiresAt);
    Optional<VerificationRecord> findVerification(long userId);
    void markEmailVerified(long userId);

    void setPasswordResetToken(long userId, String token, Timestamp expiresAt);
    Optional<PasswordResetRecord> findByPasswordResetToken(String token);
    void clearPasswordResetToken(long userId);

    final class VerificationRecord {
        private final String code;
        private final Timestamp expiresAt;

        public VerificationRecord(final String code, final Timestamp expiresAt) {
            this.code = code;
            this.expiresAt = expiresAt;
        }

        public String getCode() { return code; }
        public Timestamp getExpiresAt() { return expiresAt; }
    }

    final class PasswordResetRecord {
        private final long userId;
        private final String email;
        private final Timestamp expiresAt;

        public PasswordResetRecord(final long userId, final String email, final Timestamp expiresAt) {
            this.userId = userId;
            this.email = email;
            this.expiresAt = expiresAt;
        }

        public long getUserId() { return userId; }
        public String getEmail() { return email; }
        public Timestamp getExpiresAt() { return expiresAt; }
    }
}
