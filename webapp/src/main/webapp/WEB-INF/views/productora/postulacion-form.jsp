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
    <title>${existingRequest != null ? 'Editar postulación' : 'Solicitud de productora'} — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/productora.css" />
</head>
<body>
    <paw:navbar />

    <c:choose>
        <c:when test="${existingRequest != null}">
            <c:url var="actionUrl" value="/productoras/postular/${existingRequest.id}/editar" />
        </c:when>
        <c:otherwise>
            <c:url var="actionUrl" value="/productoras/postular/nueva" />
        </c:otherwise>
    </c:choose>

    <c:url var="backUrl" value="/productoras/postular" />

    <main class="prod-form">
        <header class="prod-form-header">
            <span class="prod-kicker">Solicitud de productora</span>
            <h1 class="prod-form-hero">Convertite en administradora de tu productora</h1>
            <p class="prod-form-hero-sub">Verificamos manualmente cada solicitud. Completá los pasos y te avisamos por email cuando resolvamos.</p>
        </header>

        <c:if test="${existingRequest != null and not empty existingRequest.adminNotes}">
            <div class="prod-admin-notes">
                <strong>El administrador pidió cambios</strong>
                <p><c:out value="${existingRequest.adminNotes}" /></p>
            </div>
        </c:if>

        <div class="prod-form-layout">

            <aside class="prod-stepper" aria-label="Pasos de la postulación">
                <a class="prod-stepper-step is-active" href="#step-identidad">
                    <span class="prod-stepper-num">1</span>
                    <span class="prod-stepper-body">
                        <span class="prod-stepper-title">Identidad legal</span>
                        <span class="prod-stepper-sub">Razón social, CUIT, contacto</span>
                    </span>
                </a>
                <a class="prod-stepper-step" href="#step-productora">
                    <span class="prod-stepper-num">2</span>
                    <span class="prod-stepper-body">
                        <span class="prod-stepper-title">Sobre tu productora</span>
                        <span class="prod-stepper-sub">Nombre comercial, bio</span>
                    </span>
                </a>
                <a class="prod-stepper-step" href="#step-antecedentes">
                    <span class="prod-stepper-num">3</span>
                    <span class="prod-stepper-body">
                        <span class="prod-stepper-title">Antecedentes</span>
                        <span class="prod-stepper-sub">Obras previas y documentación</span>
                    </span>
                </a>
                <a class="prod-stepper-step" href="#step-confirmar">
                    <span class="prod-stepper-num">4</span>
                    <span class="prod-stepper-body">
                        <span class="prod-stepper-title">Confirmar y enviar</span>
                        <span class="prod-stepper-sub">Revisá antes de mandar</span>
                    </span>
                </a>

                <div class="prod-stepper-footer">
                    <h4>¿Cómo sigue?</h4>
                    <p>Después de enviar, el equipo de Platea revisa tu solicitud. Puede tardar entre 2 y 5 días hábiles. Te avisamos por mail en cuanto haya novedades.</p>
                </div>
            </aside>

            <form:form modelAttribute="productoraRequestForm" action="${actionUrl}" method="post"
                       class="prod-form-body" enctype="multipart/form-data">

                <div class="prod-form-progress" aria-hidden="true">
                    <span class="prod-form-progress-bar is-active"></span>
                    <span class="prod-form-progress-bar"></span>
                    <span class="prod-form-progress-bar"></span>
                    <span class="prod-form-progress-bar"></span>
                </div>

                <section id="step-identidad" class="prod-form-step">
                    <h2 class="prod-form-step-title">Identidad legal</h2>
                    <p class="prod-form-step-help">Nos aseguramos que la productora existe formalmente y de poder contactarte.</p>

                    <div class="prod-form-field">
                        <label class="prod-form-label" for="pr-name">Razón social <span class="prod-form-required">*</span></label>
                        <form:input id="pr-name" path="name" class="prod-form-input" placeholder="Producciones Escena Abierta S.A." maxlength="120" />
                        <span class="prod-form-help">Como figura en el estatuto o contrato constitutivo.</span>
                        <form:errors path="name" element="span" cssClass="prod-form-error" />
                        <c:if test="${existingRequest != null and not empty existingRequest.fieldFeedback['name']}">
                            <span class="prod-form-feedback"><c:out value="${existingRequest.fieldFeedback['name']}" /></span>
                        </c:if>
                    </div>

                    <div class="prod-form-grid-2">
                        <div class="prod-form-field">
                            <label class="prod-form-label" for="pr-cuit">CUIT <span class="prod-form-required">*</span></label>
                            <form:input id="pr-cuit" path="cuit" class="prod-form-input" placeholder="30-12345678-9" />
                            <form:errors path="cuit" element="span" cssClass="prod-form-error" />
                        </div>
                        <div class="prod-form-field">
                            <label class="prod-form-label" for="pr-phone">Teléfono <span class="prod-form-required">*</span></label>
                            <form:input id="pr-phone" path="phone" class="prod-form-input" placeholder="+54 9 11 5555-5555" />
                            <form:errors path="phone" element="span" cssClass="prod-form-error" />
                        </div>
                    </div>

                    <div class="prod-form-field">
                        <label class="prod-form-label" for="pr-email">Email de contacto <span class="prod-form-required">*</span></label>
                        <form:input id="pr-email" path="contactEmail" type="email" class="prod-form-input" maxlength="255" />
                        <span class="prod-form-help">Usamos la cuenta con la que iniciaste sesión. No se puede cambiar.</span>
                        <form:errors path="contactEmail" element="span" cssClass="prod-form-error" />
                    </div>
                </section>

                <section id="step-productora" class="prod-form-step">
                    <h2 class="prod-form-step-title">Sobre tu productora</h2>
                    <p class="prod-form-step-help">Cómo te presentás al público.</p>

                    <div class="prod-form-field">
                        <label class="prod-form-label" for="pr-bio">Bio</label>
                        <form:textarea id="pr-bio" path="bio" class="prod-form-textarea" rows="5" maxlength="1500" placeholder="Contanos en 1-2 párrafos qué hace tu productora." />
                        <form:errors path="bio" element="span" cssClass="prod-form-error" />
                    </div>

                    <div class="prod-form-grid-2">
                        <div class="prod-form-field">
                            <label class="prod-form-label" for="pr-instagram">Instagram</label>
                            <form:input id="pr-instagram" path="instagram" class="prod-form-input" placeholder="@tuproductora" maxlength="255" />
                        </div>
                        <div class="prod-form-field">
                            <label class="prod-form-label" for="pr-website">Sitio web</label>
                            <form:input id="pr-website" path="website" class="prod-form-input" placeholder="https://…" maxlength="255" />
                        </div>
                    </div>

                    <div class="prod-form-grid-2">
                        <div class="prod-form-field">
                            <label class="prod-form-label" for="pr-team-size">Cantidad de integrantes</label>
                            <form:input id="pr-team-size" path="teamSize" type="number" min="1" class="prod-form-input" />
                            <form:errors path="teamSize" element="span" cssClass="prod-form-error" />
                        </div>
                    </div>

                    <div class="prod-form-field">
                        <label class="prod-form-label" for="pr-team-desc">Integrantes clave y roles</label>
                        <form:textarea id="pr-team-desc" path="teamDescription" class="prod-form-textarea" rows="4" maxlength="1500" />
                    </div>
                </section>

                <section id="step-antecedentes" class="prod-form-step">
                    <h2 class="prod-form-step-title">Antecedentes</h2>
                    <p class="prod-form-step-help">Contanos qué obras produjiste antes.</p>

                    <div class="prod-form-field">
                        <label class="prod-form-label" for="pr-previous">Obras previas <span class="prod-form-required">*</span></label>
                        <form:textarea id="pr-previous" path="previousWorks" class="prod-form-textarea" rows="7" maxlength="2500" placeholder="Título · Año · Teatro · Dirección…" />
                        <form:errors path="previousWorks" element="span" cssClass="prod-form-error" />
                    </div>
                </section>

                <section id="step-confirmar" class="prod-form-step">
                    <h2 class="prod-form-step-title">Confirmar y enviar</h2>
                    <p class="prod-form-step-help">Revisá que los datos estén correctos. Una vez enviada la solicitud no se puede editar hasta que el admin responda.</p>

                    <div class="prod-form-confirm-box">
                        <p>Al enviar esta solicitud aceptás que Platea verifique la información proporcionada con las entidades correspondientes. La revisión puede tomar entre 2 y 5 días hábiles.</p>
                    </div>

                    <div class="prod-form-submit-row">
                        <a href="${backUrl}" class="btn btn-ghost btn-md">Cancelar</a>
                        <button type="submit" class="btn btn-primary btn-md">
                            <c:choose>
                                <c:when test="${existingRequest != null}">Reenviar postulación</c:when>
                                <c:otherwise>Enviar solicitud</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </section>

            </form:form>
        </div>
    </main>
</body>
</html>
