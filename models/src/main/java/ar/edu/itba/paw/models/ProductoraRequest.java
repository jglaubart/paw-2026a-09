package ar.edu.itba.paw.models;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Map;

public class ProductoraRequest implements Serializable {

    private long id;

    private long userId;
    private String contactEmail;

    private String name;
    private String cuit;
    private String bio;
    private String instagram;
    private String website;
    private Long coverImageId;

    private String teamDescription;
    private Integer teamSize;

    private String previousWorks;
    private Long supportingDocId;

    private ProductoraRequestStatus status;
    private String adminNotes;
    private LocalDateTime createdAt;
    private LocalDateTime resolvedAt;
    private Long createdProductoraId;

    private Map<String, String> fieldFeedback = Collections.emptyMap();

    public ProductoraRequest() {}

    public long getId() { return id; }
    public void setId(final long id) { this.id = id; }

    public long getUserId() { return userId; }
    public void setUserId(final long userId) { this.userId = userId; }

    public String getContactEmail() { return contactEmail; }
    public void setContactEmail(final String contactEmail) { this.contactEmail = contactEmail; }

    public String getName() { return name; }
    public void setName(final String name) { this.name = name; }

    public String getCuit() { return cuit; }
    public void setCuit(final String cuit) { this.cuit = cuit; }

    public String getBio() { return bio; }
    public void setBio(final String bio) { this.bio = bio; }

    public String getInstagram() { return instagram; }
    public void setInstagram(final String instagram) { this.instagram = instagram; }

    public String getWebsite() { return website; }
    public void setWebsite(final String website) { this.website = website; }

    public Long getCoverImageId() { return coverImageId; }
    public void setCoverImageId(final Long coverImageId) { this.coverImageId = coverImageId; }

    public String getTeamDescription() { return teamDescription; }
    public void setTeamDescription(final String teamDescription) { this.teamDescription = teamDescription; }

    public Integer getTeamSize() { return teamSize; }
    public void setTeamSize(final Integer teamSize) { this.teamSize = teamSize; }

    public String getPreviousWorks() { return previousWorks; }
    public void setPreviousWorks(final String previousWorks) { this.previousWorks = previousWorks; }

    public Long getSupportingDocId() { return supportingDocId; }
    public void setSupportingDocId(final Long supportingDocId) { this.supportingDocId = supportingDocId; }

    public ProductoraRequestStatus getStatus() { return status; }
    public void setStatus(final ProductoraRequestStatus status) { this.status = status; }

    public String getAdminNotes() { return adminNotes; }
    public void setAdminNotes(final String adminNotes) { this.adminNotes = adminNotes; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(final LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(final LocalDateTime resolvedAt) { this.resolvedAt = resolvedAt; }

    public Long getCreatedProductoraId() { return createdProductoraId; }
    public void setCreatedProductoraId(final Long createdProductoraId) { this.createdProductoraId = createdProductoraId; }

    public Map<String, String> getFieldFeedback() { return fieldFeedback; }
    public void setFieldFeedback(final Map<String, String> fieldFeedback) {
        this.fieldFeedback = fieldFeedback == null ? Collections.emptyMap() : fieldFeedback;
    }
}
