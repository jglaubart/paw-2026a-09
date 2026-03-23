package ar.edu.itba.paw.models;

import java.io.Serializable;

public class Obra implements Serializable {

    private long id;
    private String title;
    private String synopsis;
    private String genre;

    public Obra() {}

    public Obra(final long id, final String title, final String synopsis, final String genre) {
        this.id = id;
        this.title = title;
        this.synopsis = synopsis;
        this.genre = genre;
    }

    public long getId() { return id; }
    public String getTitle() { return title; }
    public String getSynopsis() { return synopsis; }
    public String getGenre() { return genre; }
}
