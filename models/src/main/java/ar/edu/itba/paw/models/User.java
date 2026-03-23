package ar.edu.itba.paw.models;

import java.io.Serializable;

public class User implements Serializable {

    private long id;
    private String email;
    private String password;

    public User() {}

    public User(final long id, final String email, final String password) {
        this.id = id;
        this.email = email;
        this.password = password;
    }

    public long getId() { return id; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
}
