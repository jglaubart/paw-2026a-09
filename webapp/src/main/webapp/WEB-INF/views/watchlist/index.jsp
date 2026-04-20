<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de obras vistas — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/user-lists.css" />
</head>
<body>

    <paw:navbar activeSection="historial" />

    <c:url var="carteleraUrl" value="/cartelera" />
    <c:set var="seenCount" value="${fn:length(seenObras)}" />
    <c:set var="ratedCount" value="${fn:length(userObraRatings)}" />

    <main class="user-list-page">

        <header class="user-list-header">
            <span class="user-list-kicker">Tu historial</span>
            <h1 class="user-list-title">Obras que ya viste</h1>
            <p class="user-list-subtitle">Repasá tu recorrido y tus puntuaciones. Cuando marcás una obra como vista o la puntuás desde su página, aparece acá automáticamente.</p>
            <c:if test="${seenCount > 0}">
                <div class="user-list-stats" aria-label="Resumen del historial">
                    <span class="user-list-stat">
                        <span class="user-list-stat-value"><c:out value="${seenCount}" /></span>
                        <span class="user-list-stat-label">Vistas</span>
                    </span>
                    <span class="user-list-stat">
                        <span class="user-list-stat-value"><c:out value="${ratedCount}" /></span>
                        <span class="user-list-stat-label">Puntuadas</span>
                    </span>
                </div>
            </c:if>
        </header>

        <c:choose>
            <c:when test="${seenCount > 0}">
                <ul class="user-list-grid" role="list">
                    <c:forEach var="o" items="${seenObras}">
                        <c:url var="obraUrl" value="/obras/${o.id}" />
                        <c:set var="obraRating" value="${userObraRatings[o.id]}" />
                        <li>
                            <a href="${obraUrl}" class="user-list-obra-card">
                                <div class="user-list-obra-info">
                                    <span class="user-list-obra-title"><c:out value="${o.title}" /></span>
                                    <c:if test="${not empty o.genre}">
                                        <span class="user-list-obra-genre"><c:out value="${o.genre}" /></span>
                                    </c:if>
                                </div>
                                <div class="user-list-obra-meta">
                                    <c:if test="${not empty obraRating}">
                                        <span class="user-list-rating" aria-label="Tu puntuación: ${obraRating} sobre 10">
                                            <span class="user-list-rating-star" aria-hidden="true">★</span>
                                            <span class="user-list-rating-value"><c:out value="${obraRating}" /></span>
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
                    <span class="user-list-empty-icon" aria-hidden="true">✓</span>
                    <p class="user-list-empty-text">Todavía no marcaste ninguna obra como vista.</p>
                    <p class="user-list-empty-hint">Cuando veas una obra, marcala o puntuala desde su página y aparecerá acá.</p>
                    <a href="${carteleraUrl}" class="btn btn-primary btn-md">
                        Ver cartelera
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

</body>
</html>
