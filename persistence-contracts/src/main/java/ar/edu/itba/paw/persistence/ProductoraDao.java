package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.Productora;
import java.util.List;
import java.util.Optional;

public interface ProductoraDao {
    Optional<Productora> findById(long id);
    List<Productora> findAll();
    Productora create(String name, String bio, Long imageId, String instagram, String website);

    Productora createApproved(String name, String bio, Long imageId,
                              String instagram, String website,
                              String cuit, String contactEmail);

    void update(long productoraId, String name, String bio, Long imageId,
                String instagram, String website);

    boolean existsByNameIgnoreCase(String name, Long excludeId);
}
