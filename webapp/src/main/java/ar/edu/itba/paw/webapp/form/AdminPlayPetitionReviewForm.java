package ar.edu.itba.paw.webapp.form;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class AdminPlayPetitionReviewForm {

    private String adminNotes;
    private List<String> issueFields = new ArrayList<>();
    private Map<String, String> fieldComments = new LinkedHashMap<>();

    public String getAdminNotes() { return adminNotes; }
    public void setAdminNotes(final String adminNotes) { this.adminNotes = adminNotes; }
    public List<String> getIssueFields() { return issueFields; }
    public void setIssueFields(final List<String> issueFields) { this.issueFields = issueFields; }
    public Map<String, String> getFieldComments() { return fieldComments; }
    public void setFieldComments(final Map<String, String> fieldComments) { this.fieldComments = fieldComments; }
}
