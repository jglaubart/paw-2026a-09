package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.Genre;
import java.util.List;

public interface GenreService {
    List<Genre> findAll();
    List<Genre> findByIds(List<Long> ids);
}
