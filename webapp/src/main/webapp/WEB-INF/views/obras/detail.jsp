<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
<c:url var="wishlistUrl" value="/wishlist" />
<c:url var="watchlistUrl" value="/watchlist" />

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

    <%-- ═══════════════ ACCIONES (wishlist / ya la vi) ═══════════════ --%>
    <div class="obra-action-bar">
        <%-- Wishlist button (per production) --%>
        <c:if test="${selectedProduction != null}">
            <c:url var="wishlistActionUrl" value="/productions/${selectedProduction.id}/wishlist" />
            <form action="${wishlistActionUrl}"
                  method="post" class="obra-action-form">
                <input type="hidden" name="obraId"      value="${obra.id}" />
                <input type="hidden" name="action"      value="${isInWishlist ? 'remove' : 'add'}" />
                <button type="submit" class="obra-action-btn ${isInWishlist ? 'obra-action-btn-active' : ''}">
                    <span aria-hidden="true">${isInWishlist ? '♥' : '♡'}</span>
                    <c:out value="${isInWishlist ? 'En wishlist' : 'Agregar a wishlist'}" />
                </button>
            </form>
        </c:if>

        <%-- Seen button (per obra) --%>
        <c:url var="seenActionUrl" value="/obras/${obra.id}/seen" />
        <form action="${seenActionUrl}"
              method="post" class="obra-action-form">
            <c:if test="${selectedProduction != null}">
                <input type="hidden" name="produccionId" value="${selectedProduction.id}" />
            </c:if>
            <input type="hidden" name="action" value="${hasSeen ? 'remove' : 'add'}" />
            <button type="submit" class="obra-action-btn obra-action-btn-seen ${hasSeen ? 'obra-action-btn-active' : ''}">
                <span aria-hidden="true">${hasSeen ? '✓' : '○'}</span>
                <c:out value="${hasSeen ? 'Ya la vi' : 'Marcar como vista'}" />
            </button>
        </form>
    </div>

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
                            <c:url var="versionUrl" value="/obras/${obra.id}">
                                <c:param name="produccionId" value="${p.id}" />
                            </c:url>
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
                    <c:if test="${selectedProduction != null && not empty selectedProduction.website}">
                        <a href="${selectedProductionWebsiteUrl}"
                           class="btn btn-primary btn-md"
                           target="_blank" rel="noopener noreferrer">
                            Comprar Entradas (Sitio Externo) ↗
                        </a>
                    </c:if>
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
                                    <c:if test="${selectedProduction.endDate != null}">
                                        — <c:out value="${selectedProduction.endDate}" />
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
                </c:if>
            </section>

            <%-- QUÉ DICE LA GENTE --%>
            <section class="obra-section">
                <div class="obra-section-head">
                    <div class="obra-reviews-head">
                        <h2 class="obra-reviews-section-title">Qué dice la gente</h2>
                        <c:if test="${avgStars != null}">
                            <span class="obra-avg-rating">
                                <span class="obra-avg-stars" aria-hidden="true">
                                    <span class="obra-avg-stars-base">★★★★★</span>
                                    <span class="obra-avg-stars-fill" style="width: ${avgStarsPercent}%;">★★★★★</span>
                                </span>
                                <span class="obra-avg-rating-value">
                                    <fmt:formatNumber value="${avgStars}" maxFractionDigits="1" /> / 5
                                </span>
                                <span class="obra-avg-rating-meta">
                                    <c:out value="${fn:length(reviews)}" /> reseña${fn:length(reviews) == 1 ? '' : 's'}
                                </span>
                            </span>
                        </c:if>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty reviews}">
                        <div class="obra-reviews-grid">
                            <c:forEach var="r" items="${reviews}">
                                <div class="obra-review-card">
                                    <div class="obra-review-header">
                                        <span class="obra-review-avatar">U<c:out value="${r.userId}" /></span>
                                        <span class="obra-review-author">Usuario #<c:out value="${r.userId}" /></span>
                                    </div>
                                    <p class="obra-review-body">"<c:out value="${r.body}" />"</p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="obra-reviews-empty">
                            Todavía no hay reseñas publicadas para esta versión.
                        </div>
                    </c:otherwise>
                </c:choose>

                <%-- CALIFICAR + RESEÑAR --%>
                <c:if test="${selectedProduction != null}">
                    <div class="obra-interact-panel">
                        <div class="obra-participation-rating">
                            <div class="obra-interact-head">
                                <h3 class="obra-interact-title">Tu calificación</h3>
                                <span class="obra-rating-value">
                                    <c:choose>
                                        <c:when test="${userStars != null}">
                                            <fmt:formatNumber value="${userStars}" maxFractionDigits="1" />/5
                                        </c:when>
                                        <c:otherwise>
                                            --/5
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <c:if test="${param.rating == 'saved'}">
                                <p class="obra-inline-feedback obra-inline-feedback-success">
                                    Guardada.
                                </p>
                            </c:if>

                            <c:url var="rateActionUrl" value="/productions/${selectedProduction.id}/rate" />
                            <form action="${rateActionUrl}"
                                  method="post"
                                  accept-charset="UTF-8"
                                  class="obra-rate-form-inner">
                                <input type="hidden" name="obraId" value="${obra.id}" />
                                <paw:starRating
                                    name="score"
                                    currentValue="${userStars}"
                                    max="5"
                                    groupLabel="Tu calificación"
                                    promptText="Sin calificar"
                                    autosubmit="true" />
                            </form>
                        </div>

                        <div class="obra-participation-review ${userStars == null ? 'obra-participation-review-locked' : ''}" data-review-module>
                            <div class="obra-interact-head">
                                <h3 class="obra-interact-title">Tu reseña</h3>
                            </div>

                            <c:if test="${param.error == 'rate_first'}">
                                <p class="obra-inline-feedback obra-inline-feedback-warning">
                                    Primero calificá.
                                </p>
                            </c:if>

                            <c:if test="${param.review == 'saved'}">
                                <p class="obra-inline-feedback obra-inline-feedback-success">
                                    Publicada.
                                </p>
                            </c:if>

                            <c:choose>
                                <c:when test="${userReview != null}">
                                    <div class="obra-user-review-card">
                                        <blockquote class="obra-user-review">
                                            "<c:out value="${userReview.body}" />"
                                        </blockquote>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:url var="reviewActionUrl" value="/productions/${selectedProduction.id}/review" />
                                    <form action="${reviewActionUrl}"
                                          method="post"
                                          accept-charset="UTF-8"
                                          class="obra-review-form ${userStars == null ? 'obra-review-form-locked' : ''}"
                                          data-review-gate>
                                        <input type="hidden" name="obraId" value="${obra.id}" />
                                        <textarea name="body"
                                                  rows="4"
                                                  class="obra-review-textarea"
                                                  placeholder="${userStars != null ? '¿Qué te dejó esta obra?' : 'Calificá para escribir'}"
                                                  data-enabled-placeholder="¿Qué te dejó esta obra?"
                                                  data-disabled-placeholder="Calificá para escribir"
                                                  ${userStars == null ? 'disabled' : ''}></textarea>
                                        <div class="obra-review-actions">
                                            <button type="submit"
                                                    class="btn btn-primary btn-md obra-review-submit"
                                                    ${userStars == null ? 'disabled' : ''}>
                                                Publicar reseña
                                            </button>
                                        </div>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
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
                <a href="${wishlistUrl}" class="btn btn-outline btn-md obra-sidebar-cta">
                    MI WISHLIST
                </a>
                <a href="${watchlistUrl}" class="btn btn-outline btn-md obra-sidebar-cta">
                    YA LAS VI
                </a>
            </div>
        </aside>

    </div>

</main>

</body>
</html>
