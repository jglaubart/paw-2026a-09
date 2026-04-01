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

    <c:url var="previousPageUrl" value="/search">
        <c:if test="${not empty query}">
            <c:param name="q" value="${query}" />
        </c:if>
        <c:if test="${not empty genre}">
            <c:param name="genre" value="${genre}" />
        </c:if>
        <c:if test="${not empty theater}">
            <c:param name="theater" value="${theater}" />
        </c:if>
        <c:if test="${not empty location}">
            <c:param name="location" value="${location}" />
        </c:if>
        <c:if test="${not empty dateFrom}">
            <c:param name="dateFrom" value="${dateFrom}" />
        </c:if>
        <c:if test="${not empty dateTo}">
            <c:param name="dateTo" value="${dateTo}" />
        </c:if>
        <c:if test="${available}">
            <c:param name="available" value="true" />
        </c:if>
        <c:param name="page" value="${page - 1}" />
    </c:url>
    <c:url var="nextPageUrl" value="/search">
        <c:if test="${not empty query}">
            <c:param name="q" value="${query}" />
        </c:if>
        <c:if test="${not empty genre}">
            <c:param name="genre" value="${genre}" />
        </c:if>
        <c:if test="${not empty theater}">
            <c:param name="theater" value="${theater}" />
        </c:if>
        <c:if test="${not empty location}">
            <c:param name="location" value="${location}" />
        </c:if>
        <c:if test="${not empty dateFrom}">
            <c:param name="dateFrom" value="${dateFrom}" />
        </c:if>
        <c:if test="${not empty dateTo}">
            <c:param name="dateTo" value="${dateTo}" />
        </c:if>
        <c:if test="${available}">
            <c:param name="available" value="true" />
        </c:if>
        <c:param name="page" value="${page + 1}" />
    </c:url>

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
                <c:if test="${not empty dateFrom}">
                    <span class="search-results-chip">Desde: <c:out value="${dateFrom}" /></span>
                </c:if>
                <c:if test="${not empty dateTo}">
                    <span class="search-results-chip">Hasta: <c:out value="${dateTo}" /></span>
                </c:if>
                <c:if test="${available}">
                    <span class="search-results-chip">Solo disponibles</span>
                </c:if>
            </div>

            <c:if test="${not empty dateRangeError}">
                <p class="search-results-error"><c:out value="${dateRangeError}" /></p>
            </c:if>
        </section>

        <c:choose>
            <c:when test="${not empty results}">
                <paw:sectionRow title="Resultados" subtitle="${fn:length(results)} producciones encontradas">
                    <c:forEach var="p" items="${results}">
                        <c:url var="detailUrl" value="/obras/${p.obraId}">
                            <c:param name="produccionId" value="${p.id}" />
                        </c:url>
                        <paw:productionCard
                            title="${fn:escapeXml(p.name)}"
                            imageUrl="${not empty p.imageUrl ? p.imageUrl : pageContext.request.contextPath.concat('/images/Portadas/hamlet.jpg')}"
                            venue="${fn:escapeXml(p.theater)}"
                            rating="${productionRatings[p.id]}"
                            detailUrl="${detailUrl}"
                        />
                    </c:forEach>
                </paw:sectionRow>
            </c:when>
            <c:when test="${not empty dateRangeError}">
                <section class="search-results-empty">
                    <h2>Corregí el rango de fechas</h2>
                    <p class="search-results-empty-text">Ajustá las fechas para poder ver resultados.</p>
                </section>
            </c:when>
            <c:otherwise>
                <section class="search-results-empty">
                    <h2>No se encontraron resultados</h2>
                    <p class="search-results-empty-text">Intentá con otra búsqueda o cambiá los filtros.</p>
                </section>
            </c:otherwise>
        </c:choose>

        <div class="search-results-pagination">
            <c:if test="${page > 0}">
                <a href="${previousPageUrl}" class="btn btn-primary btn-md search-results-link">← Anterior</a>
            </c:if>
            <c:if test="${fn:length(results) == 12}">
                <a href="${nextPageUrl}" class="btn btn-primary btn-md search-results-link">Siguiente →</a>
            </c:if>
        </div>
    </main>

</body>
</html>
