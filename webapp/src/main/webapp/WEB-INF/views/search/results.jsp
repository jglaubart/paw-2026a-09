<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buscar — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/production-card.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search-results-page.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/section-row.css" />
</head>
<body>

    <paw:navbar />

    <c:set var="previousPageUrl" value="/search?q=${query}&genre=${genre}&theater=${theater}&location=${location}&date=${date}&available=true&page=${page - 1}" />
    <c:set var="nextPageUrl" value="/search?q=${query}&genre=${genre}&theater=${theater}&location=${location}&date=${date}&available=true&page=${page + 1}" />

    <main class="search-results-page">
        <section class="search-results-filters">
            <p class="search-results-kicker">Busqueda</p>
            <h1 class="search-results-title">Resultados</h1>
            <p class="search-results-copy">Ajustá texto y filtros desde la barra superior.</p>

            <div class="search-results-active-filters">
                <c:if test="${not empty query}">
                    <span class="search-results-chip">Texto: <c:out value="${query}" /></span>
                </c:if>
                <c:if test="${not empty genre}">
                    <span class="search-results-chip">Género: <c:out value="${genre}" /></span>
                </c:if>
                <c:if test="${not empty theater}">
                    <span class="search-results-chip">Sala: <c:out value="${theater}" /></span>
                </c:if>
                <c:if test="${not empty location}">
                    <span class="search-results-chip">Zona: <c:out value="${location}" /></span>
                </c:if>
                <c:if test="${not empty date}">
                    <span class="search-results-chip">Fecha: <c:out value="${date}" /></span>
                </c:if>
                <c:if test="${available}">
                    <span class="search-results-chip">Solo disponibles</span>
                </c:if>
            </div>

            <c:if test="${empty resultCards and not empty nearbyDates}">
                <section class="search-results-nearby" aria-label="Fechas cercanas">
                    <div class="search-results-nearby-head">
                        <p class="search-results-nearby-kicker">Otras fechas</p>
                        <p class="search-results-nearby-copy">No hay funciones ese día, pero estas fechas cercanas sí tienen opciones.</p>
                    </div>

                    <div class="search-results-nearby-list">
                        <c:forEach var="dateOption" items="${nearbyDates}">
                            <c:set var="nearbyDateUrl" value="/search?q=${query}&genre=${genre}&theater=${theater}&location=${location}&available=true&date=${dateOption.date}" />

                            <a href="${nearbyDateUrl}" class="search-results-nearby-option search-results-nearby-option-link">
                                <span class="search-results-nearby-date"><c:out value="${dateOption.date}" /></span>
                                <span class="search-results-nearby-count"><c:out value="${dateOption.productionCount}" /> obras</span>
                            </a>
                        </c:forEach>
                    </div>
                </section>
            </c:if>
        </section>

        <c:choose>
            <c:when test="${not empty resultCards}">
                <paw:sectionRow title="Resultados" subtitle="${fn:length(resultCards)} obras encontradas">
                    <c:forEach var="card" items="${resultCards}">
                        <c:set var="detailUrl" value="/obras/${card.obraId}?produccionId=${card.representativeProductionId}" />
                        <paw:productionCard
                            title="${fn:escapeXml(card.title)}"
                            imageUrl="${not empty card.imageUrl ? card.imageUrl : '/images/Portadas/hamlet.jpg'}"
                            venue="${fn:escapeXml(card.theaterSummary)}"
                            rating="${productionRatings[card.representativeProductionId]}"
                            detailUrl="${detailUrl}"
                        />
                    </c:forEach>
                </paw:sectionRow>
            </c:when>
            <c:otherwise>
                <section class="search-results-empty">
                    <c:choose>
                        <c:when test="${not empty date}">
                            <h2>No encontramos funciones para esa fecha</h2>
                            <c:choose>
                                <c:when test="${not empty nearbyDates}">
                                    <p class="search-results-empty-text">Probá con una de las fechas cercanas que sí tienen funciones.</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="search-results-empty-text">Intentá con otra fecha o cambiá los demás filtros.</p>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <h2>No se encontraron resultados</h2>
                            <p class="search-results-empty-text">Intentá con otra búsqueda o cambiá los filtros.</p>
                        </c:otherwise>
                    </c:choose>
                </section>
            </c:otherwise>
        </c:choose>

        <div class="search-results-pagination">
            <c:if test="${page > 0}">
                <a href="${previousPageUrl}" class="btn btn-primary btn-md search-results-link">← Anterior</a>
            </c:if>
            <c:if test="${fn:length(resultCards) == 12}">
                <a href="${nextPageUrl}" class="btn btn-primary btn-md search-results-link">Siguiente →</a>
            </c:if>
        </div>
    </main>

</body>
</html>
