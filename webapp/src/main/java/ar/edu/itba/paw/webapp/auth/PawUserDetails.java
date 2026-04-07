package ar.edu.itba.paw.webapp.auth;

import ar.edu.itba.paw.models.User;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import java.util.Collections;

public class PawUserDetails extends org.springframework.security.core.userdetails.User {

    private final User user;

    public PawUserDetails(final User user) {
        super(
            user.getEmail(),
            user.getPassword(),
            Collections.singletonList(new SimpleGrantedAuthority(user.getRole()))
        );
        this.user = user;
    }

    public User getUser() {
        return user;
    }
}
