package ar.edu.itba.paw.webapp.form;

import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

public class UpdatePersonalDataForm {

    @Size(min = 1, max = 30, message = "{profile.username.size}")
    @Pattern(regexp = "^[a-zA-Z0-9_.-]+$", message = "{auth.register.username.pattern}")
    private String username;

    @Size(max = 300, message = "{profile.bio.size}")
    private String bio;

    public UpdatePersonalDataForm() {}

    public String getUsername() { return username; }
    public void setUsername(final String username) { this.username = username; }

    public String getBio() { return bio; }
    public void setBio(final String bio) { this.bio = bio; }
}
