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

    public User() {}

    public User(final long id, final String email, final String password) {
        this(id, email, password, "ROLE_USER", "", null, "");
    }

    public User(final long id, final String email, final String password, final String role) {
        this(id, email, password, role, "", null, "");
    }

    public User(final long id, final String email, final String password, final String role, final String username) {
        this(id, email, password, role, username, null, "");
    }

    public User(final long id, final String email, final String password, final String role, final String username, final Long imageId) {
        this(id, email, password, role, username, imageId, "");
    }

    public User(final long id, final String email, final String password, final String role, final String username, final Long imageId, final String bio) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.role = role;
        this.username = username != null ? username : "";
        this.imageId = imageId;
        this.bio = bio != null ? bio : "";
    }

    public long getId() { return id; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getRole() { return role; }
    public String getUsername() { return username; }
    public Long getImageId() { return imageId; }
    public String getBio() { return bio; }
}
