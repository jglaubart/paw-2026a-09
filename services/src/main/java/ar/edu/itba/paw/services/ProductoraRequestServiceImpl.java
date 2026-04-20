package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.ProductoraDao;
import ar.edu.itba.paw.interfaces.persistence.ProductoraMemberDao;
import ar.edu.itba.paw.interfaces.persistence.ProductoraRequestDao;
import ar.edu.itba.paw.interfaces.persistence.UserDao;
import ar.edu.itba.paw.interfaces.services.MailService;
import ar.edu.itba.paw.interfaces.services.ProductoraRequestService;
import ar.edu.itba.paw.interfaces.services.exception.ProductoraRequestAlreadyActiveException;
import ar.edu.itba.paw.models.User;
import ar.edu.itba.paw.models.Productora;
import ar.edu.itba.paw.models.ProductoraMemberRole;
import ar.edu.itba.paw.models.ProductoraRequest;
import ar.edu.itba.paw.models.ProductoraRequestStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ProductoraRequestServiceImpl implements ProductoraRequestService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ProductoraRequestServiceImpl.class);

    private final ProductoraRequestDao requestDao;
    private final ProductoraDao productoraDao;
    private final ProductoraMemberDao memberDao;
    private final UserDao userDao;
    private final MailService mailService;

    @Autowired
    public ProductoraRequestServiceImpl(final ProductoraRequestDao requestDao,
                                        final ProductoraDao productoraDao,
                                        final ProductoraMemberDao memberDao,
                                        final UserDao userDao,
                                        final MailService mailService) {
        this.requestDao = requestDao;
        this.productoraDao = productoraDao;
        this.memberDao = memberDao;
        this.userDao = userDao;
        this.mailService = mailService;
    }

    @Override
    public ProductoraRequest submit(final long userId, final String contactEmail, final String phone,
                                    final String name, final String cuit, final String bio,
                                    final String instagram, final String website, final Long coverImageId,
                                    final String teamDescription, final Integer teamSize,
                                    final String previousWorks, final Long supportingDocId) {
        if (requestDao.findActiveByUser(userId).isPresent()) {
            throw new ProductoraRequestAlreadyActiveException(userId);
        }
        final ProductoraRequest r = fillRequest(new ProductoraRequest(), userId, contactEmail, phone, name, cuit, bio,
                instagram, website, coverImageId, teamDescription, teamSize, previousWorks, supportingDocId);
        r.setCreatedAt(LocalDateTime.now());
        final ProductoraRequest saved = requestDao.create(r);
        LOGGER.info("ProductoraRequest {} submitted by user {}", saved.getId(), userId);
        sendConfirmationMail(saved, userId);
        return saved;
    }

    @Override
    public ProductoraRequest resubmit(final long requestId, final long userId, final String contactEmail, final String phone,
                                      final String name, final String cuit, final String bio,
                                      final String instagram, final String website, final Long coverImageId,
                                      final String teamDescription, final Integer teamSize,
                                      final String previousWorks, final Long supportingDocId) {
        final ProductoraRequest existing = requestDao.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException("Request not found: " + requestId));
        if (existing.getUserId() != userId) {
            throw new IllegalStateException("User mismatch on request resubmit");
        }
        if (!existing.getStatus().isEditable()) {
            throw new IllegalStateException("Request not editable in status " + existing.getStatus());
        }
        fillRequest(existing, userId, contactEmail, phone, name, cuit, bio, instagram, website, coverImageId,
                teamDescription, teamSize, previousWorks, supportingDocId);
        requestDao.updateContent(existing);
        requestDao.clearFieldFeedback(requestId);
        existing.setStatus(ProductoraRequestStatus.PENDING);
        LOGGER.info("ProductoraRequest {} resubmitted by user {}", requestId, userId);
        sendConfirmationMail(existing, userId);
        return existing;
    }

    @Override
    public Optional<ProductoraRequest> findActiveForUser(final long userId) {
        return requestDao.findActiveByUser(userId)
                .map(this::attachFeedback);
    }

    @Override
    public List<ProductoraRequest> findHistoryForUser(final long userId) {
        return requestDao.findByUser(userId);
    }

    @Override
    public Optional<ProductoraRequest> findById(final long id) {
        return requestDao.findById(id).map(this::attachFeedback);
    }

    @Override
    public List<ProductoraRequest> findForAdmin(final ProductoraRequestStatus filter) {
        return requestDao.findForAdmin(filter);
    }

    @Override
    public Map<ProductoraRequestStatus, Integer> countByStatus() {
        return requestDao.countByStatus();
    }

    @Override
    public Productora approve(final long requestId, final String adminNotes) {
        final ProductoraRequest req = requestDao.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException("Request not found: " + requestId));
        if (req.getStatus() == ProductoraRequestStatus.APPROVED) {
            return productoraDao.findById(req.getCreatedProductoraId() != null ? req.getCreatedProductoraId() : -1L)
                    .orElseThrow(() -> new IllegalStateException("Already approved but no productora"));
        }
        final Productora created = productoraDao.createApproved(
                req.getName(), req.getBio(), req.getCoverImageId(),
                req.getInstagram(), req.getWebsite(),
                req.getCuit(), req.getContactEmail()
        );
        memberDao.add(req.getUserId(), created.getId(), ProductoraMemberRole.OWNER);
        requestDao.updateStatus(requestId, ProductoraRequestStatus.APPROVED, adminNotes, created.getId());
        requestDao.clearFieldFeedback(requestId);
        LOGGER.info("ProductoraRequest {} approved: productora={} owner={}", requestId, created.getId(), req.getUserId());
        req.setAdminNotes(adminNotes);
        req.setCreatedProductoraId(created.getId());
        sendMailToUser(req.getUserId(), (email, username) ->
                mailService.sendProductoraRequestApproved(req, email, username));
        return created;
    }

    @Override
    public void reject(final long requestId, final String adminNotes) {
        final ProductoraRequest req = requestDao.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException("Request not found: " + requestId));
        requestDao.updateStatus(requestId, ProductoraRequestStatus.REJECTED, adminNotes, null);
        requestDao.clearFieldFeedback(requestId);
        LOGGER.info("ProductoraRequest {} rejected", requestId);
        req.setAdminNotes(adminNotes);
        sendMailToUser(req.getUserId(), (email, username) ->
                mailService.sendProductoraRequestRejected(req, email, username));
    }

    @Override
    public void requestChanges(final long requestId, final String adminNotes,
                               final Map<String, String> fieldFeedback) {
        final ProductoraRequest req = requestDao.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException("Request not found: " + requestId));
        requestDao.updateStatus(requestId, ProductoraRequestStatus.CHANGES_REQUESTED, adminNotes, null);
        requestDao.replaceFieldFeedback(requestId, fieldFeedback);
        LOGGER.info("ProductoraRequest {} changes requested", requestId);
        req.setAdminNotes(adminNotes);
        sendMailToUser(req.getUserId(), (email, username) ->
                mailService.sendProductoraRequestChangesRequested(req, email, username));
    }

    @FunctionalInterface
    private interface MailAction {
        void send(String email, String username);
    }

    private void sendMailToUser(final long userId, final MailAction action) {
        userDao.findById(userId).ifPresent(user -> {
            try {
                final String displayName = user.getUsername() != null && !user.getUsername().trim().isEmpty()
                        ? user.getUsername() : user.getEmail();
                action.send(user.getEmail(), displayName);
            } catch (final RuntimeException e) {
                LOGGER.error("Failed to send productora mail to user {}: {}", userId, e.getMessage());
            }
        });
    }

    private void sendConfirmationMail(final ProductoraRequest request, final long userId) {
        sendMailToUser(userId, (email, username) ->
                mailService.sendProductoraRequestConfirmation(request, email, username));
    }

    private ProductoraRequest attachFeedback(final ProductoraRequest r) {
        if (r != null) {
            r.setFieldFeedback(requestDao.findFieldFeedback(r.getId()));
        }
        return r;
    }

    private ProductoraRequest fillRequest(final ProductoraRequest r, final long userId, final String contactEmail, final String phone,
                                          final String name, final String cuit, final String bio,
                                          final String instagram, final String website, final Long coverImageId,
                                          final String teamDescription, final Integer teamSize,
                                          final String previousWorks, final Long supportingDocId) {
        r.setUserId(userId);
        r.setContactEmail(contactEmail);
        r.setPhone(phone);
        r.setName(name);
        r.setCuit(cuit);
        r.setBio(bio);
        r.setInstagram(instagram);
        r.setWebsite(website);
        r.setCoverImageId(coverImageId);
        r.setTeamDescription(teamDescription);
        r.setTeamSize(teamSize);
        r.setPreviousWorks(previousWorks);
        r.setSupportingDocId(supportingDocId);
        return r;
    }
}
