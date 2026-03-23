package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ProductionService;
import ar.edu.itba.paw.models.Production;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
public class HomeController {

    private static final int PAGE_SIZE = 8;

    private final ProductionService productionService;

    @Autowired
    public HomeController(final ProductionService productionService) {
        this.productionService = productionService;
    }

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public ModelAndView index() {
        final ModelAndView mav = new ModelAndView("index");
        final List<Production> available = productionService.findAvailable(0, PAGE_SIZE);
        final List<Production> all = productionService.findAll(0, PAGE_SIZE);
        mav.addObject("availableProductions", available);
        mav.addObject("allProductions", all);
        mav.addObject("featuredProduction", available.isEmpty() ? null : available.get(0));
        return mav;
    }
}
