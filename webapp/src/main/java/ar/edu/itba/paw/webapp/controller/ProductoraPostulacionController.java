package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ProductoraRequestService;
import ar.edu.itba.paw.interfaces.services.exception.ProductoraRequestAlreadyActiveException;
import ar.edu.itba.paw.models.ProductoraRequest;
import ar.edu.itba.paw.models.ProductoraRequestStatus;
import ar.edu.itba.paw.webapp.auth.PawAuthUser;
import ar.edu.itba.paw.webapp.form.ProductoraRequestForm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;
import java.util.Optional;

@Controller
@RequestMapping("/productoras/postular")
public class ProductoraPostulacionController {

    private final ProductoraRequestService requestService;

    @Autowired
    public ProductoraPostulacionController(final ProductoraRequestService requestService) {
        this.requestService = requestService;
    }

    @RequestMapping(method = RequestMethod.GET)
    public ModelAndView entry(@AuthenticationPrincipal final PawAuthUser authUser) {
        final long userId = authUser.getUser().getId();
        final Optional<ProductoraRequest> active = requestService.findActiveForUser(userId);
        if (active.isPresent()) {
            return new ModelAndView("redirect:/productoras/postular/estado");
        }
        final ModelAndView mav = new ModelAndView("productora/postulacion-entry");
        mav.addObject("history", requestService.findHistoryForUser(userId));
        return mav;
    }

    @RequestMapping(value = "/nueva", method = RequestMethod.GET)
    public ModelAndView newForm(@AuthenticationPrincipal final PawAuthUser authUser) {
        if (requestService.findActiveForUser(authUser.getUser().getId()).isPresent()) {
            return new ModelAndView("redirect:/productoras/postular/estado");
        }
        return formView(new ProductoraRequestForm(), null);
    }

    @RequestMapping(value = "/nueva", method = RequestMethod.POST)
    public ModelAndView submit(@Valid @ModelAttribute("productoraRequestForm") final ProductoraRequestForm form,
                               final BindingResult errors,
                               @AuthenticationPrincipal final PawAuthUser authUser) {
        if (errors.hasErrors()) {
            return formView(form, null);
        }
        try {
            requestService.submit(
                    authUser.getUser().getId(),
                    form.getContactEmail(),
                    form.getPhone(),
                    form.getName(),
                    form.getCuit(),
                    form.getBio(),
                    form.getInstagram(),
                    form.getWebsite(),
                    form.getCoverImageId(),
                    form.getTeamDescription(),
                    form.getTeamSize(),
                    form.getPreviousWorks(),
                    form.getSupportingDocId()
            );
        } catch (final ProductoraRequestAlreadyActiveException e) {
            return new ModelAndView("redirect:/productoras/postular/estado");
        }
        return new ModelAndView("redirect:/productoras/postular/estado?sent=1");
    }


    @RequestMapping(value = "/estado", method = RequestMethod.GET)
    public ModelAndView status(@AuthenticationPrincipal final PawAuthUser authUser) {
        final long userId = authUser.getUser().getId();
        final Optional<ProductoraRequest> active = requestService.findActiveForUser(userId);
        final ModelAndView mav = new ModelAndView("productora/postulacion-status");
        if (active.isPresent()) {
            mav.addObject("request", active.get());
        } else {
            mav.addObject("history", requestService.findHistoryForUser(userId));
        }
        return mav;
    }

    @RequestMapping(value = "/{id:\\d+}/editar", method = RequestMethod.GET)
    public ModelAndView editForm(@PathVariable("id") final long id,
                                 @AuthenticationPrincipal final PawAuthUser authUser) {
        final ProductoraRequest req = loadEditable(id, authUser);
        final ProductoraRequestForm form = prefill(req);
        return formView(form, req);
    }

    @RequestMapping(value = "/{id:\\d+}/editar", method = RequestMethod.POST)
    public ModelAndView editSubmit(@PathVariable("id") final long id,
                                   @Valid @ModelAttribute("productoraRequestForm") final ProductoraRequestForm form,
                                   final BindingResult errors,
                                   @AuthenticationPrincipal final PawAuthUser authUser) {
        final ProductoraRequest req = loadEditable(id, authUser);
        if (errors.hasErrors()) {
            return formView(form, req);
        }
        requestService.resubmit(
                id,
                authUser.getUser().getId(),
                form.getContactEmail(),
                form.getPhone(),
                form.getName(),
                form.getCuit(),
                form.getBio(),
                form.getInstagram(),
                form.getWebsite(),
                form.getCoverImageId(),
                form.getTeamDescription(),
                form.getTeamSize(),
                form.getPreviousWorks(),
                form.getSupportingDocId()
        );
        return new ModelAndView("redirect:/productoras/postular/estado?resent=1");
    }

    private ModelAndView formView(final ProductoraRequestForm form, final ProductoraRequest existing) {
        final ModelAndView mav = new ModelAndView("productora/postulacion-form");
        mav.addObject("productoraRequestForm", form);
        mav.addObject("existingRequest", existing);
        return mav;
    }

    private ProductoraRequest loadEditable(final long id, final PawAuthUser authUser) {
        final ProductoraRequest req = requestService.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Request not found: " + id));
        if (req.getUserId() != authUser.getUser().getId()) {
            throw new IllegalStateException("User mismatch on productora request");
        }
        if (req.getStatus() != ProductoraRequestStatus.CHANGES_REQUESTED) {
            throw new IllegalStateException("Request not editable in status " + req.getStatus());
        }
        return req;
    }

    private ProductoraRequestForm prefill(final ProductoraRequest r) {
        final ProductoraRequestForm f = new ProductoraRequestForm();
        f.setName(r.getName());
        f.setCuit(r.getCuit());
        f.setContactEmail(r.getContactEmail());
        f.setPhone(r.getPhone());
        f.setBio(r.getBio());
        f.setInstagram(r.getInstagram());
        f.setWebsite(r.getWebsite());
        f.setCoverImageId(r.getCoverImageId());
        f.setTeamDescription(r.getTeamDescription());
        f.setTeamSize(r.getTeamSize());
        f.setPreviousWorks(r.getPreviousWorks());
        f.setSupportingDocId(r.getSupportingDocId());
        return f;
    }
}
