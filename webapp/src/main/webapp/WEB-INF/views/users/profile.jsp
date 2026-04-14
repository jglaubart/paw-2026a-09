<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="profile.pageTitle" /></title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/production-card.css" /> --%>
    <%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/section-row.css" /> --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/user-profile.css" />
</head>
<body>

    <paw:navbar />

    <%-- <c:url var="carteleraUrl" value="/cartelera" /> --%>

    <main class="user-profile-page">
        <section class="user-profile-header">
            <h1 class="user-profile-title"><spring:message code="profile.title" /></h1>
            <p class="user-profile-subtitle"><c:out value="${currentUserEmail}" /></p>
        </section>

        <%--
        Watchlist temporalmente deshabilitada para este sprint.

        <c:choose>
            <c:when test="${not empty watchlist}">
                <paw:sectionRow title="Mi Watchlist" subtitle="Producciones que quiero ver">
                    <c:forEach var="p" items="${watchlist}">
                        <c:set var="detailUrl" value="/obras/${p.obraId}?produccionId=${p.id}" />
                        <paw:productionCard
                            title="${fn:escapeXml(p.name)}"
                            imageUrl="${not empty p.imageUrl ? p.imageUrl : '/images/Portadas/hamlet.jpg'}"
                            venue="${fn:escapeXml(p.theater)}"
                            rating="${productionRatings[p.id]}"
                            detailUrl="${detailUrl}"
                        />
                    </c:forEach>
                </paw:sectionRow>
            </c:when>
            <c:otherwise>
                <section class="user-profile-section">
                    <h2>Mi Watchlist</h2>
                    <p class="user-profile-empty-text">Tu watchlist está vacía. Explorá producciones y agregalas.</p>
                    <a href="${carteleraUrl}" class="btn btn-primary btn-md">Ver cartelera</a>
                </section>
            </c:otherwise>
        </c:choose>
        --%>

        <section class="user-profile-section">
            <h2><spring:message code="profile.reviews.title" /></h2>
            <c:choose>
                <c:when test="${not empty reviews}">
                    <c:forEach var="r" items="${reviews}">
                        <c:url var="reviewObraUrl" value="/obras/${r.obraId}" />
                        <div class="user-profile-review-card">
                            <c:if test="${r.productionImageId != null}">
                                <c:url var="reviewImgUrl" value="/images/${r.productionImageId}" />
                                <a href="${reviewObraUrl}" class="user-profile-review-img-link">
                                    <img class="user-profile-review-img" src="${reviewImgUrl}" alt="${fn:escapeXml(r.obraTitle)}" />
                                </a>
                            </c:if>
                            <div class="user-profile-review-content">
                                <a href="${reviewObraUrl}" class="user-profile-review-link">
                                    <c:out value="${not empty r.obraTitle ? r.obraTitle : 'Ver obra'}" />
                                </a>
                                <p class="user-profile-review-body"><c:out value="${r.body}" /></p>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="user-profile-no-reviews"><spring:message code="profile.reviews.empty" /></p>
                </c:otherwise>
            </c:choose>
        </section>
    </main>

</body>
</html>
