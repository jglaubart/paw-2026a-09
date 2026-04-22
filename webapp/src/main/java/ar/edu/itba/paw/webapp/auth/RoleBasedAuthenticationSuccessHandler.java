package ar.edu.itba.paw.webapp.auth;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class RoleBasedAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {

    private static final String ADMIN_ROLE = "ROLE_ADMIN";
    private static final String ADMIN_LANDING = "/admin";
    private static final String DEFAULT_LANDING = "/users/me";

    private final HttpSessionRequestCache requestCache = new HttpSessionRequestCache();

    public RoleBasedAuthenticationSuccessHandler() {
        setDefaultTargetUrl(DEFAULT_LANDING);
    }

    @Override
    public void onAuthenticationSuccess(final HttpServletRequest request,
                                        final HttpServletResponse response,
                                        final Authentication authentication) throws IOException, ServletException {
        if (hasAdminAuthority(authentication)) {
            requestCache.removeRequest(request, response);
            getRedirectStrategy().sendRedirect(request, response, request.getContextPath() + ADMIN_LANDING);
            return;
        }
        final SavedRequest saved = requestCache.getRequest(request, response);
        if (saved != null && !"GET".equalsIgnoreCase(saved.getMethod())) {
            requestCache.removeRequest(request, response);
            getRedirectStrategy().sendRedirect(request, response, request.getContextPath() + DEFAULT_LANDING);
            return;
        }
        super.onAuthenticationSuccess(request, response, authentication);
    }

    private boolean hasAdminAuthority(final Authentication authentication) {
        if (authentication == null || authentication.getAuthorities() == null) {
            return false;
        }
        for (final GrantedAuthority authority : authentication.getAuthorities()) {
            if (ADMIN_ROLE.equals(authority.getAuthority())) {
                return true;
            }
        }
        return false;
    }
}
