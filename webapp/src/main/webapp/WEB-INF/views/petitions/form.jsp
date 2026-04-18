<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Subir obra a Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/alert.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/play-petition-form.css" />
    <script src="${pageContext.request.contextPath}/js/components/play-petition-form.js" defer></script>
</head>
<body>
<c:url var="heroImageUrl" value="/images/Portadas/hamilton.jpg" />
<c:url var="subirObraUrl" value="/subir-obra" />
<c:set var="maxUploadMb" value="5" />
<c:set var="hasFeedbackTitle" value="${not empty fieldFeedback['title']}" />
<c:set var="hasFeedbackSynopsis" value="${not empty fieldFeedback['synopsis']}" />
<c:set var="hasFeedbackGenreIds" value="${not empty fieldFeedback['genreIds']}" />
<c:set var="hasFeedbackDuration" value="${not empty fieldFeedback['durationMinutes']}" />
<c:set var="hasFeedbackLanguage" value="${not empty fieldFeedback['language']}" />
<c:set var="hasFeedbackTheater" value="${not empty fieldFeedback['theater']}" />
<c:set var="hasFeedbackTheaterAddress" value="${not empty fieldFeedback['theaterAddress']}" />
<c:set var="hasFeedbackStartDate" value="${not empty fieldFeedback['startDate']}" />
<c:set var="hasFeedbackDirector" value="${not empty fieldFeedback['director']}" />
<c:set var="hasFeedbackCoverImage" value="${not empty fieldFeedback['coverImage']}" />
<c:set var="hasFeedbackEndDate" value="${not empty fieldFeedback['endDate']}" />
<c:set var="hasFeedbackSchedule" value="${not empty fieldFeedback['schedule']}" />
<c:set var="hasFeedbackTicketUrl" value="${not empty fieldFeedback['ticketUrl']}" />
<c:set var="hasFeedbackAdditionalDates" value="${not empty fieldFeedback['additionalShowDates']}" />
<c:choose>
    <c:when test="${hasEditableDraft}">
        <c:set var="submitButtonText" value="Reenviar petición" />
        <c:set var="actionsTitle" value="Volvimos a abrir tu draft para que lo ajustes con los comentarios del equipo." />
        <c:set var="actionsText" value="Corregí únicamente los campos observados o aprovechá para mejorar el resto. Cuando la reenviás, vuelve al panel editorial sin perder el historial." />
    </c:when>
    <c:otherwise>
        <c:set var="submitButtonText" value="Enviar petición" />
        <c:set var="actionsTitle" value="Una vez enviada, la revisamos manualmente." />
        <c:set var="actionsText" value="Si aprobamos la petición, generamos automáticamente la obra y su producción base dentro de Platea." />
    </c:otherwise>
</c:choose>

<paw:navbar />

<section class="petition-hero">
    <img class="petition-hero-bg" src="${heroImageUrl}" alt="" aria-hidden="true" />
    <div class="petition-hero-gradient" aria-hidden="true"></div>
    <div class="petition-hero-content">
        <p class="petition-hero-kicker">Convocatoria Platea</p>
        <h1 class="petition-hero-title">Traé tu obra a la cartelera</h1>
        <p class="petition-hero-copy">Armamos un flujo de dos pasos para que cargues rápido lo esencial y completes después una ficha con el tono editorial del resto del sitio.</p>
        <div class="petition-hero-pills">
            <span class="petition-hero-pill">Revision manual</span>
            <span class="petition-hero-pill">Draft editable</span>
            <span class="petition-hero-pill">Respuesta por mail</span>
        </div>
    </div>
</section>

