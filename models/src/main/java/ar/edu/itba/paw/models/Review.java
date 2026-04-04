package ar.edu.itba.paw.models;

import java.io.Serializable;

public class Review implements Serializable {

    private long id;
    private long userId;
    private String userEmail;
    private long productionId;
    private long obraId;
    private String body;
    private Long ratingId;
    private Integer score;

    public Review() {}

    public Review(final long id, final long userId, final String userEmail,
                  final long productionId, final long obraId,
                  final String body, final Long ratingId, final Integer score) {
        this.id = id;
        this.userId = userId;
        this.userEmail = userEmail;
        this.productionId = productionId;
        this.obraId = obraId;
        this.body = body;
        this.ratingId = ratingId;
        this.score = score;
    }

    public long getId() { return id; }
    public long getUserId() { return userId; }
    public String getUserEmail() { return userEmail; }
    public long getProductionId() { return productionId; }
    public long getObraId() { return obraId; }
    public String getBody() { return body; }
    public Long getRatingId() { return ratingId; }
    public Integer getScore() { return score; }
}
