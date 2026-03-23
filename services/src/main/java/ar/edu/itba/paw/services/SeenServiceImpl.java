package ar.edu.itba.paw.services;

import ar.edu.itba.paw.interfaces.persistence.SeenDao;
import ar.edu.itba.paw.interfaces.services.SeenService;
import ar.edu.itba.paw.models.Obra;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SeenServiceImpl implements SeenService {

    private final SeenDao seenDao;

    @Autowired
    public SeenServiceImpl(final SeenDao seenDao) {
        this.seenDao = seenDao;
    }

    @Override
    public List<Obra> findByUser(final long userId) {
        return seenDao.findByUser(userId);
    }

    @Override
    public boolean hasSeen(final long userId, final long obraId) {
        return seenDao.hasSeen(userId, obraId);
    }

    @Override
    public void markSeen(final long userId, final long obraId) {
        seenDao.markSeen(userId, obraId);
    }

    @Override
    public void unmarkSeen(final long userId, final long obraId) {
        seenDao.unmarkSeen(userId, obraId);
    }
}
