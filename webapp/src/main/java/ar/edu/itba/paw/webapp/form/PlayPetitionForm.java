package ar.edu.itba.paw.webapp.form;

import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;

public class PlayPetitionForm {

    private String petitionId;
    private String sourceObraId;
    private String sourceProductionId;
    private String existingCoverImageId;
    private String title;
    private String synopsis;
    private String durationMinutes;
    private List<String> genreIds = new ArrayList<>();
    private String theater;
    private String theaterAddress;
    private String startDate;
    private String endDate;
    private List<String> additionalShowDates = new ArrayList<>();
    private MultipartFile coverImage;
    private String director;
    private String petitionerEmail;
    private String schedule;
    private String ticketUrl;
    private String language;

    public String getPetitionId() { return petitionId; }
    public void setPetitionId(final String petitionId) { this.petitionId = petitionId; }
    public String getSourceObraId() { return sourceObraId; }
    public void setSourceObraId(final String sourceObraId) { this.sourceObraId = sourceObraId; }
    public String getSourceProductionId() { return sourceProductionId; }
    public void setSourceProductionId(final String sourceProductionId) { this.sourceProductionId = sourceProductionId; }
    public String getExistingCoverImageId() { return existingCoverImageId; }
    public void setExistingCoverImageId(final String existingCoverImageId) { this.existingCoverImageId = existingCoverImageId; }
    public String getTitle() { return title; }
    public void setTitle(final String title) { this.title = title; }
    public String getSynopsis() { return synopsis; }
    public void setSynopsis(final String synopsis) { this.synopsis = synopsis; }
    public String getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(final String durationMinutes) { this.durationMinutes = durationMinutes; }
    public List<String> getGenreIds() { return genreIds; }
    public void setGenreIds(final List<String> genreIds) { this.genreIds = genreIds; }
    public String getTheater() { return theater; }
    public void setTheater(final String theater) { this.theater = theater; }
    public String getTheaterAddress() { return theaterAddress; }
    public void setTheaterAddress(final String theaterAddress) { this.theaterAddress = theaterAddress; }
    public String getStartDate() { return startDate; }
    public void setStartDate(final String startDate) { this.startDate = startDate; }
    public String getEndDate() { return endDate; }
    public void setEndDate(final String endDate) { this.endDate = endDate; }
    public List<String> getAdditionalShowDates() { return additionalShowDates; }
    public void setAdditionalShowDates(final List<String> additionalShowDates) { this.additionalShowDates = additionalShowDates; }
    public MultipartFile getCoverImage() { return coverImage; }
    public void setCoverImage(final MultipartFile coverImage) { this.coverImage = coverImage; }
    public String getDirector() { return director; }
    public void setDirector(final String director) { this.director = director; }
    public String getPetitionerEmail() { return petitionerEmail; }
    public void setPetitionerEmail(final String petitionerEmail) { this.petitionerEmail = petitionerEmail; }
    public String getSchedule() { return schedule; }
    public void setSchedule(final String schedule) { this.schedule = schedule; }
    public String getTicketUrl() { return ticketUrl; }
    public void setTicketUrl(final String ticketUrl) { this.ticketUrl = ticketUrl; }
    public String getLanguage() { return language; }
    public void setLanguage(final String language) { this.language = language; }
}
