<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Postulaciones de productora — Admin Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/productora.css" />
</head>
<body>
    <paw:navbar />

    <c:url var="baseUrl" value="/admin/productoras/postulaciones" />

    <main class="productora-admin">
        <header class="productora-admin-header">
            <span class="productora-kicker">Panel admin</span>
            <h1 class="productora-admin-title">Postulaciones de productora</h1>
            <p class="productora-admin-lede">Revisá las solicitudes pendientes y decidí si aceptar, rechazar o pedir cambios.</p>
        </header>

        <nav class="productora-admin-tabs" aria-label="Filtrar por estado">
            <a class="productora-admin-tab ${selectedStatus == 'ALL' ? 'is-active' : ''}" href="${baseUrl}">
                Todas
            </a>
            <a class="productora-admin-tab ${selectedStatus == 'PENDING' ? 'is-active' : ''}" href="${baseUrl}?status=PENDING">
                Pendientes <span class="productora-admin-tab-count"><c:out value="${counts['PENDING']}" /></span>
            </a>
            <a class="productora-admin-tab ${selectedStatus == 'CHANGES_REQUESTED' ? 'is-active' : ''}" href="${baseUrl}?status=CHANGES_REQUESTED">
                Con cambios <span class="productora-admin-tab-count"><c:out value="${counts['CHANGES_REQUESTED']}" /></span>
            </a>
            <a class="productora-admin-tab ${selectedStatus == 'APPROVED' ? 'is-active' : ''}" href="${baseUrl}?status=APPROVED">
                Aprobadas <span class="productora-admin-tab-count"><c:out value="${counts['APPROVED']}" /></span>
            </a>
            <a class="productora-admin-tab ${selectedStatus == 'REJECTED' ? 'is-active' : ''}" href="${baseUrl}?status=REJECTED">
                Rechazadas <span class="productora-admin-tab-count"><c:out value="${counts['REJECTED']}" /></span>
            </a>
        </nav>

        <c:choose>
            <c:when test="${empty requests}">
                <div class="productora-admin-empty">
                    <p>No hay postulaciones en este estado.</p>
                </div>
            </c:when>
            <c:otherwise>
                <ul class="productora-admin-list">
                    <c:forEach var="r" items="${requests}">
                        <c:url var="detailUrl" value="/admin/productoras/postulaciones/${r.id}" />
                        <li>
                            <a href="${detailUrl}" class="productora-admin-row">
                                <div class="productora-admin-row-main">
                                    <span class="productora-admin-row-name"><c:out value="${r.name}" /></span>
                                    <span class="productora-admin-row-meta">
                                        CUIT <c:out value="${r.cuit}" /> · Contacto <c:out value="${r.contactEmail}" />
                                    </span>
                                </div>
                                <span class="productora-admin-row-status productora-history-status-${fn:toLowerCase(r.status)}">
                                    <c:out value="${r.status}" />
                                </span>
                                <span class="productora-admin-row-arrow">→</span>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </c:otherwise>
        </c:choose>
    </main>
</body>
</html>
