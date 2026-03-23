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

    @RequestMapping(value = "/obras/{id:\\d+}/review", method = RequestMethod.POST)
    public ModelAndView createReview(@PathVariable("id") final long obraId,
                                     @RequestParam("body") final String body) {
        if (body != null && !body.trim().isEmpty()) {
            try {
                reviewService.create(HARDCODED_USER_ID, obraId, body.trim());
            } catch (IllegalStateException e) {
                return new ModelAndView("redirect:/obras/" + obraId + "?error=rate_first");
            }
        }
        return new ModelAndView("redirect:/obras/" + obraId);
    }
}
