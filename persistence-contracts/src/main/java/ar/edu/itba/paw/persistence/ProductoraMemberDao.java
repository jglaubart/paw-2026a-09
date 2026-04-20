package ar.edu.itba.paw.interfaces.persistence;

import ar.edu.itba.paw.models.ProductoraMember;
import ar.edu.itba.paw.models.ProductoraMemberRole;

import java.util.List;
import java.util.Optional;

public interface ProductoraMemberDao {

    List<ProductoraMember> findByProductora(long productoraId);

    List<ProductoraMember> findByUser(long userId);

    Optional<ProductoraMember> find(long userId, long productoraId);

    boolean exists(long userId, long productoraId);

    boolean isOwnerOfAnyProductora(long userId);

    void add(long userId, long productoraId, ProductoraMemberRole role);

    void remove(long userId, long productoraId);

    void updateRole(long userId, long productoraId, ProductoraMemberRole role);
}
