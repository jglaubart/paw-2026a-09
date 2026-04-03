package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.GenreDao;
import ar.edu.itba.paw.interfaces.services.GenreService;
import ar.edu.itba.paw.models.Genre;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GenreServiceImpl implements GenreService {

    private final GenreDao genreDao;

    @Autowired
    public GenreServiceImpl(final GenreDao genreDao) {
        this.genreDao = genreDao;
    }

    @Override
    public List<Genre> findAll() {
        return genreDao.findAll();
    }

    @Override
    public List<Genre> findByIds(final List<Long> ids) {
        return genreDao.findByIds(ids);
    }
}
