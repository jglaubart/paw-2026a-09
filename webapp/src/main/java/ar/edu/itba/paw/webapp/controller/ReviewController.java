package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ProductionService;
import ar.edu.itba.paw.interfaces.services.RatingService;
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

    private final ProductionService productionService;
    private final ReviewService reviewService;
    private final RatingService ratingService;

    @Autowired
    public ReviewController(final ProductionService productionService,
                            final ReviewService reviewService,
                            final RatingService ratingService) {
        this.productionService = productionService;
        this.reviewService = reviewService;
        this.ratingService = ratingService;
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
                    + (reviewCreated ? "&review=saved&email=" + normalizedEmail : "&error=invalid_review"));
        }
        return new ModelAndView("redirect:/productions/" + productionId + (reviewCreated ? "?review=saved" : "?error=invalid_review"));
    }

    @RequestMapping(value = "/obras/{id:\\d+}/review", method = RequestMethod.POST)
    public ModelAndView createObraReview(@PathVariable("id") final long obraId,
                                         @RequestParam("email") final String email,
                                         @RequestParam("body") final String body,
                                         @RequestParam(value = "produccionId", required = false) final Long produccionId) {
        final String normalizedEmail = email != null ? email.trim().toLowerCase() : null;
        final boolean valid = normalizedEmail != null && normalizedEmail.contains("@")
                && body != null && !body.trim().isEmpty()
                && isValidSelectedProduction(obraId, produccionId);
        final String encodedEmail = normalizedEmail != null ? URLEncoder.encode(normalizedEmail, StandardCharsets.UTF_8) : "";
        final String base = "redirect:/obras/" + obraId + (produccionId != null ? "?produccionId=" + produccionId : "?");
        final String separator = base.contains("?") && !base.endsWith("?") ? "&" : "";

        if (!valid) {
            return new ModelAndView(base + separator + "error=invalid_review");
        }

        reviewService.createOrUpdateByEmailForObra(normalizedEmail, obraId, produccionId, body.trim());
        return new ModelAndView(base + separator + "review=saved&email=" + encodedEmail);
    }

    @RequestMapping(value = "/obras/{id:\\d+}/feedback", method = RequestMethod.POST)
    public ModelAndView submitObraFeedback(@PathVariable("id") final long obraId,
                                           @RequestParam("email") final String email,
                                           @RequestParam("score") final String score,
                                           @RequestParam(value = "body", required = false) final String body,
                                           @RequestParam(value = "produccionId", required = false) final Long produccionId) {
        final String normalizedEmail = email != null ? email.trim().toLowerCase() : null;
        final Integer normalizedScore = normalizeScore(score);
        final String encodedEmail = normalizedEmail != null ? URLEncoder.encode(normalizedEmail, StandardCharsets.UTF_8) : "";
        final String base = "redirect:/obras/" + obraId + (produccionId != null ? "?produccionId=" + produccionId : "?");
        final String separator = base.contains("?") && !base.endsWith("?") ? "&" : "";

        if (normalizedEmail == null || !normalizedEmail.contains("@") || normalizedScore == null
                || !isValidSelectedProduction(obraId, produccionId)) {
            return new ModelAndView(base + separator + "error=invalid_feedback");
        }

        ratingService.rateObraByEmail(normalizedEmail, obraId, normalizedScore);
        if (body != null && !body.trim().isEmpty()) {
            reviewService.createOrUpdateByEmailForObra(normalizedEmail, obraId, produccionId, body.trim());
        } else {
            reviewService.deleteByEmailAndObra(normalizedEmail, obraId);
        }

        return new ModelAndView(base + separator + "feedback=saved&email=" + encodedEmail);
    }

    private Integer normalizeScore(final String rawScore) {
        final Double parsed;
        try {
            parsed = Double.valueOf(rawScore);
        } catch (final NumberFormatException e) {
            return null;
        }

        if (parsed >= 1d && parsed <= 10d && Math.floor(parsed) == parsed) {
            return parsed.intValue();
        }
        return null;
    }

    private boolean isValidSelectedProduction(final long obraId, final Long productionId) {
        return productionId != null && productionService.findSelectedByObraId(obraId, productionId).isPresent();
    }
}
