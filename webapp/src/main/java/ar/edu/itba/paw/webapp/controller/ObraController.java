package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ObraService;
import ar.edu.itba.paw.interfaces.services.ProductionService;
import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.interfaces.services.ReviewService;
import ar.edu.itba.paw.interfaces.services.SeenService;
import ar.edu.itba.paw.interfaces.services.WatchlistService;
import ar.edu.itba.paw.models.Obra;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.Review;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Controller
public class ObraController {

    private static final long HARDCODED_USER_ID = 1L;

    private final ObraService obraService;
    private final ProductionService productionService;
    private final RatingService ratingService;
    private final ReviewService reviewService;
    private final WatchlistService watchlistService;
    private final SeenService seenService;

    @Autowired
    public ObraController(final ObraService obraService,
                          final ProductionService productionService,
                          final RatingService ratingService,
                          final ReviewService reviewService,
                          final WatchlistService watchlistService,
                          final SeenService seenService) {
        this.obraService = obraService;
        this.productionService = productionService;
        this.ratingService = ratingService;
        this.reviewService = reviewService;
        this.watchlistService = watchlistService;
        this.seenService = seenService;
    }

    @RequestMapping(value = "/obras/{id:\\d+}", method = RequestMethod.GET)
    public ModelAndView detail(@PathVariable("id") final long id,
                               @RequestParam(value = "produccionId", required = false) final Long produccionId) {
        final Optional<Obra> obraOpt = obraService.findById(id);
        if (!obraOpt.isPresent()) {
            return new ModelAndView("redirect:/");
        }
        final Obra obra = obraOpt.get();
        final ModelAndView mav = new ModelAndView("obras/detail");
        mav.addObject("obra", obra);

        final List<Production> productions = productionService.findByObraId(id);
        mav.addObject("productions", productions);

        final Production selectedProduction = productionService.findSelectedByObraId(id, produccionId).orElse(null);
        mav.addObject("selectedProduction", selectedProduction);

        if (selectedProduction != null) {
            final long pid = selectedProduction.getId();
            mav.addObject("reviews", reviewService.findByProduction(pid));
            mav.addObject("userScore", ratingService.getProductionRating(HARDCODED_USER_ID, pid)
                    .map(r -> r.getScore()).orElse(null));
            mav.addObject("avgRating", ratingService.getProductionAverageRating(pid).orElse(null));
            mav.addObject("userReview", reviewService.findByUserAndProduction(HARDCODED_USER_ID, pid).orElse(null));
        } else {
            mav.addObject("reviews", Collections.emptyList());
            mav.addObject("userScore", null);
            mav.addObject("avgRating", null);
            mav.addObject("userReview", null);
        }

        if (selectedProduction != null) {
            mav.addObject("isInWishlist",
                    watchlistService.isInWatchlist(HARDCODED_USER_ID, selectedProduction.getId()));
        } else {
            mav.addObject("isInWishlist", false);
        }
        mav.addObject("hasSeen", seenService.hasSeen(HARDCODED_USER_ID, id));

        return mav;
    }
}
