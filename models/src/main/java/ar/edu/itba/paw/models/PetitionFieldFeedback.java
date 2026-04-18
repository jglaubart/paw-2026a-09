package ar.edu.itba.paw.models;

import java.io.Serializable;

public class PetitionFieldFeedback implements Serializable {

    private long petitionId;
    private String fieldKey;
    private String comment;

    public PetitionFieldFeedback() {}

    public PetitionFieldFeedback(final long petitionId, final String fieldKey, final String comment) {
        this.petitionId = petitionId;
        this.fieldKey = fieldKey;
        this.comment = comment;
    }

    public long getPetitionId() { return petitionId; }
    public String getFieldKey() { return fieldKey; }
    public String getComment() { return comment; }
}
