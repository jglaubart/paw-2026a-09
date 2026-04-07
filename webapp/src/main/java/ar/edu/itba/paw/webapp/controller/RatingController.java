package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.webapp.auth.PawUserDetails;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Controller
public class RatingController {

    private final RatingService ratingService;

    @Autowired
    public RatingController(final RatingService ratingService) {
        this.ratingService = ratingService;
    }

    @RequestMapping(value = "/productions/{id:\\d+}/rate", method = RequestMethod.POST)
    public Object rateProduction(@PathVariable("id") final long productionId,
                                 @RequestParam("score") final String score,
                                 @RequestParam(value = "obraId", required = false) final Long obraId,
                                 @AuthenticationPrincipal final PawUserDetails userDetails,
                                 final HttpServletRequest request) {
        final Integer normalizedScore = normalizeScore(score);

        if (normalizedScore != null && userDetails != null) {
            ratingService.rateProduction(userDetails.getUser().getId(), productionId, normalizedScore);
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

    @RequestMapping(value = "/obras/{id:\\d+}/rate", method = RequestMethod.POST)
    public Object rateObra(@PathVariable("id") final long obraId,
                           @RequestParam("email") final String email,
                           @RequestParam("score") final String score,
                           @RequestParam(value = "produccionId", required = false) final Long produccionId,
                           final HttpServletRequest request) {
        final Integer normalizedScore = normalizeScore(score);
        final String normalizedEmail = email != null ? email.trim().toLowerCase() : null;

        if (normalizedScore != null && normalizedEmail != null && normalizedEmail.contains("@")) {
            ratingService.rateObraByEmail(normalizedEmail, obraId, normalizedScore);
        }

        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            if (normalizedScore == null || normalizedEmail == null || !normalizedEmail.contains("@")) {
                return new ResponseEntity<Void>(HttpStatus.BAD_REQUEST);
            }
            return new ResponseEntity<Void>(HttpStatus.NO_CONTENT);
        }

        final String encodedEmail = normalizedEmail != null ? URLEncoder.encode(normalizedEmail, StandardCharsets.UTF_8) : "";
        final String redirectBase = "/obras/" + obraId + (produccionId != null ? "?produccionId=" + produccionId : "?");
        final String separator = redirectBase.contains("?") && !redirectBase.endsWith("?") ? "&" : "";
        if (normalizedScore == null || normalizedEmail == null || !normalizedEmail.contains("@")) {
            return new ModelAndView("redirect:" + redirectBase + separator + "error=invalid_rating");
        }
        return new ModelAndView("redirect:" + redirectBase + separator + "rating=saved&email=" + encodedEmail);
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
