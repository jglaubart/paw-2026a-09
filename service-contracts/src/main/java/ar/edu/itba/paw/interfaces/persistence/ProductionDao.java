package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.Production;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface ProductionDao {
    Optional<Production> findById(long id);
    List<Production> findAll(int page, int pageSize);
    List<Production> findAvailable(int page, int pageSize);
    List<Production> findByObraId(long obraId);
    List<Production> findByProductoraId(long productoraId);
    List<Production> search(String query, int page, int pageSize);
    List<Production> findByGenre(String genre, int page, int pageSize);
    Production create(String name, long obraId, Long productoraId, String synopsis,
                      String direction, String theater, LocalDate startDate, LocalDate endDate,
                      Long imageId, String genre, String instagram, String website);
}
