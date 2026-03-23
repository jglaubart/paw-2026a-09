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

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/production-card.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/section-row.css" />
</head>
<body>

    <paw:navbar activeSection="cartelera" />

    <main>
        <paw:sectionRow title="${available ? 'Cartelera' : (genre != null ? genre : 'Catálogo')}" subtitle="${available ? 'Producciones con funciones disponibles' : 'Todas las producciones'}">
            <c:forEach var="p" items="${productions}">
                <c:url var="detailUrl" value="/productions/${p.id}" />
                <paw:productionCard
                    title="${fn:escapeXml(p.name)}"
                    imageUrl="${p.imageId != null ? pageContext.request.contextPath.concat('/images/').concat(p.imageId) : pageContext.request.contextPath.concat('/images/Portadas/hamlet.jpg')}"
                    venue="${fn:escapeXml(p.theater)}"
                    detailUrl="${detailUrl}"
                />
            </c:forEach>
        </paw:sectionRow>

        <c:if test="${empty productions}">
            <section style="padding: 4rem 2rem; text-align: center;">
                <h2>No se encontraron producciones</h2>
            </section>
        </c:if>

        <%-- Paginación simple --%>
        <div style="display: flex; justify-content: center; gap: 1rem; padding: 2rem;">
            <c:if test="${page > 0}">
                <a href="${pageContext.request.contextPath}/productions?page=${page - 1}&available=${available}${genre != null ? '&genre='.concat(fn:escapeXml(genre)) : ''}" class="btn btn-md" style="background: #7c3aed; color: white; text-decoration: none; padding: 0.5rem 1rem; border-radius: 4px;">← Anterior</a>
            </c:if>
            <c:if test="${fn:length(productions) == 8}">
                <a href="${pageContext.request.contextPath}/productions?page=${page + 1}&available=${available}${genre != null ? '&genre='.concat(fn:escapeXml(genre)) : ''}" class="btn btn-md" style="background: #7c3aed; color: white; text-decoration: none; padding: 0.5rem 1rem; border-radius: 4px;">Siguiente →</a>
            </c:if>
        </div>
    </main>

</body>
</html>
