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

    @RequestMapping(value = "/productions/{id:\\d+}/rate", method = RequestMethod.POST)
    public ModelAndView rateProduction(@PathVariable("id") final long productionId,
                                       @RequestParam("score") final int score,
                                       @RequestParam(value = "obraId", required = false) final Long obraId) {
        if (score >= 1 && score <= 10) {
            ratingService.rateProduction(HARDCODED_USER_ID, productionId, score);
        }
        if (obraId != null) {
            return new ModelAndView("redirect:/obras/" + obraId + "?produccionId=" + productionId);
        }
        return new ModelAndView("redirect:/productions/" + productionId);
    }
}
