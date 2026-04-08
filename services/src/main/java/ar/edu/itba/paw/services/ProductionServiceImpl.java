package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.ObraDao;
import ar.edu.itba.paw.interfaces.persistence.ProductionDao;
import ar.edu.itba.paw.interfaces.services.ProductionService;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.ProductionCardSummary;
import ar.edu.itba.paw.models.ProductionSearchCriteria;
import ar.edu.itba.paw.models.SearchDateOption;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

@Service
public class ProductionServiceImpl implements ProductionService {

    private final ProductionDao productionDao;
    private final ObraDao obraDao;

    @Autowired
    public ProductionServiceImpl(final ProductionDao productionDao,
                                 final ObraDao obraDao) {
        this.productionDao = productionDao;
        this.obraDao = obraDao;
    }

    @Override
    public Optional<Production> findById(final long id) {
        return productionDao.findById(id);
    }

    @Override
    public List<Production> findAll() {
        return productionDao.findAll();
    }

    @Override
    public List<Production> findAll(final int page, final int pageSize) {
        return productionDao.findAll(page, pageSize);
    }

    @Override
    public List<ProductionCardSummary> findAllCards() {
        return summarizeByObra(productionDao.findAll());
    }

    @Override
    public List<ProductionCardSummary> findAllCards(final int page, final int pageSize) {
        return paginate(summarizeByObra(productionDao.findAll()), page, pageSize);
    }

    @Override
    public List<Production> findAvailable() {
        return productionDao.findAvailable();
    }

    @Override
    public List<Production> findAvailable(final int page, final int pageSize) {
        return productionDao.findAvailable(page, pageSize);
    }

    @Override
    public List<ProductionCardSummary> findAvailableCards() {
        return summarizeByObra(productionDao.findAvailable());
    }

    @Override
    public List<ProductionCardSummary> findAvailableCards(final int page, final int pageSize) {
        return paginate(summarizeByObra(productionDao.findAvailable()), page, pageSize);
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
    public List<ProductionCardSummary> findByGenreCards(final String genre, final int page, final int pageSize) {
        return paginate(summarizeByObra(productionDao.findByGenre(genre, 0, Integer.MAX_VALUE)), page, pageSize);
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
    public List<ProductionCardSummary> searchCards(final ProductionSearchCriteria criteria, final int page, final int pageSize) {
        return paginate(summarizeByObra(productionDao.search(criteria, 0, Integer.MAX_VALUE)), page, pageSize);
    }

    @Override
    public List<SearchDateOption> findNearbyDates(final ProductionSearchCriteria criteria,
                                                  final LocalDate selectedDate,
                                                  final int windowDays) {
        return productionDao.findNearbyDates(criteria, selectedDate, windowDays);
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

    private List<ProductionCardSummary> summarizeByObra(final List<Production> productions) {
        if (productions.isEmpty()) {
            return Collections.emptyList();
        }

        final Map<Long, List<Production>> productionsByObraId = new LinkedHashMap<>();
        for (final Production production : productions) {
            productionsByObraId.computeIfAbsent(production.getObraId(), ignored -> new ArrayList<>()).add(production);
        }

        final List<ProductionCardSummary> cards = new ArrayList<>(productionsByObraId.size());
        for (final Map.Entry<Long, List<Production>> entry : productionsByObraId.entrySet()) {
            final long obraId = entry.getKey();
            final List<Production> groupedProductions = entry.getValue();
            final Production representative = selectRepresentative(groupedProductions);
            final String title = obraDao.findById(obraId)
                    .map(obra -> obra.getTitle())
                    .orElse(representative.getName());

            cards.add(new ProductionCardSummary(
                    obraId,
                    representative.getId(),
                    title,
                    selectImageUrl(groupedProductions, representative),
                    formatTheaters(groupedProductions, representative)
            ));
        }

        return cards;
    }

    private List<ProductionCardSummary> paginate(final List<ProductionCardSummary> cards,
                                                 final int page,
                                                 final int pageSize) {
        if (cards.isEmpty()) {
            return cards;
        }

        final int normalizedPage = Math.max(page, 0);
        final int fromIndex = normalizedPage * pageSize;
        if (fromIndex >= cards.size()) {
            return Collections.emptyList();
        }

        final int toIndex = Math.min(fromIndex + pageSize, cards.size());
        return new ArrayList<>(cards.subList(fromIndex, toIndex));
    }

    private Production selectRepresentative(final List<Production> productions) {
        Production representative = productions.get(0);
        for (int i = 1; i < productions.size(); i++) {
            final Production candidate = productions.get(i);
            if (isBetterRepresentative(candidate, representative)) {
                representative = candidate;
            }
        }
        return representative;
    }

    private boolean isBetterRepresentative(final Production candidate, final Production current) {
        final boolean candidateActive = isActive(candidate);
        final boolean currentActive = isActive(current);
        if (candidateActive != currentActive) {
            return candidateActive;
        }

        final int startComparison = compareDates(candidate.getStartDate(), current.getStartDate());
        if (startComparison != 0) {
            return startComparison > 0;
        }

        final int endComparison = compareDates(candidate.getEndDate(), current.getEndDate());
        if (endComparison != 0) {
            return endComparison > 0;
        }

        return candidate.getId() > current.getId();
    }

    private int compareDates(final LocalDate left, final LocalDate right) {
        if (left == null && right == null) {
            return 0;
        }
        if (left == null) {
            return -1;
        }
        if (right == null) {
            return 1;
        }
        return left.compareTo(right);
    }

    private boolean isActive(final Production production) {
        if (production.getStartDate() == null) {
            return false;
        }
        final LocalDate today = LocalDate.now();
        return !production.getStartDate().isAfter(today)
                && (production.getEndDate() == null || !production.getEndDate().isBefore(today));
    }

    private String selectImageUrl(final List<Production> productions, final Production representative) {
        if (hasText(representative.getImageUrl())) {
            return representative.getImageUrl();
        }

        for (final Production production : productions) {
            if (hasText(production.getImageUrl())) {
                return production.getImageUrl();
            }
        }

        return null;
    }

    private String formatTheaters(final List<Production> productions, final Production representative) {
        final Set<String> theaters = new LinkedHashSet<>();
        addTheater(theaters, representative.getTheater());
        for (final Production production : productions) {
            addTheater(theaters, production.getTheater());
        }

        if (theaters.isEmpty()) {
            return null;
        }

        final List<String> orderedTheaters = new ArrayList<>(theaters);
        if (orderedTheaters.size() == 1) {
            return orderedTheaters.get(0);
        }
        if (orderedTheaters.size() == 2) {
            return orderedTheaters.get(0) + " y " + orderedTheaters.get(1);
        }

        final StringBuilder builder = new StringBuilder();
        for (int i = 0; i < orderedTheaters.size(); i++) {
            if (i > 0) {
                builder.append(i == orderedTheaters.size() - 1 ? " y " : ", ");
            }
            builder.append(orderedTheaters.get(i));
        }
        return builder.toString();
    }

    private void addTheater(final Set<String> theaters, final String theater) {
        if (hasText(theater)) {
            theaters.add(theater.trim());
        }
    }

    private boolean hasText(final String value) {
        return value != null && !value.trim().isEmpty();
    }
}
