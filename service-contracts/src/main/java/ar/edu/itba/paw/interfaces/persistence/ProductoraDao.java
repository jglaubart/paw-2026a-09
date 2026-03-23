package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.Productora;
import java.util.List;
import java.util.Optional;

public interface ProductoraDao {
    Optional<Productora> findById(long id);
    List<Productora> findAll();
    Productora create(String name, String bio, String imageUrl, String instagram, String website);
}
