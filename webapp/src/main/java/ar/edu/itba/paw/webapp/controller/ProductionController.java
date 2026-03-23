package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ObraService;
import ar.edu.itba.paw.interfaces.services.ProductionService;
import ar.edu.itba.paw.interfaces.services.ProductoraService;
import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.interfaces.services.WatchlistService;
import ar.edu.itba.paw.models.Obra;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.Productora;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Optional;

@Controller
public class ProductionController {

    private static final long HARDCODED_USER_ID = 1L;
    private static final int PAGE_SIZE = 8;

    private final ProductionService productionService;
    private final ObraService obraService;
    private final ProductoraService productoraService;
    private final RatingService ratingService;
    private final WatchlistService watchlistService;

    @Autowired
    public ProductionController(final ProductionService productionService,
                                final ObraService obraService,
                                final ProductoraService productoraService,
                                final RatingService ratingService,
                                final WatchlistService watchlistService) {
        this.productionService = productionService;
        this.obraService = obraService;
        this.productoraService = productoraService;
        this.ratingService = ratingService;
        this.watchlistService = watchlistService;
    }

    @RequestMapping(value = "/productions/{id:\\d+}", method = RequestMethod.GET)
    public ModelAndView detail(@PathVariable("id") final long id) {
        final Optional<Production> productionOpt = productionService.findById(id);
        if (!productionOpt.isPresent()) {
            return new ModelAndView("redirect:/");
        }
        final Production production = productionOpt.get();
        return new ModelAndView("redirect:/obras/" + production.getObraId() + "?produccionId=" + id);
    }

    @RequestMapping(value = "/cartelera", method = RequestMethod.GET)
    public ModelAndView cartelera(
            @RequestParam(value = "page", defaultValue = "0") final int page,
            @RequestParam(value = "genre", required = false) final String genre) {
        return list(page, true, genre);
    }

    @RequestMapping(value = "/productions", method = RequestMethod.GET)
    public ModelAndView list(
            @RequestParam(value = "page", defaultValue = "0") final int page,
            @RequestParam(value = "available", defaultValue = "false") final boolean available,
            @RequestParam(value = "genre", required = false) final String genre) {
        final ModelAndView mav = new ModelAndView("productions/list");
        final List<Production> productions;
        if (genre != null && !genre.isEmpty()) {
            productions = productionService.findByGenre(genre, page, PAGE_SIZE);
        } else if (available) {
            productions = productionService.findAvailable(page, PAGE_SIZE);
        } else {
            productions = productionService.findAll(page, PAGE_SIZE);
        }
        mav.addObject("productions", productions);
        mav.addObject("page", page);
        mav.addObject("available", available);
        mav.addObject("genre", genre);
        return mav;
    }
}
