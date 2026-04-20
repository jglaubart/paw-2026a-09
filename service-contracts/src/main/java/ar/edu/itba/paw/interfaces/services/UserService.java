package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.User;
import java.util.Optional;

public interface UserService {

    enum VerificationResult {
        VERIFIED,
        INVALID_CODE,
        EXPIRED,
        ALREADY_VERIFIED,
        USER_NOT_FOUND
    }

    Optional<User> findById(long id);
    Optional<User> findByEmail(String email);
    Optional<User> findByUsername(String username);
    User create(String email, String password, String username);
    void updateUsername(long userId, String username);
    void updateImage(long userId, long imageId);
    void updateBio(long userId, String bio);

    /**
     * Generates and stores a new 4-digit verification code for the given user
     * and sends it to their email. Marks the user as unverified until the code
     * is validated.
     */
    void issueVerificationCode(long userId);

    /**
     * Validates the submitted code against the stored one and, if correct and
     * not expired, marks the user as verified.
     */
    VerificationResult verifyEmailCode(long userId, String code);
}
