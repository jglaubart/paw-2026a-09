package ar.edu.itba.paw.models;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class PlayPetition implements Serializable {

    private long id;
    private String title;
    private String synopsis;
    private int durationMinutes;
    private String theater;
    private String theaterAddress;
    private LocalDate startDate;
    private LocalDate endDate;
    private Long coverImageId;
    private String director;
    private Long petitionerUserId;
    private String petitionerEmail;
    private String schedule;
    private String ticketUrl;
    private String language;
    private PetitionStatus status;
    private String adminNotes;
    private LocalDateTime createdAt;
    private LocalDateTime resolvedAt;
    private Long sourceObraId;
    private Long sourceProductionId;
    private Long createdObraId;
    private Long createdProductionId;
    private List<LocalDate> additionalShowDates;
    private List<Genre> genres;
    private List<PetitionFieldFeedback> fieldFeedback;

    public PlayPetition() {}

    public PlayPetition(
            final long id,
            final String title,
            final String synopsis,
            final int durationMinutes,
            final String theater,
            final String theaterAddress,
            final LocalDate startDate,
            final LocalDate endDate,
            final Long coverImageId,
            final String director,
            final Long petitionerUserId,
            final String petitionerEmail,
            final String schedule,
            final String ticketUrl,
            final String language,
            final PetitionStatus status,
            final String adminNotes,
            final LocalDateTime createdAt,
            final LocalDateTime resolvedAt,
            final Long sourceObraId,
            final Long sourceProductionId,
            final Long createdObraId,
            final Long createdProductionId,
            final List<LocalDate> additionalShowDates,
            final List<Genre> genres,
            final List<PetitionFieldFeedback> fieldFeedback) {
        this.id = id;
        this.title = title;
        this.synopsis = synopsis;
        this.durationMinutes = durationMinutes;
        this.theater = theater;
        this.theaterAddress = theaterAddress;
        this.startDate = startDate;
        this.endDate = endDate;
        this.coverImageId = coverImageId;
        this.director = director;
        this.petitionerUserId = petitionerUserId;
        this.petitionerEmail = petitionerEmail;
        this.schedule = schedule;
        this.ticketUrl = ticketUrl;
        this.language = language;
        this.status = status;
        this.adminNotes = adminNotes;
        this.createdAt = createdAt;
        this.resolvedAt = resolvedAt;
        this.sourceObraId = sourceObraId;
        this.sourceProductionId = sourceProductionId;
        this.createdObraId = createdObraId;
        this.createdProductionId = createdProductionId;
        this.additionalShowDates = additionalShowDates;
        this.genres = genres;
        this.fieldFeedback = fieldFeedback;
    }

    public long getId() { return id; }
    public String getTitle() { return title; }
    public String getSynopsis() { return synopsis; }
    public int getDurationMinutes() { return durationMinutes; }
    public String getTheater() { return theater; }
    public String getTheaterAddress() { return theaterAddress; }
    public LocalDate getStartDate() { return startDate; }
    public LocalDate getEndDate() { return endDate; }
    public Long getCoverImageId() { return coverImageId; }
    public String getDirector() { return director; }
    public Long getPetitionerUserId() { return petitionerUserId; }
    public String getPetitionerEmail() { return petitionerEmail; }
    public String getSchedule() { return schedule; }
    public String getTicketUrl() { return ticketUrl; }
    public String getLanguage() { return language; }
    public PetitionStatus getStatus() { return status; }
    public String getAdminNotes() { return adminNotes; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public LocalDateTime getResolvedAt() { return resolvedAt; }
    public Long getSourceObraId() { return sourceObraId; }
    public Long getSourceProductionId() { return sourceProductionId; }
    public Long getCreatedObraId() { return createdObraId; }
    public Long getCreatedProductionId() { return createdProductionId; }
    public List<LocalDate> getAdditionalShowDates() { return additionalShowDates; }
    public List<Genre> getGenres() { return genres; }
    public List<PetitionFieldFeedback> getFieldFeedback() { return fieldFeedback; }
}
