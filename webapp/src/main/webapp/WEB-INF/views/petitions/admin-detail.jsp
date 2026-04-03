<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Petición #${petition.id}</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/alert.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/play-petitions-admin.css" />
</head>
<body>
<paw:navbar />

<main class="petition-admin-page petition-admin-page-detail">
    <section class="petition-admin-shell petition-admin-detail-shell">
        <div class="petition-admin-detail-header petition-admin-panel petition-admin-panel-hero">
            <a href="${pageContext.request.contextPath}/internal/dev/play-petitions" class="petition-admin-back">← Volver al listado</a>
            <div class="petition-admin-card-head">
                <span class="petition-admin-status petition-admin-status-${fn:toLowerCase(petition.status)}"><c:out value="${petition.status}" /></span>
                <p class="petition-admin-card-id">Solicitud #<c:out value="${petition.id}" /></p>
            </div>
            <h1><c:out value="${petition.title}" /></h1>
            <p class="petition-admin-card-meta"><c:out value="${petition.petitionerEmail}" /> · <c:out value="${petition.theater}" /></p>
        </div>

        <c:if test="${updated eq 'approved'}"><div class="petition-admin-alert"><paw:alert variant="success" message="La petición fue aprobada y se notificó al solicitante." showClose="false" /></div></c:if>
        <c:if test="${updated eq 'rejected'}"><div class="petition-admin-alert"><paw:alert variant="warning" message="La petición fue rechazada y se notificó al solicitante." showClose="false" /></div></c:if>
        <c:if test="${error eq 'already_resolved'}"><div class="petition-admin-alert"><paw:alert variant="error" message="La petición ya estaba resuelta." showClose="false" /></div></c:if>
        <c:if test="${error eq 'invalid_action'}"><div class="petition-admin-alert"><paw:alert variant="error" message="La acción solicitada no es válida." showClose="false" /></div></c:if>

        <div class="petition-admin-detail-grid">
            <section class="petition-admin-panel petition-admin-panel-story">
                <c:if test="${petition.coverImageId != null}">
                    <c:url var="coverUrl" value="/petition-images/${petition.coverImageId}" />
                    <img class="petition-admin-cover" src="${coverUrl}" alt="${fn:escapeXml(petition.title)}" />
                </c:if>

                <dl class="petition-admin-definition-list">
                    <dt>Sinopsis</dt>
                    <dd><c:out value="${petition.synopsis}" /></dd>
                    <dt>Géneros</dt>
                    <dd>
                        <c:forEach var="genre" items="${petition.genres}" varStatus="status">
                            <c:out value="${genre.name}" /><c:if test="${not status.last}">, </c:if>
                        </c:forEach>
                    </dd>
                    <dt>Duración</dt>
                    <dd><c:out value="${petition.durationMinutes}" /> minutos</dd>
                    <dt>Dirección</dt>
                    <dd><c:out value="${petition.director}" /></dd>
                    <dt>Teatro / sala</dt>
                    <dd><c:out value="${petition.theater}" /></dd>
                    <dt>Dirección de la sala</dt>
                    <dd><c:out value="${petition.theaterAddress}" /></dd>
                    <dt>Inicio de temporada</dt>
                    <dd><c:out value="${petition.startDate}" /></dd>
                    <c:if test="${petition.endDate != null}">
                        <dt>Fin de temporada</dt>
                        <dd><c:out value="${petition.endDate}" /></dd>
                    </c:if>
                    <c:if test="${not empty petition.schedule}">
                        <dt>Horarios</dt>
                        <dd><c:out value="${petition.schedule}" /></dd>
                    </c:if>
                    <c:if test="${not empty petition.ticketUrl}">
                        <dt>Entradas</dt>
                        <dd><a class="petition-admin-inline-link" href="${fn:escapeXml(petition.ticketUrl)}" target="_blank" rel="noreferrer">Ver link</a></dd>
                    </c:if>
                    <c:if test="${not empty petition.language}">
                        <dt>Idioma</dt>
                        <dd><c:out value="${petition.language}" /></dd>
                    </c:if>
                </dl>
            </section>

            <section class="petition-admin-panel petition-admin-panel-actions">
                <h2>Decisión editorial</h2>
                <p class="petition-admin-panel-copy">Dejá una nota opcional para el solicitante. Si aprobás, se crea automáticamente la obra y su producción base en la plataforma.</p>

                <c:if test="${petition.status eq 'PENDING'}">
                    <form action="${pageContext.request.contextPath}/internal/dev/play-petitions/${petition.id}/decision" method="post" class="petition-admin-decision-form">
                        <label for="adminNotes">Notas para el solicitante</label>
                        <textarea id="adminNotes" name="adminNotes" rows="7"><c:out value="${petition.adminNotes}" /></textarea>
                        <div class="petition-admin-actions">
                            <button type="submit" name="action" value="approve" class="btn btn-md petition-admin-approve">Aprobar</button>
                            <button type="submit" name="action" value="reject" class="btn btn-md petition-admin-reject">Rechazar</button>
                        </div>
                    </form>
                </c:if>

                <c:if test="${petition.status ne 'PENDING'}">
                    <div class="petition-admin-resolution">
                        <p class="petition-admin-resolution-title">Esta petición ya fue resuelta.</p>
                        <c:if test="${not empty petition.adminNotes}">
                            <p><strong>Notas:</strong> <c:out value="${petition.adminNotes}" /></p>
                        </c:if>
                        <c:if test="${petition.createdObraId != null and petition.createdProductionId != null}">
                            <a class="btn btn-md petition-admin-card-link" href="${pageContext.request.contextPath}/obras/${petition.createdObraId}?produccionId=${petition.createdProductionId}">Ver publicación creada</a>
                        </c:if>
                    </div>
                </c:if>
            </section>
        </div>
    </section>
</main>
</body>
</html>
