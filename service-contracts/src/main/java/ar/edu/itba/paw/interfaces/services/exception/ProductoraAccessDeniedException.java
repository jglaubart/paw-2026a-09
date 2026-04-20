package ar.edu.itba.paw.interfaces.services.exception;

public class ProductoraAccessDeniedException extends RuntimeException {

    public ProductoraAccessDeniedException(final long userId, final long productoraId) {
        super("User " + userId + " does not have permission on productora " + productoraId);
    }
}
