package ar.edu.itba.paw.models;

import java.io.Serializable;

public class ProductionCardSummary implements Serializable {

    private final long obraId;
    private final long representativeProductionId;
    private final String title;
    private final String imageUrl;
    private final String theaterSummary;

    public ProductionCardSummary(final long obraId,
                                 final long representativeProductionId,
                                 final String title,
                                 final String imageUrl,
                                 final String theaterSummary) {
        this.obraId = obraId;
        this.representativeProductionId = representativeProductionId;
        this.title = title;
        this.imageUrl = imageUrl;
        this.theaterSummary = theaterSummary;
    }

    public long getObraId() {
        return obraId;
    }

    public long getRepresentativeProductionId() {
        return representativeProductionId;
    }

    public String getTitle() {
        return title;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public String getTheaterSummary() {
        return theaterSummary;
    }
}
