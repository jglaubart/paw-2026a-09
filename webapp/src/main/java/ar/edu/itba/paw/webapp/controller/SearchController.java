package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ProductionService;
import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.ProductionSearchCriteria;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDate;
import java.util.Collections;
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
            @RequestParam(value = "theater", required = false) final String theater,
            @RequestParam(value = "location", required = false) final String location,
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            @RequestParam(value = "dateFrom", required = false) final LocalDate dateFrom,
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            @RequestParam(value = "dateTo", required = false) final LocalDate dateTo,
            @RequestParam(value = "available", required = false) final Boolean available,
            @RequestParam(value = "page", defaultValue = "0") final int page) {
        final ModelAndView mav = new ModelAndView("search/results");
        final String normalizedQuery = trimToNull(query);
        final String normalizedGenre = trimToNull(genre);
        final String normalizedTheater = trimToNull(theater);
        final String normalizedLocation = trimToNull(location);
        final boolean availableOnly = Boolean.TRUE.equals(available);
        final int normalizedPage = Math.max(page, 0);

        mav.addObject("query", normalizedQuery);
        mav.addObject("genre", normalizedGenre);
        mav.addObject("theater", normalizedTheater);
        mav.addObject("location", normalizedLocation);
        mav.addObject("dateFrom", dateFrom);
        mav.addObject("dateTo", dateTo);
        mav.addObject("available", availableOnly);
        mav.addObject("page", normalizedPage);

        final List<Production> results;
        if (dateFrom != null && dateTo != null && dateFrom.isAfter(dateTo)) {
            results = Collections.emptyList();
            mav.addObject("page", 0);
            mav.addObject("dateRangeError", "La fecha desde no puede ser posterior a la fecha hasta.");
        } else {
            results = productionService.search(
                    new ProductionSearchCriteria(
                            normalizedQuery,
                            normalizedGenre,
                            normalizedTheater,
                            normalizedLocation,
                            dateFrom,
                            dateTo,
                            availableOnly
                    ),
                    normalizedPage,
                    PAGE_SIZE
            );
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

    private String trimToNull(final String value) {
        if (value == null) {
            return null;
        }
        final String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
