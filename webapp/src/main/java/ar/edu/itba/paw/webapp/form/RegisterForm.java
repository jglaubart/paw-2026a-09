package ar.edu.itba.paw.webapp.form;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

public class RegisterForm {

    @NotBlank(message = "{auth.register.email.required}")
    @Email(message = "{auth.register.email.invalid}")
    @Size(max = 255, message = "{auth.register.email.max}")
    private String email;

    @NotBlank(message = "{auth.register.password.required}")
    @Size(min = 8, max = 72, message = "{auth.register.password.size}")
    private String password;

    @NotBlank(message = "{auth.register.repeatPassword.required}")
    private String repeatPassword;

    public String getEmail() {
        return email;
    }

    public void setEmail(final String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(final String password) {
        this.password = password;
    }

    public String getRepeatPassword() {
        return repeatPassword;
    }

    public void setRepeatPassword(final String repeatPassword) {
        this.repeatPassword = repeatPassword;
    }

    public boolean passwordsMatch() {
        return password != null && password.equals(repeatPassword);
    }
}
