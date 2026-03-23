<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="title"       required="true" %>
<%@ attribute name="description" required="false" %>
<%@ attribute name="imageUrl"    required="false" %>
<%@ attribute name="badge"       required="false" %>
<%@ attribute name="rating"      required="false" %>
<%@ attribute name="ticketUrl"   required="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:set var="heroBadge" value="${not empty badge ? badge : 'DESTACADO'}" />
<c:if test="${not empty ticketUrl}">
    <c:url var="resolvedTicketUrl" value="${ticketUrl}" />
</c:if>

<section class="hero">
    <c:if test="${not empty imageUrl}">
        <img class="hero-bg-image"
             src="${imageUrl}"
             alt=""
             aria-hidden="true" />
    </c:if>
    <div class="hero-gradient" aria-hidden="true"></div>

    <div class="hero-body">
        <div class="hero-content">
            <div class="hero-badges">
                <span class="hero-badge hero-badge-featured">
                    <c:out value="${heroBadge}" />
                </span>
                <c:if test="${not empty rating}">
                    <span class="hero-badge hero-badge-rating">
                        <span class="hero-badge-star" aria-hidden="true">★</span>
                        <c:out value="${rating}" />
                    </span>
                </c:if>
            </div>

            <h1 class="hero-title"><c:out value="${title}" /></h1>

            <c:if test="${not empty description}">
                <p class="hero-description"><c:out value="${description}" /></p>
            </c:if>

            <div class="hero-actions">
                <c:choose>
                    <c:when test="${not empty resolvedTicketUrl}">
                        <a href="${resolvedTicketUrl}" class="btn btn-lg btn-primary">
                            Reservar Entradas
                        </a>
                    </c:when>
                    <c:otherwise>
                        <paw:button text="Reservar Entradas" size="lg" cssClass="btn-primary" />
                    </c:otherwise>
                </c:choose>
                <paw:button text="Watch List" size="lg" cssClass="btn-outline" />
            </div>
        </div>

        <div class="hero-nav" aria-label="Navegar entre destacados">
            <paw:button text="←" cssClass="hero-nav-btn" ariaLabel="Producción anterior" />
            <paw:button text="→" cssClass="hero-nav-btn" ariaLabel="Producción siguiente" />
        </div>
    </div>
</section>
