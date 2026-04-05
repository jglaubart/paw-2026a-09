package ar.edu.itba.paw.webapp.controller;

/*
import ar.edu.itba.paw.interfaces.services.SeenService;
import ar.edu.itba.paw.models.Obra;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
public class SeenController {

    private static final long HARDCODED_USER_ID = 1L;

    private final SeenService seenService;

    @Autowired
    public SeenController(final SeenService seenService) {
        this.seenService = seenService;
    }

    @RequestMapping(value = "/historial", method = RequestMethod.GET)
    public ModelAndView historial() {
        final ModelAndView mav = new ModelAndView("watchlist/index");
        final List<Obra> obras = seenService.findByUser(HARDCODED_USER_ID);
        mav.addObject("seenObras", obras);
        return mav;
    }

    @RequestMapping(value = "/obras/{id:\\d+}/seen", method = RequestMethod.POST)
    public ModelAndView toggle(@PathVariable("id") final long obraId,
                               @RequestParam("action") final String action,
                               @RequestParam(value = "produccionId", required = false) final Long produccionId) {
        if ("add".equals(action)) {
            seenService.markSeen(HARDCODED_USER_ID, obraId);
        } else if ("remove".equals(action)) {
            seenService.unmarkSeen(HARDCODED_USER_ID, obraId);
        }
        final StringBuilder redirect = new StringBuilder("redirect:/obras/").append(obraId);
        if (produccionId != null) {
            redirect.append("?produccionId=").append(produccionId);
        }
        return new ModelAndView(redirect.toString());
    }
}
*/

final class SeenControllerDisabled {
    private SeenControllerDisabled() {
    }
}
