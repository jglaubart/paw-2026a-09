package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.Obra;
import java.util.List;
import java.util.Optional;

public interface ObraDao {
    Optional<Obra> findById(long id);
    List<Obra> findAll(int page, int pageSize);
    Obra create(String title, String synopsis, String genre);
}
