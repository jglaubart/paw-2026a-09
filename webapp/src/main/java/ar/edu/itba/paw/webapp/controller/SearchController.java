package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ProductionService;
import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.models.Production;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
public class SearchController {

    private static final int PAGE_SIZE = 12;

    private final ProductionService productionService;
    private final RatingService ratingService;

    @Autowired
    public SearchController(final ProductionService productionService,
                            final RatingService ratingService) {
        this.productionService = productionService;
        this.ratingService = ratingService;
    }

    @RequestMapping(value = "/search", method = RequestMethod.GET)
    public ModelAndView search(
            @RequestParam(value = "q", required = false) final String query,
            @RequestParam(value = "genre", required = false) final String genre,
            @RequestParam(value = "available", required = false) final Boolean available,
            @RequestParam(value = "page", defaultValue = "0") final int page) {
        final ModelAndView mav = new ModelAndView("search/results");
        mav.addObject("query", query);
        mav.addObject("genre", genre);
        mav.addObject("available", available);
        mav.addObject("page", page);

        final List<Production> results;
        if (query != null && !query.trim().isEmpty()) {
            results = productionService.search(query.trim(), page, PAGE_SIZE);
        } else if (genre != null && !genre.trim().isEmpty()) {
            results = productionService.findByGenre(genre.trim(), page, PAGE_SIZE);
        } else if (Boolean.TRUE.equals(available)) {
            results = productionService.findAvailable(page, PAGE_SIZE);
        } else {
            results = productionService.findAll(page, PAGE_SIZE);
        }
        mav.addObject("results", results);
        mav.addObject("productionRatings", ratingService.getProductionRatingLabels(collectProductionIds(results)));
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
