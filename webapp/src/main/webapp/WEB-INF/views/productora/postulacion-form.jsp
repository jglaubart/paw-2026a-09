<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"    uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"   uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="paw"  tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${existingRequest != null ? 'Editar postulación' : 'Nueva postulación'} — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/auth.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/productora.css" />
</head>
<body>
    <paw:navbar />

    <c:choose>
        <c:when test="${existingRequest != null}">
            <c:url var="actionUrl" value="/productoras/postular/${existingRequest.id}/editar" />
            <c:set var="pageTitle" value="Editar y reenviar postulación" />
        </c:when>
        <c:otherwise>
            <c:url var="actionUrl" value="/productoras/postular/nueva" />
            <c:set var="pageTitle" value="Nueva postulación de productora" />
        </c:otherwise>
    </c:choose>

    <c:url var="backUrl" value="/productoras/postular" />

    <main class="productora-form-page">
        <header class="productora-form-header">
            <a href="${backUrl}" class="productora-form-back">← Volver</a>
            <h1 class="productora-form-title"><c:out value="${pageTitle}" /></h1>
        </header>

        <c:if test="${existingRequest != null and not empty existingRequest.adminNotes}">
            <div class="productora-form-admin-notes">
                <strong>El administrador pidió cambios:</strong>
                <p><c:out value="${existingRequest.adminNotes}" /></p>
            </div>
        </c:if>

        <form:form modelAttribute="productoraRequestForm" action="${actionUrl}" method="post" class="productora-form" enctype="multipart/form-data">

            <fieldset class="productora-form-section">
                <legend class="productora-form-legend">1. Identidad</legend>

                <div class="productora-form-field">
                    <label class="productora-form-label" for="pr-name">Nombre de la productora</label>
                    <form:input id="pr-name" path="name" class="productora-form-input" maxlength="120" />
                    <form:errors path="name" element="span" cssClass="productora-form-error" />
                    <c:if test="${existingRequest != null and not empty existingRequest.fieldFeedback['name']}">
                        <span class="productora-form-feedback"><c:out value="${existingRequest.fieldFeedback['name']}" /></span>
                    </c:if>
                </div>

                <div class="productora-form-field">
                    <label class="productora-form-label" for="pr-cuit">CUIT</label>
                    <form:input id="pr-cuit" path="cuit" class="productora-form-input" placeholder="30-12345678-9" />
                    <form:errors path="cuit" element="span" cssClass="productora-form-error" />
                    <c:if test="${existingRequest != null and not empty existingRequest.fieldFeedback['cuit']}">
                        <span class="productora-form-feedback"><c:out value="${existingRequest.fieldFeedback['cuit']}" /></span>
                    </c:if>
                </div>

                <div class="productora-form-field">
                    <label class="productora-form-label" for="pr-email">Email de contacto</label>
                    <form:input id="pr-email" path="contactEmail" type="email" class="productora-form-input" maxlength="255" />
                    <form:errors path="contactEmail" element="span" cssClass="productora-form-error" />
                </div>

                <div class="productora-form-field">
                    <label class="productora-form-label" for="pr-bio">Bio</label>
                    <form:textarea id="pr-bio" path="bio" class="productora-form-textarea" rows="4" maxlength="1500" />
                    <form:errors path="bio" element="span" cssClass="productora-form-error" />
                </div>

                <div class="productora-form-field-row">
                    <div class="productora-form-field">
                        <label class="productora-form-label" for="pr-instagram">Instagram</label>
                        <form:input id="pr-instagram" path="instagram" class="productora-form-input" maxlength="255" />
                    </div>
                    <div class="productora-form-field">
                        <label class="productora-form-label" for="pr-website">Sitio web</label>
                        <form:input id="pr-website" path="website" class="productora-form-input" maxlength="255" />
                    </div>
                </div>
            </fieldset>

            <fieldset class="productora-form-section">
                <legend class="productora-form-legend">2. Equipo</legend>

                <div class="productora-form-field">
                    <label class="productora-form-label" for="pr-team-size">Cantidad de integrantes</label>
                    <form:input id="pr-team-size" path="teamSize" type="number" min="1" class="productora-form-input productora-form-input-narrow" />
                    <form:errors path="teamSize" element="span" cssClass="productora-form-error" />
                </div>

                <div class="productora-form-field">
                    <label class="productora-form-label" for="pr-team-desc">Integrantes clave y roles</label>
                    <form:textarea id="pr-team-desc" path="teamDescription" class="productora-form-textarea" rows="4" maxlength="1500" />
                    <form:errors path="teamDescription" element="span" cssClass="productora-form-error" />
                </div>
            </fieldset>

            <fieldset class="productora-form-section">
                <legend class="productora-form-legend">3. Antecedentes</legend>

                <div class="productora-form-field">
                    <label class="productora-form-label" for="pr-previous">Obras previas</label>
                    <form:textarea id="pr-previous" path="previousWorks" class="productora-form-textarea" rows="6" maxlength="2500" />
                    <form:errors path="previousWorks" element="span" cssClass="productora-form-error" />
                </div>
            </fieldset>

            <div class="productora-form-submit-row">
                <a href="${backUrl}" class="btn btn-ghost btn-md">Cancelar</a>
                <button type="submit" class="btn btn-primary btn-md">
                    <c:choose>
                        <c:when test="${existingRequest != null}">Reenviar</c:when>
                        <c:otherwise>Enviar postulación</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </form:form>
    </main>
</body>
</html>
