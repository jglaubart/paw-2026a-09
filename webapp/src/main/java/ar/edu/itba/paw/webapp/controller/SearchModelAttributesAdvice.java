package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ProductionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.List;

@ControllerAdvice
public class SearchModelAttributesAdvice {

    private final ProductionService productionService;

    @Autowired
    public SearchModelAttributesAdvice(final ProductionService productionService) {
        this.productionService = productionService;
    }

    @ModelAttribute("searchGenres")
    public List<String> searchGenres() {
        return productionService.findAvailableGenres();
    }

    @ModelAttribute("searchTheaters")
    public List<String> searchTheaters() {
        return productionService.findAvailableTheaters();
    }

    @ModelAttribute("searchLocations")
    public List<String> searchLocations() {
        return productionService.findAvailableLocations();
    }
}
