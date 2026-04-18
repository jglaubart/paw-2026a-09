package ar.edu.itba.paw.models;

import java.io.Serializable;

public class PetitionObraSuggestion implements Serializable {

    private long obraId;
    private Long productionId;
    private String title;
    private String theater;
    private String imageUrl;

    public PetitionObraSuggestion() {}

    public PetitionObraSuggestion(final long obraId, final Long productionId, final String title,
                                  final String theater, final String imageUrl) {
        this.obraId = obraId;
        this.productionId = productionId;
        this.title = title;
        this.theater = theater;
        this.imageUrl = imageUrl;
    }

    public long getObraId() { return obraId; }
    public Long getProductionId() { return productionId; }
    public String getTitle() { return title; }
    public String getTheater() { return theater; }
    public String getImageUrl() { return imageUrl; }
}
