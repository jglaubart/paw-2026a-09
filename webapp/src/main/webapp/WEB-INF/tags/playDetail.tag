<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="imageUrl" required="false" %>
<%@ attribute name="productionName" required="false" %>
<%@ attribute name="year" required="false" %>
<%@ attribute name="location" required="false" %>
<%@ attribute name="averageRating" required="false" %>
<%@ attribute name="summary" required="false" %>
<%@ attribute name="ticketUrl" required="false" %>
<%@ attribute name="reviewsUrl" required="false" %>
<%@ attribute name="otherEditions" required="false" %>
<%@ attribute name="seen" required="false" type="java.lang.Boolean" %>
<%@ attribute name="inWishlist" required="false" type="java.lang.Boolean" %>
<%@ attribute name="currentlyRunning" required="false" type="java.lang.Boolean" %>
<%@ attribute name="expiringSoon" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:set var="playSeen" value="${seen ne null ? seen : false}" />
<c:set var="playInWishlist" value="${inWishlist ne null ? inWishlist : false}" />
<c:set var="playCurrentlyRunning" value="${currentlyRunning ne null ? currentlyRunning : false}" />
<c:set var="playExpiringSoon" value="${expiringSoon ne null ? expiringSoon : false}" />

<c:if test="${not empty ticketUrl}">
    <c:url var="resolvedTicketUrl" value="${ticketUrl}" />
</c:if>
<c:if test="${not empty reviewsUrl}">
    <c:url var="resolvedReviewsUrl" value="${reviewsUrl}" />
</c:if>

<article class="play-detail">
    <div class="play-detail-poster">
        <c:choose>
            <c:when test="${not empty imageUrl}">
                <img src="${imageUrl}" alt="${fn:escapeXml(title)}" class="play-detail-image" />
            </c:when>
            <c:otherwise>
                <div class="play-detail-placeholder">Sin imagen</div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="play-detail-body">
        <div class="play-detail-heading">
            <div class="play-detail-heading-main">
                <h3 class="play-detail-title"><c:out value="${title}" /></h3>

                <div class="play-detail-meta">
                    <c:if test="${not empty productionName}">
                        <span class="play-detail-meta-item"><c:out value="${productionName}" /></span>
                    </c:if>
                    <c:if test="${not empty year}">
                        <span class="play-detail-meta-item"><c:out value="${year}" /></span>
                    </c:if>
                    <c:if test="${not empty location}">
                        <span class="play-detail-meta-item"><c:out value="${location}" /></span>
                    </c:if>
                </div>

                <c:if test="${not empty averageRating}">
                    <div class="play-detail-rating-row">
                        <div class="play-detail-rating">
                            <span class="play-detail-rating-icon" aria-hidden="true">★</span>
                            <span class="play-detail-rating-label">Rating</span>
                            <span class="play-detail-rating-value"><c:out value="${averageRating}" /> / 10</span>
                        </div>
                        <c:choose>
                            <c:when test="${not empty reviewsUrl}">
                                <a href="${resolvedReviewsUrl}" class="btn btn-md play-detail-reviews-link">Ver opiniones</a>
                            </c:when>
                            <c:otherwise>
                                <paw:button text="Ver opiniones" size="md" cssClass="play-detail-reviews-button" />
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </div>

            <div class="play-detail-statuses">
                <span class="play-detail-status play-detail-status-seen ${playSeen ? 'play-detail-status-active' : 'play-detail-status-inactive'}">
                    <span class="play-detail-status-icon" aria-hidden="true">✓</span>
                    <span>Vista</span>
                </span>
                <span class="play-detail-status play-detail-status-wishlist ${playInWishlist ? 'play-detail-status-active' : 'play-detail-status-inactive'}">
                    <span class="play-detail-status-icon" aria-hidden="true">★</span>
                    <span>Wishlist</span>
                </span>
                <span class="play-detail-status play-detail-status-current ${playCurrentlyRunning ? 'play-detail-status-active' : 'play-detail-status-inactive'}">
                    <span class="play-detail-status-icon" aria-hidden="true">☀</span>
                    <span>En cartelera</span>
                </span>
                <span class="play-detail-status play-detail-status-expiring ${playExpiringSoon ? 'play-detail-status-active' : 'play-detail-status-inactive'}">
                    <span class="play-detail-status-icon" aria-hidden="true">⏱</span>
                    <span>Por vencer</span>
                </span>
            </div>
        </div>

        <c:if test="${not empty summary}">
            <p class="play-detail-summary"><c:out value="${summary}" /></p>
        </c:if>

        <div class="play-detail-actions">
            <c:if test="${not empty ticketUrl}">
                <a href="${resolvedTicketUrl}" class="btn btn-md play-detail-ticket-link">Ver entradas</a>
            </c:if>
            <paw:button text="Calificar obra vista" size="md" cssClass="play-detail-rate-button" />
            <paw:button text="${playInWishlist ? 'Eliminar de la wishlist' : 'Agregar a wishlist'}" size="md" cssClass="play-detail-wishlist-button" />
        </div>
    </div>

    <c:if test="${not empty otherEditions}">
        <details class="play-detail-editions">
            <summary>Ver otras ediciones</summary>
            <div class="play-detail-editions-panel">
                <c:forEach var="editionEntry" items="${fn:split(otherEditions, '~')}">
                    <c:set var="editionParts" value="${fn:split(editionEntry, ';')}" />
                    <button type="button" class="play-detail-edition-button">
                        <span class="play-detail-edition-year"><c:out value="${fn:trim(editionParts[0])}" /></span>
                        <span class="play-detail-edition-production"><c:out value="${fn:trim(editionParts[1])}" /></span>
                        <span class="play-detail-edition-location"><c:out value="${fn:trim(editionParts[2])}" /></span>
                    </button>
                </c:forEach>
            </div>
        </details>
    </c:if>
</article>
