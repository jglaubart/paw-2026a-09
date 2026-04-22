<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Postulación <c:out value="${request.name}" /> — Backoffice</title>
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
<c:url var="approveUrl"     value="/admin/productoras/postulaciones/${request.id}/aprobar" />
<c:url var="rejectUrl"      value="/admin/productoras/postulaciones/${request.id}/rechazar" />
<c:url var="changesUrl"     value="/admin/productoras/postulaciones/${request.id}/cambios" />

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
            <a class="prod-dash-sidebar-item" href="${petitionsUrl}">
                Peticiones de obra
            </a>
            <a class="prod-dash-sidebar-item is-active" href="${productorasUrl}">
                Postulaciones productora
            </a>
        </aside>

        <section class="prod-dash-content">

            <div class="adm-detail-head">
                <a href="${productorasUrl}" class="adm-detail-back">← Volver a la cola</a>
                <div class="adm-detail-head-row">
                    <div>
                        <h2 class="prod-dash-content-title"><c:out value="${request.name}" /></h2>
                        <div class="adm-detail-meta">
                            <span class="adm-status adm-status-${fn:toLowerCase(request.status)}">
                                <c:choose>
                                    <c:when test="${request.status eq 'CHANGES_REQUESTED'}">Con cambios</c:when>
                                    <c:when test="${request.status eq 'PENDING'}">Pendiente</c:when>
                                    <c:when test="${request.status eq 'APPROVED'}">Aprobada</c:when>
                                    <c:when test="${request.status eq 'REJECTED'}">Rechazada</c:when>
                                    <c:otherwise><c:out value="${request.status}" /></c:otherwise>
                                </c:choose>
                            </span>
                            <span class="adm-type-pill productora"><span class="adm-type-pill-swatch"></span>Postulación productora</span>
                            <span class="adm-detail-id">CUIT <c:out value="${request.cuit}" /></span>
                            <span class="prod-dash-subtle"><c:out value="${request.contactEmail}" /></span>
                        </div>
                    </div>
                </div>
            </div>

            <c:choose>
                <c:when test="${request.status eq 'PENDING' or request.status eq 'CHANGES_REQUESTED'}">

                    <div class="adm-field-form">

                        <form id="adm-changes-form" action="${changesUrl}" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                        </form>
                        <form id="adm-approve-form" action="${approveUrl}" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                            <input type="hidden" name="adminNotes" value="" />
                        </form>
                        <form id="adm-reject-form" action="${rejectUrl}" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                        </form>

                        <div class="adm-detail-grid">

                            <div class="adm-panel">
                                <div class="adm-panel-head-row">
                                    <h3>Revisión por campo</h3>
                                    <span class="adm-panel-hint">Flag los campos con problemas y dejá feedback. El resto queda aprobado implícito.</span>
                                </div>

                                <div class="adm-field-list">

                                    <div class="adm-field" data-field-key="name">
                                        <span class="adm-field-label">Nombre</span>
                                        <div class="adm-field-value"><c:out value="${request.name}" /></div>
                                        <input type="checkbox" class="adm-hidden-check" />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment adm-field-comment-hidden" data-flag-comment="name">
                                            <span class="adm-field-comment-label">Feedback para Nombre</span>
                                            <textarea name="feedback[name]" form="adm-changes-form" placeholder='Explicá qué corregir en "Nombre"…' disabled></textarea>
                                        </div>
                                    </div>

                                    <div class="adm-field" data-field-key="cuit">
                                        <span class="adm-field-label">CUIT</span>
                                        <div class="adm-field-value"><c:out value="${request.cuit}" /></div>
                                        <input type="checkbox" class="adm-hidden-check" />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment adm-field-comment-hidden" data-flag-comment="cuit">
                                            <span class="adm-field-comment-label">Feedback para CUIT</span>
                                            <textarea name="feedback[cuit]" form="adm-changes-form" placeholder='Explicá qué corregir en "CUIT"…' disabled></textarea>
                                        </div>
                                    </div>

                                    <div class="adm-field" data-field-key="contactEmail">
                                        <span class="adm-field-label">Email de contacto</span>
                                        <div class="adm-field-value"><c:out value="${request.contactEmail}" /></div>
                                        <input type="checkbox" class="adm-hidden-check" />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment adm-field-comment-hidden" data-flag-comment="contactEmail">
                                            <span class="adm-field-comment-label">Feedback para Email de contacto</span>
                                            <textarea name="feedback[contactEmail]" form="adm-changes-form" placeholder='Explicá qué corregir en "Email"…' disabled></textarea>
                                        </div>
                                    </div>

                                    <div class="adm-field" data-field-key="bio">
                                        <span class="adm-field-label">Bio</span>
                                        <div class="adm-field-value"><c:out value="${request.bio}" /></div>
                                        <input type="checkbox" class="adm-hidden-check" />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment adm-field-comment-hidden" data-flag-comment="bio">
                                            <span class="adm-field-comment-label">Feedback para Bio</span>
                                            <textarea name="feedback[bio]" form="adm-changes-form" placeholder='Explicá qué corregir en "Bio"…' disabled></textarea>
                                        </div>
                                    </div>

                                    <c:if test="${not empty request.instagram}">
                                        <div class="adm-field" data-field-key="instagram">
                                            <span class="adm-field-label">Instagram</span>
                                            <div class="adm-field-value"><c:out value="${request.instagram}" /></div>
                                            <input type="checkbox" class="adm-hidden-check" />
                                            <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                            <div class="adm-field-comment adm-field-comment-hidden" data-flag-comment="instagram">
                                                <span class="adm-field-comment-label">Feedback para Instagram</span>
                                                <textarea name="feedback[instagram]" form="adm-changes-form" placeholder='Explicá qué corregir en "Instagram"…' disabled></textarea>
                                            </div>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty request.website}">
                                        <div class="adm-field" data-field-key="website">
                                            <span class="adm-field-label">Sitio web</span>
                                            <div class="adm-field-value"><c:out value="${request.website}" /></div>
                                            <input type="checkbox" class="adm-hidden-check" />
                                            <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                            <div class="adm-field-comment adm-field-comment-hidden" data-flag-comment="website">
                                                <span class="adm-field-comment-label">Feedback para Sitio web</span>
                                                <textarea name="feedback[website]" form="adm-changes-form" placeholder='Explicá qué corregir en "Sitio web"…' disabled></textarea>
                                            </div>
                                        </div>
                                    </c:if>

                                    <div class="adm-field" data-field-key="teamDescription">
                                        <span class="adm-field-label">Equipo</span>
                                        <div class="adm-field-value"><c:out value="${request.teamDescription}" /></div>
                                        <input type="checkbox" class="adm-hidden-check" />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment adm-field-comment-hidden" data-flag-comment="teamDescription">
                                            <span class="adm-field-comment-label">Feedback para Equipo</span>
                                            <textarea name="feedback[teamDescription]" form="adm-changes-form" placeholder='Explicá qué corregir en "Equipo"…' disabled></textarea>
                                        </div>
                                    </div>

                                    <div class="adm-field" data-field-key="previousWorks">
                                        <span class="adm-field-label">Antecedentes</span>
                                        <div class="adm-field-value"><c:out value="${request.previousWorks}" /></div>
                                        <input type="checkbox" class="adm-hidden-check" />
                                        <button type="button" class="adm-flag-btn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>Flag</button>
                                        <div class="adm-field-comment adm-field-comment-hidden" data-flag-comment="previousWorks">
                                            <span class="adm-field-comment-label">Feedback para Antecedentes</span>
                                            <textarea name="feedback[previousWorks]" form="adm-changes-form" placeholder='Explicá qué corregir en "Antecedentes"…' disabled></textarea>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <div class="adm-panel-side">

                                <div class="adm-panel">
                                    <h3>Decisión</h3>
                                    <div class="adm-decision">
                                        <div class="adm-admin-notes-wrap">
                                            <span class="adm-summary-label">Mensaje para el solicitante (cambios)</span>
                                            <textarea name="adminNotes" form="adm-changes-form" class="adm-admin-notes-textarea" placeholder="Mensaje general que acompaña los cambios solicitados…"></textarea>
                                        </div>
                                        <div class="adm-decision-cta">
                                            <button type="submit" form="adm-approve-form" class="adm-btn primary">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                                                Aprobar
                                            </button>
                                            <button type="submit" form="adm-changes-form" class="adm-btn warn">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" y1="22" x2="4" y2="15"/></svg>
                                                Solicitar cambios
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <div class="adm-panel">
                                    <h3>Rechazar</h3>
                                    <div class="adm-decision">
                                        <div class="adm-summary-note adm-summary-note-reject">
                                            <span class="adm-summary-label">Motivo (se comparte con el postulante)</span>
                                            <textarea name="adminNotes" form="adm-reject-form" placeholder="Explicá por qué se rechaza la postulación…"></textarea>
                                        </div>
                                        <button type="submit" form="adm-reject-form" class="adm-btn danger">Rechazar postulación</button>
                                    </div>
                                </div>

                                <div class="adm-panel">
                                    <h3>Actividad</h3>
                                    <div class="adm-timeline">
                                        <div class="adm-tl pending">
                                            <b>Postulación enviada</b>
                                            <span class="adm-tl-when"><c:out value="${request.contactEmail}" /></span>
                                            <div class="adm-tl-what">Estado: <c:out value="${request.status}" /></div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>

                    </div>

                </c:when>

                <c:otherwise>
                    <div class="adm-detail-grid">

                        <div class="adm-panel">
                            <h3>Resolución</h3>
                            <div class="adm-resolution">
                                <c:choose>
                                    <c:when test="${request.status eq 'APPROVED'}">
                                        <p class="adm-resolution-title">Esta postulación fue aprobada. La productora ya puede operar en Platea.</p>
                                    </c:when>
                                    <c:when test="${request.status eq 'REJECTED'}">
                                        <p class="adm-resolution-title">Esta postulación fue rechazada.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="adm-resolution-title">Estado: <c:out value="${request.status}" /></p>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="adm-field-list" style="margin-top:1.2rem">
                                <div class="adm-field"><span class="adm-field-label">Nombre</span><div class="adm-field-value"><c:out value="${request.name}" /></div></div>
                                <div class="adm-field"><span class="adm-field-label">CUIT</span><div class="adm-field-value"><c:out value="${request.cuit}" /></div></div>
                                <div class="adm-field"><span class="adm-field-label">Email</span><div class="adm-field-value"><c:out value="${request.contactEmail}" /></div></div>
                                <div class="adm-field"><span class="adm-field-label">Bio</span><div class="adm-field-value"><c:out value="${request.bio}" /></div></div>
                                <c:if test="${not empty request.instagram}">
                                    <div class="adm-field"><span class="adm-field-label">Instagram</span><div class="adm-field-value"><c:out value="${request.instagram}" /></div></div>
                                </c:if>
                                <c:if test="${not empty request.website}">
                                    <div class="adm-field"><span class="adm-field-label">Sitio web</span><div class="adm-field-value"><c:out value="${request.website}" /></div></div>
                                </c:if>
                                <div class="adm-field"><span class="adm-field-label">Equipo</span><div class="adm-field-value"><c:out value="${request.teamDescription}" /></div></div>
                                <div class="adm-field"><span class="adm-field-label">Antecedentes</span><div class="adm-field-value"><c:out value="${request.previousWorks}" /></div></div>
                            </div>
                        </div>

                        <div class="adm-panel-side">
                            <div class="adm-panel">
                                <h3>Actividad</h3>
                                <div class="adm-timeline">
                                    <div class="adm-tl pending">
                                        <b>Postulación enviada</b>
                                        <span class="adm-tl-when"><c:out value="${request.contactEmail}" /></span>
                                    </div>
                                    <c:if test="${request.status eq 'APPROVED'}">
                                        <div class="adm-tl"><b>Aprobada</b><div class="adm-tl-what">Productora habilitada en Platea.</div></div>
                                    </c:if>
                                    <c:if test="${request.status eq 'REJECTED'}">
                                        <div class="adm-tl"><b>Rechazada</b></div>
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
