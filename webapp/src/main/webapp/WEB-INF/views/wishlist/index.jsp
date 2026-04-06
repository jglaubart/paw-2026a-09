<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/production-card.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/section-row.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/user-lists.css" />
</head>
<body>

    <paw:navbar />

    <c:url var="carteleraUrl" value="/cartelera" />

    <main class="user-list-page">

        <header class="user-list-header">
            <h1 class="user-list-title">Mi Watchlist</h1>
            <p class="user-list-subtitle">Producciones que querés ver</p>
        </header>

        <c:choose>
            <c:when test="${not empty wishlist}">
                <paw:sectionRow title="En tu watchlist" subtitle="${fn:length(wishlist)} produccion${fn:length(wishlist) != 1 ? 'es' : ''}">
                    <c:forEach var="p" items="${wishlist}">
                        <c:set var="detailUrl" value="/obras/${p.obraId}?produccionId=${p.id}" />
                        <paw:productionCard
                            title="${fn:escapeXml(p.name)}"
                            imageUrl="${not empty p.imageUrl ? p.imageUrl : '/images/Portadas/hamlet.jpg'}"
                            venue="${fn:escapeXml(p.theater)}"
                            rating="${productionRatings[p.id]}"
                            detailUrl="${detailUrl}"
                        />
                    </c:forEach>
                </paw:sectionRow>
            </c:when>
            <c:otherwise>
                <div class="user-list-empty">
                    <span class="user-list-empty-icon" aria-hidden="true">♡</span>
                    <p class="user-list-empty-text">Tu watchlist está vacía.</p>
                    <p class="user-list-empty-hint">Explorá la cartelera y agregá producciones que te interesen.</p>
                    <a href="${carteleraUrl}" class="btn btn-primary btn-md">
                        Ver cartelera
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

</body>
</html>
--%>
