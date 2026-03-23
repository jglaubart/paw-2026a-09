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

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/play-detail.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/alert.css" />
</head>
<body>

<paw:navbar />

<main class="obra-detail-page">

    <%-- ═══════════════ HERO ═══════════════ --%>
    <c:set var="heroStyle" value="" />
    <c:if test="${not empty productions && productions[0].imageId != null}">
        <c:url var="heroImgUrl" value="/images/${productions[0].imageId}" />
        <c:set var="heroStyle" value="background-image: url('${heroImgUrl}');" />
    </c:if>

    <section class="obra-hero" style="${heroStyle}">
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
    <c:if test="${not empty productions}">
        <div class="obra-meta-bar">
            <c:if test="${not empty productions[0].theater}">
                <span class="obra-hero-meta-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2"
                         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                        <polyline points="9 22 9 12 15 12 15 22"/>
                    </svg>
                    <c:out value="${productions[0].theater}" />
                </span>
            </c:if>
            <c:if test="${productions[0].startDate != null}">
                <span class="obra-hero-meta-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2"
                         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                        <line x1="16" y1="2" x2="16" y2="6"/>
                        <line x1="8"  y1="2" x2="8"  y2="6"/>
                        <line x1="3"  y1="10" x2="21" y2="10"/>
                    </svg>
                    <c:out value="${productions[0].startDate}" />
                    <c:if test="${productions[0].endDate != null}">
                        — <c:out value="${productions[0].endDate}" />
                    </c:if>
                </span>
            </c:if>
            <c:if test="${not empty productions[0].direction}">
                <span class="obra-hero-meta-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2"
                         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <circle cx="12" cy="12" r="10"/>
                        <polygon points="10 8 16 12 10 16 10 8"/>
                    </svg>
                    <c:out value="${productions[0].direction}" />
                </span>
            </c:if>
        </div>
    </c:if>

    <%-- ═══════════════ BODY ═══════════════ --%>
    <div class="obra-content">

        <%-- ── MAIN COLUMN ── --%>
        <div class="obra-main-col">

            <%-- SINOPSIS --%>
            <section class="obra-section">
                <div class="obra-section-head">
                    <h2 class="obra-heading">Sinopsis</h2>
                    <div class="obra-head-actions">
                        <c:if test="${not empty productions && not empty productions[0].website}">
                            <a href="${fn:escapeXml(productions[0].website)}"
                               class="btn btn-primary btn-md"
                               target="_blank" rel="noopener noreferrer">
                                Comprar Entradas (Sitio Externo) ↗
                            </a>
                        </c:if>
                        <button type="button" class="obra-bookmark-btn" aria-label="Guardar en watchlist">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="2"
                                 stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/>
                            </svg>
                        </button>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty obra.synopsis}">
                        <p class="obra-synopsis"><c:out value="${obra.synopsis}" /></p>
                    </c:when>
                    <c:otherwise>
                        <p class="obra-synopsis obra-synopsis-empty">Sin sinopsis disponible.</p>
                    </c:otherwise>
                </c:choose>

                <%-- INFORMACIÓN ÚTIL --%>
                <c:if test="${not empty productions}">
                    <div class="obra-info-box">
                        <h3 class="obra-info-box-title">INFORMACIÓN ÚTIL</h3>
                        <div class="obra-info-grid">

                            <c:if test="${not empty productions[0].theater}">
                                <div class="obra-info-item">
                                    <span class="obra-info-icon" aria-hidden="true">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                             stroke="currentColor" stroke-width="2.5"
                                             stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0 1 18 0z"/>
                                            <circle cx="12" cy="10" r="3"/>
                                        </svg>
                                    </span>
                                    <div>
                                        <strong class="obra-info-label">Teatro</strong>
                                        <p class="obra-info-value"><c:out value="${productions[0].theater}" /></p>
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${productions[0].startDate != null}">
                                <div class="obra-info-item">
                                    <span class="obra-info-icon" aria-hidden="true">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                             stroke="currentColor" stroke-width="2.5"
                                             stroke-linecap="round" stroke-linejoin="round">
                                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                                            <line x1="16" y1="2" x2="16" y2="6"/>
                                            <line x1="8"  y1="2" x2="8"  y2="6"/>
                                            <line x1="3"  y1="10" x2="21" y2="10"/>
                                        </svg>
                                    </span>
                                    <div>
                                        <strong class="obra-info-label">Funciones</strong>
                                        <p class="obra-info-value">
                                            <c:out value="${productions[0].startDate}" />
                                            <c:if test="${productions[0].endDate != null}">
                                                — <c:out value="${productions[0].endDate}" />
                                            </c:if>
                                        </p>
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${not empty productions[0].direction}">
                                <div class="obra-info-item">
                                    <span class="obra-info-icon" aria-hidden="true">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                             stroke="currentColor" stroke-width="2.5"
                                             stroke-linecap="round" stroke-linejoin="round">
                                            <polygon points="23 7 16 12 23 17 23 7"/>
                                            <rect x="1" y="5" width="15" height="14" rx="2" ry="2"/>
                                        </svg>
                                    </span>
                                    <div>
                                        <strong class="obra-info-label">Dirección</strong>
                                        <p class="obra-info-value"><c:out value="${productions[0].direction}" /></p>
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${not empty productions[0].website}">
                                <div class="obra-info-item">
                                    <span class="obra-info-icon" aria-hidden="true">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                             stroke="currentColor" stroke-width="2.5"
                                             stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M20 12V22H4V12"/>
                                            <path d="M22 7H2v5h20V7z"/>
                                            <path d="M12 22V7"/>
                                            <path d="M12 7H7.5a2.5 2.5 0 0 1 0-5C11 2 12 7 12 7z"/>
                                            <path d="M12 7h4.5a2.5 2.5 0 0 0 0-5C13 2 12 7 12 7z"/>
                                        </svg>
                                    </span>
                                    <div>
                                        <strong class="obra-info-label">Retiro de entradas</strong>
                                        <p class="obra-info-value">
                                            <a href="${fn:escapeXml(productions[0].website)}"
                                               target="_blank" rel="noopener noreferrer"
                                               class="obra-info-link">
                                                Sitio oficial ↗
                                            </a>
                                        </p>
                                    </div>
                                </div>
                            </c:if>

                        </div>
                    </div>
                </c:if>
            </section>

            <%-- QUÉ DICE LA GENTE --%>
            <section class="obra-section">
                <div class="obra-section-head">
                    <div class="obra-reviews-head">
                        <h2 class="obra-reviews-section-title">Qué dice la gente</h2>
                        <c:if test="${avgRating != null}">
                            <span class="obra-avg-rating">
                                <span class="obra-avg-stars" aria-hidden="true">★★★★★</span>
                                <fmt:formatNumber value="${avgRating}" maxFractionDigits="1" /> / 10
                            </span>
                        </c:if>
                    </div>
                </div>

                <c:if test="${not empty reviews}">
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
                </c:if>

                <%-- CALIFICAR + RESEÑAR --%>
                <div class="obra-interact-row">
                    <div class="obra-interact-card">
                        <h4 class="obra-interact-title">Calificar obra</h4>
                        <c:if test="${userScore != null}">
                            <p class="obra-user-score">Tu puntaje: <strong><c:out value="${userScore}" />/10</strong></p>
                        </c:if>
                        <form action="${pageContext.request.contextPath}/obras/${obra.id}/rate"
                              method="post" class="obra-rate-form-inner">
                            <select name="score" class="obra-score-select">
                                <c:forEach var="i" begin="1" end="10">
                                    <option value="${i}" ${userScore != null && userScore == i ? 'selected' : ''}>
                                        <c:out value="${i}" />
                                    </option>
                                </c:forEach>
                            </select>
                            <button type="submit" class="btn btn-primary btn-md">Calificar</button>
                        </form>
                    </div>

                    <div class="obra-interact-card">
                        <h4 class="obra-interact-title">Escribir reseña</h4>
                        <c:if test="${param.error == 'rate_first'}">
                            <paw:alert message="Tenés que calificar la obra antes de escribir una reseña." variant="warning" />
                        </c:if>
                        <c:choose>
                            <c:when test="${userReview != null}">
                                <blockquote class="obra-user-review">
                                    "<c:out value="${userReview.body}" />"
                                </blockquote>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/obras/${obra.id}/review"
                                      method="post">
                                    <textarea name="body" rows="3" class="obra-review-textarea"
                                              placeholder="Escribí tu reseña..."></textarea>
                                    <button type="submit" class="btn btn-primary btn-md">Enviar reseña</button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </section>

        </div>

        <%-- ── SIDEBAR ── --%>
        <aside class="obra-sidebar-col">
            <div class="obra-sidebar-card">
                <h3 class="obra-sidebar-title">SI TE GUSTÓ ESTA...</h3>

                <c:if test="${not empty productions}">
                    <div class="obra-sidebar-list">
                        <c:forEach var="p" items="${productions}">
                            <c:url var="prodUrl" value="/productions/${p.id}" />
                            <a href="${prodUrl}" class="obra-sidebar-item">
                                <div class="obra-sidebar-item-img">
                                    <c:choose>
                                        <c:when test="${p.imageId != null}">
                                            <img src="${pageContext.request.contextPath}/images/${p.imageId}"
                                                 alt="${fn:escapeXml(p.name)}" />
                                        </c:when>
                                        <c:otherwise>
                                            <div class="obra-sidebar-item-placeholder"></div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="obra-sidebar-item-info">
                                    <strong class="obra-sidebar-item-title"><c:out value="${p.name}" /></strong>
                                    <c:if test="${not empty p.theater}">
                                        <span class="obra-sidebar-item-theater"><c:out value="${p.theater}" /></span>
                                    </c:if>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </c:if>

                <a href="${pageContext.request.contextPath}/cartelera" class="btn btn-outline btn-md obra-sidebar-cta">
                    VER TODA LA CARTELERA
                </a>
            </div>
        </aside>

    </div>

</main>

</body>
</html>
