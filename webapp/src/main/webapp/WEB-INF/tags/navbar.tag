<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="activeSection" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:url var="homeUrl"         value="/" />
<c:url var="carteleraUrl"    value="/cartelera" />
<c:url var="subirObraUrl"    value="/subir-obra" />
<%-- <c:url var="watchlistUrl" value="/watchlist" /> --%>
<%-- <c:url var="historialUrl" value="/historial" /> --%>
<c:url var="navbarSearchScriptUrl" value="/js/components/navbar-search.js" />
<c:set var="resolvedActiveSection" value="${activeSection}" />
<c:if test="${empty resolvedActiveSection}">
    <c:set var="currentRequestUri" value="${not empty requestScope['javax.servlet.forward.request_uri'] ? requestScope['javax.servlet.forward.request_uri'] : pageContext.request.requestURI}" />
    <c:set var="requestPath" value="${fn:substringAfter(currentRequestUri, pageContext.request.contextPath)}" />
    <c:choose>
        <c:when test="${fn:startsWith(requestPath, '/cartelera')}">
            <c:set var="resolvedActiveSection" value="cartelera" />
        </c:when>
        <%--
        <c:when test="${fn:startsWith(requestPath, '/watchlist')}">
            <c:set var="resolvedActiveSection" value="watchlist" />
        </c:when>
        --%>
        <%--
        <c:when test="${fn:startsWith(requestPath, '/historial')}">
            <c:set var="resolvedActiveSection" value="historial" />
        </c:when>
        --%>
    </c:choose>
</c:if>
<header class="navbar">
    <a class="navbar-logo" href="${homeUrl}">PLATEA</a>

    <nav class="navbar-nav" aria-label="Navegación principal">
        <a class="navbar-link ${resolvedActiveSection == 'cartelera' ? 'navbar-link-active' : ''}" href="${carteleraUrl}">CARTELERA</a>
        <%-- <a class="navbar-link ${resolvedActiveSection == 'watchlist' ? 'navbar-link-active' : ''}" href="${watchlistUrl}">WATCHLIST</a> --%>
        <%-- <a class="navbar-link ${resolvedActiveSection == 'historial' ? 'navbar-link-active' : ''}" href="${historialUrl}">HISTORIAL</a> --%>
    </nav>

    <div class="navbar-actions">
        <paw:advancedSearch variant="navbar" />
        <paw:button text="Subir obra" size="md" cssClass="btn-primary navbar-submit-button" href="${subirObraUrl}" />
    </div>
</header>
<script src="${navbarSearchScriptUrl}" defer></script>
