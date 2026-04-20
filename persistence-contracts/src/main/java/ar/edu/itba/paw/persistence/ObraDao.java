package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.Obra;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface ObraDao {
    Optional<Obra> findById(long id);
    List<Obra> findAll(int page, int pageSize);
    Map<Long, String> findTitlesByIds(Collection<Long> obraIds);
    Obra create(String title, String synopsis, String genre);
}
