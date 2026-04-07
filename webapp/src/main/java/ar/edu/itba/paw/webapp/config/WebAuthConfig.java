package ar.edu.itba.paw.webapp.config;

import ar.edu.itba.paw.webapp.auth.PawUserDetails;
import ar.edu.itba.paw.webapp.auth.PawUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Configuration
@EnableWebSecurity
public class WebAuthConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private PawUserDetailsService userDetailsService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void configure(final org.springframework.security.config.annotation.web.builders.WebSecurity web) {
        web.ignoring().antMatchers("/css/**", "/js/**", "/images/**", "/favicon.png");
    }

    @Override
    protected void configure(final AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService)
                .passwordEncoder(passwordEncoder);
    }

    private AuthenticationSuccessHandler successHandler() {
        return new SavedRequestAwareAuthenticationSuccessHandler() {
            @Override
            public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                                Authentication authentication) throws IOException, ServletException {
                final HttpSessionRequestCache requestCache = new HttpSessionRequestCache();
                final SavedRequest savedRequest = requestCache.getRequest(request, response);
                requestCache.removeRequest(request, response);
                clearAuthenticationAttributes(request);

                final String targetUrl = (savedRequest != null)
                        ? savedRequest.getRedirectUrl()
                        : request.getContextPath() + "/users/me";
                response.sendRedirect(targetUrl);
            }
        };
    }

    @Override
    protected void configure(final HttpSecurity http) throws Exception {
        http
            .sessionManagement()
                .invalidSessionUrl("/login")
            .and()
            .authorizeRequests()
                .antMatchers("/users/me").hasRole("USER")
                .anyRequest().permitAll()
            .and()
            .formLogin()
                .loginPage("/login")
                .usernameParameter("email")
                .passwordParameter("password")
                .successHandler(successHandler())
                .failureUrl("/login?error=true")
                .permitAll()
            .and()
            .rememberMe()
                .rememberMeParameter("remember-me")
                .userDetailsService(userDetailsService)
                .key("plateaRememberMeKey")
            .and()
            .logout()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/login?logout=true")
                .deleteCookies("JSESSIONID")
                .permitAll()
            .and()
            .csrf();
    }
}
