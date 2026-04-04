<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Platea — Descubrí teatro en Buenos Aires</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/hero.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/home-page.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/production-card.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/section-row.css" />
</head>
<body>

    <paw:navbar />

    <c:choose>
        <c:when test="${not empty heroSlides}">
            <paw:hero slides="${heroSlides}" badge="EN ESCENA" />
        </c:when>
        <c:when test="${featuredProduction != null}">
            <c:set var="heroImageUrl" value="${not empty featuredProduction.imageUrl ? featuredProduction.imageUrl : pageContext.request.contextPath.concat('/images/Portadas/hamlet.jpg')}" />
            <paw:hero
                title="${fn:escapeXml(featuredProduction.name)}"
                description="${fn:escapeXml(featuredProduction.synopsis)}"
                imageUrl="${heroImageUrl}"
                badge="DESTACADO"
            />
        </c:when>
        <c:otherwise>
            <paw:hero
                title="Platea"
                description="Descubrí teatro en Buenos Aires"
                imageUrl="${pageContext.request.contextPath}/images/Portadas/hamlet.jpg"
                badge="BIENVENIDO"
            />
        </c:otherwise>
    </c:choose>

    <main>
        <c:if test="${not empty todayProductions}">
            <paw:sectionRow title="Para Hoy" subtitle="Obras con función hoy">
                <c:forEach var="p" items="${todayProductions}">
                    <c:url var="detailUrl" value="/obras/${p.obraId}">
                        <c:param name="produccionId" value="${p.id}" />
                    </c:url>
                    <paw:productionCard
                        title="${fn:escapeXml(p.name)}"
                        imageUrl="${not empty p.imageUrl ? p.imageUrl : pageContext.request.contextPath.concat('/images/Portadas/hamlet.jpg')}"
                        venue="${fn:escapeXml(p.theater)}"
                        rating="${productionRatings[p.id]}"
                        badge="HOY"
                        detailUrl="${detailUrl}"
                    />
                </c:forEach>
            </paw:sectionRow>
        </c:if>

        <c:if test="${not empty availableProductions}">
            <paw:sectionRow title="En Cartelera" subtitle="Obras activas dentro de su periodo">
                <c:forEach var="p" items="${availableProductions}">
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
        </c:if>

        <c:if test="${not empty allProductions}">
            <paw:sectionRow title="Catálogo" subtitle="Todas las obras cargadas, activas o no">
                <c:forEach var="p" items="${allProductions}">
                    <c:url var="detailUrl" value="/obras/${p.obraId}">
                        <c:param name="produccionId" value="${p.id}" />
                    </c:url>
                    <paw:productionCard
                        title="${fn:escapeXml(p.name)}"
                        imageUrl="${not empty p.imageUrl ? p.imageUrl : pageContext.request.contextPath.concat('/images/Portadas/principito.jpg')}"
                        venue="${fn:escapeXml(p.theater)}"
                        rating="${productionRatings[p.id]}"
                        detailUrl="${detailUrl}"
                    />
                </c:forEach>
            </paw:sectionRow>
        </c:if>

        <c:if test="${empty availableProductions and empty allProductions}">
            <section class="home-page-empty">
                <h2>No hay producciones cargadas aún</h2>
                <p class="home-page-empty-text">Cargá datos en la base de datos para verlos aquí.</p>
            </section>
        </c:if>
    </main>

</body>
</html>
