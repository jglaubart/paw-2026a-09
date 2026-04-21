<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard <c:out value="${productora.name}" /> — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/productora.css" />
</head>
<body>
    <paw:navbar activeSection="productora-dashboard" />

    <c:url var="baseUrl"      value="/productoras/${productora.id}/dashboard" />
    <c:url var="subirObraUrl" value="/subir-obra" />
    <c:url var="addMemberUrl" value="/productoras/${productora.id}/miembros" />
    <c:set var="ownerRow" value="${members[0]}" />
    <c:set var="userRole" value="${ownerRow.userId == currentUserId ? ownerRow.role : 'MEMBER'}" />

    <main class="prod-dash">

        <header class="prod-dash-header">
            <span class="prod-dash-logo" aria-hidden="true">
                <c:out value="${fn:toUpperCase(fn:substring(productora.name, 0, 1))}" /><c:if test="${fn:length(productora.name) > 1}"><c:set var="secondChar" value="${fn:substring(productora.name, 1, 2)}" /><c:out value="${fn:toUpperCase(secondChar)}" /></c:if>
            </span>
            <div class="prod-dash-header-text">
                <h1 class="prod-dash-title"><c:out value="${productora.name}" /></h1>
                <div class="prod-dash-meta">
                    <span class="prod-dash-meta-pill prod-dash-meta-owner">● <c:out value="${userRole}" /></span>
                    <span class="prod-dash-meta-sep">·</span>
                    <span><c:out value="${fn:length(members)}" /> miembros</span>
                    <c:if test="${not empty productora.createdAt}">
                        <span class="prod-dash-meta-sep">·</span>
                        <span>Desde <c:out value="${productora.createdAt}" /></span>
                    </c:if>
                </div>
            </div>
        </header>

        <div class="prod-dash-layout">

            <aside class="prod-dash-sidebar" aria-label="Secciones del dashboard">
                <h4 class="prod-dash-sidebar-section">Dashboard</h4>
                <a class="prod-dash-sidebar-item ${activeTab == 'overview' ? 'is-active' : ''}" href="${baseUrl}?tab=overview">Overview</a>
                <a class="prod-dash-sidebar-item ${activeTab == 'obras' ? 'is-active' : ''}" href="${baseUrl}?tab=obras">
                    Obras <span class="prod-dash-sidebar-count"><c:out value="${stats.obraCount}" /></span>
                </a>
                <a class="prod-dash-sidebar-item ${activeTab == 'producciones' ? 'is-active' : ''}" href="${baseUrl}?tab=producciones">
                    Producciones <span class="prod-dash-sidebar-count"><c:out value="${stats.productionCount}" /></span>
                </a>

                <h4 class="prod-dash-sidebar-section">Público</h4>
                <a class="prod-dash-sidebar-item ${activeTab == 'resenas' ? 'is-active' : ''}" href="${baseUrl}?tab=resenas">
                    Reseñas <span class="prod-dash-sidebar-count"><c:out value="${stats.reviewCount}" /></span>
                </a>
                <a class="prod-dash-sidebar-item ${activeTab == 'comentarios' ? 'is-active' : ''}" href="${baseUrl}?tab=comentarios">
                    Puntuaciones <span class="prod-dash-sidebar-count"><c:out value="${stats.ratingCount}" /></span>
                </a>

                <h4 class="prod-dash-sidebar-section">Organización</h4>
                <a class="prod-dash-sidebar-item ${activeTab == 'equipo' ? 'is-active' : ''}" href="${baseUrl}?tab=equipo">
                    Usuarios <span class="prod-dash-sidebar-count"><c:out value="${fn:length(members)}" /></span>
                </a>
                <a class="prod-dash-sidebar-item ${activeTab == 'config' ? 'is-active' : ''}" href="${baseUrl}?tab=config">Configuración</a>
            </aside>

            <section class="prod-dash-content">

                <c:choose>
                    <c:when test="${activeTab == 'equipo'}">
                        <h2 class="prod-dash-content-title">Usuarios</h2>
                        <p class="prod-dash-subtle">Los miembros pueden subir obras y ver el dashboard. Solo los OWNERS pueden agregar o quitar personas.</p>

                        <ul class="prod-team-list">
                            <c:forEach var="m" items="${members}">
                                <li class="prod-team-row">
                                    <div>
                                        <span class="prod-team-name"><c:out value="${not empty m.username ? m.username : m.userEmail}" /></span>
                                        <span class="prod-team-email"><c:out value="${m.userEmail}" /></span>
                                    </div>
                                    <span class="prod-team-role prod-team-role-${fn:toLowerCase(m.role)}">● <c:out value="${m.role}" /></span>
                                    <c:if test="${m.userId != currentUserId}">
                                        <c:url var="removeUrl" value="/productoras/${productora.id}/miembros/${m.userId}/remover" />
                                        <form action="${removeUrl}" method="post" class="prod-team-remove">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                                            <button type="submit" class="btn btn-ghost btn-sm">Quitar</button>
                                        </form>
                                    </c:if>
                                </li>
                            </c:forEach>
                        </ul>

                        <form action="${addMemberUrl}" method="post" class="prod-team-add">
                            <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                            <label>
                                <span>Agregar miembro por email</span>
                                <input type="email" name="email" placeholder="nombre@mail.com" required />
                            </label>
                            <button type="submit" class="btn btn-primary btn-md">Agregar</button>
                        </form>
                    </c:when>

                    <c:when test="${activeTab == 'config'}">
                        <h2 class="prod-dash-content-title">Configuración</h2>
                        <p class="prod-dash-subtle">Datos públicos de tu productora. Solo los OWNERS pueden editarlos.</p>
                        <dl class="prod-dash-dl">
                            <dt>Nombre</dt><dd><c:out value="${productora.name}" /></dd>
                            <c:if test="${not empty productora.cuit}"><dt>CUIT</dt><dd><c:out value="${productora.cuit}" /></dd></c:if>
                            <c:if test="${not empty productora.contactEmail}"><dt>Email</dt><dd><c:out value="${productora.contactEmail}" /></dd></c:if>
                            <c:if test="${not empty productora.bio}"><dt>Bio</dt><dd><c:out value="${productora.bio}" /></dd></c:if>
                        </dl>
                    </c:when>

                    <c:when test="${activeTab == 'obras' or activeTab == 'producciones'}">
                        <h2 class="prod-dash-content-title">${activeTab == 'obras' ? 'Obras' : 'Producciones'}</h2>
                        <p class="prod-dash-subtle">Cada producción aprobada por el admin aparece acá con sus stats públicas.</p>

                        <c:choose>
                            <c:when test="${empty productions}">
                                <div class="prod-dash-empty">
                                    <p>Todavía no tenés producciones aprobadas. Subí una obra y cuando el admin la apruebe va a aparecer acá.</p>
                                    <a href="${subirObraUrl}" class="btn btn-primary btn-md">Subir nueva obra</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <ul class="prod-dash-obras-list" role="list">
                                    <c:forEach var="p" items="${productions}">
                                        <c:url var="prodUrl" value="/obras/${p.obraId}">
                                            <c:param name="produccionId" value="${p.id}" />
                                        </c:url>
                                        <li class="prod-dash-obras-row">
                                            <div class="prod-dash-obras-info">
                                                <a href="${prodUrl}" class="prod-dash-obras-title"><c:out value="${p.name}" /></a>
                                                <span class="prod-dash-obras-meta">
                                                    <c:if test="${not empty p.theater}"><c:out value="${p.theater}" /></c:if>
                                                    <c:if test="${not empty p.startDate}"> · <c:out value="${p.startDate}" /></c:if>
                                                </span>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                                <div class="prod-dash-cta-row">
                                    <a href="${subirObraUrl}" class="btn btn-primary btn-md">Subir nueva obra</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:when>

                    <c:when test="${activeTab == 'resenas'}">
                        <h2 class="prod-dash-content-title">Reseñas</h2>
                        <p class="prod-dash-subtle">Últimas reseñas que dejaron los usuarios sobre las obras de tu productora.</p>
                        <c:choose>
                            <c:when test="${empty recentReviews}">
                                <div class="prod-dash-empty">
                                    <p>Sin reseñas por ahora. Cuando alguien reseñe una obra tuya, vas a verla acá.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <ul class="prod-dash-reviews-list" role="list">
                                    <c:forEach var="r" items="${recentReviews}">
                                        <li class="prod-dash-review-row">
                                            <div class="prod-dash-review-head">
                                                <span class="prod-dash-review-user"><c:out value="${not empty r.username ? r.username : r.email}" /></span>
                                                <span class="prod-dash-review-obra">en <c:out value="${r.obraTitle}" /></span>
                                                <c:if test="${r.score != null}">
                                                    <span class="prod-dash-review-score">★ <c:out value="${r.score}" />/10</span>
                                                </c:if>
                                            </div>
                                            <p class="prod-dash-review-body"><c:out value="${r.body}" /></p>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                    </c:when>

                    <c:when test="${activeTab == 'comentarios'}">
                        <h2 class="prod-dash-content-title">Puntuaciones</h2>
                        <p class="prod-dash-subtle">
                            <c:choose>
                                <c:when test="${stats.ratingCount > 0}">
                                    Recibiste <c:out value="${stats.ratingCount}" /> puntuación(es) en total, con un promedio de <c:out value="${stats.ratingAverage != null ? stats.ratingAverage : '—'}" />/10.
                                </c:when>
                                <c:otherwise>
                                    Todavía nadie puntuó las obras de tu productora.
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </c:when>

                    <c:otherwise>
                        <div class="prod-dash-stats">
                            <div class="prod-dash-stat prod-dash-stat-violet">
                                <span class="prod-dash-stat-label">Obras aprobadas</span>
                                <span class="prod-dash-stat-value"><c:out value="${stats.obraCount}" /></span>
                                <span class="prod-dash-stat-delta"><c:out value="${stats.productionCount}" /> producciones</span>
                            </div>
                            <div class="prod-dash-stat prod-dash-stat-amber">
                                <span class="prod-dash-stat-label">Rating promedio</span>
                                <c:choose>
                                    <c:when test="${stats.ratingAverage != null}">
                                        <span class="prod-dash-stat-value"><fmt:formatNumber value="${stats.ratingAverage}" maxFractionDigits="1" minFractionDigits="1" /><span class="prod-dash-stat-scale">/10</span></span>
                                        <span class="prod-dash-stat-delta"><c:out value="${stats.ratingCount}" /> puntuación(es)</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="prod-dash-stat-value">—<span class="prod-dash-stat-scale">/10</span></span>
                                        <span class="prod-dash-stat-delta">Sin datos aún</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="prod-dash-stat prod-dash-stat-violet">
                                <span class="prod-dash-stat-label">En watchlist</span>
                                <span class="prod-dash-stat-value"><c:out value="${stats.watchlistCount}" /></span>
                                <span class="prod-dash-stat-delta">guardados por usuarios</span>
                            </div>
                            <div class="prod-dash-stat prod-dash-stat-violet">
                                <span class="prod-dash-stat-label">Vistos</span>
                                <span class="prod-dash-stat-value"><c:out value="${stats.seenCount}" /></span>
                                <span class="prod-dash-stat-delta">marcaron como vista</span>
                            </div>
                        </div>

                        <div class="prod-dash-chart">
                            <div class="prod-dash-chart-head">
                                <div>
                                    <h3 class="prod-dash-chart-title">Tendencia de views</h3>
                                    <p class="prod-dash-chart-sub">Últimos 30 días, todas las obras</p>
                                </div>
                                <span class="prod-dash-chart-range">30 días</span>
                            </div>
                            <div class="prod-dash-chart-bars" aria-hidden="true">
                                <span style="height:28%"></span><span style="height:33%"></span><span style="height:31%"></span>
                                <span style="height:55%"></span><span style="height:48%"></span><span style="height:52%"></span>
                                <span style="height:66%"></span><span style="height:60%"></span><span style="height:71%"></span>
                                <span style="height:65%"></span><span style="height:78%"></span><span style="height:75%"></span>
                                <span style="height:86%"></span><span style="height:92%"></span>
                            </div>
                            <div class="prod-dash-chart-axis">
                                <span>hace 30d</span>
                                <span>hace 20d</span>
                                <span>hace 10d</span>
                                <span>hoy</span>
                            </div>
                        </div>

                        <div class="prod-dash-reviews">
                            <div class="prod-dash-reviews-head">
                                <h3>Últimas reseñas</h3>
                                <span class="prod-dash-reviews-link">Próximamente →</span>
                            </div>
                            <p class="prod-dash-subtle">Cuando tu productora tenga obras reseñadas, vas a verlas acá.</p>
                        </div>
                    </c:otherwise>
                </c:choose>

            </section>
        </div>
    </main>
</body>
</html>
