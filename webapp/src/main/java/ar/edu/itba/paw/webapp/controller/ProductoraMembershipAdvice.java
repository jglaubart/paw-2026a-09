package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ProductoraService;
import ar.edu.itba.paw.webapp.auth.PawAuthUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

/**
 * Exposes `navIsProductoraMember` on every request so the navbar can decide
 * whether to render the "Subir obra" button and the "Mi productora" link
 * without forcing every controller to add the flag explicitly.
 */
@ControllerAdvice
public class ProductoraMembershipAdvice {

    private final ProductoraService productoraService;

    @Autowired
    public ProductoraMembershipAdvice(final ProductoraService productoraService) {
        this.productoraService = productoraService;
    }

    @ModelAttribute("navIsProductoraMember")
    public boolean isProductoraMember(@AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser == null) {
            return false;
        }
        return !productoraService.findMineByUser(authUser.getUser().getId()).isEmpty();
    }
}
