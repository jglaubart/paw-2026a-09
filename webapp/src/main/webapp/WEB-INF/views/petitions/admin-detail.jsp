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
    <script src="${pageContext.request.contextPath}/js/components/play-petitions-admin-detail.js" defer></script>
</head>
<body>
<paw:navbar />

<main class="petition-admin-page petition-admin-page-detail">
    <section class="petition-admin-shell petition-admin-detail-shell">
        <div class="petition-admin-detail-header petition-admin-panel petition-admin-panel-hero">
            <c:url var="adminListUrl" value="/admin" />
            <a href="${adminListUrl}" class="petition-admin-back">← Volver al listado</a>
            <div class="petition-admin-card-head">
                <span class="petition-admin-status petition-admin-status-${fn:toLowerCase(petition.status)}"><c:out value="${petition.status}" /></span>
                <p class="petition-admin-card-id">Solicitud #<c:out value="${petition.id}" /></p>
            </div>
            <h1><c:out value="${petition.title}" /></h1>
            <p class="petition-admin-card-meta"><c:out value="${petition.petitionerEmail}" /> · <c:out value="${petition.theater}" /></p>
        </div>

        <c:if test="${updated eq 'approved'}"><div class="petition-admin-alert"><paw:alert variant="success" message="La petición fue aprobada y se notificó al solicitante." showClose="false" /></div></c:if>
        <c:if test="${updated eq 'changes_requested'}"><div class="petition-admin-alert"><paw:alert variant="warning" message="Se solicitaron cambios y el draft ya quedó disponible para el solicitante." showClose="false" /></div></c:if>
        <c:if test="${error eq 'already_resolved'}"><div class="petition-admin-alert"><paw:alert variant="error" message="La petición ya estaba resuelta." showClose="false" /></div></c:if>
        <c:if test="${error eq 'invalid_action'}"><div class="petition-admin-alert"><paw:alert variant="error" message="La acción solicitada no es válida." showClose="false" /></div></c:if>
        <c:if test="${error eq 'invalid_review'}"><div class="petition-admin-alert"><paw:alert variant="error" message="Marcá al menos un campo observado y explicá qué corregir antes de pedir cambios." showClose="false" /></div></c:if>

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
                    <dt>Idioma</dt>
                    <dd><c:out value="${petition.language}" /></dd>
                    <dt>Dirección</dt>
                    <dd><c:out value="${petition.director}" /></dd>
                    <dt>Teatro / sala</dt>
                    <dd><c:out value="${petition.theater}" /></dd>
                    <dt>Dirección de la sala</dt>
                    <dd><c:out value="${petition.theaterAddress}" /></dd>
                    <dt>Inicio de temporada</dt>
                    <dd><c:out value="${petition.startDate}" /></dd>
                    <dt>Fin de temporada</dt>
                    <dd><c:out value="${petition.endDate}" /></dd>
                    <c:if test="${not empty petition.additionalShowDates}">
                        <dt>Fechas adicionales</dt>
                        <dd>
                            <c:forEach var="showDate" items="${petition.additionalShowDates}" varStatus="status">
                                <c:out value="${showDate}" /><c:if test="${not status.last}">, </c:if>
                            </c:forEach>
                        </dd>
                    </c:if>
                    <c:if test="${not empty petition.schedule}">
                        <dt>Horarios</dt>
                        <dd><c:out value="${petition.schedule}" /></dd>
                    </c:if>
                    <c:if test="${not empty petition.ticketUrl}">
                        <dt>Entradas</dt>
                        <dd><a class="petition-admin-inline-link" href="${fn:escapeXml(petition.ticketUrl)}" target="_blank" rel="noreferrer">Ver link</a></dd>
                    </c:if>
                    <c:if test="${petition.sourceObraId != null}">
                        <dt>Obra reutilizada</dt>
                        <dd>Esta petición está vinculada a una obra existente. Al aprobar, se crea solo una nueva producción.</dd>
                    </c:if>
                </dl>
            </section>

            <section class="petition-admin-panel petition-admin-panel-actions">
                <h2>Decisión editorial</h2>
                <p class="petition-admin-panel-copy">Marcá únicamente los campos con problemas y dejá un comentario concreto para que el submitter vea qué corregir dentro del draft.</p>

                <c:if test="${petition.status eq 'PENDING'}">
                    <c:url var="decisionUrl" value="/admin/${petition.id}/decision" />
                    <form action="${decisionUrl}" method="post" class="petition-admin-decision-form">
                        <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />

                        <label for="adminNotes">Resumen general para el solicitante</label>
                        <textarea id="adminNotes" name="adminNotes" rows="4" class="petition-admin-notes"><c:out value="${reviewForm.adminNotes}" /></textarea>

                        <div class="petition-admin-review-grid">
                            <c:set var="titleToken" value=",title," />
                            <c:set var="titleSelected" value="${fn:contains(selectedIssueFieldsCsv, titleToken)}" />
                            <div class="petition-admin-review-item">
                                <label class="petition-admin-review-checkbox"><input type="checkbox" name="issueFields" value="title" data-review-issue-toggle="true" data-comment-key="title" <c:if test="${titleSelected}">checked="checked"</c:if> />Título</label>
                                <p class="petition-admin-review-value"><c:out value="${petition.title}" /></p>
                                <div class="petition-admin-review-comment ${titleSelected ? '' : 'petition-admin-review-comment-hidden'}" data-review-comment="title">
                                    <label for="field-comment-title" class="petition-admin-review-comment-label">Motivo</label>
                                    <textarea id="field-comment-title" name="fieldComments[title]" rows="2" placeholder="Explicá por qué el título no es correcto" data-review-comment-input="title" <c:if test="${not titleSelected}">disabled="disabled"</c:if>><c:out value="${reviewForm.fieldComments['title']}" /></textarea>
                                </div>
                            </div>

                            <c:set var="synopsisToken" value=",synopsis," />
                            <c:set var="synopsisSelected" value="${fn:contains(selectedIssueFieldsCsv, synopsisToken)}" />
                            <div class="petition-admin-review-item">
                                <label class="petition-admin-review-checkbox"><input type="checkbox" name="issueFields" value="synopsis" data-review-issue-toggle="true" data-comment-key="synopsis" <c:if test="${synopsisSelected}">checked="checked"</c:if> />Sinopsis</label>
                                <p class="petition-admin-review-value"><c:out value="${petition.synopsis}" /></p>
                                <div class="petition-admin-review-comment ${synopsisSelected ? '' : 'petition-admin-review-comment-hidden'}" data-review-comment="synopsis">
                                    <label for="field-comment-synopsis" class="petition-admin-review-comment-label">Motivo</label>
                                    <textarea id="field-comment-synopsis" name="fieldComments[synopsis]" rows="2" placeholder="Explicá por qué la sinopsis no es correcta" data-review-comment-input="synopsis" <c:if test="${not synopsisSelected}">disabled="disabled"</c:if>><c:out value="${reviewForm.fieldComments['synopsis']}" /></textarea>
                                </div>
                            </div>

                            <c:set var="genreToken" value=",genreIds," />
                            <c:set var="genreSelected" value="${fn:contains(selectedIssueFieldsCsv, genreToken)}" />
                            <div class="petition-admin-review-item">
                                <label class="petition-admin-review-checkbox"><input type="checkbox" name="issueFields" value="genreIds" data-review-issue-toggle="true" data-comment-key="genreIds" <c:if test="${genreSelected}">checked="checked"</c:if> />Géneros</label>
                                <p class="petition-admin-review-value">
                                    <c:forEach var="genre" items="${petition.genres}" varStatus="status">
                                        <c:out value="${genre.name}" /><c:if test="${not status.last}">, </c:if>
                                    </c:forEach>
                                </p>
                                <div class="petition-admin-review-comment ${genreSelected ? '' : 'petition-admin-review-comment-hidden'}" data-review-comment="genreIds">
                                    <label for="field-comment-genreIds" class="petition-admin-review-comment-label">Motivo</label>
                                    <textarea id="field-comment-genreIds" name="fieldComments[genreIds]" rows="2" placeholder="Explicá por qué los géneros no son correctos" data-review-comment-input="genreIds" <c:if test="${not genreSelected}">disabled="disabled"</c:if>><c:out value="${reviewForm.fieldComments['genreIds']}" /></textarea>
                                </div>
                            </div>

                            <c:set var="durationToken" value=",durationMinutes," />
                            <c:set var="durationSelected" value="${fn:contains(selectedIssueFieldsCsv, durationToken)}" />
                            <div class="petition-admin-review-item">
                                <label class="petition-admin-review-checkbox"><input type="checkbox" name="issueFields" value="durationMinutes" data-review-issue-toggle="true" data-comment-key="durationMinutes" <c:if test="${durationSelected}">checked="checked"</c:if> />Duración</label>
                                <p class="petition-admin-review-value"><c:out value="${petition.durationMinutes}" /> minutos</p>
                                <div class="petition-admin-review-comment ${durationSelected ? '' : 'petition-admin-review-comment-hidden'}" data-review-comment="durationMinutes">
                                    <label for="field-comment-durationMinutes" class="petition-admin-review-comment-label">Motivo</label>
                                    <textarea id="field-comment-durationMinutes" name="fieldComments[durationMinutes]" rows="2" placeholder="Explicá por qué la duración no es correcta" data-review-comment-input="durationMinutes" <c:if test="${not durationSelected}">disabled="disabled"</c:if>><c:out value="${reviewForm.fieldComments['durationMinutes']}" /></textarea>
                                </div>
                            </div>

                            <c:set var="languageToken" value=",language," />
                            <c:set var="languageSelected" value="${fn:contains(selectedIssueFieldsCsv, languageToken)}" />
                            <div class="petition-admin-review-item">
                                <label class="petition-admin-review-checkbox"><input type="checkbox" name="issueFields" value="language" data-review-issue-toggle="true" data-comment-key="language" <c:if test="${languageSelected}">checked="checked"</c:if> />Idioma</label>
                                <p class="petition-admin-review-value"><c:out value="${petition.language}" /></p>
                                <div class="petition-admin-review-comment ${languageSelected ? '' : 'petition-admin-review-comment-hidden'}" data-review-comment="language">
                                    <label for="field-comment-language" class="petition-admin-review-comment-label">Motivo</label>
                                    <textarea id="field-comment-language" name="fieldComments[language]" rows="2" placeholder="Explicá por qué el idioma no es correcto" data-review-comment-input="language" <c:if test="${not languageSelected}">disabled="disabled"</c:if>><c:out value="${reviewForm.fieldComments['language']}" /></textarea>
                                </div>
                            </div>

                            <c:set var="theaterToken" value=",theater," />
                            <c:set var="theaterSelected" value="${fn:contains(selectedIssueFieldsCsv, theaterToken)}" />
                            <div class="petition-admin-review-item">
                                <label class="petition-admin-review-checkbox"><input type="checkbox" name="issueFields" value="theater" data-review-issue-toggle="true" data-comment-key="theater" <c:if test="${theaterSelected}">checked="checked"</c:if> />Teatro / sala</label>
                                <p class="petition-admin-review-value"><c:out value="${petition.theater}" /></p>
                                <div class="petition-admin-review-comment ${theaterSelected ? '' : 'petition-admin-review-comment-hidden'}" data-review-comment="theater">
                                    <label for="field-comment-theater" class="petition-admin-review-comment-label">Motivo</label>
                                    <textarea id="field-comment-theater" name="fieldComments[theater]" rows="2" placeholder="Explicá por qué la sala no es correcta" data-review-comment-input="theater" <c:if test="${not theaterSelected}">disabled="disabled"</c:if>><c:out value="${reviewForm.fieldComments['theater']}" /></textarea>
                                </div>
                            </div>

                            <c:set var="theaterAddressToken" value=",theaterAddress," />
                            <c:set var="theaterAddressSelected" value="${fn:contains(selectedIssueFieldsCsv, theaterAddressToken)}" />
                            <div class="petition-admin-review-item">
                                <label class="petition-admin-review-checkbox"><input type="checkbox" name="issueFields" value="theaterAddress" data-review-issue-toggle="true" data-comment-key="theaterAddress" <c:if test="${theaterAddressSelected}">checked="checked"</c:if> />Dirección de la sala</label>
                                <p class="petition-admin-review-value"><c:out value="${petition.theaterAddress}" /></p>
                                <div class="petition-admin-review-comment ${theaterAddressSelected ? '' : 'petition-admin-review-comment-hidden'}" data-review-comment="theaterAddress">
                                    <label for="field-comment-theaterAddress" class="petition-admin-review-comment-label">Motivo</label>
                                    <textarea id="field-comment-theaterAddress" name="fieldComments[theaterAddress]" rows="2" placeholder="Explicá por qué la dirección no es correcta" data-review-comment-input="theaterAddress" <c:if test="${not theaterAddressSelected}">disabled="disabled"</c:if>><c:out value="${reviewForm.fieldComments['theaterAddress']}" /></textarea>
                                </div>
                            </div>

                            <c:set var="startDateToken" value=",startDate," />
                            <c:set var="startDateSelected" value="${fn:contains(selectedIssueFieldsCsv, startDateToken)}" />
                            <div class="petition-admin-review-item">
                                <label class="petition-admin-review-checkbox"><input type="checkbox" name="issueFields" value="startDate" data-review-issue-toggle="true" data-comment-key="startDate" <c:if test="${startDateSelected}">checked="checked"</c:if> />Inicio</label>
                                <p class="petition-admin-review-value"><c:out value="${petition.startDate}" /></p>
                                <div class="petition-admin-review-comment ${startDateSelected ? '' : 'petition-admin-review-comment-hidden'}" data-review-comment="startDate">
                                    <label for="field-comment-startDate" class="petition-admin-review-comment-label">Motivo</label>
                                    <textarea id="field-comment-startDate" name="fieldComments[startDate]" rows="2" placeholder="Explicá por qué la fecha de inicio no es correcta" data-review-comment-input="startDate" <c:if test="${not startDateSelected}">disabled="disabled"</c:if>><c:out value="${reviewForm.fieldComments['startDate']}" /></textarea>
                                </div>
                            </div>

                            <c:set var="endDateToken" value=",endDate," />
                            <c:set var="endDateSelected" value="${fn:contains(selectedIssueFieldsCsv, endDateToken)}" />
                            <div class="petition-admin-review-item">
                                <label class="petition-admin-review-checkbox"><input type="checkbox" name="issueFields" value="endDate" data-review-issue-toggle="true" data-comment-key="endDate" <c:if test="${endDateSelected}">checked="checked"</c:if> />Fin</label>
                                <p class="petition-admin-review-value"><c:out value="${petition.endDate}" /></p>
                                <div class="petition-admin-review-comment ${endDateSelected ? '' : 'petition-admin-review-comment-hidden'}" data-review-comment="endDate">
                                    <label for="field-comment-endDate" class="petition-admin-review-comment-label">Motivo</label>
                                    <textarea id="field-comment-endDate" name="fieldComments[endDate]" rows="2" placeholder="Explicá por qué la fecha de fin no es correcta" data-review-comment-input="endDate" <c:if test="${not endDateSelected}">disabled="disabled"</c:if>><c:out value="${reviewForm.fieldComments['endDate']}" /></textarea>
                                </div>
                            </div>

                            <c:set var="additionalDatesToken" value=",additionalShowDates," />
                            <c:set var="additionalDatesSelected" value="${fn:contains(selectedIssueFieldsCsv, additionalDatesToken)}" />
                            <div class="petition-admin-review-item">
                                <label class="petition-admin-review-checkbox"><input type="checkbox" name="issueFields" value="additionalShowDates" data-review-issue-toggle="true" data-comment-key="additionalShowDates" <c:if test="${additionalDatesSelected}">checked="checked"</c:if> />Fechas adicionales</label>
                                <p class="petition-admin-review-value">
                                    <c:choose>
                                        <c:when test="${empty petition.additionalShowDates}">Sin fechas adicionales.</c:when>
                                        <c:otherwise>
                                            <c:forEach var="showDate" items="${petition.additionalShowDates}" varStatus="status">
                                                <c:out value="${showDate}" /><c:if test="${not status.last}">, </c:if>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <div class="petition-admin-review-comment ${additionalDatesSelected ? '' : 'petition-admin-review-comment-hidden'}" data-review-comment="additionalShowDates">
                                    <label for="field-comment-additionalShowDates" class="petition-admin-review-comment-label">Motivo</label>
                                    <textarea id="field-comment-additionalShowDates" name="fieldComments[additionalShowDates]" rows="2" placeholder="Explicá por qué estas fechas no son correctas" data-review-comment-input="additionalShowDates" <c:if test="${not additionalDatesSelected}">disabled="disabled"</c:if>><c:out value="${reviewForm.fieldComments['additionalShowDates']}" /></textarea>
                                </div>
                            </div>

                            <c:set var="directorToken" value=",director," />
                            <c:set var="directorSelected" value="${fn:contains(selectedIssueFieldsCsv, directorToken)}" />
                            <div class="petition-admin-review-item">
                                <label class="petition-admin-review-checkbox"><input type="checkbox" name="issueFields" value="director" data-review-issue-toggle="true" data-comment-key="director" <c:if test="${directorSelected}">checked="checked"</c:if> />Dirección</label>
                                <p class="petition-admin-review-value"><c:out value="${petition.director}" /></p>
                                <div class="petition-admin-review-comment ${directorSelected ? '' : 'petition-admin-review-comment-hidden'}" data-review-comment="director">
                                    <label for="field-comment-director" class="petition-admin-review-comment-label">Motivo</label>
                                    <textarea id="field-comment-director" name="fieldComments[director]" rows="2" placeholder="Explicá por qué la dirección no es correcta" data-review-comment-input="director" <c:if test="${not directorSelected}">disabled="disabled"</c:if>><c:out value="${reviewForm.fieldComments['director']}" /></textarea>
                                </div>
                            </div>

                            <c:set var="coverImageToken" value=",coverImage," />
                            <c:set var="coverImageSelected" value="${fn:contains(selectedIssueFieldsCsv, coverImageToken)}" />
                            <div class="petition-admin-review-item">
                                <label class="petition-admin-review-checkbox"><input type="checkbox" name="issueFields" value="coverImage" data-review-issue-toggle="true" data-comment-key="coverImage" <c:if test="${coverImageSelected}">checked="checked"</c:if> />Portada</label>
                                <p class="petition-admin-review-value">Imagen cargada ${petition.coverImageId != null ? 'correctamente' : 'sin portada'}.</p>
                                <div class="petition-admin-review-comment ${coverImageSelected ? '' : 'petition-admin-review-comment-hidden'}" data-review-comment="coverImage">
                                    <label for="field-comment-coverImage" class="petition-admin-review-comment-label">Motivo</label>
                                    <textarea id="field-comment-coverImage" name="fieldComments[coverImage]" rows="2" placeholder="Explicá por qué la portada no es correcta" data-review-comment-input="coverImage" <c:if test="${not coverImageSelected}">disabled="disabled"</c:if>><c:out value="${reviewForm.fieldComments['coverImage']}" /></textarea>
                                </div>
                            </div>

                            <c:set var="scheduleToken" value=",schedule," />
                            <c:set var="scheduleSelected" value="${fn:contains(selectedIssueFieldsCsv, scheduleToken)}" />
                            <div class="petition-admin-review-item">
                                <label class="petition-admin-review-checkbox"><input type="checkbox" name="issueFields" value="schedule" data-review-issue-toggle="true" data-comment-key="schedule" <c:if test="${scheduleSelected}">checked="checked"</c:if> />Horarios</label>
                                <p class="petition-admin-review-value"><c:out value="${empty petition.schedule ? 'Sin horarios informados.' : petition.schedule}" /></p>
                                <div class="petition-admin-review-comment ${scheduleSelected ? '' : 'petition-admin-review-comment-hidden'}" data-review-comment="schedule">
                                    <label for="field-comment-schedule" class="petition-admin-review-comment-label">Motivo</label>
                                    <textarea id="field-comment-schedule" name="fieldComments[schedule]" rows="2" placeholder="Explicá por qué los horarios no son correctos" data-review-comment-input="schedule" <c:if test="${not scheduleSelected}">disabled="disabled"</c:if>><c:out value="${reviewForm.fieldComments['schedule']}" /></textarea>
                                </div>
                            </div>

                            <c:set var="ticketUrlToken" value=",ticketUrl," />
                            <c:set var="ticketUrlSelected" value="${fn:contains(selectedIssueFieldsCsv, ticketUrlToken)}" />
                            <div class="petition-admin-review-item">
                                <label class="petition-admin-review-checkbox"><input type="checkbox" name="issueFields" value="ticketUrl" data-review-issue-toggle="true" data-comment-key="ticketUrl" <c:if test="${ticketUrlSelected}">checked="checked"</c:if> />Link de entradas</label>
                                <p class="petition-admin-review-value"><c:out value="${empty petition.ticketUrl ? 'Sin link informado.' : petition.ticketUrl}" /></p>
                                <div class="petition-admin-review-comment ${ticketUrlSelected ? '' : 'petition-admin-review-comment-hidden'}" data-review-comment="ticketUrl">
                                    <label for="field-comment-ticketUrl" class="petition-admin-review-comment-label">Motivo</label>
                                    <textarea id="field-comment-ticketUrl" name="fieldComments[ticketUrl]" rows="2" placeholder="Explicá por qué el link de entradas no es correcto" data-review-comment-input="ticketUrl" <c:if test="${not ticketUrlSelected}">disabled="disabled"</c:if>><c:out value="${reviewForm.fieldComments['ticketUrl']}" /></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="petition-admin-actions">
                            <button type="submit" name="action" value="approve" class="btn btn-md petition-admin-approve">Aprobar</button>
                            <button type="submit" name="action" value="request_changes" class="btn btn-md petition-admin-request-changes">Solicitar cambios</button>
                        </div>
                    </form>
                </c:if>

                <c:if test="${petition.status ne 'PENDING'}">
                    <div class="petition-admin-resolution">
                        <c:choose>
                            <c:when test="${petition.status eq 'CHANGES_REQUESTED'}">
                                <p class="petition-admin-resolution-title">La petición está esperando correcciones del submitter.</p>
                            </c:when>
                            <c:otherwise>
                                <p class="petition-admin-resolution-title">Esta petición ya fue aprobada.</p>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${not empty petition.adminNotes}">
                            <p><strong>Notas:</strong> <c:out value="${petition.adminNotes}" /></p>
                        </c:if>

                        <c:if test="${not empty fieldFeedback}">
                            <div class="petition-admin-feedback-list">
                                <c:forEach var="entry" items="${fieldFeedback}">
                                    <div class="petition-admin-feedback-item">
                                        <strong><c:out value="${entry.key}" /></strong>
                                        <p><c:out value="${entry.value}" /></p>
                                    </div>
                                </c:forEach>
                            </div>
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
