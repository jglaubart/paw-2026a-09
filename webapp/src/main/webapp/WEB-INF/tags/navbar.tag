<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="activeSection" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<sec:authorize access="hasRole('ADMIN')" var="isAdmin" />

<c:url var="homeUrl"              value="/" />
<c:url var="adminUrl"             value="/admin" />
<c:url var="carteleraUrl"         value="/cartelera" />
<c:url var="watchlistUrl"         value="/watchlist" />
<c:url var="historialUrl"         value="/historial" />
<c:url var="subirObraUrl"         value="/subir-obra" />
<c:url var="loginUrl"             value="/login" />
<c:url var="registerUrl"          value="/register" />
<c:url var="profileUrl"           value="/users/me" />
<c:url var="logoutUrl"            value="/logout" />
<c:url var="navbarSearchScriptUrl" value="/js/components/navbar-search.js" />
<spring:message code="navbar.brand"                      var="brandLabel" />
<spring:message code="navbar.cartelera"                  var="carteleraLabel" />
<spring:message code="navbar.submitPlay"                 var="submitPlayLabel" />
<spring:message code="navbar.login"                      var="loginLabel" />
<spring:message code="navbar.register"                   var="registerLabel" />
<spring:message code="navbar.profile"                    var="profileLabel" />
<spring:message code="navbar.logout"                     var="logoutLabel" />
<spring:message code="navbar.adminObras"                 var="adminObrasLabel" />
<spring:message code="navbar.adminProductoras"           var="adminProductorasLabel" />
<spring:message code="navbar.adminProductorasTooltip"    var="adminProductorasTooltip" />
<c:set var="currentRequestUri" value="${not empty requestScope['javax.servlet.forward.request_uri'] ? requestScope['javax.servlet.forward.request_uri'] : pageContext.request.requestURI}" />
<c:set var="requestPath" value="${fn:substringAfter(currentRequestUri, pageContext.request.contextPath)}" />
<c:set var="resolvedActiveSection" value="${activeSection}" />
<c:if test="${empty resolvedActiveSection}">
    <c:choose>
        <c:when test="${isAdmin and fn:startsWith(requestPath, '/admin')}">
            <c:set var="resolvedActiveSection" value="admin-obras" />
        </c:when>
        <c:when test="${fn:startsWith(requestPath, '/cartelera')}">
            <c:set var="resolvedActiveSection" value="cartelera" />
        </c:when>
        <c:when test="${fn:startsWith(requestPath, '/watchlist')}">
            <c:set var="resolvedActiveSection" value="watchlist" />
        </c:when>
        <c:when test="${fn:startsWith(requestPath, '/historial')}">
            <c:set var="resolvedActiveSection" value="historial" />
        </c:when>
    </c:choose>
</c:if>
<c:set var="logoTargetUrl" value="${isAdmin ? adminUrl : homeUrl}" />
<header class="navbar">
    <a class="navbar-logo" href="${logoTargetUrl}"><c:out value="${brandLabel}" /></a>

    <nav class="navbar-nav" aria-label="Navegación principal">
        <c:choose>
            <c:when test="${isAdmin}">
                <a class="navbar-link ${resolvedActiveSection == 'admin-obras' ? 'navbar-link-active' : ''}" href="${adminUrl}"><c:out value="${adminObrasLabel}" /></a>
                <span class="navbar-link navbar-link-disabled" aria-disabled="true" title="${fn:escapeXml(adminProductorasTooltip)}"><c:out value="${adminProductorasLabel}" /></span>
            </c:when>
            <c:otherwise>
                <a class="navbar-link ${resolvedActiveSection == 'cartelera' ? 'navbar-link-active' : ''}" href="${carteleraUrl}"><c:out value="${carteleraLabel}" /></a>
                <sec:authorize access="isAuthenticated()">
                    <a class="navbar-link ${resolvedActiveSection == 'watchlist' ? 'navbar-link-active' : ''}" href="${watchlistUrl}"><spring:message code="navbar.watchlist" /></a>
                    <a class="navbar-link ${resolvedActiveSection == 'historial' ? 'navbar-link-active' : ''}" href="${historialUrl}"><spring:message code="navbar.historial" /></a>
                </sec:authorize>
            </c:otherwise>
        </c:choose>
    </nav>

    <div class="navbar-actions">
        <c:if test="${not isAdmin}">
            <paw:advancedSearch variant="navbar" />
        </c:if>
        <div class="navbar-auth">
            <sec:authorize access="isAnonymous()">
                <a class="navbar-auth-link" href="${loginUrl}"><c:out value="${loginLabel}" /></a>
                <paw:button text="${registerLabel}" size="md" variant="cta" cssClass="navbar-register-button" href="${registerUrl}" />
            </sec:authorize>
            <sec:authorize access="isAuthenticated()">
                <sec:authentication property="principal.user.username" var="currentUsername" />
                <sec:authentication property="principal.user.email"    var="currentUserEmail" />
                <c:if test="${not isAdmin}">
                    <paw:button text="${submitPlayLabel}" size="md" variant="cta" cssClass="navbar-submit-button" href="${subirObraUrl}" />
                </c:if>
                <div class="navbar-user-menu" id="navbarUserMenu">
                    <button type="button"
                            class="navbar-user-btn"
                            id="navbarAvatarBtn"
                            aria-haspopup="true"
                            aria-expanded="false"
                            aria-label="Menú de usuario"
                            data-username="${fn:escapeXml(currentUsername)}">
                        ${fn:toUpperCase(fn:substring(currentUsername, 0, 1))}
                    </button>
                    <div class="navbar-user-dropdown" id="navbarDropdown" role="menu">
                        <div class="navbar-dropdown-header">
                            <span class="navbar-dropdown-username"><c:out value="${currentUsername}" /></span>
                            <span class="navbar-dropdown-email"><c:out value="${currentUserEmail}" /></span>
                        </div>
                        <div class="navbar-dropdown-list">
                            <c:if test="${not isAdmin}">
                                <a class="navbar-dropdown-item" href="${profileUrl}" role="menuitem">
                                    <c:out value="${profileLabel}" />
                                </a>
                                <div class="navbar-dropdown-divider"></div>
                            </c:if>
                            <form action="${logoutUrl}" method="post" style="margin:0;">
                                <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                                <button type="submit" class="navbar-dropdown-item navbar-dropdown-item-danger" role="menuitem">
                                    <c:out value="${logoutLabel}" />
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </sec:authorize>
        </div>
    </div>
</header>
<script src="${navbarSearchScriptUrl}" defer></script>
<script>
(function () {
    var btn = document.getElementById('navbarAvatarBtn');
    if (!btn) return;

    /* ── avatar color from username hash ── */
    var colors = ['#7c3aed','#2563eb','#0891b2','#059669','#d97706','#dc2626','#db2777','#7c3aed'];
    var name = btn.getAttribute('data-username') || '';
    var hash = 0;
    for (var i = 0; i < name.length; i++) { hash = (hash * 31 + name.charCodeAt(i)) & 0xffffffff; }
    btn.style.background = colors[Math.abs(hash) % colors.length];

    /* ── dropdown toggle ── */
    var dropdown = document.getElementById('navbarDropdown');
    btn.addEventListener('click', function (e) {
        e.stopPropagation();
        var open = dropdown.classList.toggle('is-open');
        btn.setAttribute('aria-expanded', open ? 'true' : 'false');
    });
    document.addEventListener('click', function () {
        dropdown.classList.remove('is-open');
        btn.setAttribute('aria-expanded', 'false');
    });
    dropdown.addEventListener('click', function (e) { e.stopPropagation(); });
})();
</script>
