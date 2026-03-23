<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="activeSection" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:url var="homeUrl"         value="/" />
<c:url var="carteleraUrl"    value="/cartelera" />
<c:url var="teatrosUrl"      value="/teatros" />
<header class="navbar">
    <a class="navbar-logo" href="${homeUrl}">PLATEA</a>

    <nav class="navbar-nav" aria-label="Navegación principal">
        <a class="navbar-link ${activeSection == 'cartelera'    ? 'navbar-link-active' : ''}" href="${carteleraUrl}">CARTELERA</a>
        <a class="navbar-link ${activeSection == 'teatros'      ? 'navbar-link-active' : ''}" href="${teatrosUrl}">TEATROS</a>
    </nav>

    <div class="navbar-actions">
        <div class="navbar-search">
            <span class="navbar-search-icon" aria-hidden="true">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2.5"
                     stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="7"/>
                    <line x1="16.5" y1="16.5" x2="22" y2="22"/>
                </svg>
            </span>
            <paw:search name="q" placeholder="Buscar obras..." maxlength="100" />
        </div>
        <button type="button" class="navbar-user-btn" aria-label="Perfil de usuario">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                <path d="M12 12c2.7 0 4.8-2.1 4.8-4.8S14.7 2.4 12 2.4 7.2 4.5 7.2 7.2 9.3 12 12 12zm0 2.4c-3.2 0-9.6 1.6-9.6 4.8v2.4h19.2v-2.4c0-3.2-6.4-4.8-9.6-4.8z"/>
            </svg>
        </button>
    </div>
</header>
