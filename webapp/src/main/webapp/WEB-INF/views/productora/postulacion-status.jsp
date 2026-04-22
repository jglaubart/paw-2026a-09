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
    <c:url var="newUrl"       value="/productoras/postular" />

    <main class="prod-status">

        <c:choose>
            <c:when test="${request != null and request.status == 'PENDING'}">
                <div class="prod-status-card">
                    <span class="prod-status-icon prod-status-icon-pending" aria-hidden="true">✓</span>
                    <h1 class="prod-status-card-title">Solicitud enviada</h1>
                    <p class="prod-status-card-lede">Recibimos tu postulación. Vamos a revisar la documentación y te avisamos por mail en 2-5 días hábiles.</p>
                    <div class="prod-status-card-actions">
                        <a href="${carteleraUrl}" class="navbar-auth-link">Volver a cartelera</a>
                    </div>
                </div>
            </c:when>

            <c:when test="${request != null and request.status == 'CHANGES_REQUESTED'}">
                <div class="prod-status-card">
                    <span class="prod-status-icon prod-status-icon-changes" aria-hidden="true">!</span>
                    <h1 class="prod-status-card-title">Revisá tu postulación</h1>
                    <p class="prod-status-card-lede">El equipo de Platea revisó tu solicitud y encontró campos que necesitan corrección. Actualizalos y reenviá tu postulación.</p>

                    <c:if test="${not empty request.adminNotes}">
                        <div class="prod-status-notes">
                            <h3>Notas del administrador</h3>
                            <p><c:out value="${request.adminNotes}" /></p>
                        </div>
                    </c:if>

                    <c:if test="${not empty request.fieldFeedback}">
                        <div class="prod-status-flags">
                            <p class="prod-status-flags-label">Campos a corregir</p>
                            <c:forEach var="entry" items="${request.fieldFeedback}">
                                <div class="prod-status-flag-item">
                                    <span class="prod-status-flag-key">
                                        <c:choose>
                                            <c:when test="${entry.key eq 'name'}">Nombre</c:when>
                                            <c:when test="${entry.key eq 'cuit'}">CUIT</c:when>
                                            <c:when test="${entry.key eq 'contactEmail'}">Email de contacto</c:when>
                                            <c:when test="${entry.key eq 'bio'}">Descripción</c:when>
                                            <c:when test="${entry.key eq 'instagram'}">Instagram</c:when>
                                            <c:when test="${entry.key eq 'website'}">Sitio web</c:when>
                                            <c:when test="${entry.key eq 'teamDescription'}">Equipo</c:when>
                                            <c:when test="${entry.key eq 'previousWorks'}">Antecedentes</c:when>
                                            <c:otherwise><c:out value="${entry.key}" /></c:otherwise>
                                        </c:choose>
                                    </span>
                                    <p class="prod-status-flag-comment"><c:out value="${entry.value}" /></p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <div class="prod-status-card-actions">
                        <a href="${carteleraUrl}" class="navbar-auth-link">Volver a cartelera</a>
                        <a href="${editUrl}" class="btn btn-md btn-cta">Editar y reenviar</a>
                    </div>
                </div>
            </c:when>

            <c:when test="${request != null and request.status == 'APPROVED'}">
                <div class="prod-status-card">
                    <span class="prod-status-icon prod-status-icon-approved" aria-hidden="true">✓</span>
                    <h1 class="prod-status-card-title">¡Bienvenida a Platea!</h1>
                    <p class="prod-status-card-lede"><strong><c:out value="${request.name}" /></strong> ya está activa. Podés empezar a cargar obras desde tu dashboard.</p>
                    <div class="prod-status-card-actions">
                        <a href="${dashboardUrl}" class="btn btn-md btn-cta">Ir al dashboard</a>
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
                        <a href="${carteleraUrl}" class="navbar-auth-link">Volver a cartelera</a>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div class="prod-status-card">
                    <span class="prod-status-icon" aria-hidden="true">♡</span>
                    <h1 class="prod-status-card-title">No tenés una postulación activa</h1>
                    <p class="prod-status-card-lede">Podés iniciar una nueva postulación cuando quieras.</p>
                    <div class="prod-status-card-actions">
                        <a href="${newUrl}" class="btn btn-md btn-cta">Nueva postulación</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

    </main>
</body>
</html>
