package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.ObraDao;
import ar.edu.itba.paw.interfaces.services.ObraService;
import ar.edu.itba.paw.models.Obra;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ObraServiceImpl implements ObraService {

    private final ObraDao obraDao;

    @Autowired
    public ObraServiceImpl(final ObraDao obraDao) {
        this.obraDao = obraDao;
    }

    @Override
    public Optional<Obra> findById(final long id) {
        return obraDao.findById(id);
    }

    @Override
    public List<Obra> findAll(final int page, final int pageSize) {
        return obraDao.findAll(page, pageSize);
    }

    @Override
    public Obra create(final String title, final String synopsis, final String genre) {
        return obraDao.create(title, synopsis, genre);
    }
}
