package ar.edu.itba.paw.models;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Productora implements Serializable {

    private long id;
    private String name;
    private String bio;
    private String imageUrl;
    private String instagram;
    private String website;

    private String cuit;
    private String contactEmail;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime approvedAt;

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

    public Productora(final long id, final String name, final String bio,
                      final String imageUrl, final String instagram, final String website,
                      final String cuit, final String contactEmail, final String status,
                      final LocalDateTime createdAt, final LocalDateTime approvedAt) {
        this(id, name, bio, imageUrl, instagram, website);
        this.cuit = cuit;
        this.contactEmail = contactEmail;
        this.status = status;
        this.createdAt = createdAt;
        this.approvedAt = approvedAt;
    }

    public long getId() { return id; }
    public String getName() { return name; }
    public String getBio() { return bio; }
    public String getImageUrl() { return imageUrl; }
    public String getInstagram() { return instagram; }
    public String getWebsite() { return website; }
    public String getCuit() { return cuit; }
    public String getContactEmail() { return contactEmail; }
    public String getStatus() { return status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public LocalDateTime getApprovedAt() { return approvedAt; }

    public boolean isApproved() { return "APPROVED".equals(status); }
}
