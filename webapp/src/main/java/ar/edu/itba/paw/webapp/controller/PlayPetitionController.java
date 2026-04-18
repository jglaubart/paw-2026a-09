package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.GenreService;
import ar.edu.itba.paw.interfaces.services.PlayPetitionService;
import ar.edu.itba.paw.models.Genre;
import ar.edu.itba.paw.models.PetitionFieldFeedback;
import ar.edu.itba.paw.models.PetitionObraPrefill;
import ar.edu.itba.paw.models.PetitionObraSuggestion;
import ar.edu.itba.paw.models.PetitionStatus;
import ar.edu.itba.paw.models.PlayPetition;
import ar.edu.itba.paw.webapp.auth.PawAuthUser;
import ar.edu.itba.paw.webapp.config.WebConfig;
import ar.edu.itba.paw.webapp.form.PlayPetitionForm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;
import java.net.URI;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;

@Controller
public class PlayPetitionController {

    private static final long MAX_IMAGE_UPLOAD_BYTES = WebConfig.MAX_UPLOAD_SIZE_BYTES;
    private static final int AUTOCOMPLETE_LIMIT = 8;

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
                             @RequestParam(value = "imageTooLarge", required = false) final String imageTooLarge,
                             @RequestParam(value = "petitionId", required = false) final String petitionId,
                             @AuthenticationPrincipal final PawAuthUser authUser) {
        final Map<String, String> errors = new LinkedHashMap<>();
        final Optional<PlayPetition> selectedEditablePetition = selectedEditablePetition(authUser, petitionId);
        final PlayPetitionForm form = selectedEditablePetition.isPresent()
                ? formFromPetition(selectedEditablePetition.get(), authUser)
                : new PlayPetitionForm();
        prefillPetitionerEmail(form, authUser);

        if ("1".equals(imageTooLarge)) {
            errors.put("coverImage", "La imagen excede el tamaño máximo permitido de " + readableUploadLimit() + ".");
        }

        final ModelAndView mav = petitionForm(form, errors, authUser, selectedEditablePetition.orElse(null));
        mav.addObject("created", "1".equals(created));
        return mav;
    }

    @RequestMapping(value = "/subir-obra", method = RequestMethod.POST)
    public ModelAndView submit(@ModelAttribute("form") final PlayPetitionForm form,
                               @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser == null) {
            return new ModelAndView("redirect:/login");
        }

        prefillPetitionerEmail(form, authUser);
        final Map<String, String> errors = validate(form);
        final Long petitionId = parseOptionalLong("petitionId", form.getPetitionId(), errors);
        final Long sourceObraId = parseOptionalLong("sourceObraId", form.getSourceObraId(), errors);
        final Long sourceProductionId = parseOptionalLong("sourceProductionId", form.getSourceProductionId(), errors);
        final Long existingCoverImageId = parseOptionalLong("existingCoverImageId", form.getExistingCoverImageId(), errors);
        final List<Long> genreIds = parseGenreIds(form.getGenreIds(), errors);
        final Integer durationMinutes = parseDuration(form.getDurationMinutes(), errors);
        final LocalDate startDate = parseDate("startDate", form.getStartDate(), true, errors);
        final LocalDate endDate = parseDate("endDate", form.getEndDate(), true, errors);
        final List<LocalDate> additionalShowDates = parseAdditionalDates(form.getAdditionalShowDates(), errors);
        final MultipartFile coverImage = form.getCoverImage();

        if (startDate != null && endDate != null && endDate.isBefore(startDate)) {
            errors.put("endDate", "La fecha de fin no puede ser anterior al inicio.");
        }

        PlayPetition currentPetition = resolveCurrentPetition(form, authUser).orElse(null);
        if (!errors.isEmpty()) {
            return petitionForm(form, errors, authUser, currentPetition);
        }

        try {
            if (petitionId != null) {
                currentPetition = playPetitionService.resubmit(
                        petitionId,
                        form.getTitle(),
                        form.getSynopsis(),
                        durationMinutes,
                        genreIds,
                        form.getTheater(),
                        form.getTheaterAddress(),
                        startDate,
                        endDate,
                        coverImage != null ? coverImage.getContentType() : null,
                        coverImage != null ? coverImage.getBytes() : null,
                        existingCoverImageId,
                        additionalShowDates,
                        form.getDirector(),
                        authUser.getUser().getId(),
                        form.getPetitionerEmail(),
                        form.getSchedule(),
                        form.getTicketUrl(),
                        form.getLanguage(),
                        sourceObraId,
                        sourceProductionId
                );
            } else {
                currentPetition = playPetitionService.create(
                        form.getTitle(),
                        form.getSynopsis(),
                        durationMinutes,
                        genreIds,
                        form.getTheater(),
                        form.getTheaterAddress(),
                        startDate,
                        endDate,
                        coverImage != null ? coverImage.getContentType() : null,
                        coverImage != null ? coverImage.getBytes() : null,
                        existingCoverImageId,
                        additionalShowDates,
                        form.getDirector(),
                        authUser.getUser().getId(),
                        form.getPetitionerEmail(),
                        form.getSchedule(),
                        form.getTicketUrl(),
                        form.getLanguage(),
                        sourceObraId,
                        sourceProductionId
                );
            }
            return new ModelAndView("redirect:/subir-obra?created=1");
        } catch (final IOException e) {
            errors.put("coverImage", "No se pudo leer la imagen subida.");
            return petitionForm(form, errors, authUser, currentPetition);
        } catch (final IllegalArgumentException e) {
            errors.put("global", friendlyErrorMessage(e.getMessage()));
            return petitionForm(form, errors, authUser, currentPetition);
        } catch (final IllegalStateException e) {
            errors.put("global", friendlyErrorMessage(e.getMessage()));
            return petitionForm(form, errors, authUser, currentPetition);
        }
    }

    @ResponseBody
    @RequestMapping(value = "/subir-obra/autocomplete", method = RequestMethod.GET)
    public ResponseEntity<List<PetitionObraSuggestion>> autocomplete(
            @RequestParam(value = "q", required = false) final String query,
            @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }
        return new ResponseEntity<>(playPetitionService.searchSourceObras(query, AUTOCOMPLETE_LIMIT), HttpStatus.OK);
    }

    @ResponseBody
    @RequestMapping(value = "/subir-obra/autocomplete/{obraId:\\d+}", method = RequestMethod.GET)
    public ResponseEntity<PetitionObraPrefill> autocompletePrefill(@PathVariable("obraId") final long obraId,
                                                                   @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }
        final Optional<PetitionObraPrefill> prefill = playPetitionService.getSourceObraPrefill(obraId);
        return prefill.map(value -> new ResponseEntity<>(value, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    private ModelAndView petitionForm(final PlayPetitionForm form,
                                      final Map<String, String> errors,
                                      final PawAuthUser authUser,
                                      final PlayPetition petition) {
        final PlayPetition resolvedPetition = petition != null ? petition : resolveCurrentPetition(form, authUser).orElse(null);
        final ModelAndView mav = new ModelAndView("petitions/form");
        mav.addObject("form", form);
        mav.addObject("genres", genreService.findAll());
        mav.addObject("errors", errors);
        mav.addObject("selectedGenreIdsCsv", selectedGenreIdsCsv(form.getGenreIds()));
        mav.addObject("fieldFeedback", toFieldFeedbackMap(resolvedPetition));
        mav.addObject("hasEditableDraft", resolvedPetition != null && resolvedPetition.getStatus() == PetitionStatus.CHANGES_REQUESTED);
        mav.addObject("currentPetition", resolvedPetition);
        mav.addObject("myPetitions", myPetitions(authUser));
        mav.addObject("currentCoverImageUrl", coverImageUrl(form));
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

        final boolean hasExistingCoverImage = hasText(form.getExistingCoverImageId());
        if ((form.getCoverImage() == null || form.getCoverImage().isEmpty()) && !hasExistingCoverImage) {
            errors.put("coverImage", "Subí una imagen de portada o elegí una existente.");
        } else if (form.getCoverImage() != null && !form.getCoverImage().isEmpty()) {
            if (form.getCoverImage().getContentType() == null || !form.getCoverImage().getContentType().startsWith("image/")) {
                errors.put("coverImage", "La portada debe ser una imagen válida.");
            } else if (form.getCoverImage().getSize() > MAX_IMAGE_UPLOAD_BYTES) {
                errors.put("coverImage", "La imagen excede el tamaño máximo permitido de " + readableUploadLimit() + ".");
            }
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

    private LocalDate parseDate(final String field, final String value, final boolean required,
                                final Map<String, String> errors) {
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

    private Long parseOptionalLong(final String field, final String value, final Map<String, String> errors) {
        if (!hasText(value)) {
            return null;
        }
        try {
            return Long.parseLong(value.trim());
        } catch (final NumberFormatException e) {
            errors.put("global", "Hay datos internos inválidos para " + field + ". Volvé a seleccionar la obra sugerida.");
            return null;
        }
    }

    private void requireText(final String value, final String field, final String message,
                             final Map<String, String> errors) {
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

    private void prefillPetitionerEmail(final PlayPetitionForm form,
                                        final PawAuthUser authUser) {
        if (authUser != null) {
            form.setPetitionerEmail(authUser.getUser().getEmail());
        }
    }

    private PlayPetitionForm formFromPetition(final PlayPetition petition, final PawAuthUser authUser) {
        final PlayPetitionForm form = new PlayPetitionForm();
        form.setPetitionId(String.valueOf(petition.getId()));
        if (petition.getSourceObraId() != null) {
            form.setSourceObraId(String.valueOf(petition.getSourceObraId()));
        }
        if (petition.getSourceProductionId() != null) {
            form.setSourceProductionId(String.valueOf(petition.getSourceProductionId()));
        }
        if (petition.getCoverImageId() != null) {
            form.setExistingCoverImageId(String.valueOf(petition.getCoverImageId()));
        }
        form.setTitle(petition.getTitle());
        form.setSynopsis(petition.getSynopsis());
        form.setDurationMinutes(String.valueOf(petition.getDurationMinutes()));
        form.setGenreIds(toGenreIdStrings(petition.getGenres()));
        form.setTheater(petition.getTheater());
        form.setTheaterAddress(petition.getTheaterAddress());
        form.setStartDate(petition.getStartDate() != null ? petition.getStartDate().toString() : null);
        form.setEndDate(petition.getEndDate() != null ? petition.getEndDate().toString() : null);
        form.setAdditionalShowDates(toDateStrings(petition.getAdditionalShowDates()));
        form.setDirector(petition.getDirector());
        form.setPetitionerEmail(petition.getPetitionerEmail());
        form.setSchedule(petition.getSchedule());
        form.setTicketUrl(petition.getTicketUrl());
        form.setLanguage(petition.getLanguage());
        prefillPetitionerEmail(form, authUser);
        return form;
    }

    private List<String> toGenreIdStrings(final List<Genre> genres) {
        final List<String> ids = new ArrayList<>();
        if (genres == null) {
            return ids;
        }
        for (final Genre genre : genres) {
            ids.add(String.valueOf(genre.getId()));
        }
        return ids;
    }

    private List<String> toDateStrings(final List<LocalDate> dates) {
        final List<String> values = new ArrayList<>();
        if (dates == null || dates.isEmpty()) {
            return values;
        }
        for (final LocalDate date : dates) {
            values.add(date.toString());
        }
        return values;
    }

    private Optional<PlayPetition> editablePetition(final PawAuthUser authUser) {
        if (authUser == null) {
            return Optional.empty();
        }
        return playPetitionService.findLatestEditableByPetitionerUserId(authUser.getUser().getId());
    }

    private Optional<PlayPetition> selectedEditablePetition(final PawAuthUser authUser,
                                                            final String petitionId) {
        if (authUser == null || !hasText(petitionId)) {
            return editablePetition(authUser);
        }

        try {
            final long parsedId = Long.parseLong(petitionId.trim());
            final Optional<PlayPetition> selected = playPetitionService.findById(parsedId);
            if (!selected.isPresent()) {
                return editablePetition(authUser);
            }

            final PlayPetition petition = selected.get();
            final boolean samePetitioner = petition.getPetitionerUserId() != null
                    && petition.getPetitionerUserId() == authUser.getUser().getId();
            if (!samePetitioner || petition.getStatus() != PetitionStatus.CHANGES_REQUESTED) {
                return editablePetition(authUser);
            }
            return selected;
        } catch (final NumberFormatException ignored) {
            return editablePetition(authUser);
        }
    }

    private List<PlayPetition> myPetitions(final PawAuthUser authUser) {
        if (authUser == null) {
            return Collections.emptyList();
        }
        return playPetitionService.findByPetitionerUserId(authUser.getUser().getId());
    }

    private Optional<PlayPetition> resolveCurrentPetition(final PlayPetitionForm form,
                                                          final PawAuthUser authUser) {
        if (authUser == null) {
            return Optional.empty();
        }

        if (hasText(form.getPetitionId())) {
            try {
                final long petitionId = Long.parseLong(form.getPetitionId().trim());
                final Optional<PlayPetition> petition = playPetitionService.findById(petitionId);
                if (petition.isPresent() && petition.get().getPetitionerUserId() != null
                        && petition.get().getPetitionerUserId() == authUser.getUser().getId()) {
                    return petition;
                }
            } catch (final NumberFormatException ignored) {
                return Optional.empty();
            }
        }

        return editablePetition(authUser);
    }

    private Map<String, String> toFieldFeedbackMap(final PlayPetition petition) {
        final Map<String, String> feedback = new LinkedHashMap<>();
        if (petition == null || petition.getFieldFeedback() == null) {
            return feedback;
        }
        for (final PetitionFieldFeedback item : petition.getFieldFeedback()) {
            feedback.put(item.getFieldKey(), item.getComment());
        }
        return feedback;
    }

    private String coverImageUrl(final PlayPetitionForm form) {
        if (!hasText(form.getExistingCoverImageId())) {
            return null;
        }
        return "/petition-images/" + form.getExistingCoverImageId().trim();
    }

    private String friendlyErrorMessage(final String rawMessage) {
        if (rawMessage == null || rawMessage.trim().isEmpty()) {
            return "No pudimos procesar la petición. Revisá los datos e intentá nuevamente.";
        }
        final String normalized = rawMessage.trim().toLowerCase(Locale.ROOT);
        if (normalized.contains("selected source obra") || normalized.contains("selected source production")) {
            return "La obra seleccionada para autocompletar ya no está disponible. Volvé a elegir una sugerencia.";
        }
        if (normalized.contains("missing required petition fields")) {
            return "Completá todos los campos obligatorios antes de enviar la petición.";
        }
        if (normalized.contains("petition is not editable") || normalized.contains("petition was already resolved")) {
            return "La petición ya no está disponible para editar. Recargá la página para ver su estado actual.";
        }
        return rawMessage;
    }

    private String readableUploadLimit() {
        return (MAX_IMAGE_UPLOAD_BYTES / (1024 * 1024)) + " MB";
    }
}
