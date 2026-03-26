package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.RatingService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

@Controller
public class RatingController {

    private static final long HARDCODED_USER_ID = 1L;

    private final RatingService ratingService;

    @Autowired
    public RatingController(final RatingService ratingService) {
        this.ratingService = ratingService;
    }

    @RequestMapping(value = "/productions/{id:\\d+}/rate", method = RequestMethod.POST)
    public Object rateProduction(@PathVariable("id") final long productionId,
                                 @RequestParam("score") final String score,
                                 @RequestParam(value = "obraId", required = false) final Long obraId,
                                 final HttpServletRequest request) {
        final Integer normalizedScore = normalizeScore(score);

        if (normalizedScore != null) {
            ratingService.rateProduction(HARDCODED_USER_ID, productionId, normalizedScore);
        }

        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            if (normalizedScore == null) {
                return new ResponseEntity<Void>(HttpStatus.BAD_REQUEST);
            }
            return new ResponseEntity<Void>(HttpStatus.NO_CONTENT);
        }

        if (obraId != null) {
            return new ModelAndView("redirect:/obras/" + obraId + "?produccionId=" + productionId + "&rating=saved");
        }
        return new ModelAndView("redirect:/productions/" + productionId + "?rating=saved");
    }

    private Integer normalizeScore(final String rawScore) {
        final Double score;

        try {
            score = Double.valueOf(rawScore);
        } catch (NumberFormatException e) {
            return null;
        }

        if (score >= 0.5d && score <= 5d) {
            return (int) Math.round(score * 2d);
        }

        if (score >= 1d && score <= 10d && Math.floor(score) == score) {
            return score.intValue();
        }

        return null;
    }
}
