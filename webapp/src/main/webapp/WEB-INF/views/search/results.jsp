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

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/production-card.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/section-row.css" />
</head>
<body>

    <paw:navbar />

    <main>
        <%-- Search form --%>
        <section style="padding: 2rem; max-width: 900px; margin: 0 auto;">
            <h1>Buscar Producciones</h1>
            <form action="${pageContext.request.contextPath}/search" method="get" style="display: flex; gap: 0.5rem; flex-wrap: wrap; margin-top: 1rem;">
                <input type="text" name="q" value="${fn:escapeXml(query)}" placeholder="Buscar por nombre, obra, productora, teatro..."
                       style="flex: 1; min-width: 200px; background: rgba(255,255,255,0.08); color: white; border: 1px solid rgba(255,255,255,0.15); border-radius: 4px; padding: 0.6rem;" />
                <select name="genre" style="background: rgba(255,255,255,0.08); color: white; border: 1px solid rgba(255,255,255,0.15); border-radius: 4px; padding: 0.6rem;">
                    <option value="">Todos los géneros</option>
                    <option value="Drama" ${genre == 'Drama' ? 'selected' : ''}>Drama</option>
                    <option value="Comedia" ${genre == 'Comedia' ? 'selected' : ''}>Comedia</option>
                    <option value="Musical" ${genre == 'Musical' ? 'selected' : ''}>Musical</option>
                    <option value="Tragedia" ${genre == 'Tragedia' ? 'selected' : ''}>Tragedia</option>
                    <option value="Infantil" ${genre == 'Infantil' ? 'selected' : ''}>Infantil</option>
                </select>
                <label style="display: flex; align-items: center; gap: 0.3rem; color: rgba(255,255,255,0.7);">
                    <input type="checkbox" name="available" value="true" ${available ? 'checked' : ''} />
                    Solo disponibles
                </label>
                <button type="submit" class="btn btn-md" style="background: #7c3aed; color: white; border: none; cursor: pointer; padding: 0.6rem 1.2rem; border-radius: 4px;">Buscar</button>
            </form>
        </section>

        <%-- Results --%>
        <c:choose>
            <c:when test="${not empty results}">
                <paw:sectionRow title="Resultados" subtitle="${fn:length(results)} producciones encontradas">
                    <c:forEach var="p" items="${results}">
                        <c:url var="detailUrl" value="/obras/${p.obraId}">
                            <c:param name="produccionId" value="${p.id}" />
                        </c:url>
                        <paw:productionCard
                            title="${fn:escapeXml(p.name)}"
                            imageUrl="${p.imageId != null ? pageContext.request.contextPath.concat('/images/').concat(p.imageId) : pageContext.request.contextPath.concat('/images/Portadas/hamlet.jpg')}"
                            venue="${fn:escapeXml(p.theater)}"
                            detailUrl="${detailUrl}"
                        />
                    </c:forEach>
                </paw:sectionRow>
            </c:when>
            <c:otherwise>
                <section style="padding: 4rem 2rem; text-align: center;">
                    <h2>No se encontraron resultados</h2>
                    <p style="color: rgba(255,255,255,0.5);">Intentá con otra búsqueda o cambiá los filtros.</p>
                </section>
            </c:otherwise>
        </c:choose>

        <%-- Paginación --%>
        <div style="display: flex; justify-content: center; gap: 1rem; padding: 2rem;">
            <c:if test="${page > 0}">
                <a href="${pageContext.request.contextPath}/search?q=${fn:escapeXml(query)}&genre=${fn:escapeXml(genre)}&available=${available}&page=${page - 1}" class="btn btn-md" style="background: #7c3aed; color: white; text-decoration: none; padding: 0.5rem 1rem; border-radius: 4px;">← Anterior</a>
            </c:if>
            <c:if test="${fn:length(results) == 12}">
                <a href="${pageContext.request.contextPath}/search?q=${fn:escapeXml(query)}&genre=${fn:escapeXml(genre)}&available=${available}&page=${page + 1}" class="btn btn-md" style="background: #7c3aed; color: white; text-decoration: none; padding: 0.5rem 1rem; border-radius: 4px;">Siguiente →</a>
            </c:if>
        </div>
    </main>

</body>
</html>
