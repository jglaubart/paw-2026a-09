package ar.edu.itba.paw.interfaces.services;

import ar.edu.itba.paw.models.Productora;
import ar.edu.itba.paw.models.ProductoraMember;

import java.util.List;
import java.util.Optional;

public interface ProductoraService {

    Optional<Productora> findById(long id);
    List<Productora> findAll();
    Productora create(String name, String bio, Long imageId, String instagram, String website);

    List<Productora> findMineByUser(long userId);

    List<ProductoraMember> listMembers(long productoraId);

    boolean canManage(long userId, long productoraId);

    void updateDetails(long productoraId, long actingUserId,
                       String name, String bio, Long imageId,
                       String instagram, String website);

    void addMemberByEmail(long productoraId, long actingUserId, String email);

    void removeMember(long productoraId, long actingUserId, long memberUserId);
}
