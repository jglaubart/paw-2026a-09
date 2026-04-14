package ar.edu.itba.paw.interfaces.services.exception;

public class UserAlreadyExistsException extends RuntimeException {

    public UserAlreadyExistsException(final String email) {
        super("User already exists: " + email);
    }
}
