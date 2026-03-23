package ar.edu.itba.paw.models;

import java.io.Serializable;

public class Review implements Serializable {

    private long id;
    private long userId;
    private long obraId;
    private String body;
    private long ratingId;

    public Review() {}

    public Review(final long id, final long userId, final long obraId,
                  final String body, final long ratingId) {
        this.id = id;
        this.userId = userId;
        this.obraId = obraId;
        this.body = body;
        this.ratingId = ratingId;
    }

    public long getId() { return id; }
    public long getUserId() { return userId; }
    public long getObraId() { return obraId; }
    public String getBody() { return body; }
    public long getRatingId() { return ratingId; }
}
