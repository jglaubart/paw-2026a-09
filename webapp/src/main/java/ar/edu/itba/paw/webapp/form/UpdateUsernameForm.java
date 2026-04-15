package ar.edu.itba.paw.webapp.form;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

public class UpdateUsernameForm {

    @NotEmpty(message = "{auth.register.username.required}")
    @Size(min = 1, max = 30, message = "{auth.register.username.size}")
    @Pattern(regexp = "^[a-zA-Z0-9_.-]+$", message = "{auth.register.username.pattern}")
    private String username;

    public UpdateUsernameForm() {}

    public String getUsername() { return username; }
    public void setUsername(final String username) { this.username = username; }
}
