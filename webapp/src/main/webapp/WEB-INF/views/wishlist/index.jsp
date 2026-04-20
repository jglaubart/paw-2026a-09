<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Watchlist — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/user-lists.css" />
</head>
<body>

    <paw:navbar activeSection="watchlist" />

    <c:url var="carteleraUrl" value="/cartelera" />
    <c:set var="wishlistCount" value="${fn:length(wishlist)}" />

    <main class="user-list-page">

        <header class="user-list-header">
            <span class="user-list-kicker">Tu watchlist</span>
            <h1 class="user-list-title">Producciones que querés ver</h1>
            <p class="user-list-subtitle">Guardá acá las producciones que te interesan. Cuando marques una como vista, va a pasar a tu historial automáticamente.</p>
            <c:if test="${wishlistCount > 0}">
                <div class="user-list-stats" aria-label="Resumen de la watchlist">
                    <span class="user-list-stat">
                        <span class="user-list-stat-value"><c:out value="${wishlistCount}" /></span>
                        <span class="user-list-stat-label">Guardadas</span>
                    </span>
                </div>
            </c:if>
        </header>

        <c:choose>
            <c:when test="${wishlistCount > 0}">
                <ul class="user-list-grid" role="list">
                    <c:forEach var="p" items="${wishlist}">
                        <c:url var="detailUrl" value="/obras/${p.obraId}?produccionId=${p.id}" />
                        <c:set var="prodRating" value="${productionRatings[p.id]}" />
                        <li>
                            <a href="${detailUrl}" class="user-list-obra-card">
                                <div class="user-list-obra-info">
                                    <span class="user-list-obra-title"><c:out value="${p.name}" /></span>
                                    <c:if test="${not empty p.theater}">
                                        <span class="user-list-obra-genre"><c:out value="${p.theater}" /></span>
                                    </c:if>
                                </div>
                                <div class="user-list-obra-meta">
                                    <c:if test="${not empty prodRating and prodRating ne 'N/A'}">
                                        <span class="user-list-rating" aria-label="Puntuación promedio: ${prodRating} sobre 10">
                                            <span class="user-list-rating-star" aria-hidden="true">★</span>
                                            <span class="user-list-rating-value"><c:out value="${prodRating}" /></span>
                                            <span class="user-list-rating-scale" aria-hidden="true">/ 10</span>
                                        </span>
                                    </c:if>
                                    <span class="user-list-obra-cta" aria-hidden="true">
                                        Ver detalle
                                        <span class="user-list-obra-cta-arrow">→</span>
                                    </span>
                                </div>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <div class="user-list-empty">
                    <span class="user-list-empty-icon" aria-hidden="true">♡</span>
                    <p class="user-list-empty-text">Tu watchlist está vacía.</p>
                    <p class="user-list-empty-hint">Explorá la cartelera y agregá producciones que te interesen para seguirlas desde acá.</p>
                    <a href="${carteleraUrl}" class="btn btn-primary btn-md">
                        Ver cartelera
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

</body>
</html>
