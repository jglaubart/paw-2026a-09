package ar.edu.itba.paw.models;

import java.io.Serializable;

public class Review implements Serializable {

    private long id;
    private long userId;
    private long productionId;
    private String body;
    private long ratingId;

    public Review() {}

    public Review(final long id, final long userId, final long productionId,
                  final String body, final long ratingId) {
        this.id = id;
        this.userId = userId;
        this.productionId = productionId;
        this.body = body;
        this.ratingId = ratingId;
    }

    public long getId() { return id; }
    public long getUserId() { return userId; }
    public long getProductionId() { return productionId; }
    public String getBody() { return body; }
    public long getRatingId() { return ratingId; }
}
