package ar.edu.itba.paw.models;

import java.io.Serializable;

public class Image implements Serializable {

    private long id;
    private String contentType;
    private byte[] content;

    public Image() {}

    public Image(final long id, final String contentType, final byte[] content) {
        this.id = id;
        this.contentType = contentType;
        this.content = content;
    }

    public long getId() { return id; }
    public String getContentType() { return contentType; }
    public byte[] getContent() { return content; }
}
