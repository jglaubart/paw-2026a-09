<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="activeSection" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:url var="homeUrl"         value="/" />
<c:url var="carteleraUrl"    value="/cartelera" />
<c:url var="wishlistUrl"     value="/wishlist" />
<c:url var="watchlistUrl"    value="/watchlist" />
<c:url var="navbarSearchScriptUrl" value="/js/components/navbar-search.js" />
<header class="navbar">
    <a class="navbar-logo" href="${homeUrl}">PLATEA</a>

    <nav class="navbar-nav" aria-label="Navegación principal">
        <a class="navbar-link ${activeSection == 'cartelera' ? 'navbar-link-active' : ''}" href="${carteleraUrl}">CARTELERA</a>
        <a class="navbar-link ${activeSection == 'wishlist' ? 'navbar-link-active' : ''}" href="${wishlistUrl}">WISHLIST</a>
        <a class="navbar-link ${activeSection == 'watchlist' ? 'navbar-link-active' : ''}" href="${watchlistUrl}">YA LAS VI</a>
    </nav>

    <div class="navbar-actions">
        <paw:advancedSearch variant="navbar" />
    </div>
</header>
<script src="${navbarSearchScriptUrl}" defer></script>
