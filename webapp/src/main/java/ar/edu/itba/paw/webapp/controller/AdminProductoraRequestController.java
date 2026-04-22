package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ProductoraRequestService;
import ar.edu.itba.paw.models.ProductoraRequest;
import ar.edu.itba.paw.models.ProductoraRequestStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin/productoras")
public class AdminProductoraRequestController {

    private final ProductoraRequestService requestService;

    @Autowired
    public AdminProductoraRequestController(final ProductoraRequestService requestService) {
        this.requestService = requestService;
    }

    @RequestMapping(value = {"/postulaciones", ""}, method = RequestMethod.GET)
    public ModelAndView list(@RequestParam(value = "status", required = false) final String statusRaw) {
        final ProductoraRequestStatus filter = parseFilter(statusRaw);
        final Map<ProductoraRequestStatus, Integer> rawCounts = requestService.countByStatus();
        int total = 0;
        for (final int v : rawCounts.values()) total += v;
        final ModelAndView mav = new ModelAndView("productora/admin-list");
        mav.addObject("requests", requestService.findForAdmin(filter));
        mav.addObject("selectedStatus", filter != null ? filter.name() : "ALL");
        mav.addObject("pendingCount", rawCounts.getOrDefault(ProductoraRequestStatus.PENDING, 0));
        mav.addObject("changesRequestedCount", rawCounts.getOrDefault(ProductoraRequestStatus.CHANGES_REQUESTED, 0));
        mav.addObject("approvedCount", rawCounts.getOrDefault(ProductoraRequestStatus.APPROVED, 0));
        mav.addObject("rejectedCount", rawCounts.getOrDefault(ProductoraRequestStatus.REJECTED, 0));
        mav.addObject("totalCount", total);
        return mav;
    }

    @RequestMapping(value = "/postulaciones/{id:\\d+}", method = RequestMethod.GET)
    public ModelAndView detail(@PathVariable("id") final long id) {
        final ProductoraRequest req = requestService.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Request not found: " + id));
        final ModelAndView mav = new ModelAndView("productora/admin-detail");
        mav.addObject("request", req);
        return mav;
    }

    @RequestMapping(value = "/postulaciones/{id:\\d+}/aprobar", method = RequestMethod.POST)
    public ModelAndView approve(@PathVariable("id") final long id,
                                @RequestParam(value = "adminNotes", required = false) final String adminNotes) {
        requestService.approve(id, adminNotes);
        return new ModelAndView("redirect:/admin/productoras/postulaciones?status=APPROVED");
    }

    @RequestMapping(value = "/postulaciones/{id:\\d+}/rechazar", method = RequestMethod.POST)
    public ModelAndView reject(@PathVariable("id") final long id,
                               @RequestParam(value = "adminNotes", required = false) final String adminNotes) {
        requestService.reject(id, adminNotes);
        return new ModelAndView("redirect:/admin/productoras/postulaciones?status=REJECTED");
    }

    @RequestMapping(value = "/postulaciones/{id:\\d+}/cambios", method = RequestMethod.POST)
    public ModelAndView requestChanges(@PathVariable("id") final long id,
                                       @RequestParam(value = "adminNotes", required = false) final String adminNotes,
                                       final HttpServletRequest httpRequest) {
        final Map<String, String> clean = new LinkedHashMap<>();
        for (final Map.Entry<String, String[]> entry : httpRequest.getParameterMap().entrySet()) {
            final String paramName = entry.getKey();
            if (paramName.startsWith("feedback[") && paramName.endsWith("]")) {
                final String fieldKey = paramName.substring("feedback[".length(), paramName.length() - 1);
                final String[] values = entry.getValue();
                if (values != null && values.length > 0 && values[0] != null && !values[0].trim().isEmpty()) {
                    clean.put(fieldKey, values[0].trim());
                }
            }
        }
        requestService.requestChanges(id, adminNotes, clean);
        return new ModelAndView("redirect:/admin/productoras/postulaciones?status=CHANGES_REQUESTED");
    }

    private ProductoraRequestStatus parseFilter(final String raw) {
        if (raw == null || raw.trim().isEmpty() || "ALL".equalsIgnoreCase(raw)) {
            return null;
        }
        try {
            return ProductoraRequestStatus.valueOf(raw.toUpperCase());
        } catch (final IllegalArgumentException e) {
            return null;
        }
    }
}
