package ar.edu.itba.paw.interfaces.services.exception;

public class UsernameAlreadyExistsException extends RuntimeException {

    public UsernameAlreadyExistsException(final String username) {
        super("Username already exists: " + username);
    }
}
