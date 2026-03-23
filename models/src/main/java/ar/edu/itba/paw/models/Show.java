package ar.edu.itba.paw.models;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalTime;

public class Show implements Serializable {

    private long id;
    private long productionId;
    private LocalDate showDate;
    private LocalTime showTime;
    private String theater;

    public Show() {}

    public Show(final long id, final long productionId, final LocalDate showDate,
                final LocalTime showTime, final String theater) {
        this.id = id;
        this.productionId = productionId;
        this.showDate = showDate;
        this.showTime = showTime;
        this.theater = theater;
    }

    public long getId() { return id; }
    public long getProductionId() { return productionId; }
    public LocalDate getShowDate() { return showDate; }
    public LocalTime getShowTime() { return showTime; }
    public String getTheater() { return theater; }
}
