package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.Genre;
import java.util.List;
import java.util.Optional;

public interface GenreDao {
    List<Genre> findAll();
    Optional<Genre> findById(long id);
    List<Genre> findByIds(List<Long> ids);
    List<Genre> findByPetitionId(long petitionId);
}
