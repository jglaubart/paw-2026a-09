<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${obra.title}" /> — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/play-detail.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/star-rating.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/alert.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/user-lists.css" />
    <script src="${pageContext.request.contextPath}/js/components/star-rating.js" defer></script>
    <script src="${pageContext.request.contextPath}/js/components/obra-feedback.js" defer></script>
    <script src="${pageContext.request.contextPath}/js/components/share-dialog.js" defer></script>
</head>
<body>

<paw:navbar />

<c:if test="${selectedProduction != null && not empty selectedProduction.imageUrl}">
    <c:url var="heroImageUrl" value="${selectedProduction.imageUrl}" />
</c:if>
<c:if test="${selectedProduction != null && not empty selectedProduction.website}">
    <c:url var="selectedProductionWebsiteUrl" value="${selectedProduction.website}" />
</c:if>
<c:url var="carteleraUrl" value="/cartelera" />
<c:url var="loginUrl" value="/login" />
<c:url var="registerUrl" value="/register" />
<c:url var="watchlistUrl" value="/watchlist" />
<c:url var="historialUrl" value="/historial" />

<main class="obra-detail-page">

    <section class="obra-hero">
        <c:if test="${not empty heroImageUrl}">
            <img class="obra-hero-image" src="${heroImageUrl}" alt="" aria-hidden="true" />
        </c:if>
        <div class="obra-hero-overlay">
            <div class="obra-hero-top">
                <c:if test="${not empty obra.genre}">
                    <span class="obra-genre-badge"><c:out value="${obra.genre}" /></span>
                </c:if>
                <c:if test="${avgRating != null}">
                    <span class="obra-hero-rating">
                        <span class="obra-hero-rating-star" aria-hidden="true">★</span>
                        <fmt:formatNumber value="${avgRating}" maxFractionDigits="1" />
                    </span>
                </c:if>
            </div>

            <div class="obra-hero-bottom">
                <h1 class="obra-hero-title"><c:out value="${obra.title}" /></h1>
            </div>
        </div>
    </section>

    <%-- ═══════════════ META BAR ═══════════════ --%>
    <c:if test="${selectedProduction != null}">
        <div class="obra-meta-bar">
            <c:if test="${not empty selectedProduction.theater}">
                <span class="obra-hero-meta-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2"
                         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                        <polyline points="9 22 9 12 15 12 15 22"/>
                    </svg>
                    <c:out value="${selectedProduction.theater}" />
                </span>
            </c:if>
            <c:if test="${selectedProduction.startDate != null}">
                <span class="obra-hero-meta-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2"
                         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                        <line x1="16" y1="2" x2="16" y2="6"/>
                        <line x1="8"  y1="2" x2="8"  y2="6"/>
                        <line x1="3"  y1="10" x2="21" y2="10"/>
                    </svg>
                    <c:out value="${selectedProduction.startDate}" />
                    <c:if test="${selectedProduction.endDate != null}">
                        — <c:out value="${selectedProduction.endDate}" />
                    </c:if>
                </span>
            </c:if>
            <c:if test="${not empty selectedProduction.direction}">
                <span class="obra-hero-meta-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2"
                         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <circle cx="12" cy="12" r="10"/>
                        <polygon points="10 8 16 12 10 16 10 8"/>
                    </svg>
                    <c:out value="${selectedProduction.direction}" />
                </span>
            </c:if>
        </div>
    </c:if>

    <%-- ═══════════════ ACCIONES ═══════════════ --%>
    <div class="obra-action-bar">
        <div class="obra-action-bar-left">
            <sec:authorize access="isAuthenticated()">
                <c:if test="${selectedProduction != null}">
                    <c:url var="watchlistActionUrl" value="/productions/${selectedProduction.id}/watchlist" />
                    <form action="${watchlistActionUrl}" method="post" class="obra-action-form">
                        <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                        <input type="hidden" name="obraId" value="${obra.id}" />
                        <input type="hidden" name="action" value="${isInWishlist ? 'remove' : 'add'}" />
                        <button type="submit" class="obra-action-btn ${isInWishlist ? 'obra-action-btn-active' : ''}">
                            <span aria-hidden="true">${isInWishlist ? '♥' : '♡'}</span>
                            <c:out value="${isInWishlist ? 'En watchlist' : 'Agregar a watchlist'}" />
                        </button>
                    </form>
                </c:if>

                <c:url var="seenActionUrl" value="/obras/${obra.id}/seen" />
                <form action="${seenActionUrl}" method="post" class="obra-action-form">
                    <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                    <c:if test="${selectedProduction != null}">
                        <input type="hidden" name="produccionId" value="${selectedProduction.id}" />
                    </c:if>
                    <input type="hidden" name="action" value="${hasSeen ? 'remove' : 'add'}" />
                    <button type="submit" class="obra-action-btn obra-action-btn-seen ${hasSeen ? 'obra-action-btn-active' : ''}">
                        <span aria-hidden="true">${hasSeen ? '✓' : '○'}</span>
                        <c:out value="${hasSeen ? 'Ya la vi' : 'Marcar como vista'}" />
                    </button>
                </form>
            </sec:authorize>

            <c:if test="${selectedProduction != null}">
                <button type="button" class="obra-action-btn obra-action-btn-share" data-share-open>
                    <span aria-hidden="true">↗</span>
                    Compartir por mail
                </button>
            </c:if>
        </div>

        <c:if test="${selectedProduction != null}">
            <div class="obra-action-bar-right">
                <c:choose>
                    <c:when test="${selectedProductionActive and not empty selectedProduction.website}">
                        <a href="${selectedProductionWebsiteUrl}"
                           class="obra-ticket-btn"
                           target="_blank" rel="noopener noreferrer">
                            Comprar entradas ↗
                        </a>
                    </c:when>
                    <c:when test="${selectedProductionActive}">
                        <button type="button" class="obra-ticket-btn obra-ticket-btn-disabled" data-ticket-status-message="Esta obra no tiene un link de entradas cargado.">
                            Comprar entradas ↗
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="obra-ticket-btn obra-ticket-btn-disabled" data-ticket-status-message="La obra no está activa en este momento.">
                            Comprar entradas ↗
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </div>

    <c:if test="${param.share == 'sent'}">
        <div class="obra-action-feedback-wrap">
            <p class="obra-inline-feedback obra-inline-feedback-success">Publicación compartida por mail.</p>
        </div>
    </c:if>
    <c:if test="${param.share == 'invalid'}">
        <div class="obra-action-feedback-wrap">
            <p class="obra-inline-feedback obra-inline-feedback-warning">Completá un nombre y un mail válidos para compartir.</p>
        </div>
    </c:if>
    <div class="obra-action-feedback-wrap obra-action-feedback-wrap-hidden" data-ticket-feedback>
        <p class="obra-inline-feedback obra-inline-feedback-warning" data-ticket-feedback-text></p>
    </div>

    <c:if test="${selectedProduction != null}">
        <dialog class="obra-share-dialog" data-share-dialog>
            <form method="dialog" class="obra-share-dialog-close-form">
                <button type="submit" class="obra-share-dialog-close" aria-label="Cerrar compartir">×</button>
            </form>

            <div class="obra-share-dialog-body">
                <p class="obra-share-dialog-kicker">Compartir publicación</p>
                <h2 class="obra-share-dialog-title">Mandá esta obra por mail</h2>
                <p class="obra-share-dialog-copy">Vamos a enviarle la publicación seleccionada con un template de Platea y tu nombre como remitente.</p>

                <c:url var="shareActionUrl" value="/obras/${obra.id}/share" />
                <form action="${shareActionUrl}" method="post" class="obra-share-form">
                    <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                    <input type="hidden" name="produccionId" value="${selectedProduction.id}" />

                    <label class="obra-share-label" for="share-sender-name">Tu nombre</label>
                    <input id="share-sender-name" name="senderName" type="text" class="obra-share-input" maxlength="80" required />

                    <label class="obra-share-label" for="share-recipient-email">Mail de destino</label>
                    <input id="share-recipient-email" name="recipientEmail" type="email" class="obra-share-input" maxlength="255" required />

                    <div class="obra-share-actions">
                        <button type="submit" class="btn btn-primary btn-md">Enviar publicación</button>
                    </div>
                </form>
            </div>
        </dialog>
    </c:if>

    <%-- ═══════════════ BODY ═══════════════ --%>
    <div class="obra-content">

        <%-- ── MAIN COLUMN ── --%>
        <div class="obra-main-col">

            <%-- VERSIONES (solo si hay más de una producción) --%>
            <c:if test="${fn:length(productions) > 1}">
                <section class="obra-section">
                    <div class="obra-section-head">
                        <h2 class="obra-heading">Versiones</h2>
                    </div>
                    <div class="obra-versions-grid">
                        <c:forEach var="p" items="${productions}">
                            <c:set var="versionUrl" value="/obras/${obra.id}?produccionId=${p.id}" />
                            <a href="${versionUrl}" class="obra-version-item ${p.id eq selectedProduction.id ? 'obra-version-item-active' : ''}">
                                <p class="obra-version-theater">
                                    <c:out value="${not empty p.theater ? p.theater : p.name}" />
                                </p>
                                <c:if test="${p.startDate != null}">
                                    <p class="obra-version-dates">
                                        <c:out value="${p.startDate}" />
                                        <c:if test="${p.endDate != null}"> — <c:out value="${p.endDate}" /></c:if>
                                    </p>
                                </c:if>
                                <c:if test="${not empty p.direction}">
                                    <p class="obra-version-dates">Dir. <c:out value="${p.direction}" /></p>
                                </c:if>
                            </a>
                        </c:forEach>
                    </div>
                </section>
            </c:if>

            <%-- SINOPSIS --%>
            <section class="obra-section">
                <div class="obra-section-head">
                    <h2 class="obra-heading">Sinopsis</h2>
                </div>

                <c:choose>
                    <c:when test="${not empty obra.synopsis}">
                        <p class="obra-synopsis"><c:out value="${obra.synopsis}" /></p>
                    </c:when>
                    <c:otherwise>
                        <p class="obra-synopsis obra-synopsis-empty">Sin sinopsis disponible.</p>
                    </c:otherwise>
                </c:choose>

                <c:if test="${selectedProduction != null}">
                    <div class="obra-meta-strip">
                        <c:if test="${not empty selectedProduction.theater}">
                            <div class="obra-meta-inline-item">
                                <span class="obra-meta-inline-label">Teatro</span>
                                <p class="obra-meta-inline-value"><c:out value="${selectedProduction.theater}" /></p>
                            </div>
                        </c:if>

                        <c:if test="${selectedProduction.startDate != null}">
                            <div class="obra-meta-inline-item">
                                <span class="obra-meta-inline-label">Funciones</span>
                                <p class="obra-meta-inline-value">
                                    <c:out value="${selectedProduction.startDate}" />
                                    <c:if test="${lastShowDate != null}">
                                        — <c:out value="${lastShowDate}" />
                                    </c:if>
                                </p>
                            </div>
                        </c:if>

                        <c:if test="${not empty obra.genre}">
                            <div class="obra-meta-inline-item">
                                <span class="obra-meta-inline-label">Género</span>
                                <p class="obra-meta-inline-value"><c:out value="${obra.genre}" /></p>
                            </div>
                        </c:if>

                        <c:if test="${not empty selectedProduction.direction}">
                            <div class="obra-meta-inline-item">
                                <span class="obra-meta-inline-label">Dirección</span>
                                <p class="obra-meta-inline-value"><c:out value="${selectedProduction.direction}" /></p>
                            </div>
                        </c:if>
                    </div>

                    <c:if test="${not empty showDates}">
                        <details class="obra-show-dates">
                            <summary class="obra-show-dates-summary">Ver todas las fechas</summary>
                            <div class="obra-show-dates-list">
                                <c:forEach var="showDate" items="${showDates}">
                                    <span class="obra-show-date-pill"><c:out value="${showDate}" /></span>
                                </c:forEach>
                            </div>
                        </details>
                    </c:if>
                </c:if>
            </section>

            <%-- QUÉ DICE LA GENTE --%>
            <section class="obra-section">
                <div class="obra-section-head">
                    <div class="obra-reviews-head">
                        <h2 class="obra-reviews-section-title">Qué dice la gente</h2>
                        <c:if test="${avgStars != null}">
                            <span class="obra-avg-rating" data-feedback-avg-block>
                                <span class="obra-avg-stars" aria-hidden="true">
                                    <span class="obra-avg-stars-base">★★★★★★★★★★</span>
                                    <span class="obra-avg-stars-fill" data-feedback-avg-stars-fill style="width: ${avgStarsPercent}%;">★★★★★★★★★★</span>
                                </span>
                                <span class="obra-avg-rating-value" data-feedback-avg-value>
                                    <fmt:formatNumber value="${avgStars}" maxFractionDigits="1" /> / 10
                                </span>
                                <span class="obra-avg-rating-meta" data-feedback-review-count>
                                    <c:out value="${fn:length(reviews)}" /> reseña${fn:length(reviews) == 1 ? '' : 's'}
                                </span>
                            </span>
                        </c:if>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty reviews}">
                        <div class="obra-reviews-grid" data-feedback-reviews-grid>
                            <c:forEach var="r" items="${reviews}">
                                <div class="obra-review-card" data-review-card data-review-username="${fn:escapeXml(r.username)}">
                                    <div class="obra-review-header">
                                        <span class="obra-review-avatar">${fn:toUpperCase(fn:substring(r.username, 0, 1))}</span>
                                        <span class="obra-review-author"><c:out value="${r.username}" /></span>
                                        <c:if test="${r.score != null}">
                                            <span class="obra-review-score"><c:out value="${r.score}" />/10</span>
                                        </c:if>
                                    </div>
                                    <p class="obra-review-body">"<c:out value="${r.body}" />"</p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="obra-reviews-empty" data-feedback-reviews-empty>
                            Todavía no hay reseñas publicadas para esta obra.
                        </div>
                    </c:otherwise>
                </c:choose>

                <%-- CALIFICAR + RESEÑAR --%>
                <c:if test="${selectedProduction != null}">
                    <sec:authorize access="isAuthenticated()">
                        <div class="obra-interact-panel">
                            <div class="obra-participation-rating">
                                <div class="obra-interact-head">
                                    <h3 class="obra-interact-title">Tu reseña y puntuación</h3>
                                    <span class="obra-rating-value">
                                        <c:choose>
                                            <c:when test="${userStars != null}">
                                                <span data-feedback-user-score><fmt:formatNumber value="${userStars}" maxFractionDigits="1" />/10</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span data-feedback-user-score>--/10</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <p class="obra-review-signed-in-as">Participás como <strong><c:out value="${currentUserEmail}" /></strong>.</p>

                                <c:if test="${param.feedback == 'saved'}">
                                    <p class="obra-inline-feedback obra-inline-feedback-success">
                                        Puntuación y reseña guardadas.
                                    </p>
                                </c:if>

                                <c:if test="${param.error == 'invalid_feedback'}">
                                    <p class="obra-inline-feedback obra-inline-feedback-warning">
                                        Elegí un puntaje válido para guardar tu participación.
                                    </p>
                                </c:if>

                                <c:if test="${param.error == 'missing_score'}">
                                    <p class="obra-inline-feedback obra-inline-feedback-warning">
                                        Elegí una calificación antes de guardar tu participación.
                                    </p>
                                </c:if>

                                <p class="obra-inline-feedback obra-action-feedback-wrap-hidden" data-feedback-inline-message></p>

                                <c:url var="feedbackActionUrl" value="/obras/${obra.id}/feedback" />
                                <form action="${feedbackActionUrl}"
                                      method="post"
                                      accept-charset="UTF-8"
                                      class="obra-rate-form-inner"
                                      data-obra-feedback-form>
                                    <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                                    <input type="hidden" name="produccionId" value="${selectedProduction.id}" />
                                    <input type="hidden" name="email" value="${fn:escapeXml(currentUserEmail)}" />
                                    <paw:starRating
                                        name="score"
                                        currentValue="${userStars}"
                                        max="10"
                                        groupLabel="Tu puntuación"
                                        promptText="Sin calificar"
                                        autosubmit="false" />
                                    <textarea name="body"
                                              rows="4"
                                              class="obra-review-textarea"
                                              placeholder="¿Qué te dejó esta obra? (opcional)"><c:out value="${userReview != null ? userReview.body : ''}" /></textarea>
                                    <div class="obra-review-actions">
                                        <span class="obra-review-help">La puntuación es obligatoria. La reseña es opcional y, si la dejás vacía, se elimina la anterior.</span>
                                        <button type="submit" class="btn btn-primary btn-md obra-review-submit" data-feedback-submit><c:out value="${userReview != null || userStars != null ? 'Actualizar participación' : 'Guardar participación'}" /></button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </sec:authorize>

                    <sec:authorize access="isAnonymous()">
                        <div class="obra-interact-panel obra-interact-panel-guest">
                            <div class="obra-interact-head">
                                <h3 class="obra-interact-title">Tu reseña y puntuación</h3>
                            </div>
                            <p class="obra-interact-guest-copy">Iniciá sesión para guardar puntuaciones, editar tu reseña y ver tu actividad desde el perfil.</p>
                            <div class="obra-interact-auth-actions">
                                <a href="${loginUrl}" class="btn btn-primary btn-md obra-review-submit">Iniciar sesión</a>
                                <a href="${registerUrl}" class="btn btn-outline btn-md obra-sidebar-cta">Crear cuenta</a>
                            </div>
                        </div>
                    </sec:authorize>
                </c:if>
            </section>

        </div>

        <%-- ── SIDEBAR ── --%>
        <aside class="obra-sidebar-col">
            <div class="obra-sidebar-card">
                <h3 class="obra-sidebar-title">EXPLORÁ MÁS</h3>
                <a href="${carteleraUrl}" class="btn btn-outline btn-md obra-sidebar-cta">
                    VER TODA LA CARTELERA
                </a>
                <sec:authorize access="isAuthenticated()">
                    <a href="${watchlistUrl}" class="btn btn-outline btn-md obra-sidebar-cta">
                        MI WATCHLIST
                    </a>
                    <a href="${historialUrl}" class="btn btn-outline btn-md obra-sidebar-cta">
                        ✓ HISTORIAL
                    </a>
                </sec:authorize>
            </div>
        </aside>

    </div>

</main>

</body>
</html>
