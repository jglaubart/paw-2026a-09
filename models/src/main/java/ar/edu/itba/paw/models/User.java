package ar.edu.itba.paw.models;

import java.io.Serializable;

public class User implements Serializable {

    private long id;
    private String email;
    private String password;
    private String role;
    private String username;
    private Long imageId;
    private String bio;
    private boolean emailVerified;

    public User() {}

    public User(final long id, final String email, final String password) {
        this(id, email, password, "ROLE_USER", "", null, "", true);
    }

    public User(final long id, final String email, final String password, final String role) {
        this(id, email, password, role, "", null, "", true);
    }

    public User(final long id, final String email, final String password, final String role, final String username) {
        this(id, email, password, role, username, null, "", true);
    }

    public User(final long id, final String email, final String password, final String role, final String username, final Long imageId) {
        this(id, email, password, role, username, imageId, "", true);
    }

    public User(final long id, final String email, final String password, final String role, final String username, final Long imageId, final String bio) {
        this(id, email, password, role, username, imageId, bio, true);
    }

    public User(final long id, final String email, final String password, final String role, final String username, final Long imageId, final String bio, final boolean emailVerified) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.role = role;
        this.username = username != null ? username : "";
        this.imageId = imageId;
        this.bio = bio != null ? bio : "";
        this.emailVerified = emailVerified;
    }

    public long getId() { return id; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getRole() { return role; }
    public String getUsername() { return username; }
    public Long getImageId() { return imageId; }
    public String getBio() { return bio; }
    public boolean isEmailVerified() { return emailVerified; }
}
