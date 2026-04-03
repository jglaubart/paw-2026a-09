package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.PlayPetition;

public interface MailService {
    void sendPetitionConfirmation(PlayPetition petition);
    void sendPetitionApproved(PlayPetition petition);
    void sendPetitionRejected(PlayPetition petition);
}
