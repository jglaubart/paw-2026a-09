package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ProductionService;
import ar.edu.itba.paw.interfaces.services.ProductoraService;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.Productora;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Optional;

@Controller
public class ProductoraController {

    private final ProductoraService productoraService;
    private final ProductionService productionService;

    @Autowired
    public ProductoraController(final ProductoraService productoraService,
                                final ProductionService productionService) {
        this.productoraService = productoraService;
        this.productionService = productionService;
    }

    @RequestMapping(value = "/productoras/{id:\\d+}", method = RequestMethod.GET)
    public ModelAndView detail(@PathVariable("id") final long id) {
        final Optional<Productora> productoraOpt = productoraService.findById(id);
        if (!productoraOpt.isPresent()) {
            return new ModelAndView("redirect:/");
        }
        final Productora productora = productoraOpt.get();
        final List<Production> productions = productionService.findByProductoraId(id);
        final ModelAndView mav = new ModelAndView("productoras/detail");
        mav.addObject("productora", productora);
        mav.addObject("productions", productions);
        return mav;
    }
}
