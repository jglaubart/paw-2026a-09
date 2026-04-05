package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ProductionService;
import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.models.Production;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Optional;

@Controller
public class ProductionController {

    private static final int PRODUCTION_PAGE_SIZE = 8;

    private final ProductionService productionService;
    private final RatingService ratingService;

    @Autowired
    public ProductionController(final ProductionService productionService,
                                final RatingService ratingService) {
        this.productionService = productionService;
        this.ratingService = ratingService;
    }

    @RequestMapping(value = "/productions/{id:\\d+}", method = RequestMethod.GET)
    public ModelAndView detail(@PathVariable("id") final long id) {
        final Optional<Production> productionOpt = productionService.findById(id);
        if (!productionOpt.isPresent()) {
            return new ModelAndView("redirect:/");
        }
        final Production production = productionOpt.get();
        return new ModelAndView("redirect:/obras/" + production.getObraId() + "?produccionId=" + id);
    }

    @RequestMapping(value = "/cartelera", method = RequestMethod.GET)
    public ModelAndView cartelera(
            @RequestParam(value = "page", defaultValue = "0") final int page,
            @RequestParam(value = "genre", required = false) final String genre) {
        return list(page, true, genre);
    }

    @RequestMapping(value = "/productions", method = RequestMethod.GET)
    public ModelAndView list(
            @RequestParam(value = "page", defaultValue = "0") final int page,
            @RequestParam(value = "available", defaultValue = "false") final boolean available,
            @RequestParam(value = "genre", required = false) final String genre) {
        final ModelAndView mav = new ModelAndView("productions/list");
        final List<Production> productions;
        if (genre != null && !genre.isEmpty()) {
            productions = productionService.findByGenre(genre, page, PRODUCTION_PAGE_SIZE);
        } else if (available) {
            productions = productionService.findAvailable(page, PRODUCTION_PAGE_SIZE);
        } else {
            productions = productionService.findAll(page, PRODUCTION_PAGE_SIZE);
        }
        mav.addObject("productions", productions);
        mav.addObject("productionRatings", ratingService.getProductionRatingLabels(collectProductionIds(productions)));
        mav.addObject("page", page);
        mav.addObject("available", available);
        mav.addObject("genre", genre);
        return mav;
    }

    private List<Long> collectProductionIds(final List<Production> productions) {
        final List<Long> productionIds = new java.util.ArrayList<>();
        for (final Production production : productions) {
            productionIds.add(production.getId());
        }
        return productionIds;
    }
}
