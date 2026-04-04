<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

    <c:url var="previousPageUrl" value="/productions">
        <c:param name="page" value="${page - 1}" />
        <c:param name="available" value="${available}" />
        <c:if test="${not empty genre}">
            <c:param name="genre" value="${genre}" />
        </c:if>
    </c:url>
    <c:url var="nextPageUrl" value="/productions">
        <c:param name="page" value="${page + 1}" />
        <c:param name="available" value="${available}" />
        <c:if test="${not empty genre}">
            <c:param name="genre" value="${genre}" />
        </c:if>
    </c:url>

    <main>
        <paw:sectionRow title="${available ? 'Cartelera' : (genre != null ? genre : 'Catálogo')}" subtitle="${available ? 'Obras activas dentro de su periodo' : 'Todas las obras cargadas'}">
            <c:forEach var="p" items="${productions}">
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

        <c:if test="${empty productions}">
            <section class="production-list-empty">
                <h2>No se encontraron producciones</h2>
            </section>
        </c:if>

        <%-- Paginación simple --%>
        <div class="production-list-pagination">
            <c:if test="${page > 0}">
                <a href="${previousPageUrl}" class="btn btn-primary btn-md production-list-pagination-link">← Anterior</a>
            </c:if>
            <c:if test="${fn:length(productions) == 8}">
                <a href="${nextPageUrl}" class="btn btn-primary btn-md production-list-pagination-link">Siguiente →</a>
            </c:if>
        </div>
    </main>

</body>
</html>
