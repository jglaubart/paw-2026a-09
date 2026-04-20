package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.ProductionSearchCriteria;
import ar.edu.itba.paw.models.SearchDateOption;
import java.time.LocalDate;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface ProductionDao {
    Optional<Production> findById(long id);
    List<Production> findAll();
    List<Production> findAll(int page, int pageSize);
    List<Production> findAvailable();
    List<Production> findAvailable(int page, int pageSize);
    List<Production> findByObraId(long obraId);
    Map<Long, String> findCoverImageUrlByObraIds(Collection<Long> obraIds);
    List<Production> findByProductoraId(long productoraId);
    List<Production> search(String query, int page, int pageSize);
    List<Production> search(ProductionSearchCriteria criteria, int page, int pageSize);
    List<SearchDateOption> findNearbyDates(ProductionSearchCriteria criteria, LocalDate selectedDate, int windowDays);
    List<Production> findByGenre(String genre, int page, int pageSize);
    List<String> findAvailableGenres();
    List<String> findAvailableTheaters();
    List<String> findAvailableLocations();
    Production create(String name, long obraId, Long productoraId, String synopsis,
                      String direction, String theater, LocalDate startDate, LocalDate endDate,
                      Long imageId, Integer durationMinutes, String language,
                      String instagram, String website);
}
