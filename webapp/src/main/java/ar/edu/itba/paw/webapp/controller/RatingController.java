package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.RatingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class RatingController {

    private static final long HARDCODED_USER_ID = 1L;

    private final RatingService ratingService;

    @Autowired
    public RatingController(final RatingService ratingService) {
        this.ratingService = ratingService;
    }

    @RequestMapping(value = "/obras/{id:\\d+}/rate", method = RequestMethod.POST)
    public ModelAndView rateObra(@PathVariable("id") final long obraId,
                                 @RequestParam("score") final int score) {
        if (score >= 1 && score <= 10) {
            ratingService.rateObra(HARDCODED_USER_ID, obraId, score);
        }
        return new ModelAndView("redirect:/obras/" + obraId);
    }

    @RequestMapping(value = "/productions/{id:\\d+}/rate", method = RequestMethod.POST)
    public ModelAndView rateProduction(@PathVariable("id") final long productionId,
                                       @RequestParam("score") final int score) {
        if (score >= 1 && score <= 10) {
            ratingService.rateProduction(HARDCODED_USER_ID, productionId, score);
        }
        return new ModelAndView("redirect:/productions/" + productionId);
    }
}
