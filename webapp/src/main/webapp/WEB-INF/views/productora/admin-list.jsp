<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Backoffice — Postulaciones de productora</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/alert.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/productora.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/admin-backoffice.css" />
</head>
<body>

<c:url var="petitionsUrl"   value="/admin/obras" />
<c:url var="productorasUrl" value="/admin/productoras" />
<c:url var="baseUrl"        value="/admin/productoras" />

<paw:navbar />

<main class="prod-dash">

    <header class="prod-dash-header">
        <span class="prod-dash-logo" aria-hidden="true">A</span>
        <div class="prod-dash-header-text">
            <h1 class="prod-dash-title">Backoffice</h1>
            <div class="prod-dash-meta">
                <span class="prod-dash-meta-pill prod-dash-meta-owner">● Administración</span>
            </div>
        </div>
    </header>

    <div class="prod-dash-layout">

        <aside class="prod-dash-sidebar" aria-label="Secciones del backoffice">
            <h4 class="prod-dash-sidebar-section">Revisión</h4>
            <a class="prod-dash-sidebar-item" href="${petitionsUrl}">
                Peticiones de obra
            </a>
            <a class="prod-dash-sidebar-item is-active" href="${productorasUrl}">
                Postulaciones productora
                <span class="prod-dash-sidebar-count"><c:out value="${pendingCount}" /></span>
            </a>
        </aside>

        <section class="prod-dash-content">

            <h2 class="prod-dash-content-title">Cola de revisión · Postulaciones de productora</h2>
            <p class="prod-dash-subtle">Aceptá, rechazá o pedí cambios en las postulaciones para operar como productora en Platea.</p>

            <div class="prod-dash-stats">
                <div class="prod-dash-stat prod-dash-stat-violet">
                    <span class="prod-dash-stat-label">Total en cola</span>
                    <span class="prod-dash-stat-value"><c:out value="${totalCount}" /></span>
                </div>
                <div class="prod-dash-stat prod-dash-stat-amber">
                    <span class="prod-dash-stat-label">Pendientes</span>
                    <span class="prod-dash-stat-value"><c:out value="${pendingCount}" /></span>
                </div>
                <div class="prod-dash-stat prod-dash-stat-violet">
                    <span class="prod-dash-stat-label">Con cambios</span>
                    <span class="prod-dash-stat-value"><c:out value="${changesRequestedCount}" /></span>
                </div>
                <div class="prod-dash-stat prod-dash-stat-amber">
                    <span class="prod-dash-stat-label">Aprobadas</span>
                    <span class="prod-dash-stat-value"><c:out value="${approvedCount}" /></span>
                </div>
            </div>

            <div class="adm-toolbar">
                <div class="adm-tabs">
                    <a class="adm-tab ${selectedStatus == 'ALL' ? 'is-active' : ''}" href="${baseUrl}">
                        Todas
                    </a>
                    <a class="adm-tab ${selectedStatus == 'PENDING' ? 'is-active' : ''}" href="${baseUrl}?status=PENDING">
                        Pendientes <span class="adm-tab-pill"><c:out value="${pendingCount}" /></span>
                    </a>
                    <a class="adm-tab ${selectedStatus == 'APPROVED' ? 'is-active' : ''}" href="${baseUrl}?status=APPROVED">
                        Aprobadas <span class="adm-tab-pill"><c:out value="${approvedCount}" /></span>
                    </a>
                    <a class="adm-tab ${selectedStatus == 'REJECTED' ? 'is-active' : ''}" href="${baseUrl}?status=REJECTED">
                        Rechazadas <span class="adm-tab-pill"><c:out value="${rejectedCount}" /></span>
                    </a>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty requests}">
                    <div class="adm-empty">
                        <h3>No hay postulaciones en este estado.</h3>
                        <p>Cuando lleguen nuevas solicitudes aparecerán acá.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="adm-table-wrap">
                        <table class="adm-data">
                            <thead>
                                <tr>
                                    <th>Productora</th>
                                    <th>CUIT</th>
                                    <th>Contacto</th>
                                    <th>Estado</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${requests}">
                                    <c:url var="detailUrl" value="/admin/productoras/postulaciones/${r.id}" />
                                    <tr onclick="location.href='${detailUrl}'">
                                        <td>
                                            <div class="adm-cell-title"><c:out value="${r.name}" /></div>
                                        </td>
                                        <td class="adm-cell-meta"><c:out value="${r.cuit}" /></td>
                                        <td class="adm-cell-meta"><c:out value="${r.contactEmail}" /></td>
                                        <td>
                                            <span class="adm-status adm-status-${fn:toLowerCase(r.status)}">
                                                <c:choose>
                                                    <c:when test="${r.status eq 'CHANGES_REQUESTED'}">Con cambios</c:when>
                                                    <c:when test="${r.status eq 'PENDING'}">Pendiente</c:when>
                                                    <c:when test="${r.status eq 'APPROVED'}">Aprobada</c:when>
                                                    <c:when test="${r.status eq 'REJECTED'}">Rechazada</c:when>
                                                    <c:otherwise><c:out value="${r.status}" /></c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td><a href="${detailUrl}" class="adm-table-action">Revisar →</a></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>

        </section>
    </div>
</main>

</body>
</html>
