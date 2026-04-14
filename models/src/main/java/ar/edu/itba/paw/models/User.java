package ar.edu.itba.paw.models;

import java.io.Serializable;

public class User implements Serializable {

    private long id;
    private String email;
    private String password;
    private String role;
    private String username;

    public User() {}

    public User(final long id, final String email, final String password) {
        this(id, email, password, "ROLE_USER", "");
    }

    public User(final long id, final String email, final String password, final String role) {
        this(id, email, password, role, "");
    }

    public User(final long id, final String email, final String password, final String role, final String username) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.role = role;
        this.username = username != null ? username : "";
    }

    public long getId() { return id; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getRole() { return role; }
    public String getUsername() { return username; }
}
