<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Petición #<c:out value="${petition.id}" /> — Backoffice</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/alert.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/productora.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/admin-backoffice.css" />
    <script src="${pageContext.request.contextPath}/js/components/admin-field-flags.js" defer></script>
</head>
<body>

<c:url var="petitionsUrl"   value="/admin/obras" />
<c:url var="productorasUrl" value="/admin/productoras" />
<c:url var="decisionUrl"    value="/admin/${petition.id}/decision" />

<paw:navbar />

<main class="prod-dash">

    <header class="prod-dash-header adm-shell-header">
        <span class="prod-dash-logo" aria-hidden="true">A</span>
        <div class="prod-dash-header-text">
            <h1 class="prod-dash-title">Backoffice</h1>
            <div class="prod-dash-meta">
                <span class="prod-dash-meta-pill prod-dash-meta-owner">Administración</span>
            </div>
        </div>
    </header>

    <div class="prod-dash-layout">

        <aside class="prod-dash-sidebar" aria-label="Secciones del backoffice">
            <h4 class="prod-dash-sidebar-section">Revisión</h4>
            <a class="prod-dash-sidebar-item is-active" href="${petitionsUrl}">
                Peticiones de obra
            </a>
            <a class="prod-dash-sidebar-item" href="${productorasUrl}">
                Postulaciones productora
            </a>
        </aside>

        <section class="prod-dash-content">

            <c:if test="${updated eq 'approved'}"><div class="adm-alert"><paw:alert variant="success" message="La petición fue aprobada y se notificó al solicitante." showClose="false" /></div></c:if>
            <c:if test="${updated eq 'changes_requested'}"><div class="adm-alert"><paw:alert variant="warning" message="Se solicitaron cambios y el draft ya quedó disponible para el solicitante." showClose="false" /></div></c:if>
            <c:if test="${error eq 'already_resolved'}"><div class="adm-alert"><paw:alert variant="error" message="La petición ya estaba resuelta." showClose="false" /></div></c:if>
            <c:if test="${error eq 'invalid_action'}"><div class="adm-alert"><paw:alert variant="error" message="La acción solicitada no es válida." showClose="false" /></div></c:if>
            <c:if test="${error eq 'invalid_review'}"><div class="adm-alert"><paw:alert variant="error" message="Marcá al menos un campo observado y explicá qué corregir antes de pedir cambios." showClose="false" /></div></c:if>

            <div class="adm-detail-head">
                <a href="${petitionsUrl}" class="adm-detail-back">← Volver a la cola</a>
                <div class="adm-detail-head-row">
                    <div>
                        <h2 class="prod-dash-content-title"><c:out value="${petition.title}" /></h2>
                        <div class="adm-detail-meta">
                            <span class="adm-status adm-status-${fn:toLowerCase(petition.status)}">
                                <c:choose>
                                    <c:when test="${petition.status eq 'CHANGES_REQUESTED'}">Con cambios</c:when>
                                    <c:when test="${petition.status eq 'PENDING'}">Pendiente</c:when>
                                    <c:when test="${petition.status eq 'APPROVED'}">Aprobada</c:when>
                                    <c:otherwise><c:out value="${petition.status}" /></c:otherwise>
                                </c:choose>
                            </span>
                            <span class="adm-type-pill petition"><span class="adm-type-pill-swatch"></span>Petición de obra</span>
                            <span class="adm-detail-id">#<c:out value="${petition.id}" /></span>
                            <span class="prod-dash-subtle"><c:out value="${petition.petitionerEmail}" /></span>
                        </div>
                    </div>
                </div>
            </div>

            <c:choose>
                <c:when test="${petition.status eq 'PENDING'}">
                    <c:url var="decisionUrl" value="/admin/${petition.id}/decision" />
                    <form action="${decisionUrl}" method="post" class="adm-field-form adm-field-form-row-toggle">
                        <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />

                        <div class="adm-detail-grid">

                            <div class="adm-panel">
                                <div class="adm-panel-head-row">
                                    <h3>Revisión por campo</h3>
                                    <span class="adm-panel-hint">Hacé click en la fila para marcar un campo con problemas y dejar comentario. El resto queda aprobado implícito.</span>
                                </div>

                                <div class="adm-field-list">

                                    <c:set var="isFlagged" value="${fn:contains(selectedIssueFieldsCsv, ',title,')}" />
                                    <div class="adm-field ${isFlagged ? 'is-flagged' : ''}" data-field-key="title">
                                        <span class="adm-field-label">Título</span>
                                        <div class="adm-field-value"><c:out value="${petition.title}" /></div>
                                        <input type="checkbox" class="adm-hidden-check" name="issueFields" value="title" <c:if test="${isFlagged}">checked</c:if> />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment ${isFlagged ? '' : 'adm-field-comment-hidden'}" data-flag-comment="title">
                                            <span class="adm-field-comment-label">Motivo para Título</span>
                                            <textarea name="fieldComments[title]" placeholder='Explicá qué corregir en "Título"…' <c:if test="${not isFlagged}">disabled</c:if>><c:out value="${reviewForm.fieldComments['title']}" /></textarea>
                                        </div>
                                    </div>

                                    <c:set var="isFlagged" value="${fn:contains(selectedIssueFieldsCsv, ',synopsis,')}" />
                                    <div class="adm-field ${isFlagged ? 'is-flagged' : ''}" data-field-key="synopsis">
                                        <span class="adm-field-label">Sinopsis</span>
                                        <div class="adm-field-value"><c:out value="${petition.synopsis}" /></div>
                                        <input type="checkbox" class="adm-hidden-check" name="issueFields" value="synopsis" <c:if test="${isFlagged}">checked</c:if> />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment ${isFlagged ? '' : 'adm-field-comment-hidden'}" data-flag-comment="synopsis">
                                            <span class="adm-field-comment-label">Motivo para Sinopsis</span>
                                            <textarea name="fieldComments[synopsis]" placeholder='Explicá qué corregir en "Sinopsis"…' <c:if test="${not isFlagged}">disabled</c:if>><c:out value="${reviewForm.fieldComments['synopsis']}" /></textarea>
                                        </div>
                                    </div>

                                    <c:set var="isFlagged" value="${fn:contains(selectedIssueFieldsCsv, ',genreIds,')}" />
                                    <div class="adm-field ${isFlagged ? 'is-flagged' : ''}" data-field-key="genreIds">
                                        <span class="adm-field-label">Géneros</span>
                                        <div class="adm-field-value">
                                            <c:forEach var="genre" items="${petition.genres}" varStatus="st">
                                                <c:out value="${genre.name}" /><c:if test="${not st.last}">, </c:if>
                                            </c:forEach>
                                        </div>
                                        <input type="checkbox" class="adm-hidden-check" name="issueFields" value="genreIds" <c:if test="${isFlagged}">checked</c:if> />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment ${isFlagged ? '' : 'adm-field-comment-hidden'}" data-flag-comment="genreIds">
                                            <span class="adm-field-comment-label">Motivo para Géneros</span>
                                            <textarea name="fieldComments[genreIds]" placeholder='Explicá qué corregir en "Géneros"…' <c:if test="${not isFlagged}">disabled</c:if>><c:out value="${reviewForm.fieldComments['genreIds']}" /></textarea>
                                        </div>
                                    </div>

                                    <c:set var="isFlagged" value="${fn:contains(selectedIssueFieldsCsv, ',durationMinutes,')}" />
                                    <div class="adm-field ${isFlagged ? 'is-flagged' : ''}" data-field-key="durationMinutes">
                                        <span class="adm-field-label">Duración</span>
                                        <div class="adm-field-value"><c:out value="${petition.durationMinutes}" /> minutos</div>
                                        <input type="checkbox" class="adm-hidden-check" name="issueFields" value="durationMinutes" <c:if test="${isFlagged}">checked</c:if> />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment ${isFlagged ? '' : 'adm-field-comment-hidden'}" data-flag-comment="durationMinutes">
                                            <span class="adm-field-comment-label">Motivo para Duración</span>
                                            <textarea name="fieldComments[durationMinutes]" placeholder='Explicá qué corregir en "Duración"…' <c:if test="${not isFlagged}">disabled</c:if>><c:out value="${reviewForm.fieldComments['durationMinutes']}" /></textarea>
                                        </div>
                                    </div>

                                    <c:set var="isFlagged" value="${fn:contains(selectedIssueFieldsCsv, ',language,')}" />
                                    <div class="adm-field ${isFlagged ? 'is-flagged' : ''}" data-field-key="language">
                                        <span class="adm-field-label">Idioma</span>
                                        <div class="adm-field-value"><c:out value="${petition.language}" /></div>
                                        <input type="checkbox" class="adm-hidden-check" name="issueFields" value="language" <c:if test="${isFlagged}">checked</c:if> />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment ${isFlagged ? '' : 'adm-field-comment-hidden'}" data-flag-comment="language">
                                            <span class="adm-field-comment-label">Motivo para Idioma</span>
                                            <textarea name="fieldComments[language]" placeholder='Explicá qué corregir en "Idioma"…' <c:if test="${not isFlagged}">disabled</c:if>><c:out value="${reviewForm.fieldComments['language']}" /></textarea>
                                        </div>
                                    </div>

                                    <c:set var="isFlagged" value="${fn:contains(selectedIssueFieldsCsv, ',director,')}" />
                                    <div class="adm-field ${isFlagged ? 'is-flagged' : ''}" data-field-key="director">
                                        <span class="adm-field-label">Dirección</span>
                                        <div class="adm-field-value"><c:out value="${petition.director}" /></div>
                                        <input type="checkbox" class="adm-hidden-check" name="issueFields" value="director" <c:if test="${isFlagged}">checked</c:if> />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment ${isFlagged ? '' : 'adm-field-comment-hidden'}" data-flag-comment="director">
                                            <span class="adm-field-comment-label">Motivo para Dirección</span>
                                            <textarea name="fieldComments[director]" placeholder='Explicá qué corregir en "Dirección"…' <c:if test="${not isFlagged}">disabled</c:if>><c:out value="${reviewForm.fieldComments['director']}" /></textarea>
                                        </div>
                                    </div>

                                    <c:set var="isFlagged" value="${fn:contains(selectedIssueFieldsCsv, ',theater,')}" />
                                    <div class="adm-field ${isFlagged ? 'is-flagged' : ''}" data-field-key="theater">
                                        <span class="adm-field-label">Teatro / sala</span>
                                        <div class="adm-field-value"><c:out value="${petition.theater}" /></div>
                                        <input type="checkbox" class="adm-hidden-check" name="issueFields" value="theater" <c:if test="${isFlagged}">checked</c:if> />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment ${isFlagged ? '' : 'adm-field-comment-hidden'}" data-flag-comment="theater">
                                            <span class="adm-field-comment-label">Motivo para Teatro / sala</span>
                                            <textarea name="fieldComments[theater]" placeholder='Explicá qué corregir en "Teatro"…' <c:if test="${not isFlagged}">disabled</c:if>><c:out value="${reviewForm.fieldComments['theater']}" /></textarea>
                                        </div>
                                    </div>

                                    <c:set var="isFlagged" value="${fn:contains(selectedIssueFieldsCsv, ',theaterAddress,')}" />
                                    <div class="adm-field ${isFlagged ? 'is-flagged' : ''}" data-field-key="theaterAddress">
                                        <span class="adm-field-label">Dirección sala</span>
                                        <div class="adm-field-value"><c:out value="${petition.theaterAddress}" /></div>
                                        <input type="checkbox" class="adm-hidden-check" name="issueFields" value="theaterAddress" <c:if test="${isFlagged}">checked</c:if> />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment ${isFlagged ? '' : 'adm-field-comment-hidden'}" data-flag-comment="theaterAddress">
                                            <span class="adm-field-comment-label">Motivo para Dirección sala</span>
                                            <textarea name="fieldComments[theaterAddress]" placeholder='Explicá qué corregir en "Dirección sala"…' <c:if test="${not isFlagged}">disabled</c:if>><c:out value="${reviewForm.fieldComments['theaterAddress']}" /></textarea>
                                        </div>
                                    </div>

                                    <c:set var="isFlagged" value="${fn:contains(selectedIssueFieldsCsv, ',startDate,')}" />
                                    <div class="adm-field ${isFlagged ? 'is-flagged' : ''}" data-field-key="startDate">
                                        <span class="adm-field-label">Inicio de temporada</span>
                                        <div class="adm-field-value"><c:out value="${petition.startDate}" /></div>
                                        <input type="checkbox" class="adm-hidden-check" name="issueFields" value="startDate" <c:if test="${isFlagged}">checked</c:if> />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment ${isFlagged ? '' : 'adm-field-comment-hidden'}" data-flag-comment="startDate">
                                            <span class="adm-field-comment-label">Motivo para Inicio de temporada</span>
                                            <textarea name="fieldComments[startDate]" placeholder='Explicá qué corregir en "Inicio"…' <c:if test="${not isFlagged}">disabled</c:if>><c:out value="${reviewForm.fieldComments['startDate']}" /></textarea>
                                        </div>
                                    </div>

                                    <c:set var="isFlagged" value="${fn:contains(selectedIssueFieldsCsv, ',endDate,')}" />
                                    <div class="adm-field ${isFlagged ? 'is-flagged' : ''}" data-field-key="endDate">
                                        <span class="adm-field-label">Fin de temporada</span>
                                        <div class="adm-field-value"><c:out value="${petition.endDate}" /></div>
                                        <input type="checkbox" class="adm-hidden-check" name="issueFields" value="endDate" <c:if test="${isFlagged}">checked</c:if> />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment ${isFlagged ? '' : 'adm-field-comment-hidden'}" data-flag-comment="endDate">
                                            <span class="adm-field-comment-label">Motivo para Fin de temporada</span>
                                            <textarea name="fieldComments[endDate]" placeholder='Explicá qué corregir en "Fin"…' <c:if test="${not isFlagged}">disabled</c:if>><c:out value="${reviewForm.fieldComments['endDate']}" /></textarea>
                                        </div>
                                    </div>

                                    <c:set var="isFlagged" value="${fn:contains(selectedIssueFieldsCsv, ',additionalShowDates,')}" />
                                    <div class="adm-field ${isFlagged ? 'is-flagged' : ''}" data-field-key="additionalShowDates">
                                        <span class="adm-field-label">Fechas adicionales</span>
                                        <div class="adm-field-value ${empty petition.additionalShowDates ? 'dim' : ''}">
                                            <c:choose>
                                                <c:when test="${empty petition.additionalShowDates}">Sin fechas adicionales.</c:when>
                                                <c:otherwise><c:forEach var="d" items="${petition.additionalShowDates}" varStatus="st"><c:out value="${d}" /><c:if test="${not st.last}">, </c:if></c:forEach></c:otherwise>
                                            </c:choose>
                                        </div>
                                        <input type="checkbox" class="adm-hidden-check" name="issueFields" value="additionalShowDates" <c:if test="${isFlagged}">checked</c:if> />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment ${isFlagged ? '' : 'adm-field-comment-hidden'}" data-flag-comment="additionalShowDates">
                                            <span class="adm-field-comment-label">Motivo para Fechas adicionales</span>
                                            <textarea name="fieldComments[additionalShowDates]" placeholder='Explicá qué corregir en "Fechas adicionales"…' <c:if test="${not isFlagged}">disabled</c:if>><c:out value="${reviewForm.fieldComments['additionalShowDates']}" /></textarea>
                                        </div>
                                    </div>

                                    <c:set var="isFlagged" value="${fn:contains(selectedIssueFieldsCsv, ',schedule,')}" />
                                    <div class="adm-field ${isFlagged ? 'is-flagged' : ''}" data-field-key="schedule">
                                        <span class="adm-field-label">Horarios</span>
                                        <div class="adm-field-value ${empty petition.schedule ? 'dim' : ''}">
                                            <c:out value="${empty petition.schedule ? 'Sin horarios informados.' : petition.schedule}" />
                                        </div>
                                        <input type="checkbox" class="adm-hidden-check" name="issueFields" value="schedule" <c:if test="${isFlagged}">checked</c:if> />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment ${isFlagged ? '' : 'adm-field-comment-hidden'}" data-flag-comment="schedule">
                                            <span class="adm-field-comment-label">Motivo para Horarios</span>
                                            <textarea name="fieldComments[schedule]" placeholder='Explicá qué corregir en "Horarios"…' <c:if test="${not isFlagged}">disabled</c:if>><c:out value="${reviewForm.fieldComments['schedule']}" /></textarea>
                                        </div>
                                    </div>

                                    <c:set var="isFlagged" value="${fn:contains(selectedIssueFieldsCsv, ',ticketUrl,')}" />
                                    <div class="adm-field ${isFlagged ? 'is-flagged' : ''}" data-field-key="ticketUrl">
                                        <span class="adm-field-label">Link de entradas</span>
                                        <div class="adm-field-value ${empty petition.ticketUrl ? 'dim' : ''}">
                                            <c:choose>
                                                <c:when test="${not empty petition.ticketUrl}"><a class="adm-inline-link" href="${fn:escapeXml(petition.ticketUrl)}" target="_blank" rel="noreferrer"><c:out value="${petition.ticketUrl}" /></a></c:when>
                                                <c:otherwise>Sin link informado.</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <input type="checkbox" class="adm-hidden-check" name="issueFields" value="ticketUrl" <c:if test="${isFlagged}">checked</c:if> />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment ${isFlagged ? '' : 'adm-field-comment-hidden'}" data-flag-comment="ticketUrl">
                                            <span class="adm-field-comment-label">Motivo para Link de entradas</span>
                                            <textarea name="fieldComments[ticketUrl]" placeholder='Explicá qué corregir en "Link de entradas"…' <c:if test="${not isFlagged}">disabled</c:if>><c:out value="${reviewForm.fieldComments['ticketUrl']}" /></textarea>
                                        </div>
                                    </div>

                                    <c:set var="isFlagged" value="${fn:contains(selectedIssueFieldsCsv, ',coverImage,')}" />
                                    <div class="adm-field ${isFlagged ? 'is-flagged' : ''}" data-field-key="coverImage">
                                        <span class="adm-field-label">Portada</span>
                                        <div class="adm-field-value ${petition.coverImageId == null ? 'dim' : ''}">
                                            ${petition.coverImageId != null ? 'Portada cargada correctamente.' : 'Sin portada.'}
                                        </div>
                                        <input type="checkbox" class="adm-hidden-check" name="issueFields" value="coverImage" <c:if test="${isFlagged}">checked</c:if> />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment ${isFlagged ? '' : 'adm-field-comment-hidden'}" data-flag-comment="coverImage">
                                            <span class="adm-field-comment-label">Motivo para Portada</span>
                                            <textarea name="fieldComments[coverImage]" placeholder='Explicá qué corregir en "Portada"…' <c:if test="${not isFlagged}">disabled</c:if>><c:out value="${reviewForm.fieldComments['coverImage']}" /></textarea>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <div class="adm-panel-side">

                                <div class="adm-panel">
                                    <h3>Decisión</h3>
                                    <div class="adm-decision">
                                        <div class="adm-admin-notes-wrap">
                                            <span class="adm-summary-label">Resumen para el solicitante</span>
                                            <textarea id="adminNotes" name="adminNotes" class="adm-admin-notes-textarea" placeholder="Mensaje breve que abre el email. Opcional si los comentarios por campo alcanzan."><c:out value="${reviewForm.adminNotes}" /></textarea>
                                        </div>
                                        <div class="adm-decision-cta">
                                            <button type="submit" name="action" value="approve" class="adm-btn primary">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                                                Aprobar y publicar
                                            </button>
                                            <button type="submit" name="action" value="request_changes" class="adm-btn warn">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>
                                                Solicitar cambios
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <c:if test="${petition.coverImageId != null}">
                                    <div class="adm-panel">
                                        <h3>Portada propuesta</h3>
                                        <c:url var="coverUrl" value="/petition-images/${petition.coverImageId}" />
                                        <div class="adm-cover-tile" style="background-image:url('${coverUrl}')"></div>
                                        <div class="adm-cover-meta"><c:out value="${petition.petitionerEmail}" /></div>
                                    </div>
                                </c:if>

                                <div class="adm-panel">
                                    <h3>Actividad</h3>
                                    <div class="adm-timeline">
                                        <div class="adm-tl pending">
                                            <b>Petición enviada</b>
                                            <span class="adm-tl-when"><c:out value="${petition.petitionerEmail}" /></span>
                                            <div class="adm-tl-what">Estado: <c:out value="${petition.status}" /></div>
                                        </div>
                                        <c:if test="${not empty petition.adminNotes}">
                                            <div class="adm-tl changes">
                                                <b>Notas del admin</b>
                                                <div class="adm-tl-what"><c:out value="${petition.adminNotes}" /></div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </form>
                </c:when>

                <c:otherwise>
                    <div class="adm-detail-grid">

                        <div class="adm-panel">
                            <h3>Resolución</h3>
                            <div class="adm-resolution">
                                <c:choose>
                                    <c:when test="${petition.status eq 'CHANGES_REQUESTED'}">
                                        <p class="adm-resolution-title">La petición está esperando correcciones del submitter.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="adm-resolution-title">Esta petición ya fue aprobada.</p>
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${not empty petition.adminNotes}">
                                    <div class="adm-admin-notes-wrap">
                                        <span class="adm-summary-label">Notas del admin</span>
                                        <p style="margin:0;font-size:.87rem;color:var(--adm-text)"><c:out value="${petition.adminNotes}" /></p>
                                    </div>
                                </c:if>
                                <c:if test="${not empty fieldFeedback}">
                                    <div class="adm-feedback-list">
                                        <c:forEach var="entry" items="${fieldFeedback}">
                                            <div class="adm-feedback-item">
                                                <strong><c:out value="${entry.key}" /></strong>
                                                <p><c:out value="${entry.value}" /></p>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:if>
                                <c:if test="${petition.createdObraId != null and petition.createdProductionId != null}">
                                    <a class="adm-btn primary" href="${pageContext.request.contextPath}/obras/${petition.createdObraId}?produccionId=${petition.createdProductionId}">Ver publicación creada →</a>
                                </c:if>
                            </div>
                        </div>

                        <div class="adm-panel-side">
                            <c:if test="${petition.coverImageId != null}">
                                <div class="adm-panel">
                                    <h3>Portada</h3>
                                    <c:url var="coverUrl" value="/petition-images/${petition.coverImageId}" />
                                    <div class="adm-cover-tile" style="background-image:url('${coverUrl}')"></div>
                                </div>
                            </c:if>
                            <div class="adm-panel">
                                <h3>Actividad</h3>
                                <div class="adm-timeline">
                                    <div class="adm-tl pending">
                                        <b>Petición enviada</b>
                                        <span class="adm-tl-when"><c:out value="${petition.petitionerEmail}" /></span>
                                    </div>
                                    <c:if test="${petition.status eq 'CHANGES_REQUESTED'}">
                                        <div class="adm-tl changes"><b>Cambios solicitados</b></div>
                                    </c:if>
                                    <c:if test="${petition.status eq 'APPROVED'}">
                                        <div class="adm-tl"><b>Aprobada</b><div class="adm-tl-what">Obra y producción publicadas.</div></div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                    </div>
                </c:otherwise>
            </c:choose>

        </section>
    </div>
</main>

</body>
</html>
