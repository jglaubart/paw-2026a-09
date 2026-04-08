package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.PlayPetitionService;
import ar.edu.itba.paw.models.PetitionStatus;
import ar.edu.itba.paw.models.PlayPetition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class AdminPlayPetitionController {

    private static final int PAGE_SIZE = 20;

    private final PlayPetitionService playPetitionService;

    @Autowired
    public AdminPlayPetitionController(final PlayPetitionService playPetitionService) {
        this.playPetitionService = playPetitionService;
    }

    @RequestMapping(method = RequestMethod.GET)
    public ModelAndView list(@RequestParam(value = "status", required = false) final String status,
                             @RequestParam(value = "page", defaultValue = "0") final int page,
                             @RequestParam(value = "updated", required = false) final String updated,
                             @RequestParam(value = "error", required = false) final String error) {
        final PetitionStatus petitionStatus = parseStatus(status);
        final List<PlayPetition> petitions = petitionStatus == null
                ? playPetitionService.findAll(page, PAGE_SIZE)
                : playPetitionService.findByStatus(petitionStatus, page, PAGE_SIZE);

        final ModelAndView mav = new ModelAndView("petitions/admin-list");
        mav.addObject("petitions", petitions);
        mav.addObject("selectedStatus", petitionStatus != null ? petitionStatus.name() : "ALL");
        mav.addObject("page", page);
        mav.addObject("updated", updated);
        mav.addObject("error", error);
        mav.addObject("pendingCount", playPetitionService.countByStatus(PetitionStatus.PENDING));
        mav.addObject("approvedCount", playPetitionService.countByStatus(PetitionStatus.APPROVED));
        mav.addObject("rejectedCount", playPetitionService.countByStatus(PetitionStatus.REJECTED));
        mav.addObject("totalCount", playPetitionService.countAll());
        return mav;
    }

    @RequestMapping(value = "/{id:\\d+}", method = RequestMethod.GET)
    public ModelAndView detail(@PathVariable("id") final long id,
                               @RequestParam(value = "updated", required = false) final String updated,
                               @RequestParam(value = "error", required = false) final String error) {
        final Optional<PlayPetition> petition = playPetitionService.findById(id);
        if (!petition.isPresent()) {
            return new ModelAndView("redirect:/admin?error=not_found");
        }

        final ModelAndView mav = new ModelAndView("petitions/admin-detail");
        mav.addObject("petition", petition.get());
        mav.addObject("updated", updated);
        mav.addObject("error", error);
        return mav;
    }

    @RequestMapping(value = "/{id:\\d+}/decision", method = RequestMethod.POST)
    public ModelAndView decide(@PathVariable("id") final long id,
                               @RequestParam("action") final String action,
                               @RequestParam(value = "adminNotes", required = false) final String adminNotes) {
        try {
            if ("approve".equals(action)) {
                playPetitionService.approve(id, adminNotes);
                return new ModelAndView("redirect:/admin/" + id + "?updated=approved");
            }
            if ("reject".equals(action)) {
                playPetitionService.reject(id, adminNotes);
                return new ModelAndView("redirect:/admin/" + id + "?updated=rejected");
            }
            return new ModelAndView("redirect:/admin/" + id + "?error=invalid_action");
        } catch (final IllegalArgumentException e) {
            return new ModelAndView("redirect:/admin/" + id + "?error=not_found");
        } catch (final IllegalStateException e) {
            return new ModelAndView("redirect:/admin/" + id + "?error=already_resolved");
        }
    }

    private PetitionStatus parseStatus(final String status) {
        if (status == null || status.trim().isEmpty() || "ALL".equalsIgnoreCase(status)) {
            return null;
        }
        try {
            return PetitionStatus.valueOf(status.trim().toUpperCase(Locale.ROOT));
        } catch (final IllegalArgumentException e) {
            return null;
        }
    }
}
