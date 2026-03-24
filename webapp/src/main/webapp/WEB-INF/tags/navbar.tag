<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="activeSection" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:url var="homeUrl"         value="/" />
<c:url var="carteleraUrl"    value="/cartelera" />
<c:url var="wishlistUrl"     value="/wishlist" />
<c:url var="watchlistUrl"    value="/watchlist" />
<c:url var="searchUrl"       value="/search" />
<header class="navbar">
    <a class="navbar-logo" href="${homeUrl}">PLATEA</a>

    <nav class="navbar-nav" aria-label="Navegación principal">
        <a class="navbar-link ${activeSection == 'cartelera' ? 'navbar-link-active' : ''}" href="${carteleraUrl}">CARTELERA</a>
        <a class="navbar-link ${activeSection == 'wishlist' ? 'navbar-link-active' : ''}" href="${wishlistUrl}">WISHLIST</a>
        <a class="navbar-link ${activeSection == 'watchlist' ? 'navbar-link-active' : ''}" href="${watchlistUrl}">YA LAS VI</a>
    </nav>

    <div class="navbar-actions">
        <form action="${searchUrl}" method="get" class="navbar-search">
            <span class="navbar-search-icon" aria-hidden="true">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2.5"
                     stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="7"/>
                    <line x1="16.5" y1="16.5" x2="22" y2="22"/>
                </svg>
            </span>
            <paw:search name="q" placeholder="Buscar obras..." maxlength="100" />
        </form>
    </div>
</header>
