package ar.edu.itba.paw.webapp.form;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

public class VerifyEmailForm {

    @NotBlank(message = "{auth.verify.codeRequired}")
    @Size(min = 4, max = 4, message = "{auth.verify.codeSize}")
    @Pattern(regexp = "^\\d{4}$", message = "{auth.verify.codePattern}")
    private String code;

    public String getCode() { return code; }
    public void setCode(final String code) { this.code = code; }
}
