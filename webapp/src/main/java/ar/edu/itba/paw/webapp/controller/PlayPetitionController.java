package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.GenreService;
import ar.edu.itba.paw.interfaces.services.PlayPetitionService;
import ar.edu.itba.paw.models.Genre;
import ar.edu.itba.paw.webapp.config.WebConfig;
import ar.edu.itba.paw.webapp.form.PlayPetitionForm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URI;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
public class PlayPetitionController {

    private static final long MAX_IMAGE_UPLOAD_BYTES = WebConfig.MAX_UPLOAD_SIZE_BYTES;

    private final PlayPetitionService playPetitionService;
    private final GenreService genreService;

    @Autowired
    public PlayPetitionController(final PlayPetitionService playPetitionService,
                                  final GenreService genreService) {
        this.playPetitionService = playPetitionService;
        this.genreService = genreService;
    }

    @RequestMapping(value = "/subir-obra", method = RequestMethod.GET)
    public ModelAndView form(@RequestParam(value = "created", required = false) final String created,
                             @RequestParam(value = "imageTooLarge", required = false) final String imageTooLarge) {
        final Map<String, String> errors = new LinkedHashMap<>();
        if ("1".equals(imageTooLarge)) {
            errors.put("coverImage", "La imagen excede el tamaño máximo permitido de " + readableUploadLimit() + ".");
        }
        final ModelAndView mav = petitionForm(new PlayPetitionForm(), errors);
        mav.addObject("created", "1".equals(created));
        return mav;
    }

    @RequestMapping(value = "/subir-obra", method = RequestMethod.POST)
    public ModelAndView submit(@ModelAttribute("form") final PlayPetitionForm form) {
        final Map<String, String> errors = validate(form);
        final List<Long> genreIds = parseGenreIds(form.getGenreIds(), errors);
        final Integer durationMinutes = parseDuration(form.getDurationMinutes(), errors);
        final LocalDate startDate = parseDate("startDate", form.getStartDate(), true, errors);
        final LocalDate endDate = parseDate("endDate", form.getEndDate(), true, errors);
        final List<LocalDate> additionalShowDates = parseAdditionalDates(form.getAdditionalShowDates(), errors);
        final MultipartFile coverImage = form.getCoverImage();

        if (startDate != null && endDate != null && endDate.isBefore(startDate)) {
            errors.put("endDate", "La fecha de fin no puede ser anterior al inicio.");
        }

        if (!errors.isEmpty()) {
            return petitionForm(form, errors);
        }

        try {
            playPetitionService.create(
                    form.getTitle(),
                    form.getSynopsis(),
                    durationMinutes,
                    genreIds,
                    form.getTheater(),
                    form.getTheaterAddress(),
                    startDate,
                    endDate,
                    coverImage.getContentType(),
                    coverImage.getBytes(),
                    additionalShowDates,
                    form.getDirector(),
                    form.getPetitionerEmail(),
                    form.getSchedule(),
                    form.getTicketUrl(),
                    form.getLanguage()
            );
            return new ModelAndView("redirect:/subir-obra?created=1");
        } catch (final IOException e) {
            errors.put("coverImage", "No se pudo leer la imagen subida.");
            return petitionForm(form, errors);
        } catch (final IllegalArgumentException e) {
            errors.put("global", e.getMessage());
            return petitionForm(form, errors);
        }
    }

    private ModelAndView petitionForm(final PlayPetitionForm form, final Map<String, String> errors) {
        final ModelAndView mav = new ModelAndView("petitions/form");
        mav.addObject("form", form);
        mav.addObject("genres", genreService.findAll());
        mav.addObject("errors", errors);
        mav.addObject("selectedGenreIdsCsv", selectedGenreIdsCsv(form.getGenreIds()));
        return mav;
    }

