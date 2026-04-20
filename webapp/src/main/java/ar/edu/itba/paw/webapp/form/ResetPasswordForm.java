package ar.edu.itba.paw.webapp.form;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

public class ResetPasswordForm {

    @NotBlank
    private String token;

    @NotBlank(message = "{auth.reset.password.required}")
    @Size(min = 8, max = 72, message = "{auth.reset.password.size}")
    private String password;

    @NotBlank(message = "{auth.reset.repeatPassword.required}")
    private String repeatPassword;

    public String getToken() { return token; }
    public void setToken(final String token) { this.token = token; }

    public String getPassword() { return password; }
    public void setPassword(final String password) { this.password = password; }

    public String getRepeatPassword() { return repeatPassword; }
    public void setRepeatPassword(final String repeatPassword) { this.repeatPassword = repeatPassword; }

    public boolean passwordsMatch() {
        return password != null && password.equals(repeatPassword);
    }
}
