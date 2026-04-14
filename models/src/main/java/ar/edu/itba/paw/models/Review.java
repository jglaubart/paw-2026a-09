package ar.edu.itba.paw.models;

import java.io.Serializable;

public class Review implements Serializable {

    private long id;
    private long userId;
    private String username;
    private long productionId;
    private long obraId;
    private String obraTitle;
    private Long productionImageId;
    private String body;
    private Long ratingId;
    private Integer score;

    public Review() {}

    public Review(final long id, final long userId, final String username,
                  final long productionId, final long obraId, final String obraTitle,
                  final Long productionImageId, final String body,
                  final Long ratingId, final Integer score) {
        this.id = id;
        this.userId = userId;
        this.username = username;
        this.productionId = productionId;
        this.obraId = obraId;
        this.obraTitle = obraTitle;
        this.productionImageId = productionImageId;
        this.body = body;
        this.ratingId = ratingId;
        this.score = score;
    }

    public long getId() { return id; }
    public long getUserId() { return userId; }
    public String getUsername() { return username; }
    public long getProductionId() { return productionId; }
    public long getObraId() { return obraId; }
    public String getObraTitle() { return obraTitle; }
    public Long getProductionImageId() { return productionImageId; }
    public String getBody() { return body; }
    public Long getRatingId() { return ratingId; }
    public Integer getScore() { return score; }
}
