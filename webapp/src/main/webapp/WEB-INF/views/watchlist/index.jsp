<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de obras vistas — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/user-lists.css" />
</head>
<body>

    <paw:navbar activeSection="historial" />

    <c:url var="carteleraUrl" value="/cartelera" />
    <c:set var="seenCount" value="${fn:length(seenObras)}" />
    <c:set var="unratedCount" value="${seenCount - ratedCount}" />

    <main class="user-list-page">

        <section class="user-list-hero">
            <div class="user-list-hero-lead">
                <span class="user-list-kicker">Tu historial</span>
                <h1 class="user-list-hero-title">Todo lo que <em>ya viste</em></h1>
                <p class="user-list-hero-sub">Repasá las obras que marcaste como vistas, cómo las puntuaste y cuál es tu distribución de estrellas a lo largo del tiempo.</p>
                <c:if test="${seenCount > 0}">
                    <div class="user-list-hero-counts" aria-label="Resumen del historial">
                        <div class="user-list-hero-count">
                            <span class="user-list-hero-count-num"><c:out value="${seenCount}" /></span>
                            <span class="user-list-hero-count-label">Vistas</span>
                        </div>
                        <div class="user-list-hero-count">
                            <span class="user-list-hero-count-num"><c:out value="${ratedCount}" /></span>
                            <span class="user-list-hero-count-label">Puntuadas</span>
                        </div>
                        <c:if test="${unratedCount > 0}">
                            <div class="user-list-hero-count">
                                <span class="user-list-hero-count-num"><c:out value="${unratedCount}" /></span>
                                <span class="user-list-hero-count-label">Sin puntuar</span>
                            </div>
                        </c:if>
                    </div>
                </c:if>
            </div>

            <c:if test="${ratedCount > 0}">
                <aside class="user-list-breakdown" aria-label="Distribución de puntuaciones">
                    <div class="user-list-breakdown-head">
                        <span>Tu ranking</span>
                        <span class="user-list-breakdown-avg">
                            <span class="user-list-breakdown-avg-star" aria-hidden="true">★</span>
                            <c:out value="${ratingAverage}" /> promedio
                        </span>
                    </div>
                    <c:forEach begin="1" end="10" var="tierReverse">
                        <c:set var="tier" value="${11 - tierReverse}" />
                        <c:set var="tierCount" value="${ratingDistribution[tier - 1]}" />
                        <c:set var="tierPct" value="${ratingDistributionMax > 0 ? (tierCount * 100) / ratingDistributionMax : 0}" />
                        <div class="user-list-breakdown-row ${tierCount == 0 ? 'is-dim' : ''}" aria-label="${tier} de 10">
                            <span class="user-list-breakdown-score" aria-hidden="true">
                                <span class="user-list-breakdown-score-star">★</span>
                                <span class="user-list-breakdown-score-num"><c:out value="${tier}" /></span>
                            </span>
                            <span class="user-list-breakdown-bar">
                                <span class="user-list-breakdown-bar-fill" style="width: ${tierPct}%;"></span>
                            </span>
                            <span class="user-list-breakdown-count"><c:out value="${tierCount}" /></span>
                        </div>
                    </c:forEach>
                </aside>
            </c:if>
        </section>

        <c:choose>
            <c:when test="${seenCount > 0}">
                <ul class="user-list-grid" role="list">
                    <c:forEach var="o" items="${seenObras}">
                        <c:url var="obraUrl" value="/obras/${o.id}" />
                        <c:set var="rawScore" value="${userObraScores[o.id]}" />
                        <li>
                            <a href="${obraUrl}" class="user-list-row">
                                <span class="user-list-poster" aria-hidden="true">
                                    <span class="user-list-poster-placeholder"></span>
                                    <span class="user-list-poster-initial">
                                        <c:out value="${fn:toUpperCase(fn:substring(o.title, 0, 1))}" />
                                    </span>
                                </span>
                                <div class="user-list-row-info">
                                    <span class="user-list-row-title"><c:out value="${o.title}" /></span>
                                    <div class="user-list-row-meta">
                                        <c:if test="${not empty o.genre}">
                                            <span class="user-list-row-genre"><c:out value="${o.genre}" /></span>
                                        </c:if>
                                        <c:if test="${empty rawScore}">
                                            <c:if test="${not empty o.genre}"><span class="user-list-row-dot" aria-hidden="true"></span></c:if>
                                            <span class="user-list-row-unrated-text">Sin puntuar</span>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="user-list-row-right">
                                    <c:choose>
                                        <c:when test="${not empty rawScore}">
                                            <span class="user-list-row-stars" aria-label="Tu puntuación: ${rawScore} sobre 10">
                                                <c:forEach begin="1" end="5" var="starIdx">
                                                    <c:set var="threshold" value="${starIdx * 2}" />
                                                    <c:choose>
                                                        <c:when test="${rawScore >= threshold}">
                                                            <span class="user-list-row-star" aria-hidden="true">★</span>
                                                        </c:when>
                                                        <c:when test="${rawScore >= threshold - 1}">
                                                            <span class="user-list-row-star is-half" aria-hidden="true">★</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="user-list-row-star is-empty" aria-hidden="true">★</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                                <span class="user-list-row-score">
                                                    <c:out value="${rawScore}" /><span class="user-list-row-score-scale" aria-hidden="true">/10</span>
                                                </span>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="user-list-row-rate-hint" aria-hidden="true">Puntuar ＋</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="user-list-row-cta" aria-hidden="true">
                                        Ver
                                        <span class="user-list-row-cta-arrow">→</span>
                                    </span>
                                </div>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <div class="user-list-empty">
                    <span class="user-list-empty-icon" aria-hidden="true">✓</span>
                    <p class="user-list-empty-text">Todavía no marcaste ninguna obra como vista.</p>
                    <p class="user-list-empty-hint">Cuando veas una obra, marcala o puntuala desde su página y aparecerá acá.</p>
                    <a href="${carteleraUrl}" class="btn btn-primary btn-md">
                        Ver cartelera
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

</body>
</html>
