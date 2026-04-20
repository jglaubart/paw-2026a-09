package ar.edu.itba.paw.webapp.form;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

public class ForgotPasswordForm {

    @NotBlank(message = "{auth.forgot.email.required}")
    @Email(message = "{auth.forgot.email.invalid}")
    @Size(max = 255, message = "{auth.register.email.max}")
    private String email;

    public String getEmail() { return email; }
    public void setEmail(final String email) { this.email = email; }
}
