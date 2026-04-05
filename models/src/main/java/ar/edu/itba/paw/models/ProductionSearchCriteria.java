package ar.edu.itba.paw.models;

import java.time.LocalDate;

public class ProductionSearchCriteria {

    private final String query;
    private final String genre;
    private final String theater;
    private final String location;
    private final LocalDate date;
    private final boolean availableOnly;

    public ProductionSearchCriteria(final String query,
                                    final String genre,
                                    final String theater,
                                    final String location,
                                    final LocalDate date,
                                    final boolean availableOnly) {
        this.query = query;
        this.genre = genre;
        this.theater = theater;
        this.location = location;
        this.date = date;
        this.availableOnly = availableOnly;
    }

    public String getQuery() {
        return query;
    }

    public String getGenre() {
        return genre;
    }

    public String getTheater() {
        return theater;
    }

    public String getLocation() {
        return location;
    }

    public LocalDate getDate() {
        return date;
    }

    public boolean isAvailableOnly() {
        return availableOnly;
    }
}
