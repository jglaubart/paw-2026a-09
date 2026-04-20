package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.ProductoraRequest;
import ar.edu.itba.paw.models.ProductoraRequestStatus;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface ProductoraRequestDao {

    Optional<ProductoraRequest> findById(long id);

    List<ProductoraRequest> findByUser(long userId);

    Optional<ProductoraRequest> findActiveByUser(long userId);

    List<ProductoraRequest> findForAdmin(ProductoraRequestStatus statusFilter);

    Map<ProductoraRequestStatus, Integer> countByStatus();

    ProductoraRequest create(ProductoraRequest request);

    void updateContent(ProductoraRequest request);

    void updateStatus(long requestId, ProductoraRequestStatus status,
                      String adminNotes, Long createdProductoraId);

    Map<String, String> findFieldFeedback(long requestId);
    void replaceFieldFeedback(long requestId, Map<String, String> feedbackByField);
    void clearFieldFeedback(long requestId);
}
