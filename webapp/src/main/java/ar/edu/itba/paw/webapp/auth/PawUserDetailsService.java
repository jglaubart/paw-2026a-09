package ar.edu.itba.paw.webapp.auth;

import ar.edu.itba.paw.interfaces.services.UserService;
import ar.edu.itba.paw.models.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

@Component
public class PawUserDetailsService implements UserDetailsService {

    private static final Logger LOGGER = LoggerFactory.getLogger(PawUserDetailsService.class);

    private final UserService userService;

    @Autowired
    public PawUserDetailsService(final UserService userService) {
        this.userService = userService;
    }

    @Override
    public UserDetails loadUserByUsername(final String email) throws UsernameNotFoundException {
        LOGGER.debug("Loading user by email: {}", email);
        final User user = userService.findByEmail(email)
                .orElseThrow(() -> {
                    LOGGER.warn("Authentication failed — no user found with email: {}", email);
                    return new UsernameNotFoundException("No user found with email: " + email);
                });
        LOGGER.debug("User loaded successfully: id={}, role={}", user.getId(), user.getRole());
        return new PawUserDetails(user);
    }
}
