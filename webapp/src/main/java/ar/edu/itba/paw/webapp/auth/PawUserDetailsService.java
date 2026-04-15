package ar.edu.itba.paw.webapp.auth;

import ar.edu.itba.paw.interfaces.services.UserService;
import ar.edu.itba.paw.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class PawUserDetailsService implements UserDetailsService {

    private final UserService userService;

    @Autowired
    public PawUserDetailsService(final UserService userService) {
        this.userService = userService;
    }

    @Override
    public UserDetails loadUserByUsername(final String input) throws UsernameNotFoundException {
        Optional<User> user = userService.findByEmail(input);
        if (!user.isPresent()) {
            user = userService.findByUsername(input);
        }
        return user
                .filter(u -> u.getPassword() != null && !u.getPassword().trim().isEmpty())
                .map(PawAuthUser::new)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + input));
    }
}
