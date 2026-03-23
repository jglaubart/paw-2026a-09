package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.User;
import java.util.Optional;

public interface UserService {
    Optional<User> findById(long id);
    Optional<User> findByEmail(String email);
    User create(String email, String password);
}
