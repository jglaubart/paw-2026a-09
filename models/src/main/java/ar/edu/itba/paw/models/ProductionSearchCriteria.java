package ar.edu.itba.paw.models;

import java.time.LocalDate;

public class ProductionSearchCriteria {

    private final String query;
    private final String genre;
    private final String theater;
    private final LocalDate dateFrom;
    private final LocalDate dateTo;
    private final boolean availableOnly;

    public ProductionSearchCriteria(final String query,
                                    final String genre,
                                    final String theater,
                                    final LocalDate dateFrom,
                                    final LocalDate dateTo,
                                    final boolean availableOnly) {
        this.query = query;
        this.genre = genre;
        this.theater = theater;
        this.dateFrom = dateFrom;
        this.dateTo = dateTo;
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

    public LocalDate getDateFrom() {
        return dateFrom;
    }

    public LocalDate getDateTo() {
        return dateTo;
    }

    public boolean isAvailableOnly() {
        return availableOnly;
    }
}
