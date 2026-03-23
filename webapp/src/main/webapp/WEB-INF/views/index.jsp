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

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/hero.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/production-card.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/section-row.css" />
</head>
<body>

    <paw:navbar />

    <c:choose>
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
        <c:if test="${not empty availableProductions}">
            <paw:sectionRow title="En Cartelera" subtitle="Producciones con funciones disponibles">
                <c:forEach var="p" items="${availableProductions}">
                    <c:url var="detailUrl" value="/obras/${p.obraId}">
                        <c:param name="produccionId" value="${p.id}" />
                    </c:url>
                    <paw:productionCard
                        title="${fn:escapeXml(p.name)}"
                        imageUrl="${not empty p.imageUrl ? p.imageUrl : pageContext.request.contextPath.concat('/images/Portadas/hamlet.jpg')}"
                        venue="${fn:escapeXml(p.theater)}"
                        detailUrl="${detailUrl}"
                    />
                </c:forEach>
            </paw:sectionRow>
        </c:if>

        <c:if test="${not empty allProductions}">
            <paw:sectionRow title="Catálogo" subtitle="Todas las producciones">
                <c:forEach var="p" items="${allProductions}">
                    <c:url var="detailUrl" value="/obras/${p.obraId}">
                        <c:param name="produccionId" value="${p.id}" />
                    </c:url>
                    <paw:productionCard
                        title="${fn:escapeXml(p.name)}"
                        imageUrl="${not empty p.imageUrl ? p.imageUrl : pageContext.request.contextPath.concat('/images/Portadas/principito.jpg')}"
                        venue="${fn:escapeXml(p.theater)}"
                        detailUrl="${detailUrl}"
                    />
                </c:forEach>
            </paw:sectionRow>
        </c:if>

        <c:if test="${empty availableProductions and empty allProductions}">
            <section style="padding: 4rem 2rem; text-align: center;">
                <h2>No hay producciones cargadas aún</h2>
                <p style="color: rgba(255,255,255,0.6);">Cargá datos en la base de datos para verlos aquí.</p>
            </section>
        </c:if>
    </main>

</body>
</html>
