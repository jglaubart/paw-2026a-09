package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.services.MailService;
import ar.edu.itba.paw.models.PlayPetition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.thymeleaf.context.Context;
import org.thymeleaf.spring5.SpringTemplateEngine;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.util.Locale;

@Service
public class MailServiceImpl implements MailService {

    private final JavaMailSender mailSender;
    private final SpringTemplateEngine mailTemplateEngine;
    private final MessageSource messageSource;
    private final String publicBaseUrl;
    private final String fromAddress;

    @Autowired
    public MailServiceImpl(final JavaMailSender mailSender,
                           final SpringTemplateEngine mailTemplateEngine,
                           final MessageSource messageSource,
                           @Value("${platea.public.base-url:http://localhost:8080}") final String publicBaseUrl,
                           @Value("${platea.mail.from:platea.noreply@gmail.com}") final String fromAddress) {
        this.mailSender = mailSender;
        this.mailTemplateEngine = mailTemplateEngine;
        this.messageSource = messageSource;
        this.publicBaseUrl = publicBaseUrl;
        this.fromAddress = fromAddress;
    }

    @Async
    @Override
    public void sendPetitionConfirmation(final PlayPetition petition) {
        final Locale locale = resolveLocale();
        final Context context = baseContext(petition, locale);
        sendHtmlMail(
                petition.getPetitionerEmail(),
                messageSource.getMessage("mail.petition.confirmation.subject", new Object[]{ petition.getTitle() }, locale),
                "petition-confirmation",
                context
        );
    }

    @Async
    @Override
    public void sendPetitionApproved(final PlayPetition petition) {
        final Locale locale = resolveLocale();
        final Context context = baseContext(petition, locale);
        final String detailUrl = petition.getCreatedObraId() != null && petition.getCreatedProductionId() != null
                ? publicBaseUrl + "/obras/" + petition.getCreatedObraId() + "?produccionId=" + petition.getCreatedProductionId()
                : publicBaseUrl + "/productions";
        context.setVariable("ctaUrl", detailUrl);
        context.setVariable("ctaLabel", messageSource.getMessage("mail.petition.approved.cta", null, locale));
        sendHtmlMail(
                petition.getPetitionerEmail(),
                messageSource.getMessage("mail.petition.approved.subject", new Object[]{ petition.getTitle() }, locale),
                "petition-approved",
                context
        );
    }

    @Async
    @Override
    public void sendPetitionRejected(final PlayPetition petition) {
        final Locale locale = resolveLocale();
        final Context context = baseContext(petition, locale);
        context.setVariable("ctaUrl", publicBaseUrl + "/subir-obra");
        context.setVariable("ctaLabel", messageSource.getMessage("mail.petition.rejected.cta", null, locale));
        sendHtmlMail(
                petition.getPetitionerEmail(),
                messageSource.getMessage("mail.petition.rejected.subject", new Object[]{ petition.getTitle() }, locale),
                "petition-rejected",
                context
        );
    }

    @Async
    @Override
    public void sendSharedProduction(final String recipientEmail, final String senderName,
                                     final String obraTitle, final String productionName,
                                     final String synopsis, final String detailUrl) {
        final Locale locale = resolveLocale();
        final Context context = new Context(locale);
        context.setVariable("senderName", senderName);
        context.setVariable("obraTitle", obraTitle);
        context.setVariable("productionName", productionName);
        context.setVariable("synopsis", synopsis);
        context.setVariable("ctaUrl", detailUrl.startsWith("http") ? detailUrl : publicBaseUrl + detailUrl);
        context.setVariable("ctaLabel", messageSource.getMessage("mail.share.cta", null, locale));
        sendHtmlMail(
                recipientEmail,
                messageSource.getMessage("mail.share.subject", new Object[]{ senderName, obraTitle }, locale),
                "share-production",
                context
        );
    }

    private Locale resolveLocale() {
        return new Locale("es");
    }

    private Context baseContext(final PlayPetition petition, final Locale locale) {
        final Context context = new Context(locale);
        context.setVariable("petition", petition);
        context.setVariable("title", petition.getTitle());
        context.setVariable("petitionId", petition.getId());
        context.setVariable("status", petition.getStatus());
        context.setVariable("adminNotes", petition.getAdminNotes());
        context.setVariable("publicBaseUrl", publicBaseUrl);
        return context;
    }

    private void sendHtmlMail(final String to, final String subject, final String templateName, final Context context) {
        final String html = mailTemplateEngine.process(templateName, context);
        final MimeMessage message = mailSender.createMimeMessage();
        try {
            final MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");
            helper.setTo(to);
            helper.setFrom(fromAddress);
            helper.setSubject(subject);
            helper.setText(html, true);
            mailSender.send(message);
        } catch (final MessagingException | RuntimeException e) {
            System.err.println("[Platea] Could not send petition email to " + to + ": " + e.getMessage());
            throw new IllegalStateException("Could not send petition email", e);
        }
    }
}