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
        <c:if test="${not empty date}">
            <c:param name="date" value="${date}" />
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
        <c:if test="${not empty date}">
            <c:param name="date" value="${date}" />
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
                <c:if test="${not empty date}">
                    <span class="search-results-chip">Fecha: <c:out value="${date}" /></span>
                </c:if>
                <c:if test="${available}">
                    <span class="search-results-chip">Solo disponibles</span>
                </c:if>
            </div>

            <c:if test="${not empty date}">
                <section class="search-results-nearby" aria-label="Fechas cercanas">
                    <div class="search-results-nearby-head">
                        <p class="search-results-nearby-kicker">Fechas cercanas</p>
                        <p class="search-results-nearby-copy">Mostramos tu fecha elegida y opciones hasta 3 días antes o después.</p>
                    </div>

                    <div class="search-results-nearby-list">
                        <c:forEach var="dateOption" items="${nearbyDates}">
                            <c:url var="nearbyDateUrl" value="/search">
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
                                <c:if test="${available}">
                                    <c:param name="available" value="true" />
                                </c:if>
                                <c:param name="date" value="${dateOption.date}" />
                            </c:url>

                            <c:choose>
                                <c:when test="${dateOption.date eq date}">
                                    <span class="search-results-nearby-option search-results-nearby-option-selected">
                                        <span class="search-results-nearby-date"><c:out value="${dateOption.date}" /></span>
                                        <span class="search-results-nearby-count"><c:out value="${dateOption.productionCount}" /> producciones</span>
                                    </span>
                                </c:when>
                                <c:when test="${dateOption.productionCount > 0}">
                                    <a href="${nearbyDateUrl}" class="search-results-nearby-option search-results-nearby-option-link">
                                        <span class="search-results-nearby-date"><c:out value="${dateOption.date}" /></span>
                                        <span class="search-results-nearby-count"><c:out value="${dateOption.productionCount}" /> producciones</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="search-results-nearby-option search-results-nearby-option-disabled">
                                        <span class="search-results-nearby-date"><c:out value="${dateOption.date}" /></span>
                                        <span class="search-results-nearby-count">Sin funciones</span>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </section>
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
            <c:otherwise>
                <section class="search-results-empty">
                    <c:choose>
                        <c:when test="${not empty date}">
                            <h2>No encontramos funciones para esa fecha</h2>
                            <p class="search-results-empty-text">Probá con una fecha cercana o cambiá los demás filtros.</p>
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
            <c:if test="${fn:length(results) == 12}">
                <a href="${nextPageUrl}" class="btn btn-primary btn-md search-results-link">Siguiente →</a>
            </c:if>
        </div>
    </main>

</body>
</html>
