package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.PlayPetitionService;
import ar.edu.itba.paw.models.PetitionFieldFeedback;
import ar.edu.itba.paw.models.PetitionStatus;
import ar.edu.itba.paw.models.PlayPetition;
import ar.edu.itba.paw.webapp.exception.ResourceNotFoundException;
import ar.edu.itba.paw.webapp.form.AdminPlayPetitionReviewForm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
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

    @RequestMapping(value = {"/obras", ""}, method = RequestMethod.GET)
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
        mav.addObject("changesRequestedCount", playPetitionService.countByStatus(PetitionStatus.CHANGES_REQUESTED));
        mav.addObject("approvedCount", playPetitionService.countByStatus(PetitionStatus.APPROVED));
        mav.addObject("totalCount", playPetitionService.countAll());
        return mav;
    }

    @RequestMapping(value = "/{id:\\d+}", method = RequestMethod.GET)
    public ModelAndView detail(@PathVariable("id") final long id,
                               @RequestParam(value = "updated", required = false) final String updated,
                               @RequestParam(value = "error", required = false) final String error) {
        final PlayPetition petition = playPetitionService.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("La petición de alta de obra solicitada no existe."));

        final ModelAndView mav = new ModelAndView("petitions/admin-detail");
        mav.addObject("petition", petition);
        mav.addObject("updated", updated);
        mav.addObject("error", error);
        mav.addObject("reviewForm", reviewFormFromPetition(petition));
        mav.addObject("fieldFeedback", toFieldFeedbackMap(petition));
        mav.addObject("selectedIssueFieldsCsv", selectedIssueFieldsCsv(petition));
        return mav;
    }

    @RequestMapping(value = "/{id:\\d+}/decision", method = RequestMethod.POST)
    public ModelAndView decide(@PathVariable("id") final long id,
                               @RequestParam("action") final String action,
                               @ModelAttribute("reviewForm") final AdminPlayPetitionReviewForm reviewForm) {
        try {
            if ("approve".equals(action)) {
                playPetitionService.approve(id, reviewForm.getAdminNotes());
                return new ModelAndView("redirect:/admin/" + id + "?updated=approved");
            }
            if ("request_changes".equals(action)) {
                playPetitionService.requestChanges(id, reviewForm.getAdminNotes(), extractFieldFeedback(reviewForm));
                return new ModelAndView("redirect:/admin/" + id + "?updated=changes_requested");
            }
            return new ModelAndView("redirect:/admin/" + id + "?error=invalid_action");
        } catch (final IllegalArgumentException e) {
            if (e.getMessage() != null && e.getMessage().toLowerCase(Locale.ROOT).contains("not found")) {
                return new ModelAndView("redirect:/admin/" + id + "?error=not_found");
            }
            return new ModelAndView("redirect:/admin/" + id + "?error=invalid_review");
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

    private Map<String, String> extractFieldFeedback(final AdminPlayPetitionReviewForm reviewForm) {
        final Map<String, String> feedback = new LinkedHashMap<>();
        if (reviewForm.getIssueFields() == null) {
            return feedback;
        }
        for (final String fieldKey : reviewForm.getIssueFields()) {
            if (fieldKey == null) {
                continue;
            }
            final String normalizedKey = fieldKey.trim();
            final String comment = reviewForm.getFieldComments() != null ? reviewForm.getFieldComments().get(normalizedKey) : null;
            if (comment == null || comment.trim().isEmpty()) {
                throw new IllegalArgumentException("missing_field_comment");
            }
            feedback.put(normalizedKey, comment.trim());
        }
        return feedback;
    }

    private AdminPlayPetitionReviewForm reviewFormFromPetition(final PlayPetition petition) {
        final AdminPlayPetitionReviewForm form = new AdminPlayPetitionReviewForm();
        form.setAdminNotes(petition.getAdminNotes());
        final Map<String, String> fieldComments = new LinkedHashMap<>();
        final List<String> issueFields = new java.util.ArrayList<>();
        if (petition.getFieldFeedback() != null) {
            for (final PetitionFieldFeedback item : petition.getFieldFeedback()) {
                issueFields.add(item.getFieldKey());
                fieldComments.put(item.getFieldKey(), item.getComment());
            }
        }
        form.setIssueFields(issueFields);
        form.setFieldComments(fieldComments);
        return form;
    }

    private Map<String, String> toFieldFeedbackMap(final PlayPetition petition) {
        final Map<String, String> feedback = new LinkedHashMap<>();
        if (petition.getFieldFeedback() == null) {
            return feedback;
        }
        for (final PetitionFieldFeedback item : petition.getFieldFeedback()) {
            feedback.put(item.getFieldKey(), item.getComment());
        }
        return feedback;
    }

    private String selectedIssueFieldsCsv(final PlayPetition petition) {
        final StringBuilder builder = new StringBuilder(",");
        if (petition.getFieldFeedback() == null) {
            return builder.toString();
        }
        for (final PetitionFieldFeedback item : petition.getFieldFeedback()) {
            builder.append(item.getFieldKey()).append(',');
        }
        return builder.toString();
    }
}
