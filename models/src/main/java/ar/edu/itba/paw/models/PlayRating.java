package ar.edu.itba.paw.models;

import java.io.Serializable;

public class PlayRating implements Serializable {

    private long id;
    private long userId;
    private long obraId;
    private int score;

    public PlayRating() {}

    public PlayRating(final long id, final long userId, final long obraId, final int score) {
        this.id = id;
        this.userId = userId;
        this.obraId = obraId;
        this.score = score;
    }

    public long getId() { return id; }
    public long getUserId() { return userId; }
    public long getObraId() { return obraId; }
    public int getScore() { return score; }
}
