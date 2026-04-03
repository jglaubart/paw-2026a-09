package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.Image;
import java.util.Optional;

public interface ImageDao {
    Optional<Image> findById(long id);
    Image create(String contentType, byte[] content);
}
