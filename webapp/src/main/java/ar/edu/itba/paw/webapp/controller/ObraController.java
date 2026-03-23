package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ObraService;
import ar.edu.itba.paw.interfaces.services.ProductionService;
import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.interfaces.services.ReviewService;
import ar.edu.itba.paw.models.Obra;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.Review;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Optional;

@Controller
public class ObraController {

    private static final long HARDCODED_USER_ID = 1L;

    private final ObraService obraService;
    private final ProductionService productionService;
    private final RatingService ratingService;
    private final ReviewService reviewService;

    @Autowired
    public ObraController(final ObraService obraService,
                          final ProductionService productionService,
                          final RatingService ratingService,
                          final ReviewService reviewService) {
        this.obraService = obraService;
        this.productionService = productionService;
        this.ratingService = ratingService;
        this.reviewService = reviewService;
    }

    @RequestMapping(value = "/obras/{id:\\d+}", method = RequestMethod.GET)
    public ModelAndView detail(@PathVariable("id") final long id) {
        final Optional<Obra> obraOpt = obraService.findById(id);
        if (!obraOpt.isPresent()) {
            return new ModelAndView("redirect:/");
        }
        final Obra obra = obraOpt.get();
        final ModelAndView mav = new ModelAndView("obras/detail");
        mav.addObject("obra", obra);

        final List<Production> productions = productionService.findByObraId(id);
        mav.addObject("productions", productions);

        final List<Review> reviews = reviewService.findByObra(id);
        mav.addObject("reviews", reviews);

        mav.addObject("userScore", ratingService.getObraRating(HARDCODED_USER_ID, id)
                .map(r -> r.getScore()).orElse(null));
        mav.addObject("avgRating", ratingService.getObraAverageRating(id).orElse(null));
        mav.addObject("userReview", reviewService.findByUserAndObra(HARDCODED_USER_ID, id).orElse(null));
        return mav;
    }
}
