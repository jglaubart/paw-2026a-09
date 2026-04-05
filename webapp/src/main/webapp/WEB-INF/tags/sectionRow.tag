<%@ tag language="java" pageEncoding="UTF-8" body-content="scriptless" %>
<%@ attribute name="title"    required="true" %>
<%@ attribute name="subtitle" required="false" %>
<%@ attribute name="cssClass" required="false" %>
<%@ attribute name="railNavigation" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:set var="resolvedCssClass" value="${not empty cssClass ? cssClass : ''}" />
<c:set var="hasRailNavigation" value="${railNavigation ne null ? railNavigation : false}" />

<section class="section-row ${resolvedCssClass} ${hasRailNavigation ? 'section-row-rail' : ''}" data-production-rail="${hasRailNavigation}">
    <div class="section-row-header">
        <div class="section-row-header-text">
            <h2 class="section-row-title"><c:out value="${title}" /></h2>
            <c:if test="${not empty subtitle}">
                <p class="section-row-subtitle"><c:out value="${subtitle}" /></p>
            </c:if>
        </div>
    </div>
    <c:choose>
        <c:when test="${hasRailNavigation}">
            <div class="section-row-rail-shell">
                <button type="button" class="section-row-rail-btn section-row-rail-btn-prev" data-rail-prev aria-label="Mostrar obras anteriores">
                    <span aria-hidden="true">←</span>
                </button>
                <div class="section-row-cards">
                    <jsp:doBody />
                </div>
                <button type="button" class="section-row-rail-btn section-row-rail-btn-next" data-rail-next aria-label="Mostrar más obras">
                    <span aria-hidden="true">→</span>
                </button>
            </div>
        </c:when>
        <c:otherwise>
            <div class="section-row-cards">
                <jsp:doBody />
            </div>
        </c:otherwise>
    </c:choose>
</section>
