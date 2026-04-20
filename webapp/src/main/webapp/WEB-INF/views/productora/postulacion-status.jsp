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
    <c:url var="dashboardUrl" value="/productoras/mia" />

    <main class="productora-status">

        <c:choose>
            <c:when test="${request != null}">
                <span class="productora-kicker productora-status-kicker-${fn:toLowerCase(request.status)}">
                    <c:choose>
                        <c:when test="${request.status == 'PENDING'}">En revisión</c:when>
                        <c:when test="${request.status == 'CHANGES_REQUESTED'}">El admin pidió cambios</c:when>
                        <c:when test="${request.status == 'APPROVED'}">Aprobada</c:when>
                        <c:otherwise>Rechazada</c:otherwise>
                    </c:choose>
                </span>

                <h1 class="productora-status-title">
                    <c:choose>
                        <c:when test="${request.status == 'PENDING'}">Tu postulación está en revisión</c:when>
                        <c:when test="${request.status == 'CHANGES_REQUESTED'}">Pedimos que revises algunos datos</c:when>
                        <c:when test="${request.status == 'APPROVED'}">¡Bienvenida a Platea!</c:when>
                        <c:otherwise>Postulación rechazada</c:otherwise>
                    </c:choose>
                </h1>

                <p class="productora-status-lede">
                    <c:choose>
                        <c:when test="${request.status == 'PENDING'}">Estamos revisando los datos de <strong><c:out value="${request.name}" /></strong>. Te escribimos apenas tengamos novedades.</c:when>
                        <c:when test="${request.status == 'CHANGES_REQUESTED'}">Entrá al formulario para actualizar los campos señalados y reenviar tu postulación.</c:when>
                        <c:when test="${request.status == 'APPROVED'}"><strong><c:out value="${request.name}" /></strong> ya está activa. Podés empezar a cargar obras desde tu dashboard.</c:when>
                        <c:otherwise>Por el momento no pudimos aprobar tu postulación.</c:otherwise>
                    </c:choose>
                </p>

                <dl class="productora-status-meta">
                    <div>
                        <dt>Enviada</dt>
                        <dd><c:out value="${request.createdAt}" /></dd>
                    </div>
                    <div>
                        <dt>Email de contacto</dt>
                        <dd><c:out value="${request.contactEmail}" /></dd>
                    </div>
                </dl>

                <c:if test="${not empty request.adminNotes}">
                    <div class="productora-status-notes">
                        <h3>Notas del administrador</h3>
                        <p><c:out value="${request.adminNotes}" /></p>
                    </div>
                </c:if>

                <div class="productora-status-cta">
                    <c:choose>
                        <c:when test="${request.status == 'CHANGES_REQUESTED'}">
                            <a href="${editUrl}" class="btn btn-primary btn-md">Editar y reenviar</a>
                        </c:when>
                        <c:when test="${request.status == 'APPROVED'}">
                            <a href="${dashboardUrl}" class="btn btn-primary btn-md">Ir al dashboard</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${carteleraUrl}" class="btn btn-ghost btn-md">Volver al inicio</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:when>
            <c:otherwise>
                <h1 class="productora-status-title">No tenés una postulación activa</h1>
                <p class="productora-status-lede">Podés iniciar una nueva postulación cuando quieras.</p>
                <c:url var="newUrl" value="/productoras/postular" />
                <div class="productora-status-cta">
                    <a href="${newUrl}" class="btn btn-primary btn-md">Nueva postulación</a>
                </div>
            </c:otherwise>
        </c:choose>

    </main>
</body>
</html>
