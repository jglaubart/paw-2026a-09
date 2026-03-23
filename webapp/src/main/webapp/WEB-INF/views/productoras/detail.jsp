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
            <div style="display: flex; gap: 2rem; align-items: flex-start; flex-wrap: wrap;">
                <c:if test="${not empty productora.imageUrl}">
                    <img src="${fn:escapeXml(productora.imageUrl)}" alt="${fn:escapeXml(productora.name)}" style="width: 150px; height: 150px; border-radius: 50%; object-fit: cover;" />
                </c:if>
                <div>
                    <h1><c:out value="${productora.name}" /></h1>
                    <c:if test="${productora.bio != null}">
                        <p style="color: rgba(255,255,255,0.8); margin-top: 0.5rem;"><c:out value="${productora.bio}" /></p>
                    </c:if>
                    <div style="display: flex; gap: 1rem; margin-top: 1rem;">
                        <c:if test="${productora.instagram != null}">
                            <a href="${fn:escapeXml(productora.instagram)}" target="_blank" style="color: #7c3aed;">Instagram</a>
                        </c:if>
                        <c:if test="${productora.website != null}">
                            <a href="${fn:escapeXml(productora.website)}" target="_blank" style="color: #7c3aed;">Sitio Web</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </section>

        <c:if test="${not empty productions}">
            <paw:sectionRow title="Producciones" subtitle="De ${fn:escapeXml(productora.name)}">
                <c:forEach var="p" items="${productions}">
                    <c:url var="detailUrl" value="/productions/${p.id}" />
                    <paw:productionCard
                        title="${fn:escapeXml(p.name)}"
                        imageUrl="${not empty p.imageUrl ? p.imageUrl : pageContext.request.contextPath.concat('/images/Portadas/hamlet.jpg')}"
                        venue="${fn:escapeXml(p.theater)}"
                        detailUrl="${detailUrl}"
                    />
                </c:forEach>
            </paw:sectionRow>
        </c:if>
    </main>

</body>
</html>
