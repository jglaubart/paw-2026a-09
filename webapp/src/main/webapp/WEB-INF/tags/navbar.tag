<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="activeSection" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:url var="homeUrl"         value="/" />
<c:url var="carteleraUrl"    value="/cartelera" />
<c:url var="subirObraUrl"    value="/subir-obra" />
<c:url var="loginUrl"        value="/login" />
<c:url var="registerUrl"     value="/register" />
<c:url var="profileUrl"      value="/users/me" />
<c:url var="logoutUrl"       value="/logout" />
<%-- <c:url var="watchlistUrl" value="/watchlist" /> --%>
<%-- <c:url var="historialUrl" value="/historial" /> --%>
<c:url var="navbarSearchScriptUrl" value="/js/components/navbar-search.js" />
<spring:message code="navbar.brand" var="brandLabel" />
<spring:message code="navbar.cartelera" var="carteleraLabel" />
<spring:message code="navbar.submitPlay" var="submitPlayLabel" />
<spring:message code="navbar.login" var="loginLabel" />
<spring:message code="navbar.register" var="registerLabel" />
<spring:message code="navbar.profile" var="profileLabel" />
<spring:message code="navbar.logout" var="logoutLabel" />
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
    <a class="navbar-logo" href="${homeUrl}"><c:out value="${brandLabel}" /></a>

    <nav class="navbar-nav" aria-label="Navegación principal">
        <a class="navbar-link ${resolvedActiveSection == 'cartelera' ? 'navbar-link-active' : ''}" href="${carteleraUrl}"><c:out value="${carteleraLabel}" /></a>
        <%-- <a class="navbar-link ${resolvedActiveSection == 'watchlist' ? 'navbar-link-active' : ''}" href="${watchlistUrl}">WATCHLIST</a> --%>
        <%-- <a class="navbar-link ${resolvedActiveSection == 'historial' ? 'navbar-link-active' : ''}" href="${historialUrl}">HISTORIAL</a> --%>
    </nav>

    <div class="navbar-actions">
        <paw:advancedSearch variant="navbar" />
        <div class="navbar-auth">
            <sec:authorize access="isAnonymous()">
                <a class="navbar-auth-link" href="${loginUrl}"><c:out value="${loginLabel}" /></a>
                <paw:button text="${registerLabel}" size="md" cssClass="btn-primary navbar-register-button" href="${registerUrl}" />
            </sec:authorize>
            <sec:authorize access="isAuthenticated()">
                <sec:authentication property="principal.user.email" var="currentUserEmail" />
                <span class="navbar-user-email"><c:out value="${currentUserEmail}" /></span>
                <a class="navbar-auth-link" href="${profileUrl}"><c:out value="${profileLabel}" /></a>
                <paw:button text="${submitPlayLabel}" size="md" cssClass="btn-primary navbar-submit-button" href="${subirObraUrl}" />
                <form action="${logoutUrl}" method="post" class="navbar-logout-form">
                    <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                    <button type="submit" class="navbar-auth-link navbar-logout-button"><c:out value="${logoutLabel}" /></button>
                </form>
            </sec:authorize>
        </div>
    </div>
</header>
<script src="${navbarSearchScriptUrl}" defer></script>
