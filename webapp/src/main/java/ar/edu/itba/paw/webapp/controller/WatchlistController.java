package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.WatchlistService;
import ar.edu.itba.paw.models.Production;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
public class WatchlistController {

    private static final long HARDCODED_USER_ID = 1L;

    private final WatchlistService watchlistService;

    @Autowired
    public WatchlistController(final WatchlistService watchlistService) {
        this.watchlistService = watchlistService;
    }

    @RequestMapping(value = "/wishlist", method = RequestMethod.GET)
    public ModelAndView wishlist() {
        final ModelAndView mav = new ModelAndView("wishlist/index");
        final List<Production> productions = watchlistService.findByUser(HARDCODED_USER_ID);
        mav.addObject("wishlist", productions);
        return mav;
    }

    @RequestMapping(value = "/productions/{id:\\d+}/wishlist", method = RequestMethod.POST)
    public ModelAndView toggle(@PathVariable("id") final long productionId,
                               @RequestParam("action") final String action,
                               @RequestParam("obraId") final long obraId) {
        if ("add".equals(action)) {
            watchlistService.add(HARDCODED_USER_ID, productionId);
        } else if ("remove".equals(action)) {
            watchlistService.remove(HARDCODED_USER_ID, productionId);
        }
        return new ModelAndView("redirect:/obras/" + obraId + "?produccionId=" + productionId);
    }
}
