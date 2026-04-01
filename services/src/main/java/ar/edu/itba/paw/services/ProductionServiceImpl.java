package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.ProductionDao;
import ar.edu.itba.paw.interfaces.services.ProductionService;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.ProductionSearchCriteria;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class ProductionServiceImpl implements ProductionService {

    private final ProductionDao productionDao;

    @Autowired
    public ProductionServiceImpl(final ProductionDao productionDao) {
        this.productionDao = productionDao;
    }

    @Override
    public Optional<Production> findById(final long id) {
        return productionDao.findById(id);
    }

    @Override
    public List<Production> findAll(final int page, final int pageSize) {
        return productionDao.findAll(page, pageSize);
    }

    @Override
    public List<Production> findAvailable(final int page, final int pageSize) {
        return productionDao.findAvailable(page, pageSize);
    }

    @Override
    public List<Production> findByObraId(final long obraId) {
        return productionDao.findByObraId(obraId);
    }

    @Override
    public Optional<Production> findSelectedByObraId(final long obraId, final Long preferredProductionId) {
        final List<Production> productions = productionDao.findByObraId(obraId);
        if (productions.isEmpty()) {
            return Optional.empty();
        }
        if (preferredProductionId != null) {
            for (final Production production : productions) {
                if (production.getId() == preferredProductionId) {
                    return Optional.of(production);
                }
            }
        }
        return Optional.of(productions.get(0));
    }

    @Override
    public List<Production> findByProductoraId(final long productoraId) {
        return productionDao.findByProductoraId(productoraId);
    }

    @Override
    public List<Production> search(final String query, final int page, final int pageSize) {
        return productionDao.search(query, page, pageSize);
    }

    @Override
    public List<Production> search(final ProductionSearchCriteria criteria, final int page, final int pageSize) {
        return productionDao.search(criteria, page, pageSize);
    }

    @Override
    public List<Production> findByGenre(final String genre, final int page, final int pageSize) {
        return productionDao.findByGenre(genre, page, pageSize);
    }

    @Override
    public List<String> findAvailableGenres() {
        return productionDao.findAvailableGenres();
    }

    @Override
    public List<String> findAvailableTheaters() {
        return productionDao.findAvailableTheaters();
    }

    @Override
    public List<String> findAvailableLocations() {
        return productionDao.findAvailableLocations();
    }

    @Override
    public Production create(final String name, final long obraId, final Long productoraId,
                             final String synopsis, final String direction, final String theater,
                             final LocalDate startDate, final LocalDate endDate, final String imageUrl,
                             final String instagram, final String website) {
        return productionDao.create(name, obraId, productoraId, synopsis, direction, theater,
                startDate, endDate, imageUrl, instagram, website);
    }
}
