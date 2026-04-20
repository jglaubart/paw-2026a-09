package ar.edu.itba.paw.webapp.form;

import javax.validation.constraints.Email;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

public class ProductoraRequestForm {

    @NotBlank(message = "{productora.name.notblank}")
    @Size(min = 2, max = 120, message = "{productora.name.size}")
    private String name;

    @NotBlank(message = "{productora.cuit.notblank}")
    @Pattern(regexp = "\\d{2}-?\\d{8}-?\\d", message = "{productora.cuit.format}")
    private String cuit;

    @NotBlank(message = "{productora.contactEmail.notblank}")
    @Email
    @Size(max = 255)
    private String contactEmail;

    @Size(max = 1500, message = "{productora.bio.size}")
    private String bio;

    @Size(max = 255)
    private String instagram;

    @Size(max = 255)
    private String website;

    private Long coverImageId;

    @Size(max = 1500)
    private String teamDescription;

    @Min(value = 1, message = "{productora.teamSize.min}")
    private Integer teamSize;

    @NotBlank(message = "{productora.previousWorks.notblank}")
    @Size(max = 2500)
    private String previousWorks;

    private Long supportingDocId;

    public String getName() { return name; }
    public void setName(final String name) { this.name = name; }

    public String getCuit() { return cuit; }
    public void setCuit(final String cuit) { this.cuit = cuit; }

    public String getContactEmail() { return contactEmail; }
    public void setContactEmail(final String contactEmail) { this.contactEmail = contactEmail; }

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
}
