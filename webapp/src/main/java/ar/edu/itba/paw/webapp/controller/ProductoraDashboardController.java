package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ProductoraService;
import ar.edu.itba.paw.models.Productora;
import ar.edu.itba.paw.models.ProductoraMember;
import ar.edu.itba.paw.webapp.auth.PawAuthUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
public class ProductoraDashboardController {

    private final ProductoraService productoraService;

    @Autowired
    public ProductoraDashboardController(final ProductoraService productoraService) {
        this.productoraService = productoraService;
    }

    @RequestMapping(value = "/productoras/mia", method = RequestMethod.GET)
    public ModelAndView myProductora(@AuthenticationPrincipal final PawAuthUser authUser) {
        final long userId = authUser.getUser().getId();
        final List<Productora> mine = productoraService.findMineByUser(userId);
        if (mine.isEmpty()) {
            return new ModelAndView("redirect:/productoras/postular");
        }
        final Productora first = mine.get(0);
        return new ModelAndView("redirect:/productoras/" + first.getId() + "/dashboard");
    }

    @RequestMapping(value = "/productoras/{productoraId:\\d+}/dashboard", method = RequestMethod.GET)
    public ModelAndView dashboard(@PathVariable("productoraId") final long productoraId,
                                  @RequestParam(value = "tab", required = false, defaultValue = "overview") final String tab,
                                  @AuthenticationPrincipal final PawAuthUser authUser) {
        final long userId = authUser.getUser().getId();
        if (!productoraService.canManage(userId, productoraId)) {
            return new ModelAndView("redirect:/productoras/mia");
        }
        final Productora productora = productoraService.findById(productoraId)
                .orElseThrow(() -> new IllegalArgumentException("Productora not found: " + productoraId));
        final List<ProductoraMember> members = productoraService.listMembers(productoraId);

        final ModelAndView mav = new ModelAndView("productora/dashboard-layout");
        mav.addObject("productora", productora);
        mav.addObject("members", members);
        mav.addObject("activeTab", tab);
        mav.addObject("currentUserId", userId);
        return mav;
    }

    @RequestMapping(value = "/productoras/{productoraId:\\d+}/miembros", method = RequestMethod.POST)
    public ModelAndView addMember(@PathVariable("productoraId") final long productoraId,
                                  @RequestParam("email") final String email,
                                  @AuthenticationPrincipal final PawAuthUser authUser) {
        productoraService.addMemberByEmail(productoraId, authUser.getUser().getId(), email);
        return new ModelAndView("redirect:/productoras/" + productoraId + "/dashboard?tab=equipo");
    }

    @RequestMapping(value = "/productoras/{productoraId:\\d+}/miembros/{memberUserId:\\d+}/remover", method = RequestMethod.POST)
    public ModelAndView removeMember(@PathVariable("productoraId") final long productoraId,
                                     @PathVariable("memberUserId") final long memberUserId,
                                     @AuthenticationPrincipal final PawAuthUser authUser) {
        productoraService.removeMember(productoraId, authUser.getUser().getId(), memberUserId);
        return new ModelAndView("redirect:/productoras/" + productoraId + "/dashboard?tab=equipo");
    }
}
