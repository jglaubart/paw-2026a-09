package ar.edu.itba.paw.interfaces.services.exception;

public class ProductoraRequestAlreadyActiveException extends RuntimeException {

    public ProductoraRequestAlreadyActiveException(final long userId) {
        super("User " + userId + " already has an active productora request");
    }
}
