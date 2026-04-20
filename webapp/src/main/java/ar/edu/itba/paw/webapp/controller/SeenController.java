package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.interfaces.services.SeenService;
import ar.edu.itba.paw.models.Obra;
import ar.edu.itba.paw.webapp.auth.PawAuthUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
public class SeenController {

    private final SeenService seenService;
    private final RatingService ratingService;

    @Autowired
    public SeenController(final SeenService seenService,
                          final RatingService ratingService) {
        this.seenService = seenService;
        this.ratingService = ratingService;
    }

    @RequestMapping(value = "/historial", method = RequestMethod.GET)
    public ModelAndView historial(@AuthenticationPrincipal final PawAuthUser authUser) {
        final long userId = authUser.getUser().getId();
        final ModelAndView mav = new ModelAndView("watchlist/index");
        final List<Obra> obras = seenService.findByUser(userId);

        final List<Long> obraIds = new ArrayList<>(obras.size());
        for (final Obra obra : obras) {
            obraIds.add(obra.getId());
        }
        final Map<Long, String> userRatings = ratingService.getUserObraRatingLabels(userId, obraIds);

        mav.addObject("seenObras", obras);
        mav.addObject("userObraRatings", userRatings);
        return mav;
    }

    @RequestMapping(value = "/obras/{id:\\d+}/seen", method = RequestMethod.POST)
    public ModelAndView toggle(@PathVariable("id") final long obraId,
                               @RequestParam("action") final String action,
                               @RequestParam(value = "produccionId", required = false) final Long produccionId,
                               @AuthenticationPrincipal final PawAuthUser authUser) {
        final long userId = authUser.getUser().getId();
        if ("add".equals(action)) {
            seenService.markSeen(userId, obraId);
        } else if ("remove".equals(action)) {
            seenService.unmarkSeen(userId, obraId);
        }
        final StringBuilder redirect = new StringBuilder("redirect:/obras/").append(obraId);
        if (produccionId != null) {
            redirect.append("?produccionId=").append(produccionId);
        }
        return new ModelAndView(redirect.toString());
    }
}
