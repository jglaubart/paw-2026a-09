package ar.edu.itba.paw.webapp.interceptor;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Component
public class AdminOnlyInterceptor implements HandlerInterceptor {

    private static final String ADMIN_ROLE = "ROLE_ADMIN";
    private static final String ADMIN_PREFIX = "/admin";
    private static final String LOGOUT_PATH = "/logout";

    @Override
    public boolean preHandle(final HttpServletRequest request,
                             final HttpServletResponse response,
                             final Object handler) throws Exception {
        if (!currentUserIsAdmin()) {
            return true;
        }

        final String path = extractPath(request);
        if (isAdminAllowedPath(path)) {
            return true;
        }

        response.sendRedirect(request.getContextPath() + ADMIN_PREFIX);
        return false;
    }

    private boolean currentUserIsAdmin() {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return false;
        }
        for (final GrantedAuthority authority : authentication.getAuthorities()) {
            if (ADMIN_ROLE.equals(authority.getAuthority())) {
                return true;
            }
        }
        return false;
    }

    private String extractPath(final HttpServletRequest request) {
        final String uri = request.getRequestURI();
        final String contextPath = request.getContextPath();
        if (contextPath != null && !contextPath.isEmpty() && uri.startsWith(contextPath)) {
            return uri.substring(contextPath.length());
        }
        return uri;
    }

    private boolean isAdminAllowedPath(final String path) {
        if (path == null || path.isEmpty()) {
            return false;
        }
        return path.equals(ADMIN_PREFIX)
                || path.startsWith(ADMIN_PREFIX + "/")
                || path.equals(LOGOUT_PATH);
    }
}
