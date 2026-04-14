package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ProductionService;
import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.interfaces.services.ReviewService;
import ar.edu.itba.paw.webapp.auth.PawAuthUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
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
                                     @RequestParam("body") final String body,
                                     @RequestParam(value = "obraId", required = false) final Long obraId,
                                     @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser == null) {
            return new ModelAndView("redirect:/login");
        }

        boolean reviewCreated = false;

        if (body != null && !body.trim().isEmpty()) {
            reviewService.createOrUpdate(authUser.getUser().getId(), productionId, body.trim());
            reviewCreated = true;
        }
        if (obraId != null) {
            return new ModelAndView("redirect:/obras/" + obraId + "?produccionId=" + productionId
                    + (reviewCreated ? "&review=saved" : "&error=invalid_review"));
        }
        return new ModelAndView("redirect:/productions/" + productionId + (reviewCreated ? "?review=saved" : "?error=invalid_review"));
    }

    @RequestMapping(value = "/obras/{id:\\d+}/review", method = RequestMethod.POST)
    public ModelAndView createObraReview(@PathVariable("id") final long obraId,
                                         @RequestParam("body") final String body,
                                         @RequestParam(value = "produccionId", required = false) final Long produccionId,
                                         @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser == null) {
            return new ModelAndView("redirect:/login");
        }

        final boolean valid = body != null && !body.trim().isEmpty()
                && isValidSelectedProduction(obraId, produccionId);
        final String base = "redirect:/obras/" + obraId + (produccionId != null ? "?produccionId=" + produccionId : "?");
        final String separator = base.contains("?") && !base.endsWith("?") ? "&" : "";

        if (!valid) {
            return new ModelAndView(base + separator + "error=invalid_review");
        }

        reviewService.createOrUpdateForObra(authUser.getUser().getId(), obraId, produccionId, body.trim());
        return new ModelAndView(base + separator + "review=saved");
    }

    @RequestMapping(value = "/obras/{id:\\d+}/feedback", method = RequestMethod.POST)
    public Object submitObraFeedback(@PathVariable("id") final long obraId,
                                     @RequestParam(value = "score", required = false) final String score,
                                     @RequestParam(value = "body", required = false) final String body,
                                     @RequestParam(value = "produccionId", required = false) final Long produccionId,
                                     @AuthenticationPrincipal final PawAuthUser authUser,
                                     final HttpServletRequest request) {
        if (authUser == null) {
            return unauthorizedResponse(request);
        }

        final String normalizedRawScore = score != null ? score.trim() : null;
        final Integer normalizedScore = normalizedRawScore != null && !normalizedRawScore.isEmpty()
                ? normalizeScore(normalizedRawScore)
                : null;
        final boolean ajaxRequest = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        final boolean validProduction = isValidSelectedProduction(obraId, produccionId);
        final String base = "redirect:/obras/" + obraId + (produccionId != null ? "?produccionId=" + produccionId : "?");
        final String separator = base.contains("?") && !base.endsWith("?") ? "&" : "";

        if (normalizedRawScore == null || normalizedRawScore.isEmpty()) {
            if (ajaxRequest) {
                return new ResponseEntity<String>("missing_score", HttpStatus.BAD_REQUEST);
            }
            return new ModelAndView(base + separator + "error=missing_score");
        }

        if (normalizedScore == null || !validProduction) {
            if (ajaxRequest) {
                if (normalizedScore == null) {
                    return new ResponseEntity<String>("invalid_score", HttpStatus.BAD_REQUEST);
                }
                return new ResponseEntity<String>("invalid_production", HttpStatus.BAD_REQUEST);
            }
            return new ModelAndView(base + separator + "error=invalid_feedback");
        }

        ratingService.rateObra(authUser.getUser().getId(), obraId, normalizedScore);
        if (body != null && !body.trim().isEmpty()) {
            reviewService.createOrUpdateForObra(authUser.getUser().getId(), obraId, produccionId, body.trim());
        } else {
            reviewService.deleteByUserAndObra(authUser.getUser().getId(), obraId);
        }

        if (ajaxRequest) {
            final HttpHeaders headers = new HttpHeaders();
            final Double avgRating = ratingService.getObraAverageRating(obraId).orElse(null);
            final int reviewCount = reviewService.findByObra(obraId).size();
            headers.add("X-Avg-Rating", avgRating != null ? Double.toString(avgRating) : "");
            headers.add("X-Review-Count", Integer.toString(reviewCount));
            headers.add("X-User-Score", Integer.toString(normalizedScore));
            return new ResponseEntity<Void>(headers, HttpStatus.NO_CONTENT);
        }

        return new ModelAndView(base + separator + "feedback=saved");
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

    private Object unauthorizedResponse(final HttpServletRequest request) {
        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            return new ResponseEntity<String>("unauthorized", HttpStatus.UNAUTHORIZED);
        }
        return new ModelAndView("redirect:/login");
    }
}
