package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ReviewService;
import ar.edu.itba.paw.models.Review;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
public class UserController {

    private static final long HARDCODED_USER_ID = 1L;

    private final ReviewService reviewService;

    @Autowired
    public UserController(/* final WatchlistService watchlistService, */
                          final ReviewService reviewService
                          /*, final RatingService ratingService */) {
        /* this.watchlistService = watchlistService; */
        this.reviewService = reviewService;
        /* this.ratingService = ratingService; */
    }

    @RequestMapping(value = "/users/me", method = RequestMethod.GET)
    public ModelAndView profile() {
        final ModelAndView mav = new ModelAndView("users/profile");
        /*
        final List<Production> watchlist = watchlistService.findByUser(HARDCODED_USER_ID);
        mav.addObject("watchlist", watchlist);
        mav.addObject("productionRatings", ratingService.getProductionRatingLabels(collectProductionIds(watchlist)));
        */
        final List<Review> reviews = reviewService.findByUser(HARDCODED_USER_ID);
        mav.addObject("reviews", reviews);
        return mav;
    }

    /*
    private List<Long> collectProductionIds(final List<Production> productions) {
        final List<Long> productionIds = new java.util.ArrayList<>();
        for (final Production production : productions) {
            productionIds.add(production.getId());
        }
        return productionIds;
    }
    */
}
