package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Controller
public class ReviewController {

    private final ReviewService reviewService;

    @Autowired
    public ReviewController(final ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @RequestMapping(value = "/productions/{id:\\d+}/review", method = RequestMethod.POST)
    public ModelAndView createReview(@PathVariable("id") final long productionId,
                                     @RequestParam("email") final String email,
                                     @RequestParam("body") final String body,
                                     @RequestParam(value = "obraId", required = false) final Long obraId) {
        boolean reviewCreated = false;

        if (email != null && email.contains("@") && body != null && !body.trim().isEmpty()) {
            reviewService.createOrUpdateByEmail(email.trim().toLowerCase(), productionId, body.trim());
            reviewCreated = true;
        }
        if (obraId != null) {
            final String normalizedEmail = email != null ? URLEncoder.encode(email.trim().toLowerCase(), StandardCharsets.UTF_8) : "";
            return new ModelAndView("redirect:/obras/" + obraId + "?produccionId=" + productionId
                    + (reviewCreated ? "&review=saved&reviewEmail=" + normalizedEmail : "&error=invalid_review"));
        }
        return new ModelAndView("redirect:/productions/" + productionId + (reviewCreated ? "?review=saved" : "?error=invalid_review"));
    }
}
