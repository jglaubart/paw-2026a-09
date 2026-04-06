<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${productora.name}" /> — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/production-card.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/productora-detail.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/section-row.css" />
</head>
<body>

    <paw:navbar />

    <c:if test="${not empty productora.imageUrl}">
        <c:url var="productoraImageUrl" value="${productora.imageUrl}" />
    </c:if>
    <c:if test="${not empty productora.instagram}">
        <c:url var="productoraInstagramUrl" value="${productora.instagram}" />
    </c:if>
    <c:if test="${not empty productora.website}">
        <c:url var="productoraWebsiteUrl" value="${productora.website}" />
    </c:if>

    <main class="productora-detail-page">
        <section class="productora-detail-hero">
            <div class="productora-detail-layout">
                <c:if test="${not empty productora.imageUrl}">
                    <img src="${productoraImageUrl}" alt="${fn:escapeXml(productora.name)}" class="productora-detail-image" />
                </c:if>
                <div>
                    <h1 class="productora-detail-name"><c:out value="${productora.name}" /></h1>
                    <c:if test="${productora.bio != null}">
                        <p class="productora-detail-bio"><c:out value="${productora.bio}" /></p>
                    </c:if>
                    <div class="productora-detail-links">
                        <c:if test="${productora.instagram != null}">
                            <a href="${productoraInstagramUrl}" target="_blank" rel="noopener noreferrer" class="productora-detail-link">Instagram</a>
                        </c:if>
                        <c:if test="${productora.website != null}">
                            <a href="${productoraWebsiteUrl}" target="_blank" rel="noopener noreferrer" class="productora-detail-link">Sitio Web</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </section>

        <c:if test="${not empty productions}">
            <paw:sectionRow title="Producciones" subtitle="De ${fn:escapeXml(productora.name)}">
                <c:forEach var="p" items="${productions}">
                    <c:set var="detailUrl" value="/productions/${p.id}" />
                    <paw:productionCard
                        title="${fn:escapeXml(p.name)}"
                        imageUrl="${not empty p.imageUrl ? p.imageUrl : '/images/Portadas/hamlet.jpg'}"
                        venue="${fn:escapeXml(p.theater)}"
                        rating="${productionRatings[p.id]}"
                        detailUrl="${detailUrl}"
                    />
                </c:forEach>
            </paw:sectionRow>
        </c:if>
    </main>

</body>
</html>
