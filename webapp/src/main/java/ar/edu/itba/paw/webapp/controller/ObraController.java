package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ObraService;
import ar.edu.itba.paw.interfaces.services.MailService;
import ar.edu.itba.paw.interfaces.services.ProductionService;
import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.interfaces.services.ReviewService;
import ar.edu.itba.paw.interfaces.services.SeenService;
import ar.edu.itba.paw.interfaces.services.WatchlistService;
import ar.edu.itba.paw.models.Obra;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.Review;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Controller
public class ObraController {

    private static final long HARDCODED_USER_ID = 1L;

    private final ObraService obraService;
    private final ProductionService productionService;
    private final RatingService ratingService;
    private final ReviewService reviewService;
    private final MailService mailService;
    private final WatchlistService watchlistService;
    private final SeenService seenService;

    @Autowired
    public ObraController(final ObraService obraService,
                          final ProductionService productionService,
                          final RatingService ratingService,
                          final ReviewService reviewService,
                          final MailService mailService,
                          final WatchlistService watchlistService,
                          final SeenService seenService) {
        this.obraService = obraService;
        this.productionService = productionService;
        this.ratingService = ratingService;
        this.reviewService = reviewService;
        this.mailService = mailService;
        this.watchlistService = watchlistService;
        this.seenService = seenService;
    }

    @RequestMapping(value = "/obras/{id:\\d+}", method = RequestMethod.GET)
    public ModelAndView detail(@PathVariable("id") final long id,
                               @RequestParam(value = "produccionId", required = false) final Long produccionId,
                               @RequestParam(value = "reviewEmail", required = false) final String reviewEmail) {
        final Optional<Obra> obraOpt = obraService.findById(id);
        if (!obraOpt.isPresent()) {
            return new ModelAndView("redirect:/");
        }
        final Obra obra = obraOpt.get();
        final ModelAndView mav = new ModelAndView("obras/detail");
        mav.addObject("obra", obra);

        final List<Production> productions = productionService.findByObraId(id);
        mav.addObject("productions", productions);

        final Production selectedProduction = productionService.findSelectedByObraId(id, produccionId).orElse(null);
        mav.addObject("selectedProduction", selectedProduction);

        if (selectedProduction != null) {
            final long pid = selectedProduction.getId();
            mav.addObject("reviews", reviewService.findByProduction(pid));
            final Integer userScore = ratingService.getProductionRating(HARDCODED_USER_ID, pid)
                    .map(r -> r.getScore()).orElse(null);
            final Double avgRating = ratingService.getProductionAverageRating(pid).orElse(null);
            mav.addObject("userScore", userScore);
            mav.addObject("userStars", mapScoreToStars(userScore));
            mav.addObject("avgRating", avgRating);
            mav.addObject("avgStars", avgRating != null ? avgRating / 2.0d : null);
            mav.addObject("avgStarsPercent", avgRating != null ? Math.max(0d, Math.min(100d, avgRating * 10d)) : 0d);
            mav.addObject("userReview", reviewEmail != null ? reviewService.findByEmailAndProduction(reviewEmail, pid).orElse(null) : null);
            mav.addObject("reviewEmail", reviewEmail);
        } else {
            mav.addObject("reviews", Collections.emptyList());
            mav.addObject("userScore", null);
            mav.addObject("userStars", null);
            mav.addObject("avgRating", null);
            mav.addObject("avgStars", null);
            mav.addObject("avgStarsPercent", 0d);
            mav.addObject("userReview", null);
            mav.addObject("reviewEmail", reviewEmail);
        }

        if (selectedProduction != null) {
            mav.addObject("isInWishlist",
                    watchlistService.isInWatchlist(HARDCODED_USER_ID, selectedProduction.getId()));
        } else {
            mav.addObject("isInWishlist", false);
        }
        mav.addObject("hasSeen", seenService.hasSeen(HARDCODED_USER_ID, id));

        return mav;
    }

    @RequestMapping(value = "/obras/{id:\\d+}/share", method = RequestMethod.POST)
    public ModelAndView share(@PathVariable("id") final long id,
                              @RequestParam("recipientEmail") final String recipientEmail,
                              @RequestParam("senderName") final String senderName,
                              @RequestParam(value = "produccionId", required = false) final Long produccionId) {
        if (recipientEmail == null || !recipientEmail.contains("@") || senderName == null || senderName.trim().isEmpty()) {
            return new ModelAndView("redirect:/obras/" + id + (produccionId != null ? "?produccionId=" + produccionId + "&share=invalid" : "?share=invalid"));
        }

        final Optional<Obra> obraOpt = obraService.findById(id);
        final Optional<Production> productionOpt = productionService.findSelectedByObraId(id, produccionId);
        if (!obraOpt.isPresent() || !productionOpt.isPresent()) {
            return new ModelAndView("redirect:/obras/" + id + (produccionId != null ? "?produccionId=" + produccionId + "&share=invalid" : "?share=invalid"));
        }

        final Production production = productionOpt.get();
        final String detailUrl = "/obras/" + id + "?produccionId=" + production.getId();
        mailService.sendSharedProduction(
                recipientEmail.trim().toLowerCase(),
                senderName.trim(),
                obraOpt.get().getTitle(),
                production.getName(),
                production.getSynopsis(),
                detailUrl
        );
        return new ModelAndView("redirect:/obras/" + id + "?produccionId=" + production.getId() + "&share=sent");
    }

    private Double mapScoreToStars(final Integer score) {
        if (score == null) {
            return null;
        }

        return Math.max(0.5d, Math.min(5d, score / 2.0d));
    }
}
