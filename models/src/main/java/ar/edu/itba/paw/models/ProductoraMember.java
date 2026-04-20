package ar.edu.itba.paw.models;

import java.io.Serializable;
import java.time.LocalDateTime;

public class ProductoraMember implements Serializable {

    private long userId;
    private long productoraId;
    private ProductoraMemberRole role;
    private LocalDateTime joinedAt;

    private String userEmail;
    private String username;

    public ProductoraMember() {}

    public ProductoraMember(final long userId, final long productoraId,
                            final ProductoraMemberRole role, final LocalDateTime joinedAt) {
        this.userId = userId;
        this.productoraId = productoraId;
        this.role = role;
        this.joinedAt = joinedAt;
    }

    public long getUserId() { return userId; }
    public long getProductoraId() { return productoraId; }
    public ProductoraMemberRole getRole() { return role; }
    public LocalDateTime getJoinedAt() { return joinedAt; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(final String userEmail) { this.userEmail = userEmail; }

    public String getUsername() { return username; }
    public void setUsername(final String username) { this.username = username; }

    public boolean isOwner() { return role == ProductoraMemberRole.OWNER; }
}
