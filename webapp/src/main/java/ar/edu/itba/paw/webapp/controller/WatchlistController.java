package ar.edu.itba.paw.webapp.controller;

/*
import ar.edu.itba.paw.interfaces.services.WatchlistService;
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

@Controller
public class WatchlistController {

    private static final long HARDCODED_USER_ID = 1L;

    private final WatchlistService watchlistService;
    private final RatingService ratingService;

    @Autowired
    public WatchlistController(final WatchlistService watchlistService,
                               final RatingService ratingService) {
        this.watchlistService = watchlistService;
        this.ratingService = ratingService;
    }

    @RequestMapping(value = "/watchlist", method = RequestMethod.GET)
    public ModelAndView watchlist() {
        final ModelAndView mav = new ModelAndView("wishlist/index");
        final List<Production> productions = watchlistService.findByUser(HARDCODED_USER_ID);
        mav.addObject("wishlist", productions);
        mav.addObject("productionRatings", ratingService.getProductionRatingLabels(collectProductionIds(productions)));
        return mav;
    }

    @RequestMapping(value = "/productions/{id:\\d+}/watchlist", method = RequestMethod.POST)
    public ModelAndView toggle(@PathVariable("id") final long productionId,
                               @RequestParam("action") final String action,
                               @RequestParam("obraId") final long obraId) {
        if ("add".equals(action)) {
            watchlistService.add(HARDCODED_USER_ID, productionId);
        } else if ("remove".equals(action)) {
            watchlistService.remove(HARDCODED_USER_ID, productionId);
        }
        return new ModelAndView("redirect:/obras/" + obraId + "?produccionId=" + productionId);
    }

    private List<Long> collectProductionIds(final List<Production> productions) {
        final List<Long> productionIds = new java.util.ArrayList<>();
        for (final Production production : productions) {
            productionIds.add(production.getId());
        }
        return productionIds;
    }
}
*/

final class WatchlistControllerDisabled {
    private WatchlistControllerDisabled() {
    }
}
