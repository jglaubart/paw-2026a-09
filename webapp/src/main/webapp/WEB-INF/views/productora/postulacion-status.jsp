<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Estado de tu postulación — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/productora.css" />
</head>
<body>
    <paw:navbar />

    <c:url var="carteleraUrl" value="/cartelera" />
    <c:url var="editUrl"      value="/productoras/postular/${request.id}/editar" />
    <c:url var="simulateUrl"  value="/productoras/postular/simular-aprobacion" />
    <c:url var="dashboardUrl" value="/productoras/mia" />
    <c:url var="newUrl"       value="/productoras/postular" />

    <main class="prod-status">

        <c:choose>
            <c:when test="${request != null and (request.status == 'PENDING' or request.status == 'CHANGES_REQUESTED')}">
                <div class="prod-status-card">
                    <span class="prod-status-icon prod-status-icon-pending" aria-hidden="true">✓</span>
                    <h1 class="prod-status-card-title">
                        <c:choose>
                            <c:when test="${request.status == 'PENDING'}">Solicitud enviada</c:when>
                            <c:otherwise>El admin pidió cambios</c:otherwise>
                        </c:choose>
                    </h1>
                    <p class="prod-status-card-lede">
                        <c:choose>
                            <c:when test="${request.status == 'PENDING'}">Recibimos tu postulación. Vamos a revisar la documentación y te avisamos por mail en 2-5 días hábiles.</c:when>
                            <c:otherwise>Revisá las notas del admin y actualizá los campos marcados. Después podés reenviar tu postulación.</c:otherwise>
                        </c:choose>
                    </p>

                    <c:if test="${not empty request.adminNotes}">
                        <div class="prod-status-notes">
                            <h3>Notas del administrador</h3>
                            <p><c:out value="${request.adminNotes}" /></p>
                        </div>
                    </c:if>

                    <div class="prod-status-card-actions">
                        <c:choose>
                            <c:when test="${request.status == 'CHANGES_REQUESTED'}">
                                <a href="${carteleraUrl}" class="btn btn-ghost btn-md">Volver a cartelera</a>
                                <a href="${editUrl}" class="btn btn-primary btn-md">Editar y reenviar</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${carteleraUrl}" class="btn btn-ghost btn-md">Volver a cartelera</a>
                                <form action="${simulateUrl}" method="post" class="prod-status-simulate-form">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                                    <button type="submit" class="btn btn-primary btn-md prod-status-simulate-btn">
                                        <span aria-hidden="true">⚡</span> Simular aprobación (demo)
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:when>

            <c:when test="${request != null and request.status == 'APPROVED'}">
                <div class="prod-status-card">
                    <span class="prod-status-icon prod-status-icon-approved" aria-hidden="true">✓</span>
                    <h1 class="prod-status-card-title">¡Bienvenida a Platea!</h1>
                    <p class="prod-status-card-lede"><strong><c:out value="${request.name}" /></strong> ya está activa. Podés empezar a cargar obras desde tu dashboard.</p>
                    <div class="prod-status-card-actions">
                        <a href="${dashboardUrl}" class="btn btn-primary btn-md">Ir al dashboard</a>
                    </div>
                </div>
            </c:when>

            <c:when test="${request != null and request.status == 'REJECTED'}">
                <div class="prod-status-card">
                    <span class="prod-status-icon prod-status-icon-rejected" aria-hidden="true">✕</span>
                    <h1 class="prod-status-card-title">Postulación rechazada</h1>
                    <p class="prod-status-card-lede">Por el momento no pudimos aprobar tu postulación.</p>
                    <c:if test="${not empty request.adminNotes}">
                        <div class="prod-status-notes">
                            <h3>Notas del administrador</h3>
                            <p><c:out value="${request.adminNotes}" /></p>
                        </div>
                    </c:if>
                    <div class="prod-status-card-actions">
                        <a href="${carteleraUrl}" class="btn btn-ghost btn-md">Volver a cartelera</a>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div class="prod-status-card">
                    <span class="prod-status-icon" aria-hidden="true">♡</span>
                    <h1 class="prod-status-card-title">No tenés una postulación activa</h1>
                    <p class="prod-status-card-lede">Podés iniciar una nueva postulación cuando quieras.</p>
                    <div class="prod-status-card-actions">
                        <a href="${newUrl}" class="btn btn-primary btn-md">Nueva postulación</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

    </main>
</body>
</html>
