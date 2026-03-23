<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil — Platea</title>

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
        <section style="padding: 2rem; max-width: 900px; margin: 0 auto;">
            <h1>Mi Perfil</h1>
            <p style="color: rgba(255,255,255,0.6);">Usuario de demostración (hardcoded)</p>
        </section>

        <%-- Watchlist --%>
        <c:choose>
            <c:when test="${not empty watchlist}">
                <paw:sectionRow title="Mi Watchlist" subtitle="Producciones que quiero ver">
                    <c:forEach var="p" items="${watchlist}">
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
                <section style="padding: 2rem; max-width: 900px; margin: 0 auto;">
                    <h2>Mi Watchlist</h2>
                    <p style="color: rgba(255,255,255,0.5);">Tu watchlist está vacía. Explorá producciones y agregalas.</p>
                </section>
            </c:otherwise>
        </c:choose>

        <%-- Reseñas --%>
        <section style="padding: 2rem; max-width: 900px; margin: 0 auto;">
            <h2>Mis Reseñas</h2>
            <c:choose>
                <c:when test="${not empty reviews}">
                    <c:forEach var="r" items="${reviews}">
                        <div style="background: rgba(255,255,255,0.04); border-radius: 8px; padding: 1rem; margin-bottom: 1rem; border: 1px solid rgba(255,255,255,0.08);">
                            <p style="color: rgba(255,255,255,0.5); font-size: 0.85rem; margin-bottom: 0.5rem;">
                                <a href="${pageContext.request.contextPath}/obras/${r.obraId}" style="color: #7c3aed;">Obra #<c:out value="${r.obraId}" /></a>
                            </p>
                            <p><c:out value="${r.body}" /></p>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p style="color: rgba(255,255,255,0.5);">No escribiste reseñas todavía.</p>
                </c:otherwise>
            </c:choose>
        </section>
    </main>

</body>
</html>
