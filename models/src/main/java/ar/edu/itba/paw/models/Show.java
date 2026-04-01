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
    private String address;
    private String barrio;
    private String ciudadPartido;
    private String provincia;

    public Show() {}

    public Show(final long id, final long productionId, final LocalDate showDate,
                final LocalTime showTime, final String theater) {
        this(id, productionId, showDate, showTime, theater, null, null, null, null);
    }

    public Show(final long id, final long productionId, final LocalDate showDate,
                final LocalTime showTime, final String theater, final String address,
                final String barrio, final String ciudadPartido, final String provincia) {
        this.id = id;
        this.productionId = productionId;
        this.showDate = showDate;
        this.showTime = showTime;
        this.theater = theater;
        this.address = address;
        this.barrio = barrio;
        this.ciudadPartido = ciudadPartido;
        this.provincia = provincia;
    }

    public long getId() { return id; }
    public long getProductionId() { return productionId; }
    public LocalDate getShowDate() { return showDate; }
    public LocalTime getShowTime() { return showTime; }
    public String getTheater() { return theater; }
    public String getAddress() { return address; }
    public String getBarrio() { return barrio; }
    public String getCiudadPartido() { return ciudadPartido; }
    public String getProvincia() { return provincia; }
}