    private Map<String, String> validate(final PlayPetitionForm form) {
        final Map<String, String> errors = new LinkedHashMap<>();
        requireText(form.getTitle(), "title", "Ingresá el título de la obra.", errors);
        requireText(form.getSynopsis(), "synopsis", "Ingresá una sinopsis breve.", errors);
        requireText(form.getDurationMinutes(), "durationMinutes", "Ingresá la duración aproximada.", errors);
        requireText(form.getTheater(), "theater", "Ingresá el teatro o sala.", errors);
        requireText(form.getTheaterAddress(), "theaterAddress", "Ingresá la dirección de la sala.", errors);
        requireText(form.getStartDate(), "startDate", "Ingresá la fecha de inicio de temporada.", errors);
        requireText(form.getEndDate(), "endDate", "Ingresá la última fecha de la producción.", errors);
        requireText(form.getDirector(), "director", "Ingresá la dirección de la obra.", errors);
        requireText(form.getPetitionerEmail(), "petitionerEmail", "Ingresá un email de contacto.", errors);

        if (form.getGenreIds() == null || form.getGenreIds().isEmpty()) {
            errors.put("genreIds", "Seleccioná al menos un género.");
        }

        if (!isValidEmail(form.getPetitionerEmail())) {
            errors.put("petitionerEmail", "Ingresá un email válido.");
        }

        if (form.getCoverImage() == null || form.getCoverImage().isEmpty()) {
            errors.put("coverImage", "Subí una imagen de portada.");
        } else if (form.getCoverImage().getContentType() == null || !form.getCoverImage().getContentType().startsWith("image/")) {
            errors.put("coverImage", "La portada debe ser una imagen válida.");
        } else if (form.getCoverImage().getSize() > MAX_IMAGE_UPLOAD_BYTES) {
            errors.put("coverImage", "La imagen excede el tamaño máximo permitido de " + readableUploadLimit() + ".");
        }

        if (hasText(form.getTicketUrl()) && !isValidUrl(form.getTicketUrl())) {
            errors.put("ticketUrl", "Ingresá una URL válida para la venta de entradas.");
        }

        return errors;
    }

    private List<Long> parseGenreIds(final List<String> genreIds, final Map<String, String> errors) {
        final List<Long> parsed = new ArrayList<>();
        if (genreIds == null) {
            return parsed;
        }
        for (final String genreId : genreIds) {
            try {
                parsed.add(Long.parseLong(genreId));
            } catch (final NumberFormatException e) {
                errors.put("genreIds", "Hay géneros inválidos en la selección.");
                return new ArrayList<>();
            }
        }
        return parsed;
    }

    private Integer parseDuration(final String value, final Map<String, String> errors) {
        try {
            final int duration = Integer.parseInt(value);
            if (duration <= 0) {
                errors.put("durationMinutes", "La duración debe ser mayor a cero.");
            }
            return duration;
        } catch (final NumberFormatException e) {
            errors.put("durationMinutes", "Ingresá la duración en minutos.");
            return null;
        }
    }

    private List<LocalDate> parseAdditionalDates(final List<String> rawDates, final Map<String, String> errors) {
        final List<LocalDate> parsed = new ArrayList<>();
        if (rawDates == null) {
            return parsed;
        }
        for (final String rawDate : rawDates) {
            if (!hasText(rawDate)) {
                continue;
            }
            try {
                parsed.add(LocalDate.parse(rawDate.trim()));
            } catch (final DateTimeParseException e) {
                errors.put("additionalShowDates", "Ingresá fechas adicionales válidas.");
                return new ArrayList<>();
            }
        }
        return parsed;
    }

    private LocalDate parseDate(final String field, final String value, final boolean required, final Map<String, String> errors) {
        if (!hasText(value)) {
            if (required) {
                errors.put(field, "Completá este campo.");
            }
            return null;
        }
        try {
            return LocalDate.parse(value);
        } catch (final DateTimeParseException e) {
            errors.put(field, "Ingresá una fecha válida.");
            return null;
        }
    }

    private void requireText(final String value, final String field, final String message, final Map<String, String> errors) {
        if (!hasText(value)) {
            errors.put(field, message);
        }
    }

    private String selectedGenreIdsCsv(final List<String> genreIds) {
        final StringBuilder builder = new StringBuilder(",");
        if (genreIds != null) {
            for (final String genreId : genreIds) {
                if (hasText(genreId)) {
                    builder.append(genreId.trim()).append(',');
                }
            }
        }
        return builder.toString();
    }

    private boolean isValidEmail(final String value) {
        return hasText(value) && value.contains("@") && value.indexOf('@') < value.length() - 1;
    }

    private boolean isValidUrl(final String value) {
        try {
            final URI uri = URI.create(value);
            return uri.getScheme() != null && uri.getHost() != null;
        } catch (final IllegalArgumentException e) {
            return false;
        }
    }

    private boolean hasText(final String value) {
        return value != null && !value.trim().isEmpty();
    }

    private String readableUploadLimit() {
        return (MAX_IMAGE_UPLOAD_BYTES / (1024 * 1024)) + " MB";
    }
}
