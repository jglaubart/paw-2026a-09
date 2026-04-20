package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.Productora;
import ar.edu.itba.paw.models.ProductoraRequest;
import ar.edu.itba.paw.models.ProductoraRequestStatus;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface ProductoraRequestService {

    ProductoraRequest submit(long userId, String contactEmail, String phone,
                             String name, String cuit, String bio,
                             String instagram, String website, Long coverImageId,
                             String teamDescription, Integer teamSize,
                             String previousWorks, Long supportingDocId);

    ProductoraRequest resubmit(long requestId, long userId, String contactEmail, String phone,
                               String name, String cuit, String bio,
                               String instagram, String website, Long coverImageId,
                               String teamDescription, Integer teamSize,
                               String previousWorks, Long supportingDocId);

    Optional<ProductoraRequest> findActiveForUser(long userId);

    List<ProductoraRequest> findHistoryForUser(long userId);

    Optional<ProductoraRequest> findById(long id);

    List<ProductoraRequest> findForAdmin(ProductoraRequestStatus filter);

    Map<ProductoraRequestStatus, Integer> countByStatus();

    Productora approve(long requestId, String adminNotes);

    void reject(long requestId, String adminNotes);

    void requestChanges(long requestId, String adminNotes,
                        Map<String, String> fieldFeedback);
}
