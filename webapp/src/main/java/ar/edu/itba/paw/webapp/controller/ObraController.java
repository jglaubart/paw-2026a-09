package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ObraService;
import ar.edu.itba.paw.interfaces.services.MailService;
import ar.edu.itba.paw.interfaces.services.ProductionService;
import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.interfaces.services.ReviewService;
import ar.edu.itba.paw.interfaces.services.ShowService;
import ar.edu.itba.paw.models.Obra;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.Review;
import ar.edu.itba.paw.webapp.auth.PawAuthUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.time.LocalDate;

@Controller
public class ObraController {

    private final ObraService obraService;
    private final ProductionService productionService;
    private final RatingService ratingService;
    private final ReviewService reviewService;
    private final MailService mailService;
    private final ShowService showService;

    @Autowired
    public ObraController(final ObraService obraService,
                          final ProductionService productionService,
                          final RatingService ratingService,
                          final ReviewService reviewService,
                          final MailService mailService,
                          final ShowService showService
                          /*, final WatchlistService watchlistService, */
                          /*, final SeenService seenService */) {
        this.obraService = obraService;
        this.productionService = productionService;
        this.ratingService = ratingService;
        this.reviewService = reviewService;
        this.mailService = mailService;
        this.showService = showService;
        /* this.watchlistService = watchlistService; */
        /* this.seenService = seenService; */
    }

    @RequestMapping(value = "/obras/{id:\\d+}", method = RequestMethod.GET)
    public ModelAndView detail(@PathVariable("id") final long id,
                               @RequestParam(value = "produccionId", required = false) final Long produccionId,
                               @AuthenticationPrincipal final PawAuthUser authUser) {
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
            final long currentUserId = authUser != null ? authUser.getUser().getId() : -1L;
            mav.addObject("reviews", reviewService.findByObra(id));
            final Integer userScore = authUser != null
                    ? ratingService.getObraRating(currentUserId, id).map(r -> r.getScore()).orElse(null)
                    : null;
            final Double avgRating = ratingService.getObraAverageRating(id).orElse(null);
            mav.addObject("userScore", userScore);
            mav.addObject("userStars", mapScoreToStars(userScore));
            mav.addObject("avgRating", avgRating);
            mav.addObject("avgStars", avgRating);
            mav.addObject("avgStarsPercent", avgRating != null ? Math.max(0d, Math.min(100d, avgRating * 10d)) : 0d);
            mav.addObject("userReview", authUser != null ? reviewService.findByUserAndObra(currentUserId, id).orElse(null) : null);
            final List<LocalDate> showDates = collectUniqueShowDates(pid);
            mav.addObject("showDates", showDates);
            mav.addObject("lastShowDate", showDates.isEmpty() ? selectedProduction.getEndDate() : showDates.get(showDates.size() - 1));
            mav.addObject("selectedProductionActive", isProductionActive(selectedProduction));
        } else {
            mav.addObject("reviews", Collections.emptyList());
            mav.addObject("userScore", null);
            mav.addObject("userStars", null);
            mav.addObject("avgRating", null);
            mav.addObject("avgStars", null);
            mav.addObject("avgStarsPercent", 0d);
            mav.addObject("userReview", null);
            mav.addObject("showDates", Collections.emptyList());
            mav.addObject("lastShowDate", null);
            mav.addObject("selectedProductionActive", false);
        }

        mav.addObject("currentUserEmail", authUser != null ? authUser.getUser().getEmail() : null);

        /*
        if (selectedProduction != null) {
            mav.addObject("isInWishlist",
                    watchlistService.isInWatchlist(HARDCODED_USER_ID, selectedProduction.getId()));
        } else {
            mav.addObject("isInWishlist", false);
        }
        */
        mav.addObject("isInWishlist", false);
        /* mav.addObject("hasSeen", seenService.hasSeen(HARDCODED_USER_ID, id)); */
        mav.addObject("hasSeen", false);

        return mav;
    }

    @RequestMapping(value = "/obras/{id:\\d+}/share", method = RequestMethod.POST)
    public ModelAndView share(@PathVariable("id") final long id,
                              @RequestParam("recipientEmail") final String recipientEmail,
                              @RequestParam(value = "senderName", required = false) final String senderNameParam,
                              @RequestParam(value = "produccionId", required = false) final Long produccionId,
                              @AuthenticationPrincipal final PawAuthUser authUser) {
        final String senderName = authUser != null && !authUser.getUser().getUsername().isEmpty()
                ? authUser.getUser().getUsername()
                : (senderNameParam != null ? senderNameParam.trim() : "");
        if (recipientEmail == null || !recipientEmail.contains("@") || senderName.isEmpty()) {
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

        return Math.max(1d, Math.min(10d, score.doubleValue()));
    }

    private List<LocalDate> collectUniqueShowDates(final long productionId) {
        final Set<LocalDate> uniqueDates = new LinkedHashSet<>();
        showService.findByProductionId(productionId).forEach(show -> uniqueDates.add(show.getShowDate()));
        return new java.util.ArrayList<>(uniqueDates);
    }

    private boolean isProductionActive(final Production production) {
        if (production.getStartDate() == null) {
            return false;
        }
        final LocalDate today = LocalDate.now();
        return !production.getStartDate().isAfter(today)
                && (production.getEndDate() == null || !production.getEndDate().isBefore(today));
    }
}
