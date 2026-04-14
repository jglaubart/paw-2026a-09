package ar.edu.itba.paw.webapp.auth;

import ar.edu.itba.paw.interfaces.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

@Component
public class PawUserDetailsService implements UserDetailsService {

    private final UserService userService;

    @Autowired
    public PawUserDetailsService(final UserService userService) {
        this.userService = userService;
    }

    @Override
    public UserDetails loadUserByUsername(final String email) throws UsernameNotFoundException {
        return userService.findByEmail(email)
                .filter(user -> user.getPassword() != null && !user.getPassword().trim().isEmpty())
                .map(PawAuthUser::new)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + email));
    }
}
