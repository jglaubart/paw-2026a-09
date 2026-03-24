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

    <c:url var="searchUrl" value="/search" />
    <c:url var="previousPageUrl" value="/search">
        <c:if test="${not empty query}">
            <c:param name="q" value="${query}" />
        </c:if>
        <c:if test="${not empty genre}">
            <c:param name="genre" value="${genre}" />
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
        <c:if test="${available}">
            <c:param name="available" value="true" />
        </c:if>
        <c:param name="page" value="${page + 1}" />
    </c:url>

    <main class="search-results-page">
        <section class="search-results-filters">
            <h1 class="search-results-title">Buscar Producciones</h1>
            <form action="${searchUrl}" method="get" class="search-results-form">
                <input type="text" name="q" value="${fn:escapeXml(query)}" placeholder="Buscar por nombre, obra, productora, teatro..."
                       class="search-results-input" />
                <select name="genre" class="search-results-select">
                    <option value="">Todos los géneros</option>
                    <option value="Drama" ${genre == 'Drama' ? 'selected' : ''}>Drama</option>
                    <option value="Comedia" ${genre == 'Comedia' ? 'selected' : ''}>Comedia</option>
                    <option value="Musical" ${genre == 'Musical' ? 'selected' : ''}>Musical</option>
                    <option value="Tragedia" ${genre == 'Tragedia' ? 'selected' : ''}>Tragedia</option>
                    <option value="Infantil" ${genre == 'Infantil' ? 'selected' : ''}>Infantil</option>
                </select>
                <label class="search-results-toggle">
                    <input type="checkbox" name="available" value="true" ${available ? 'checked' : ''} />
                    Solo disponibles
                </label>
                <button type="submit" class="btn btn-primary btn-md search-results-submit">Buscar</button>
            </form>
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
