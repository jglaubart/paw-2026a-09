package ar.edu.itba.paw.webapp.config;

import ar.edu.itba.paw.webapp.auth.PawUserDetailsService;
import ar.edu.itba.paw.webapp.auth.RoleBasedAuthenticationSuccessHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    private final PawUserDetailsService userDetailsService;
    private final PasswordEncoder passwordEncoder;
    private final RoleBasedAuthenticationSuccessHandler authenticationSuccessHandler;

    @Autowired
    public WebSecurityConfig(final PawUserDetailsService userDetailsService,
                             final PasswordEncoder passwordEncoder,
                             final RoleBasedAuthenticationSuccessHandler authenticationSuccessHandler) {
        this.userDetailsService = userDetailsService;
        this.passwordEncoder = passwordEncoder;
        this.authenticationSuccessHandler = authenticationSuccessHandler;
    }

    @Override
    protected void configure(final AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService).passwordEncoder(passwordEncoder);
    }

    @Override
    protected void configure(final HttpSecurity http) throws Exception {
        http
                .authorizeRequests()
                    .antMatchers("/css/**", "/js/**", "/images/**", "/favicon.png").permitAll()
                    .antMatchers(HttpMethod.GET, "/", "/cartelera", "/search/**", "/obras/**", "/productions", "/productions/**", "/productoras/**", "/images/**", "/petition-images/**").permitAll()
                    .antMatchers(HttpMethod.POST, "/obras/*/share").permitAll()
                    .antMatchers("/login", "/register", "/register/verify", "/register/verify/resend").permitAll()
                    .antMatchers("/admin/**").hasRole("ADMIN")
                    .anyRequest().authenticated()
                .and()
                    .formLogin()
                        .loginPage("/login")
                        .usernameParameter("email")
                        .passwordParameter("password")
                        .successHandler(authenticationSuccessHandler)
                        .failureHandler((request, response, exception) -> {
                            final String target = exception instanceof DisabledException
                                    ? "/login?unverified=1"
                                    : "/login?error=1";
                            new SimpleUrlAuthenticationFailureHandler(target)
                                    .onAuthenticationFailure(request, response, exception);
                        })
                        .permitAll()
                .and()
                    .logout()
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout=1")
                        .permitAll()
                .and()
                    .exceptionHandling()
                        .accessDeniedPage("/403");
    }
}
