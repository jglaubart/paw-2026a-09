package ar.edu.itba.paw.models;

import java.io.Serializable;

public class Productora implements Serializable {

    private long id;
    private String name;
    private String bio;
    private String imageUrl;
    private String instagram;
    private String website;

    public Productora() {}

    public Productora(final long id, final String name, final String bio,
                      final String imageUrl, final String instagram, final String website) {
        this.id = id;
        this.name = name;
        this.bio = bio;
        this.imageUrl = imageUrl;
        this.instagram = instagram;
        this.website = website;
    }

    public long getId() { return id; }
    public String getName() { return name; }
    public String getBio() { return bio; }
    public String getImageUrl() { return imageUrl; }
    public String getInstagram() { return instagram; }
    public String getWebsite() { return website; }
}
