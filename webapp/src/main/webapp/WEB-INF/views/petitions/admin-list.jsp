<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Backoffice — Peticiones de obras</title>
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

<c:url var="petitionsUrl"      value="/admin/obras" />
<c:url var="productorasUrl"    value="/admin/productoras" />
<c:url var="filterAllUrl"      value="/admin/obras" />
<c:url var="filterPendingUrl"  value="/admin/obras?status=PENDING" />
<c:url var="filterApprovedUrl" value="/admin/obras?status=APPROVED" />

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
            <a class="prod-dash-sidebar-item is-active" href="${petitionsUrl}">
                Peticiones de obra
                <span class="prod-dash-sidebar-count"><c:out value="${pendingCount}" /></span>
            </a>
            <a class="prod-dash-sidebar-item" href="${productorasUrl}">
                Postulaciones productora
            </a>
        </aside>

        <section class="prod-dash-content">

            <c:if test="${updated eq 'approved'}">
                <div class="adm-alert"><paw:alert variant="success" message="La petición fue aprobada." showClose="false" /></div>
            </c:if>
            <c:if test="${updated eq 'changes_requested'}">
                <div class="adm-alert"><paw:alert variant="warning" message="Se solicitaron cambios." showClose="false" /></div>
            </c:if>
            <c:if test="${error eq 'not_found'}">
                <div class="adm-alert"><paw:alert variant="error" message="No encontramos la petición solicitada." showClose="false" /></div>
            </c:if>

            <h2 class="prod-dash-content-title">Cola de revisión · Peticiones de obra</h2>
            <p class="prod-dash-subtle">Decidí qué peticiones se convierten en obras publicadas. Usá flagging por campo para dejar feedback preciso.</p>

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
                    <a class="adm-tab ${selectedStatus eq 'ALL' ? 'is-active' : ''}" href="${filterAllUrl}">
                        Todas <span class="adm-tab-pill"><c:out value="${totalCount}" /></span>
                    </a>
                    <a class="adm-tab ${selectedStatus eq 'PENDING' ? 'is-active' : ''}" href="${filterPendingUrl}">
                        Pendientes <span class="adm-tab-pill"><c:out value="${pendingCount}" /></span>
                    </a>
                    <a class="adm-tab ${selectedStatus eq 'APPROVED' ? 'is-active' : ''}" href="${filterApprovedUrl}">
                        Aprobadas <span class="adm-tab-pill"><c:out value="${approvedCount}" /></span>
                    </a>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty petitions}">
                    <div class="adm-empty">
                        <h3>No hay peticiones para este filtro.</h3>
                        <p>Cuando entren nuevas postulaciones aparecerán acá.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="adm-list">
                        <c:forEach var="petition" items="${petitions}">
                            <c:url var="detailUrl" value="/admin/${petition.id}" />
                            <a href="${detailUrl}" class="adm-row">
                                <c:choose>
                                    <c:when test="${petition.coverImageId != null}">
                                        <c:url var="coverUrl" value="/petition-images/${petition.coverImageId}" />
                                        <div class="adm-row-cover" style="background-image:url('${coverUrl}')"></div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="adm-row-cover"></div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="adm-row-title">
                                    <b><c:out value="${petition.title}" /></b>
                                    <div class="adm-row-meta">
                                        <span class="adm-status adm-status-${fn:toLowerCase(petition.status)}">
                                            <c:choose>
                                                <c:when test="${petition.status eq 'CHANGES_REQUESTED'}">Con cambios</c:when>
                                                <c:when test="${petition.status eq 'PENDING'}">Pendiente</c:when>
                                                <c:when test="${petition.status eq 'APPROVED'}">Aprobada</c:when>
                                                <c:otherwise><c:out value="${petition.status}" /></c:otherwise>
                                            </c:choose>
                                        </span>
                                        <span class="adm-type-pill petition"><span class="adm-type-pill-swatch"></span>Petición</span>
                                        <span class="adm-detail-id">#<c:out value="${petition.id}" /></span>
                                    </div>
                                </div>
                                <p class="adm-row-copy"><c:out value="${petition.synopsis}" /></p>
                                <div class="adm-row-facts">
                                    <span><b><c:out value="${petition.theater}" /></b></span>
                                    <span><c:out value="${petition.durationMinutes}" /> min · <c:out value="${petition.startDate}" /></span>
                                </div>
                                <span class="adm-row-age"><c:out value="${petition.petitionerEmail}" /></span>
                                <span class="adm-row-action">Revisar →</span>
                            </a>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

        </section>
    </div>
</main>

</body>
</html>
