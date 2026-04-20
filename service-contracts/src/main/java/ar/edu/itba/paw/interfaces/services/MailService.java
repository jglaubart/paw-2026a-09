package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.PlayPetition;

public interface MailService {
    void sendPetitionConfirmation(PlayPetition petition);
    void sendPetitionApproved(PlayPetition petition);
    void sendPetitionChangesRequested(PlayPetition petition);
    void sendSharedProduction(String recipientEmail, String senderName, String obraTitle,
                              String productionName, String synopsis, String detailUrl);
    void sendVerificationCode(String recipientEmail, String username, String code);
}
