<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin de peticiones</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/alert.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/play-petitions-admin.css" />
</head>
<body>
<c:url var="heroImageUrl" value="/images/Portadas/hamlet.jpg" />

<paw:navbar />

<section class="petition-admin-hero">
    <div class="petition-admin-hero-backdrop" style="background-image: linear-gradient(90deg, rgba(20,20,20,0.94) 0%, rgba(20,20,20,0.78) 50%, rgba(20,20,20,0.92) 100%), url('${heroImageUrl}');"></div>
    <div class="petition-admin-hero-content">
        <p class="petition-admin-kicker">Developer access</p>
        <h1>Backoffice de peticiones</h1>
        <p class="petition-admin-hero-copy">Un panel interno para revisar postulaciones, detectar faltantes y convertir las aprobadas en contenido publicado sin salir del universo visual de Platea.</p>
        <div class="petition-admin-stats petition-admin-stats-hero">
            <span>Total <strong><c:out value="${totalCount}" /></strong></span>
            <span>Pendientes <strong><c:out value="${pendingCount}" /></strong></span>
            <span>Aprobadas <strong><c:out value="${approvedCount}" /></strong></span>
            <span>Rechazadas <strong><c:out value="${rejectedCount}" /></strong></span>
        </div>
    </div>
</section>

<main class="petition-admin-page">
    <section class="petition-admin-shell">
        <div class="petition-admin-toolbar">
            <div>
                <p class="petition-admin-toolbar-label">Filtro rápido</p>
                <div class="petition-admin-filters">
                    <a class="petition-admin-filter ${selectedStatus eq 'ALL' ? 'petition-admin-filter-active' : ''}" href="${pageContext.request.contextPath}/internal/dev/play-petitions">Todas</a>
                    <a class="petition-admin-filter ${selectedStatus eq 'PENDING' ? 'petition-admin-filter-active' : ''}" href="${pageContext.request.contextPath}/internal/dev/play-petitions?status=PENDING">Pendientes</a>
                    <a class="petition-admin-filter ${selectedStatus eq 'APPROVED' ? 'petition-admin-filter-active' : ''}" href="${pageContext.request.contextPath}/internal/dev/play-petitions?status=APPROVED">Aprobadas</a>
                    <a class="petition-admin-filter ${selectedStatus eq 'REJECTED' ? 'petition-admin-filter-active' : ''}" href="${pageContext.request.contextPath}/internal/dev/play-petitions?status=REJECTED">Rechazadas</a>
                </div>
            </div>
        </div>

        <c:if test="${updated eq 'approved'}">
            <div class="petition-admin-alert">
                <paw:alert variant="success" message="La petición fue aprobada." showClose="false" />
            </div>
        </c:if>
        <c:if test="${updated eq 'rejected'}">
            <div class="petition-admin-alert">
                <paw:alert variant="warning" message="La petición fue rechazada." showClose="false" />
            </div>
        </c:if>
        <c:if test="${error eq 'not_found'}">
            <div class="petition-admin-alert">
                <paw:alert variant="error" message="No encontramos la petición solicitada." showClose="false" />
            </div>
        </c:if>

        <div class="petition-admin-list">
            <c:choose>
                <c:when test="${empty petitions}">
                    <div class="petition-admin-empty">
                        <h2>No hay peticiones para este filtro.</h2>
                        <p>Cuando entren nuevas postulaciones, van a aparecer acá con prioridad visual según su estado.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="petition" items="${petitions}">
                        <c:set var="detailUrl" value="/internal/dev/play-petitions/${petition.id}" />
                        <article class="petition-admin-card">
                            <div class="petition-admin-card-main">
                                <div class="petition-admin-card-head">
                                    <span class="petition-admin-status petition-admin-status-${fn:toLowerCase(petition.status)}"><c:out value="${petition.status}" /></span>
                                    <p class="petition-admin-card-id">Solicitud #<c:out value="${petition.id}" /></p>
                                </div>
                                <h2><c:out value="${petition.title}" /></h2>
                                <p class="petition-admin-card-meta"><c:out value="${petition.petitionerEmail}" /> · <c:out value="${petition.theater}" /></p>
                                <p class="petition-admin-card-copy"><c:out value="${petition.synopsis}" /></p>
                            </div>
                            <div class="petition-admin-card-side">
                                <div class="petition-admin-card-facts">
                                    <span><c:out value="${petition.durationMinutes}" /> min</span>
                                    <span><c:out value="${petition.startDate}" /></span>
                                </div>
                                <a href="${detailUrl}" class="btn btn-md petition-admin-card-link">Revisar</a>
                            </div>
                        </article>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</main>
</body>
</html>
