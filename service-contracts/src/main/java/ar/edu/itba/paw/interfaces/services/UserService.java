package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.User;
import java.util.Optional;

public interface UserService {
    Optional<User> findById(long id);
    Optional<User> findByEmail(String email);
    Optional<User> findByUsername(String username);
    User create(String email, String password, String username);
    void updateUsername(long userId, String username);
    void updateImage(long userId, long imageId);
    void updateBio(long userId, String bio);
}