<main class="petition-form-page">
    <section class="petition-form-shell petition-form-layout">
        <aside class="petition-form-sidebar">
            <div class="petition-form-sidebar-card">
                <p class="petition-form-kicker">Carga guiada</p>
                <h2>Cómo evaluamos una postulación</h2>
                <ol class="petition-form-checklist">
                    <li>Revisamos identidad visual, sinopsis y datos clave de programación.</li>
                    <li>Si ya existe una obra en cartelera, podés reutilizarla y cargar solo una nueva producción.</li>
                    <li>Si el equipo pide cambios, retomás exactamente esta ficha sin empezar de cero.</li>
                </ol>
            </div>

            <div class="petition-form-sidebar-card petition-form-sidebar-card-accent">
                <p class="petition-form-sidebar-title">Antes de enviar</p>
                <p class="petition-form-sidebar-copy">Los campos con <span class="petition-form-required">*</span> son obligatorios. La imagen de portada puede pesar hasta <c:out value="${maxUploadMb}" /> MB.</p>
            </div>

            <div class="petition-form-sidebar-card petition-form-sidebar-card-history">
                <p class="petition-form-sidebar-title">Mis peticiones</p>
                <c:choose>
                    <c:when test="${empty myPetitions}">
                        <p class="petition-form-sidebar-copy">Todav&iacute;a no enviaste peticiones. Cuando lo hagas, ac&aacute; vas a poder seguir su estado.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="petition-form-history-list">
                            <c:forEach var="petitionItem" items="${myPetitions}">
                                <c:set var="petitionIdText" value="${petitionItem.id}" />
                                <c:set var="petitionStatusClass" value="petition-form-history-status-pending" />
                                <c:set var="petitionStatusText" value="Pendiente" />
                                <c:choose>
                                    <c:when test="${petitionItem.status eq 'CHANGES_REQUESTED'}">
                                        <c:set var="petitionStatusClass" value="petition-form-history-status-changes_requested" />
                                        <c:set var="petitionStatusText" value="Cambios solicitados" />
                                    </c:when>
                                    <c:when test="${petitionItem.status eq 'APPROVED'}">
                                        <c:set var="petitionStatusClass" value="petition-form-history-status-approved" />
                                        <c:set var="petitionStatusText" value="Aprobada" />
                                    </c:when>
                                    <c:when test="${petitionItem.status eq 'REJECTED'}">
                                        <c:set var="petitionStatusClass" value="petition-form-history-status-rejected" />
                                        <c:set var="petitionStatusText" value="Rechazada" />
                                    </c:when>
                                </c:choose>

                                <details class="petition-form-history-item ${form.petitionId eq petitionIdText ? 'petition-form-history-item-active' : ''}">
                                    <summary class="petition-form-history-summary">
                                        <span class="petition-form-history-summary-main">
                                            <strong><c:out value="${petitionItem.title}" /></strong>
                                            <small>Solicitud #<c:out value="${petitionItem.id}" /></small>
                                        </span>
                                        <span class="petition-form-history-status ${petitionStatusClass}"><c:out value="${petitionStatusText}" /></span>
                                    </summary>

                                    <div class="petition-form-history-content">
                                        <p><strong>Teatro:</strong> <c:out value="${petitionItem.theater}" /></p>
                                        <p><strong>Creada:</strong> <c:out value="${petitionItem.createdAt}" /></p>
                                        <c:if test="${petitionItem.resolvedAt != null}">
                                            <p><strong>Resuelta:</strong> <c:out value="${petitionItem.resolvedAt}" /></p>
                                        </c:if>
                                        <c:if test="${petitionItem.status eq 'CHANGES_REQUESTED'}">
                                            <c:url var="resumePetitionUrl" value="/subir-obra">
                                                <c:param name="petitionId" value="${petitionItem.id}" />
                                            </c:url>
                                            <a href="${resumePetitionUrl}" class="petition-form-history-action">Retomar esta ficha</a>
                                        </c:if>
                                        <c:if test="${petitionItem.status ne 'CHANGES_REQUESTED'}">
                                            <p class="petition-form-history-note">Esta petici&oacute;n no est&aacute; editable por ahora.</p>
                                        </c:if>
                                    </div>
                                </details>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </aside>

        <section class="petition-form-content">
            <div class="petition-form-header">
                <p class="petition-form-kicker">Carga de contenido</p>
                <h2>Postulá tu obra para Platea</h2>
                <p class="petition-form-lead">Completá lo esencial primero y después agregá los datos opcionales para que el equipo pueda revisar tu propuesta.</p>
            </div>

            <c:if test="${created}">
                <div class="petition-form-alert">
                    <paw:alert variant="success" title="Solicitud enviada" message="Recibimos tu petición y te enviamos un correo de confirmación al email informado." showClose="false" />
                </div>
            </c:if>

            <c:if test="${hasEditableDraft}">
                <div class="petition-form-alert">
                    <paw:alert variant="warning" title="Hay cambios solicitados" message="El equipo marcó los campos que necesitaban ajustes. Debajo de cada uno vas a ver qué corregir antes de reenviar la petición." showClose="false" />
                </div>
            </c:if>

            <c:if test="${hasEditableDraft and currentPetition ne null and not empty currentPetition.adminNotes}">
                <div class="petition-form-admin-note">
                    <p class="petition-form-admin-note-title">Resumen editorial</p>
                    <p class="petition-form-admin-note-copy"><c:out value="${currentPetition.adminNotes}" /></p>
                </div>
            </c:if>

            <c:if test="${not empty errors['global']}">
                <div class="petition-form-alert">
                    <paw:alert variant="error" title="No pudimos enviar la petición" message="${errors['global']}" showClose="false" />
                </div>
            </c:if>

            <form action="${subirObraUrl}" method="post" enctype="multipart/form-data"
                  class="petition-form-card" data-play-petition-form
                  data-context-path="${pageContext.request.contextPath}"
                  data-autocomplete-url="${pageContext.request.contextPath}/subir-obra/autocomplete"
                  data-prefill-url-base="${pageContext.request.contextPath}/subir-obra/autocomplete/">
                <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                <input type="hidden" name="petitionId" value="${fn:escapeXml(form.petitionId)}" />
                <input type="hidden" name="sourceObraId" value="${fn:escapeXml(form.sourceObraId)}" data-source-obra-id />
                <input type="hidden" name="sourceProductionId" value="${fn:escapeXml(form.sourceProductionId)}" data-source-production-id />
                <input type="hidden" name="existingCoverImageId" value="${fn:escapeXml(form.existingCoverImageId)}" data-existing-cover-image-id />

                <section class="petition-form-step">
                    <div class="petition-form-step-heading">
                        <span class="petition-form-step-number">1</span>
                        <div>
                            <h3>Lo esencial</h3>
                            <p>La información mínima para poder evaluar y publicar la obra.</p>
                        </div>
                    </div>

                    <div class="petition-form-grid petition-form-grid-two">
                        <div class="petition-form-field petition-form-field-full petition-form-autocomplete-field">
                            <label for="title">Título de la obra <span class="petition-form-required">*</span></label>
                            <input id="title" name="title" type="text" value="${fn:escapeXml(form.title)}" placeholder="Hamlet" autocomplete="off" data-title-autocomplete class="${hasFeedbackTitle ? 'petition-form-input-feedback' : ''}" />
                            <div class="petition-form-source-summary ${empty form.sourceObraId ? 'petition-form-error-hidden' : ''}" data-source-summary>
                                <span class="petition-form-source-pill">Vinculada a una obra existente</span>
                                <button type="button" class="petition-form-source-clear" data-clear-source-button>Limpiar selección</button>
                            </div>
                            <div class="petition-form-autocomplete-panel petition-form-error-hidden" data-autocomplete-results></div>
                            <c:if test="${not empty errors['title']}"><span class="petition-form-error"><c:out value="${errors['title']}" /></span></c:if>
                            <c:if test="${hasFeedbackTitle}"><div class="petition-form-review-note"><strong>Título observado:</strong> <c:out value="${fieldFeedback['title']}" /></div></c:if>
                        </div>

                        <div class="petition-form-field petition-form-field-full">
                            <label for="synopsis">Sinopsis <span class="petition-form-required">*</span></label>
                            <textarea id="synopsis" name="synopsis" rows="5" placeholder="Contá en uno o dos párrafos de qué trata la obra." class="${hasFeedbackSynopsis ? 'petition-form-input-feedback' : ''}" data-prefill-synopsis><c:out value="${form.synopsis}" /></textarea>
                            <c:if test="${not empty errors['synopsis']}"><span class="petition-form-error"><c:out value="${errors['synopsis']}" /></span></c:if>
                            <c:if test="${hasFeedbackSynopsis}"><div class="petition-form-review-note"><strong>Sinopsis observada:</strong> <c:out value="${fieldFeedback['synopsis']}" /></div></c:if>
                        </div>

                        <div class="petition-form-field petition-form-field-full">
                            <span class="petition-form-label">Géneros <span class="petition-form-required">*</span></span>
                            <div class="petition-form-genre-grid" data-prefill-genre-grid>
                                <c:forEach var="genre" items="${genres}">
                                    <c:set var="genreToken" value=",${genre.id}," />
                                    <label class="petition-form-genre-option ${hasFeedbackGenreIds ? 'petition-form-genre-option-feedback' : ''}">
                                        <input type="checkbox" name="genreIds" value="${genre.id}" data-genre-id="${genre.id}" <c:if test="${fn:contains(selectedGenreIdsCsv, genreToken)}">checked="checked"</c:if> />
                                        <span><c:out value="${genre.name}" /></span>
                                    </label>
                                </c:forEach>
                            </div>
                            <c:if test="${not empty errors['genreIds']}"><span class="petition-form-error"><c:out value="${errors['genreIds']}" /></span></c:if>
                            <c:if test="${hasFeedbackGenreIds}"><div class="petition-form-review-note"><strong>Géneros observados:</strong> <c:out value="${fieldFeedback['genreIds']}" /></div></c:if>
                        </div>

                        <div class="petition-form-field">
                            <label for="durationMinutes">Duración aproximada (minutos) <span class="petition-form-required">*</span></label>
                            <input id="durationMinutes" name="durationMinutes" type="number" min="1" value="${fn:escapeXml(form.durationMinutes)}" placeholder="95" class="${hasFeedbackDuration ? 'petition-form-input-feedback' : ''}" data-prefill-duration />
                            <c:if test="${not empty errors['durationMinutes']}"><span class="petition-form-error"><c:out value="${errors['durationMinutes']}" /></span></c:if>
                            <c:if test="${hasFeedbackDuration}"><div class="petition-form-review-note"><strong>Duración observada:</strong> <c:out value="${fieldFeedback['durationMinutes']}" /></div></c:if>
                        </div>

                        <div class="petition-form-field">
                            <label for="language">Idioma</label>
                            <input id="language" name="language" type="text" value="${fn:escapeXml(form.language)}" placeholder="Castellano" class="${hasFeedbackLanguage ? 'petition-form-input-feedback' : ''}" data-prefill-language />
                            <c:if test="${hasFeedbackLanguage}"><div class="petition-form-review-note"><strong>Idioma observado:</strong> <c:out value="${fieldFeedback['language']}" /></div></c:if>
                        </div>

                        <div class="petition-form-field">
                            <label for="theater">Teatro / sala <span class="petition-form-required">*</span></label>
                            <input id="theater" name="theater" type="text" value="${fn:escapeXml(form.theater)}" placeholder="Teatro Metropolitan" class="${hasFeedbackTheater ? 'petition-form-input-feedback' : ''}" data-prefill-theater />
                            <c:if test="${not empty errors['theater']}"><span class="petition-form-error"><c:out value="${errors['theater']}" /></span></c:if>
                            <c:if test="${hasFeedbackTheater}"><div class="petition-form-review-note"><strong>Sala observada:</strong> <c:out value="${fieldFeedback['theater']}" /></div></c:if>
                        </div>

                        <div class="petition-form-field">
                            <label for="theaterAddress">Dirección de la sala <span class="petition-form-required">*</span></label>
                            <input id="theaterAddress" name="theaterAddress" type="text" value="${fn:escapeXml(form.theaterAddress)}" placeholder="Av. Corrientes 1343" class="${hasFeedbackTheaterAddress ? 'petition-form-input-feedback' : ''}" data-prefill-theater-address />
                            <c:if test="${not empty errors['theaterAddress']}"><span class="petition-form-error"><c:out value="${errors['theaterAddress']}" /></span></c:if>
                            <c:if test="${hasFeedbackTheaterAddress}"><div class="petition-form-review-note"><strong>Dirección observada:</strong> <c:out value="${fieldFeedback['theaterAddress']}" /></div></c:if>
                        </div>

                        <div class="petition-form-field">
                            <label for="startDate">Inicio de temporada <span class="petition-form-required">*</span></label>
                            <input id="startDate" name="startDate" type="date" value="${fn:escapeXml(form.startDate)}" class="${hasFeedbackStartDate ? 'petition-form-input-feedback' : ''}" data-prefill-start-date />
                            <c:if test="${not empty errors['startDate']}"><span class="petition-form-error"><c:out value="${errors['startDate']}" /></span></c:if>
                            <c:if test="${hasFeedbackStartDate}"><div class="petition-form-review-note"><strong>Inicio observado:</strong> <c:out value="${fieldFeedback['startDate']}" /></div></c:if>
                        </div>

                        <div class="petition-form-field">
                            <label for="director">Dirección <span class="petition-form-required">*</span></label>
                            <input id="director" name="director" type="text" value="${fn:escapeXml(form.director)}" placeholder="Nombre del director o directora" class="${hasFeedbackDirector ? 'petition-form-input-feedback' : ''}" data-prefill-director />
                            <c:if test="${not empty errors['director']}"><span class="petition-form-error"><c:out value="${errors['director']}" /></span></c:if>
                            <c:if test="${hasFeedbackDirector}"><div class="petition-form-review-note"><strong>Dirección observada:</strong> <c:out value="${fieldFeedback['director']}" /></div></c:if>
                        </div>

                        <div class="petition-form-field petition-form-field-full petition-form-upload-field">
                            <label for="coverImage">Imagen de portada <span class="petition-form-required">*</span></label>
                            <input id="coverImage" name="coverImage" type="file" accept="image/*" data-max-bytes="5242880" class="${hasFeedbackCoverImage ? 'petition-form-input-feedback' : ''}" />
                            <div class="petition-form-cover-preview ${empty currentCoverImageUrl ? 'petition-form-error-hidden' : ''}" data-cover-preview-container>
                                <img src="${empty currentCoverImageUrl ? '' : pageContext.request.contextPath}${empty currentCoverImageUrl ? '' : currentCoverImageUrl}" alt="Portada seleccionada" data-cover-preview-image />
                                <div>
                                    <p class="petition-form-cover-preview-title">Portada actual</p>
                                    <p class="petition-form-cover-preview-copy">Podés mantener esta imagen o reemplazarla con un nuevo archivo.</p>
                                </div>
                            </div>
                            <p class="petition-form-hint">Subí un afiche o una imagen promocional en formato imagen. Tamaño máximo: <c:out value="${maxUploadMb}" /> MB.</p>
                            <c:if test="${not empty errors['coverImage']}"><span class="petition-form-error"><c:out value="${errors['coverImage']}" /></span></c:if>
                            <span class="petition-form-error petition-form-error-hidden" data-cover-image-size-error>La imagen excede el tamaño máximo permitido de <c:out value="${maxUploadMb}" /> MB.</span>
                            <c:if test="${hasFeedbackCoverImage}"><div class="petition-form-review-note"><strong>Portada observada:</strong> <c:out value="${fieldFeedback['coverImage']}" /></div></c:if>
                        </div>

                        <div class="petition-form-field petition-form-field-full">
                            <label for="petitionerEmail">Email de contacto <span class="petition-form-required">*</span></label>
                            <input id="petitionerEmail" name="petitionerEmail" type="email" value="${fn:escapeXml(form.petitionerEmail)}" placeholder="produccion@ejemplo.com" readonly="readonly" />
                            <p class="petition-form-hint">Usamos la cuenta con la que iniciaste sesión para confirmar la recepción y comunicar la decisión del equipo.</p>
                            <c:if test="${not empty errors['petitionerEmail']}"><span class="petition-form-error"><c:out value="${errors['petitionerEmail']}" /></span></c:if>
                        </div>
                    </div>
                </section>

                <section class="petition-form-step">
                    <div class="petition-form-step-heading">
                        <span class="petition-form-step-number">2</span>
                        <div>
                            <h3>Completá tu ficha</h3>
                            <p>La última fecha es obligatoria; el resto suma contexto para publicar una ficha mucho más útil.</p>
                        </div>
                    </div>

                    <div class="petition-form-grid petition-form-grid-two">
                        <div class="petition-form-field">
                            <label for="endDate">Última fecha de la producción <span class="petition-form-required">*</span></label>
                            <input id="endDate" name="endDate" type="date" value="${fn:escapeXml(form.endDate)}" class="${hasFeedbackEndDate ? 'petition-form-input-feedback' : ''}" data-prefill-end-date />
                            <c:if test="${not empty errors['endDate']}"><span class="petition-form-error"><c:out value="${errors['endDate']}" /></span></c:if>
                            <c:if test="${hasFeedbackEndDate}"><div class="petition-form-review-note"><strong>Fin observado:</strong> <c:out value="${fieldFeedback['endDate']}" /></div></c:if>
                        </div>

                        <div class="petition-form-field">
                            <label for="schedule">Días y horarios de función</label>
                            <input id="schedule" name="schedule" type="text" value="${fn:escapeXml(form.schedule)}" placeholder="Viernes y sábados 21 hs" class="${hasFeedbackSchedule ? 'petition-form-input-feedback' : ''}" />
                            <c:if test="${hasFeedbackSchedule}"><div class="petition-form-review-note"><strong>Horarios observados:</strong> <c:out value="${fieldFeedback['schedule']}" /></div></c:if>
                        </div>

                        <div class="petition-form-field petition-form-field-full">
                            <label for="ticketUrl">Link de venta de entradas</label>
                            <input id="ticketUrl" name="ticketUrl" type="url" value="${fn:escapeXml(form.ticketUrl)}" placeholder="https://alternativateatral.com/..." class="${hasFeedbackTicketUrl ? 'petition-form-input-feedback' : ''}" data-prefill-ticket-url />
                            <c:if test="${not empty errors['ticketUrl']}"><span class="petition-form-error"><c:out value="${errors['ticketUrl']}" /></span></c:if>
                            <c:if test="${hasFeedbackTicketUrl}"><div class="petition-form-review-note"><strong>Link observado:</strong> <c:out value="${fieldFeedback['ticketUrl']}" /></div></c:if>
                        </div>

                        <div class="petition-form-field petition-form-field-full">
                            <div class="petition-form-extra-dates-head">
                                <label>Fechas adicionales de función</label>
                                <button type="button" class="petition-form-add-date" data-add-date-button>Agregar fecha</button>
                            </div>
                            <div class="petition-form-extra-dates" data-additional-dates>
                                <c:choose>
                                    <c:when test="${not empty form.additionalShowDates}">
                                        <c:forEach var="extraDate" items="${form.additionalShowDates}">
                                            <input type="date" name="additionalShowDates" value="${fn:escapeXml(extraDate)}" class="petition-form-extra-date-input ${hasFeedbackAdditionalDates ? 'petition-form-input-feedback' : ''}" />
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="date" name="additionalShowDates" value="" class="petition-form-extra-date-input ${hasFeedbackAdditionalDates ? 'petition-form-input-feedback' : ''}" />
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <p class="petition-form-hint">Podés sumar fechas puntuales extra además del inicio y del cierre de la producción.</p>
                            <c:if test="${not empty errors['additionalShowDates']}"><span class="petition-form-error"><c:out value="${errors['additionalShowDates']}" /></span></c:if>
                            <c:if test="${hasFeedbackAdditionalDates}"><div class="petition-form-review-note"><strong>Fechas adicionales observadas:</strong> <c:out value="${fieldFeedback['additionalShowDates']}" /></div></c:if>
                        </div>
                    </div>
                </section>

                <div class="petition-form-actions">
                    <div class="petition-form-actions-copy">
                        <p class="petition-form-actions-title"><c:out value="${actionsTitle}" /></p>
                        <p class="petition-form-actions-text"><c:out value="${actionsText}" /></p>
                    </div>
                    <paw:button text="${submitButtonText}" type="submit" variant="cta" cssClass="petition-form-submit" />
                </div>
            </form>
        </section>
    </section>
</main>
</body>
</html>
