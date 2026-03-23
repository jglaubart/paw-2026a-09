package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.ProductoraDao;
import ar.edu.itba.paw.interfaces.services.ProductoraService;
import ar.edu.itba.paw.models.Productora;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProductoraServiceImpl implements ProductoraService {

    private final ProductoraDao productoraDao;

    @Autowired
    public ProductoraServiceImpl(final ProductoraDao productoraDao) {
        this.productoraDao = productoraDao;
    }

    @Override
    public Optional<Productora> findById(final long id) {
        return productoraDao.findById(id);
    }

    @Override
    public List<Productora> findAll() {
        return productoraDao.findAll();
    }

    @Override
    public Productora create(final String name, final String bio, final String imageUrl,
                             final String instagram, final String website) {
        return productoraDao.create(name, bio, imageUrl, instagram, website);
    }
}
