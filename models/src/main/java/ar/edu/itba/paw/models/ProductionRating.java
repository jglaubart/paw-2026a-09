package ar.edu.itba.paw.models;

import java.io.Serializable;

public class ProductionRating implements Serializable {

    private long id;
    private long userId;
    private long productionId;
    private int score;

    public ProductionRating() {}

    public ProductionRating(final long id, final long userId, final long productionId, final int score) {
        this.id = id;
        this.userId = userId;
        this.productionId = productionId;
        this.score = score;
    }

    public long getId() { return id; }
    public long getUserId() { return userId; }
    public long getProductionId() { return productionId; }
    public int getScore() { return score; }
}
