package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.User;
import java.util.Optional;

public interface UserDao {
    Optional<User> findById(long id);
    Optional<User> findByEmail(String email);
    User create(String email, String password);
}
