<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <paw:navbar />

    <c:url var="baseUrl"        value="/productoras/${productora.id}/dashboard" />
    <c:url var="subirObraUrl"   value="/subir-obra" />
    <c:url var="addMemberUrl"   value="/productoras/${productora.id}/miembros" />

    <main class="productora-dashboard">
        <header class="productora-dashboard-header">
            <span class="productora-kicker">Productora</span>
            <h1 class="productora-dashboard-title"><c:out value="${productora.name}" /></h1>
            <c:if test="${not empty productora.bio}">
                <p class="productora-dashboard-bio"><c:out value="${productora.bio}" /></p>
            </c:if>
        </header>

        <nav class="productora-dashboard-tabs" aria-label="Secciones del dashboard">
            <a class="productora-dashboard-tab ${activeTab == 'overview' ? 'is-active' : ''}" href="${baseUrl}?tab=overview">Resumen</a>
            <a class="productora-dashboard-tab ${activeTab == 'obras' ? 'is-active' : ''}"    href="${baseUrl}?tab=obras">Obras</a>
            <a class="productora-dashboard-tab ${activeTab == 'pedidos' ? 'is-active' : ''}"  href="${baseUrl}?tab=pedidos">Pedidos</a>
            <a class="productora-dashboard-tab ${activeTab == 'equipo' ? 'is-active' : ''}"   href="${baseUrl}?tab=equipo">Equipo</a>
            <a class="productora-dashboard-tab ${activeTab == 'config' ? 'is-active' : ''}"   href="${baseUrl}?tab=config">Configuración</a>
        </nav>

        <section class="productora-dashboard-body">
            <c:choose>
                <c:when test="${activeTab == 'equipo'}">
                    <h2>Equipo</h2>
                    <p class="productora-dashboard-subtle">Los miembros pueden subir obras y ver el dashboard. Solo los OWNERS pueden agregar o quitar personas.</p>
                    <ul class="productora-team-list">
                        <c:forEach var="m" items="${members}">
                            <li class="productora-team-row">
                                <div>
                                    <span class="productora-team-name"><c:out value="${not empty m.username ? m.username : m.userEmail}" /></span>
                                    <span class="productora-team-email"><c:out value="${m.userEmail}" /></span>
                                </div>
                                <span class="productora-team-role productora-history-status-${fn:toLowerCase(m.role)}">
                                    <c:out value="${m.role}" />
                                </span>
                                <c:if test="${m.userId != currentUserId}">
                                    <c:url var="removeUrl" value="/productoras/${productora.id}/miembros/${m.userId}/remover" />
                                    <form action="${removeUrl}" method="post" class="productora-team-remove">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                                        <button type="submit" class="btn btn-ghost btn-sm">Quitar</button>
                                    </form>
                                </c:if>
                            </li>
                        </c:forEach>
                    </ul>

                    <form action="${addMemberUrl}" method="post" class="productora-team-add">
                        <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                        <label>
                            <span>Agregar miembro por email</span>
                            <input type="email" name="email" required />
                        </label>
                        <button type="submit" class="btn btn-primary btn-md">Agregar</button>
                    </form>
                </c:when>

                <c:when test="${activeTab == 'obras'}">
                    <h2>Obras</h2>
                    <p class="productora-dashboard-subtle">Próximamente vas a ver acá el listado de obras de tu productora con sus estadísticas.</p>
                    <a href="${subirObraUrl}" class="btn btn-primary btn-md">Subir nueva obra</a>
                </c:when>

                <c:when test="${activeTab == 'pedidos'}">
                    <h2>Pedidos de obra</h2>
                    <p class="productora-dashboard-subtle">Próximamente vas a ver el estado de las peticiones de obra que hizo tu productora.</p>
                    <a href="${subirObraUrl}" class="btn btn-primary btn-md">Nuevo pedido</a>
                </c:when>

                <c:when test="${activeTab == 'config'}">
                    <h2>Configuración</h2>
                    <p class="productora-dashboard-subtle">Datos públicos de tu productora. Solo los OWNERS pueden editarlos.</p>
                    <dl class="productora-admin-dl">
                        <dt>Nombre</dt><dd><c:out value="${productora.name}" /></dd>
                        <dt>CUIT</dt><dd><c:out value="${productora.cuit}" /></dd>
                        <dt>Email</dt><dd><c:out value="${productora.contactEmail}" /></dd>
                        <dt>Bio</dt><dd><c:out value="${productora.bio}" /></dd>
                    </dl>
                </c:when>

                <c:otherwise>
                    <h2>Resumen</h2>
                    <div class="productora-dashboard-overview">
                        <div class="productora-dashboard-stat">
                            <span class="productora-dashboard-stat-num"><c:out value="${fn:length(members)}" /></span>
                            <span class="productora-dashboard-stat-label">Miembros</span>
                        </div>
                    </div>
                    <p class="productora-dashboard-subtle">Usá la pestaña <strong>Obras</strong> para subir nuevos pedidos, <strong>Pedidos</strong> para ver el estado, y <strong>Equipo</strong> para administrar quién puede operar en nombre de la productora.</p>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</body>
</html>
