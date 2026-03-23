package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.interfaces.services.ReviewService;
import ar.edu.itba.paw.interfaces.services.WatchlistService;
import ar.edu.itba.paw.models.Production;
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

    private final WatchlistService watchlistService;
    private final ReviewService reviewService;
    private final RatingService ratingService;

    @Autowired
    public UserController(final WatchlistService watchlistService,
                          final ReviewService reviewService,
                          final RatingService ratingService) {
        this.watchlistService = watchlistService;
        this.reviewService = reviewService;
        this.ratingService = ratingService;
    }

    @RequestMapping(value = "/users/me", method = RequestMethod.GET)
    public ModelAndView profile() {
        final ModelAndView mav = new ModelAndView("users/profile");
        final List<Production> watchlist = watchlistService.findByUser(HARDCODED_USER_ID);
        final List<Review> reviews = reviewService.findByUser(HARDCODED_USER_ID);
        mav.addObject("watchlist", watchlist);
        mav.addObject("reviews", reviews);
        return mav;
    }
}
