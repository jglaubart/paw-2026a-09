package ar.edu.itba.paw.models;

import java.io.Serializable;

public class Genre implements Serializable {

    private long id;
    private String name;

    public Genre() {}

    public Genre(final long id, final String name) {
        this.id = id;
        this.name = name;
    }

    public long getId() { return id; }
    public String getName() { return name; }
}
