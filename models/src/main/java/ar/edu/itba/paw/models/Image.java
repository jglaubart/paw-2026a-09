package ar.edu.itba.paw.models;

import java.io.Serializable;

public class Image implements Serializable {

    private long id;
    private byte[] content;

    public Image() {}

    public Image(final long id, final byte[] content) {
        this.id = id;
        this.content = content;
    }

    public long getId() { return id; }
    public byte[] getContent() { return content; }
}
