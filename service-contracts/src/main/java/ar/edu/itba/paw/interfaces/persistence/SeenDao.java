package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.Obra;
import java.util.List;

public interface SeenDao {
    List<Obra> findByUser(long userId);
    boolean hasSeen(long userId, long obraId);
    void markSeen(long userId, long obraId);
    void unmarkSeen(long userId, long obraId);
}
