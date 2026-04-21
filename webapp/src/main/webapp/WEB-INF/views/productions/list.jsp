<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${available ? 'Cartelera' : 'Catálogo'} — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/production-card.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/production-list-page.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/section-row.css" />
</head>
<body>

    <paw:navbar activeSection="cartelera" />

    <main class="production-list-page">
        <section class="section-row production-list-row">
            <div class="section-row-header">
                <div class="section-row-header-text">
                    <h2 class="section-row-title"><c:out value="${available ? 'Cartelera' : (genre != null ? genre : 'Catálogo')}" /></h2>
                    <p class="section-row-subtitle"><c:out value="${available ? 'Selección en cartel ahora' : 'Todas las obras cargadas'}" /></p>
                </div>
            </div>

            <div class="section-row-cards production-list-row-cards">
                <c:forEach var="card" items="${productionCards}">
                    <c:set var="detailUrl" value="/obras/${card.obraId}?produccionId=${card.representativeProductionId}" />
                    <paw:productionCard
                        title="${fn:escapeXml(card.title)}"
                        imageUrl="${not empty card.imageUrl ? card.imageUrl : '/images/Portadas/hamlet.jpg'}"
                        venue="${fn:escapeXml(card.theaterSummary)}"
                        rating="${productionRatings[card.representativeProductionId]}"
                        detailUrl="${detailUrl}"
                    />
                </c:forEach>
            </div>
        </section>

        <c:if test="${empty productionCards}">
            <section class="production-list-empty">
                <h2>No se encontraron producciones</h2>
            </section>
        </c:if>

    </main>
</body>
</html>
