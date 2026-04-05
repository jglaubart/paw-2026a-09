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

    <c:url var="productionListScriptUrl" value="/js/components/production-list-navigation.js" />

    <main class="production-list-page">
        <section class="section-row production-list-row" data-production-rail>
            <div class="section-row-header">
                <div class="section-row-header-text">
                    <h2 class="section-row-title"><c:out value="${available ? 'Cartelera' : (genre != null ? genre : 'Catálogo')}" /></h2>
                    <p class="section-row-subtitle"><c:out value="${available ? 'Selección en cartel ahora' : 'Todas las obras cargadas'}" /></p>
                </div>
            </div>

            <div class="production-list-row-shell">
                <button type="button" class="production-list-rail-btn production-list-rail-btn-prev" data-rail-prev aria-label="Mostrar funciones anteriores">
                    <span aria-hidden="true">←</span>
                </button>

                <div class="section-row-cards production-list-row-cards">
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
                </div>

                <button type="button" class="production-list-rail-btn production-list-rail-btn-next" data-rail-next aria-label="Mostrar más funciones">
                    <span aria-hidden="true">→</span>
                </button>
            </div>
        </section>

        <c:if test="${empty productions}">
            <section class="production-list-empty">
                <h2>No se encontraron producciones</h2>
            </section>
        </c:if>

    </main>

    <script src="${productionListScriptUrl}" defer></script>
</body>
</html>
