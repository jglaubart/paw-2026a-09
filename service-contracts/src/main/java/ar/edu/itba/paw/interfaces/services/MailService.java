package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.PlayPetition;
import ar.edu.itba.paw.models.ProductoraRequest;

public interface MailService {
    void sendPetitionConfirmation(PlayPetition petition);
    void sendPetitionApproved(PlayPetition petition);
    void sendPetitionChangesRequested(PlayPetition petition);
    void sendSharedProduction(String recipientEmail, String senderName, String obraTitle,
                              String productionName, String synopsis, String detailUrl);
    void sendVerificationCode(String recipientEmail, String username, String code);
    void sendPasswordResetLink(String recipientEmail, String username, String resetUrl);

    void sendProductoraRequestConfirmation(ProductoraRequest request, String recipientEmail, String username);
    void sendProductoraRequestApproved(ProductoraRequest request, String recipientEmail, String username);
    void sendProductoraRequestRejected(ProductoraRequest request, String recipientEmail, String username);
    void sendProductoraRequestChangesRequested(ProductoraRequest request, String recipientEmail, String username);
}
