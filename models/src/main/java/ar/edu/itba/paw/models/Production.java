package ar.edu.itba.paw.models;

import java.io.Serializable;
import java.time.LocalDate;

public class Production implements Serializable {

    private long id;
    private String name;
    private long obraId;
    private Long productoraId;
    private String synopsis;
    private String direction;
    private String theater;
    private LocalDate startDate;
    private LocalDate endDate;
    private String imageUrl;
    private String instagram;
    private String website;

    public Production() {}

    public Production(
            final long id,
            final String name,
            final long obraId,
            final Long productoraId,
            final String synopsis,
            final String direction,
            final String theater,
            final LocalDate startDate,
            final LocalDate endDate,
            final String imageUrl,
            final String instagram,
            final String website) {
        this.id = id;
        this.name = name;
        this.obraId = obraId;
        this.productoraId = productoraId;
        this.synopsis = synopsis;
        this.direction = direction;
        this.theater = theater;
        this.startDate = startDate;
        this.endDate = endDate;
        this.imageUrl = imageUrl;
        this.instagram = instagram;
        this.website = website;
    }

    public long getId() { return id; }
    public String getName() { return name; }
    public long getObraId() { return obraId; }
    public Long getProductoraId() { return productoraId; }
    public String getSynopsis() { return synopsis; }
    public String getDirection() { return direction; }
    public String getTheater() { return theater; }
    public LocalDate getStartDate() { return startDate; }
    public LocalDate getEndDate() { return endDate; }
    public String getImageUrl() { return imageUrl; }
    public String getInstagram() { return instagram; }
    public String getWebsite() { return website; }
}
