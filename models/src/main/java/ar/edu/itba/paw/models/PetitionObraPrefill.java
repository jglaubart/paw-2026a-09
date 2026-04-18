package ar.edu.itba.paw.models;

import java.io.Serializable;
import java.util.List;

public class PetitionObraPrefill implements Serializable {

    private long obraId;
    private Long productionId;
    private String title;
    private String synopsis;
    private List<Long> genreIds;
    private String durationMinutes;
    private String theater;
    private String theaterAddress;
    private String startDate;
    private String endDate;
    private List<String> additionalShowDates;
    private String director;
    private String schedule;
    private String ticketUrl;
    private String language;
    private Long coverImageId;
    private String coverImageUrl;

    public PetitionObraPrefill() {}

    public PetitionObraPrefill(final long obraId, final Long productionId, final String title,
                               final String synopsis, final List<Long> genreIds,
                               final String durationMinutes, final String theater,
                               final String theaterAddress, final String startDate,
                               final String endDate, final List<String> additionalShowDates,
                               final String director, final String schedule,
                               final String ticketUrl, final String language,
                               final Long coverImageId, final String coverImageUrl) {
        this.obraId = obraId;
        this.productionId = productionId;
        this.title = title;
        this.synopsis = synopsis;
        this.genreIds = genreIds;
        this.durationMinutes = durationMinutes;
        this.theater = theater;
        this.theaterAddress = theaterAddress;
        this.startDate = startDate;
        this.endDate = endDate;
        this.additionalShowDates = additionalShowDates;
        this.director = director;
        this.schedule = schedule;
        this.ticketUrl = ticketUrl;
        this.language = language;
        this.coverImageId = coverImageId;
        this.coverImageUrl = coverImageUrl;
    }

    public long getObraId() { return obraId; }
    public Long getProductionId() { return productionId; }
    public String getTitle() { return title; }
    public String getSynopsis() { return synopsis; }
    public List<Long> getGenreIds() { return genreIds; }
    public String getDurationMinutes() { return durationMinutes; }
    public String getTheater() { return theater; }
    public String getTheaterAddress() { return theaterAddress; }
    public String getStartDate() { return startDate; }
    public String getEndDate() { return endDate; }
    public List<String> getAdditionalShowDates() { return additionalShowDates; }
    public String getDirector() { return director; }
    public String getSchedule() { return schedule; }
    public String getTicketUrl() { return ticketUrl; }
    public String getLanguage() { return language; }
    public Long getCoverImageId() { return coverImageId; }
    public String getCoverImageUrl() { return coverImageUrl; }
}
