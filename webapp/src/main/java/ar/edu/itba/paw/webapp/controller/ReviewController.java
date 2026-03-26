package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ReviewController {

    private static final long HARDCODED_USER_ID = 1L;

    private final ReviewService reviewService;

    @Autowired
    public ReviewController(final ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @RequestMapping(value = "/productions/{id:\\d+}/review", method = RequestMethod.POST)
    public ModelAndView createReview(@PathVariable("id") final long productionId,
                                     @RequestParam("body") final String body,
                                     @RequestParam(value = "obraId", required = false) final Long obraId) {
        boolean reviewCreated = false;

        if (body != null && !body.trim().isEmpty()) {
            try {
                reviewService.create(HARDCODED_USER_ID, productionId, body.trim());
                reviewCreated = true;
            } catch (IllegalStateException e) {
                if (obraId != null) {
                    return new ModelAndView("redirect:/obras/" + obraId
                            + "?produccionId=" + productionId + "&error=rate_first");
                }
                return new ModelAndView("redirect:/productions/" + productionId + "?error=rate_first");
            }
        }
        if (obraId != null) {
            return new ModelAndView("redirect:/obras/" + obraId + "?produccionId=" + productionId
                    + (reviewCreated ? "&review=saved" : ""));
        }
        return new ModelAndView("redirect:/productions/" + productionId + (reviewCreated ? "?review=saved" : ""));
    }
}
