<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="activeSection" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:url var="homeUrl"         value="/" />
<c:url var="carteleraUrl"    value="/cartelera" />
<c:url var="wishlistUrl"     value="/wishlist" />
<c:url var="watchlistUrl"    value="/watchlist" />
<c:url var="navbarSearchScriptUrl" value="/js/components/navbar-search.js" />
<c:set var="resolvedActiveSection" value="${activeSection}" />
<c:if test="${empty resolvedActiveSection}">
    <c:set var="currentRequestUri" value="${not empty requestScope['javax.servlet.forward.request_uri'] ? requestScope['javax.servlet.forward.request_uri'] : pageContext.request.requestURI}" />
    <c:set var="requestPath" value="${fn:substringAfter(currentRequestUri, pageContext.request.contextPath)}" />
    <c:choose>
        <c:when test="${fn:startsWith(requestPath, '/cartelera')}">
            <c:set var="resolvedActiveSection" value="cartelera" />
        </c:when>
        <c:when test="${fn:startsWith(requestPath, '/wishlist')}">
            <c:set var="resolvedActiveSection" value="wishlist" />
        </c:when>
        <c:when test="${fn:startsWith(requestPath, '/watchlist')}">
            <c:set var="resolvedActiveSection" value="watchlist" />
        </c:when>
    </c:choose>
</c:if>
<header class="navbar">
    <a class="navbar-logo" href="${homeUrl}">PLATEA</a>

    <nav class="navbar-nav" aria-label="Navegación principal">
        <a class="navbar-link ${resolvedActiveSection == 'cartelera' ? 'navbar-link-active' : ''}" href="${carteleraUrl}">CARTELERA</a>
        <a class="navbar-link ${resolvedActiveSection == 'wishlist' ? 'navbar-link-active' : ''}" href="${wishlistUrl}">WATCHLIST</a>
        <a class="navbar-link ${resolvedActiveSection == 'watchlist' ? 'navbar-link-active' : ''}" href="${watchlistUrl}">HISTORIAL</a>
    </nav>

    <div class="navbar-actions">
        <paw:advancedSearch variant="navbar" />
    </div>
</header>
<script src="${navbarSearchScriptUrl}" defer></script>
