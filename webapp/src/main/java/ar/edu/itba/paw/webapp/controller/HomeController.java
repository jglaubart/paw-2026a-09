package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.interfaces.services.ProductionService;
import ar.edu.itba.paw.interfaces.services.ShowService;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.ProductionCardSummary;
import ar.edu.itba.paw.models.Show;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
public class HomeController {

    private static final int HERO_SLIDE_COUNT = 4;
    private static final String EXCLUDED_HERO_TITLE = "AMOR/VENENO — Tangos y Boleros";
    private static final List<String> HERO_SLIDE_SELECTION = Arrays.asList(
            "A navegar, Piratas!",
            "La Revista del Cervantes",
            "Doradas — Temporada 2026",
            "Alma Mahler — Sinfonía de vida, arte y seducción"
    );

    private final ProductionService productionService;
    private final RatingService ratingService;
    private final ShowService showService;

    @Autowired
    public HomeController(final ProductionService productionService,
                          final RatingService ratingService,
                          final ShowService showService) {
        this.productionService = productionService;
        this.ratingService = ratingService;
        this.showService = showService;
    }

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public ModelAndView index() {
        final ModelAndView mav = new ModelAndView("index");
        final List<Production> available = productionService.findAvailable();
        final List<ProductionCardSummary> availableCards = productionService.findAvailableCards();
        final List<Production> today = findTodayProductions(available);
        final List<ProductionCardSummary> allCards = productionService.findAllCards();
        mav.addObject("todayProductions", today);
        mav.addObject("availableCards", availableCards);
        mav.addObject("allCards", allCards);
        mav.addObject("productionRatings", ratingService.getProductionRatingLabels(collectProductionIds(today, availableCards, allCards)));
        mav.addObject("heroSlides", buildHeroSlides(available));
        mav.addObject("featuredProduction", available.isEmpty() ? null : available.get(0));
        return mav;
    }

    private List<Production> buildHeroSlides(final List<Production>... groups) {
        final List<Production> pool = collectEligibleHeroProductions(collectUniqueProductions(groups));
        final Map<Long, Production> selected = new LinkedHashMap<>();

        for (final String title : HERO_SLIDE_SELECTION) {
            for (final Production production : pool) {
                if (title.equals(production.getName())) {
                    selected.put(production.getId(), production);
                    break;
                }
            }
        }

        for (final Production production : pool) {
            if (selected.size() >= HERO_SLIDE_COUNT) {
                break;
            }

            if (production.getImageUrl() != null && !production.getImageUrl().isEmpty()) {
                selected.put(production.getId(), production);
            }
        }

        for (final Production production : pool) {
            if (selected.size() >= HERO_SLIDE_COUNT) {
                break;
            }

            selected.put(production.getId(), production);
        }

        return new ArrayList<>(selected.values());
    }

    private List<Production> findTodayProductions(final List<Production> candidates) {
        final LocalDate today = LocalDate.now();
        final List<Production> todayProductions = new ArrayList<>();

        for (final Production production : candidates) {
            for (final Show show : showService.findFutureByProductionId(production.getId())) {
                if (today.equals(show.getShowDate())) {
                    todayProductions.add(production);
                    break;
                }
            }

        }

        return todayProductions;
    }

    private List<Long> collectProductionIds(final List<Production> productions,
                                            final List<ProductionCardSummary>... cardGroups) {
        final ArrayList<Long> productionIds = new ArrayList<>();
        for (final Production production : productions) {
            productionIds.add(production.getId());
        }
        for (final List<ProductionCardSummary> cards : cardGroups) {
            for (final ProductionCardSummary card : cards) {
                productionIds.add(card.getRepresentativeProductionId());
            }
        }
        return productionIds;
    }

    private List<Production> collectUniqueProductions(final List<Production>... groups) {
        final Map<Long, Production> productionsById = new LinkedHashMap<>();

        for (final List<Production> productions : groups) {
            for (final Production production : productions) {
                productionsById.put(production.getId(), production);
            }
        }

        return new ArrayList<>(productionsById.values());
    }

    private boolean isExcludedHeroProduction(final Production production) {
        final String name = production.getName();
        return name != null && EXCLUDED_HERO_TITLE.equalsIgnoreCase(name.trim());
    }

    private List<Production> collectEligibleHeroProductions(final List<Production> productions) {
        // Filter out productions that must never appear in the home hero slider.
        final List<Production> eligibleProductions = new ArrayList<>();

        for (final Production production : productions) {
            if (!isExcludedHeroProduction(production)) {
                eligibleProductions.add(production);
            }
        }

        return eligibleProductions;
    }
}
