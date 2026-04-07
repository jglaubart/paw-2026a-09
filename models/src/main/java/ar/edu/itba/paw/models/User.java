package ar.edu.itba.paw.models;

import java.io.Serializable;

public class User implements Serializable {

    private long id;
    private String email;
    private String password;
    private String role;

    public User() {}

    public User(final long id, final String email, final String password, final String role) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    public long getId() { return id; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getRole() { return role; }
}
