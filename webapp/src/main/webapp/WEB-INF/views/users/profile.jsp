<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec"    uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="paw"    tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="profile.pageTitle" /></title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/user-profile.css" />
</head>
<body>

<paw:navbar activeSection="profile" />

<%-- Precompute URLs --%>
<c:url var="carteleraUrl"      value="/cartelera" />
<c:url var="watchlistUrl"      value="/watchlist" />
<c:url var="historialUrl"      value="/historial" />
<c:url var="updatePictureUrl"  value="/users/me/picture" />
<c:url var="updatePersonalUrl" value="/users/me/personal" />
<c:url var="forgotPasswordUrl" value="/forgot-password" />
<c:url var="logoutUrl"         value="/logout" />

<%-- Avatar initial --%>
<c:choose>
    <c:when test="${not empty currentUsername}">
        <c:set var="avatarInitial" value="${fn:toUpperCase(fn:substring(currentUsername, 0, 1))}" />
    </c:when>
    <c:when test="${not empty currentUserEmail}">
        <c:set var="avatarInitial" value="${fn:toUpperCase(fn:substring(currentUserEmail, 0, 1))}" />
    </c:when>
    <c:otherwise>
        <c:set var="avatarInitial" value="?" />
    </c:otherwise>
</c:choose>

<%-- Max distribution count (for bar width calculation) --%>
<c:set var="maxDist" value="1" />
<c:forEach begin="1" end="10" var="s">
    <c:if test="${ratingDistribution[s] > maxDist}">
        <c:set var="maxDist" value="${ratingDistribution[s]}" />
    </c:if>
</c:forEach>

<main class="profile-page">

    <%-- ── Hero ─────────────────────────────────────────────── --%>
    <section class="profile-hero">
    <div class="profile-hero-inner">
        <div class="profile-hero-lead">

            <%-- Avatar with edit overlay --%>
            <div class="profile-hero-avatar">
                <c:choose>
                    <c:when test="${not empty currentUserImageId}">
                        <c:url var="userPfpUrl" value="/images/${currentUserImageId}" />
                        <img class="profile-hero-avatar-img"
                             src="${userPfpUrl}"
                             alt="${fn:escapeXml(currentUsername)}" />
                    </c:when>
                    <c:otherwise>
                        <span class="profile-hero-avatar-placeholder" aria-hidden="true">
                            <c:out value="${avatarInitial}" />
                        </span>
                    </c:otherwise>
                </c:choose>
                <form action="${updatePictureUrl}" method="post"
                      enctype="multipart/form-data" style="position:absolute;inset:0;">
                    <input type="hidden" name="${_csrf.parameterName}"
                           value="${fn:escapeXml(_csrf.token)}" />
                    <label for="pictureInput"
                           class="profile-hero-avatar-edit"
                           title="<spring:message code="profile.picture.change" />">
                        <span class="profile-hero-avatar-edit-icon" aria-hidden="true">&#9998;</span>
                    </label>
                    <input type="file" name="picture" accept="image/*"
                           id="pictureInput" class="user-profile-picture-input"
                           onchange="this.form.submit()" />
                </form>
            </div>

            <%-- Name / email / bio --%>
            <div class="profile-hero-info">
                <span class="profile-hero-kicker">
                    <spring:message code="profile.hero.kicker" />
                </span>
                <h1 class="profile-hero-name">
                    <spring:message code="profile.hero.greeting" />&nbsp;<em><c:out value="${not empty currentUsername ? currentUsername : currentUserEmail}" /></em>
                </h1>
                <div class="profile-hero-meta">
                    <span class="profile-hero-email"><c:out value="${currentUserEmail}" /></span>
                </div>
                <c:choose>
                    <c:when test="${not empty currentUserBio}">
                        <p class="profile-hero-bio">&#8220;<c:out value="${currentUserBio}" />&#8221;</p>
                    </c:when>
                    <c:otherwise>
                        <p class="profile-hero-bio-empty">
                            <spring:message code="profile.hero.bioEmpty" />
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- Activity mini-panel --%>
        <aside class="profile-hero-panel" aria-label="Resumen de actividad">
            <div class="profile-hero-panel-head">
                <span><spring:message code="profile.panel.activity" /></span>
            </div>
            <div class="profile-stat">
                <span class="profile-stat-num"><c:out value="${watchlistCount}" /></span>
                <span class="profile-stat-label"><spring:message code="profile.panel.watchlist" /></span>
            </div>
            <div class="profile-stat">
                <span class="profile-stat-num"><c:out value="${historialCount}" /></span>
                <span class="profile-stat-label"><spring:message code="profile.panel.seen" /></span>
            </div>
            <div class="profile-stat">
                <span class="profile-stat-num profile-stat-num-accent"><c:out value="${reviewsCount}" /></span>
                <span class="profile-stat-label"><spring:message code="profile.panel.reviews" /></span>
            </div>
            <div class="profile-stat">
                <c:choose>
                    <c:when test="${averageRating != null}">
                        <span class="profile-stat-num profile-stat-num-warm">
                            <c:out value="${avgFormatted}" /><span style="font-size:0.9rem;color:var(--platea-text-soft);font-weight:600;">/10</span>
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="profile-stat-num profile-stat-num-warm">—</span>
                    </c:otherwise>
                </c:choose>
                <span class="profile-stat-label"><spring:message code="profile.panel.average" /></span>
            </div>
        </aside>
    </div><%-- /profile-hero-inner --%>
    </section>

    <%-- ── Sidebar + Content layout ──────────────────────────── --%>
    <div class="profile-body-inner">
    <div class="profile-layout">

        <aside class="profile-sidebar" aria-label="Secciones del perfil">
            <span class="profile-sidebar-section">
                <spring:message code="profile.sidebar.sectionProfile" />
            </span>
            <button type="button" class="profile-sidebar-item is-active" data-tab="overview">
                <spring:message code="profile.sidebar.overview" />
            </button>
            <button type="button" class="profile-sidebar-item" data-tab="watchlist">
                <spring:message code="profile.sidebar.watchlist" />
                <span class="profile-sidebar-count"><c:out value="${watchlistCount}" /></span>
            </button>
            <button type="button" class="profile-sidebar-item" data-tab="reviews">
                <spring:message code="profile.sidebar.reviews" />
                <span class="profile-sidebar-count"><c:out value="${reviewsCount}" /></span>
            </button>

            <span class="profile-sidebar-section">
                <spring:message code="profile.sidebar.sectionConfig" />
            </span>
            <button type="button" class="profile-sidebar-item" data-tab="account">
                <spring:message code="profile.sidebar.account" />
            </button>
        </aside>

        <section class="profile-content">

            <%-- ── Overview panel ────────────────────────────── --%>
            <div class="profile-panel" data-panel="overview">

                <%-- Stat cards --%>
                <div class="profile-stats-grid">
                    <div class="profile-statcard profile-statcard-violet">
                        <span class="profile-statcard-label"><spring:message code="profile.stat.watchlist" /></span>
                        <span class="profile-statcard-value"><c:out value="${watchlistCount}" /></span>
                    </div>
                    <div class="profile-statcard profile-statcard-emerald">
                        <span class="profile-statcard-label"><spring:message code="profile.stat.seen" /></span>
                        <span class="profile-statcard-value"><c:out value="${historialCount}" /></span>
                    </div>
                    <div class="profile-statcard profile-statcard-violet">
                        <span class="profile-statcard-label"><spring:message code="profile.stat.reviews" /></span>
                        <span class="profile-statcard-value"><c:out value="${reviewsCount}" /></span>
                    </div>
                    <div class="profile-statcard profile-statcard-amber">
                        <span class="profile-statcard-label"><spring:message code="profile.stat.average" /></span>
                        <c:choose>
                            <c:when test="${averageRating != null}">
                                <span class="profile-statcard-value profile-statcard-value-small">
                                    <c:out value="${avgFormatted}" /><span class="profile-statcard-scale">/10</span>
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="profile-statcard-value profile-statcard-value-small">—</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <%-- Two-column: recent reviews + rating distribution --%>
                <div class="profile-two-col">

                    <%-- Recent reviews card --%>
                    <div class="profile-card">
                        <div class="profile-section-head">
                            <div>
                                <h2 class="profile-section-title">
                                    <spring:message code="profile.overview.recentReviews.title1" />
                                    <em><spring:message code="profile.overview.recentReviews.title2" /></em>
                                </h2>
                                <p class="profile-section-sub">
                                    <spring:message code="profile.overview.recentReviews.sub" />
                                </p>
                            </div>
                            <button type="button" class="profile-section-link" data-nav-tab="reviews">
                                <spring:message code="profile.overview.recentReviews.seeAll" /> →
                            </button>
                        </div>

                        <c:choose>
                            <c:when test="${not empty recentReviews}">
                                <ul class="profile-recent-list">
                                    <c:forEach var="r" items="${recentReviews}">
                                        <c:url var="reviewUrl" value="/obras/${r.obraId}" />
                                        <li>
                                            <a class="profile-recent-row" href="${reviewUrl}">
                                                <c:choose>
                                                    <c:when test="${r.productionImageId != null}">
                                                        <c:url var="rImgUrl" value="/images/${r.productionImageId}" />
                                                        <img class="profile-recent-poster"
                                                             src="${rImgUrl}"
                                                             alt="${fn:escapeXml(r.obraTitle)}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="profile-recent-poster"></div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="profile-recent-body">
                                                    <span class="profile-recent-title">
                                                        <c:out value="${not empty r.obraTitle ? r.obraTitle : 'Ver obra'}" />
                                                    </span>
                                                    <span class="profile-recent-snippet">
                                                        <c:out value="${r.body}" />
                                                    </span>
                                                </div>
                                                <c:if test="${r.score != null}">
                                                    <span class="profile-recent-score">
                                                        <c:out value="${r.score}" /><span class="profile-recent-score-scale">/10</span>
                                                    </span>
                                                </c:if>
                                            </a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <p class="profile-section-sub">
                                    <spring:message code="profile.overview.recentReviews.empty" />
                                </p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%-- Rating distribution card --%>
                    <div class="profile-card">
                        <div class="profile-section-head">
                            <div>
                                <h2 class="profile-section-title">
                                    <spring:message code="profile.overview.distribution.title1" />
                                    <em><spring:message code="profile.overview.distribution.title2" /></em>
                                </h2>
                                <p class="profile-section-sub">
                                    <spring:message code="profile.overview.distribution.sub" arguments="${reviewsCount}" />
                                </p>
                            </div>
                        </div>

                        <div class="profile-breakdown" role="list">
                            <c:forEach begin="0" end="9" var="i">
                                <c:set var="score" value="${10 - i}" />
                                <c:set var="cnt" value="${ratingDistribution[score]}" />
                                <c:set var="barPct" value="${maxDist > 0 ? (cnt * 100 / maxDist) : 0}" />
                                <div class="profile-breakdown-row ${cnt == 0 ? 'is-dim' : ''}" role="listitem">
                                    <span class="profile-breakdown-score">
                                        <span class="profile-breakdown-score-star">&#9733;</span>
                                        <span class="profile-breakdown-score-num"><c:out value="${score}" /></span>
                                    </span>
                                    <span class="profile-breakdown-bar">
                                        <span class="profile-breakdown-bar-fill" style="width:${barPct}%"></span>
                                    </span>
                                    <span class="profile-breakdown-count"><c:out value="${cnt}" /></span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                </div>
            </div>

            <%-- ── Watchlist panel ────────────────────────────── --%>
            <div class="profile-panel" data-panel="watchlist" hidden>
                <div class="profile-section-head">
                    <div>
                        <h2 class="profile-section-title">
                            <spring:message code="profile.watchlist.title1" />
                            <em><spring:message code="profile.watchlist.title2" /></em>
                        </h2>
                        <p class="profile-section-sub">
                            <spring:message code="profile.watchlist.sub" />
                        </p>
                    </div>
                    <a href="${watchlistUrl}" class="profile-section-link">
                        <spring:message code="profile.watchlist.openFull" /> →
                    </a>
                </div>

                <c:choose>
                    <c:when test="${not empty watchlist}">
                        <div class="profile-prod-grid">
                            <c:forEach var="p" items="${watchlist}">
                                <c:url var="prodUrl" value="/obras/${p.obraId}">
                                    <c:param name="produccionId" value="${p.id}" />
                                </c:url>
                                <c:set var="isEnded"  value="${p.endDate != null and p.endDate.isBefore(today)}" />
                                <c:set var="isLive"   value="${not isEnded and p.startDate != null and p.endDate != null and not p.startDate.isAfter(today)}" />
                                <a href="${prodUrl}" class="profile-prod-card">
                                    <div class="profile-prod-poster">
                                        <c:if test="${not empty p.imageId}">
                                            <c:url var="prodImgUrl" value="/images/${p.imageId}" />
                                            <img src="${prodImgUrl}" alt="${fn:escapeXml(p.name)}" />
                                        </c:if>
                                        <c:choose>
                                            <c:when test="${isEnded}">
                                                <span class="profile-prod-poster-badge profile-prod-poster-badge-ended">
                                                    <spring:message code="profile.watchlist.badge.ended" />
                                                </span>
                                            </c:when>
                                            <c:when test="${isLive}">
                                                <span class="profile-prod-poster-badge profile-prod-poster-badge-live">
                                                    <spring:message code="profile.watchlist.badge.live" />
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="profile-prod-poster-badge">
                                                    <spring:message code="profile.watchlist.badge.upcoming" />
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="profile-prod-info">
                                        <span class="profile-prod-title"><c:out value="${p.name}" /></span>
                                        <c:if test="${not empty p.theater}">
                                            <span class="profile-prod-venue"><c:out value="${p.theater}" /></span>
                                        </c:if>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="profile-empty">
                            <span class="profile-empty-icon" aria-hidden="true">&#9734;</span>
                            <p class="profile-empty-title">
                                <spring:message code="profile.watchlist.empty.title" />
                            </p>
                            <p class="profile-empty-sub">
                                <spring:message code="profile.watchlist.empty.sub" />
                            </p>
                            <div class="profile-empty-actions">
                                <paw:button text="Ver cartelera" href="${carteleraUrl}" variant="cta" />
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- ── Reviews panel ──────────────────────────────── --%>
            <div class="profile-panel" data-panel="reviews" hidden>
                <div class="profile-section-head">
                    <div>
                        <h2 class="profile-section-title">
                            <spring:message code="profile.reviews.title1" />
                            <em><spring:message code="profile.reviews.title2" /></em>
                        </h2>
                        <p class="profile-section-sub">
                            <c:choose>
                                <c:when test="${averageRating != null}">
                                    <spring:message code="profile.reviews.subWithAvg"
                                                    arguments="${reviewsCount},${avgFormatted}" />
                                </c:when>
                                <c:otherwise>
                                    <spring:message code="profile.reviews.sub"
                                                    arguments="${reviewsCount}" />
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty reviews}">
                        <div class="profile-reviews-list">
                            <c:forEach var="r" items="${reviews}">
                                <c:url var="reviewUrl" value="/obras/${r.obraId}" />
                                <a class="profile-review-card" href="${reviewUrl}">
                                    <c:choose>
                                        <c:when test="${r.productionImageId != null}">
                                            <c:url var="rImgUrl" value="/images/${r.productionImageId}" />
                                            <img class="profile-review-img"
                                                 src="${rImgUrl}"
                                                 alt="${fn:escapeXml(r.obraTitle)}" />
                                        </c:when>
                                        <c:otherwise>
                                            <div class="profile-review-img"></div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="profile-review-body">
                                        <span class="profile-review-title">
                                            <c:out value="${not empty r.obraTitle ? r.obraTitle : 'Ver obra'}" />
                                        </span>
                                        <p class="profile-review-text">
                                            &#8220;<c:out value="${r.body}" />&#8221;
                                        </p>
                                    </div>
                                    <c:if test="${r.score != null}">
                                        <span class="profile-recent-score" style="align-self:start;">
                                            <c:out value="${r.score}" /><span class="profile-recent-score-scale">/10</span>
                                        </span>
                                    </c:if>
                                </a>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="profile-empty">
                            <span class="profile-empty-icon" aria-hidden="true">&#9998;</span>
                            <p class="profile-empty-title">
                                <spring:message code="profile.reviews.empty.title" />
                            </p>
                            <p class="profile-empty-sub">
                                <spring:message code="profile.reviews.empty.sub" />
                            </p>
                            <div class="profile-empty-actions">
                                <paw:button text="Ver cartelera" href="${carteleraUrl}" variant="cta" />
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- ── Account panel ──────────────────────────────── --%>
            <div class="profile-panel" data-panel="account" hidden>

                <%-- Personal data card --%>
                <div class="profile-form-card">
                    <div class="profile-form-card-head">
                        <p class="profile-form-card-kicker">
                            <spring:message code="profile.account.identity.kicker" />
                        </p>
                        <h2 class="profile-form-card-title">
                            <spring:message code="profile.account.identity.title" />
                        </h2>
                        <p class="profile-form-card-sub">
                            <spring:message code="profile.account.identity.sub" />
                        </p>
                    </div>

                    <form:form modelAttribute="updatePersonalDataForm"
                               action="${updatePersonalUrl}" method="post">
                        <input type="hidden" name="${_csrf.parameterName}"
                               value="${fn:escapeXml(_csrf.token)}" />

                        <div class="profile-form-grid">
                            <div class="profile-form-field">
                                <label class="profile-form-label" for="fieldUsername">
                                    <spring:message code="profile.account.field.username" />
                                </label>
                                <div class="profile-username-wrap">
                                    <form:input path="username" id="fieldUsername"
                                                cssClass="profile-form-input profile-form-readonly"
                                                readonly="readonly"
                                                maxlength="30" />
                                    <button type="button" id="usernameEditBtn"
                                            class="profile-username-edit-btn<c:if test="${usernameEditLocked}"> is-locked</c:if>"
                                            <c:if test="${usernameEditLocked}">disabled="disabled"</c:if>
                                            data-secs="${not empty usernameEditSecondsLeft ? usernameEditSecondsLeft : 0}"
                                            aria-label="Editar nombre de usuario"
                                            title="${usernameEditLocked ? 'Disponible en '.concat(usernameEditSecondsLeft).concat('s') : 'Editar nombre de usuario'}">&#9998;</button>
                                </div>
                                <form:errors path="username" cssClass="field-error" element="span" />
                                <c:choose>
                                    <c:when test="${usernameEditLocked}">
                                        <span class="profile-form-hint profile-form-hint-warn" id="usernameLockedMsg">
                                            Podés cambiar el nombre en <span id="usernameCountdownSecs"><c:out value="${usernameEditSecondsLeft}" /></span>s.
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="profile-form-hint">Tocá ✏ para editar tu nombre de usuario.</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="profile-form-field">
                                <label class="profile-form-label">
                                    <spring:message code="profile.account.field.email" />
                                </label>
                                <input class="profile-form-input profile-form-readonly"
                                       type="text"
                                       value="${fn:escapeXml(currentUserEmail)}"
                                       readonly aria-readonly="true" />
                                <span class="profile-form-hint">
                                    <spring:message code="profile.account.field.emailHint" />
                                </span>
                            </div>

                            <div class="profile-form-field profile-form-field-full">
                                <label class="profile-form-label" for="fieldBio">
                                    <spring:message code="profile.account.field.bio" />
                                </label>
                                <form:textarea path="bio" id="fieldBio"
                                               cssClass="profile-form-input profile-form-textarea"
                                               maxlength="300" rows="3" />
                                <form:errors path="bio" cssClass="field-error" element="span" />
                                <div class="profile-form-counter">
                                    <span id="bio-count">0</span> / 300
                                </div>
                            </div>
                        </div>

                        <div class="profile-form-submit">
                            <button type="button" class="profile-btn profile-btn-ghost"
                                    onclick="document.getElementById('fieldBio').value='${fn:escapeXml(currentUserBio)}'; document.getElementById('bio-count').textContent='${fn:length(currentUserBio)}';">
                                <spring:message code="profile.account.btn.cancel" />
                            </button>
                            <button type="submit" class="profile-btn profile-btn-cta">
                                <spring:message code="profile.account.btn.save" />
                            </button>
                        </div>
                    </form:form>
                </div>

                <%-- Security card --%>
                <div class="profile-form-card">
                    <div class="profile-form-card-head">
                        <p class="profile-form-card-kicker profile-form-card-kicker-primary">
                            <spring:message code="profile.account.security.kicker" />
                        </p>
                        <h2 class="profile-form-card-title">
                            <spring:message code="profile.account.security.title" />
                        </h2>
                        <p class="profile-form-card-sub">
                            <spring:message code="profile.account.security.sub" />
                        </p>
                    </div>

                    <div class="profile-security-row">
                        <div class="profile-security-row-info">
                            <span class="profile-security-row-title">
                                <spring:message code="profile.account.security.password.title" />
                            </span>
                            <span class="profile-security-row-sub">
                                <spring:message code="profile.account.security.password.sub" />
                            </span>
                        </div>
                        <a href="${forgotPasswordUrl}" class="profile-btn profile-btn-ghost">
                            <spring:message code="profile.account.security.password.btn" />
                        </a>
                    </div>

                    <div class="profile-security-row">
                        <div class="profile-security-row-info">
                            <span class="profile-security-row-title">
                                <spring:message code="profile.account.security.logout.title" />
                            </span>
                            <span class="profile-security-row-sub">
                                <spring:message code="profile.account.security.logout.sub" />
                            </span>
                        </div>
                        <form action="${logoutUrl}" method="post" style="margin:0;">
                            <input type="hidden" name="${_csrf.parameterName}"
                                   value="${fn:escapeXml(_csrf.token)}" />
                            <button type="submit" class="profile-btn profile-btn-ghost">
                                <spring:message code="profile.account.security.logout.btn" />
                            </button>
                        </form>
                    </div>
                </div>

            </div><%-- end account panel --%>

        </section>
    </div><%-- end profile-layout --%>
    </div><%-- end profile-body-inner --%>

</main>

<script>
(function () {
    var tabs     = document.querySelectorAll('[data-tab]');
    var panels   = document.querySelectorAll('[data-panel]');
    var deepLinks = document.querySelectorAll('[data-nav-tab]');

    function activate(name) {
        tabs.forEach(function (t) {
            t.classList.toggle('is-active', t.dataset.tab === name);
        });
        panels.forEach(function (p) {
            p.hidden = p.dataset.panel !== name;
        });
        history.replaceState(null, '', '#' + name);
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    tabs.forEach(function (tab) {
        tab.addEventListener('click', function () { activate(tab.dataset.tab); });
    });

    deepLinks.forEach(function (link) {
        link.addEventListener('click', function (e) {
            e.preventDefault();
            activate(link.dataset.navTab);
        });
    });

    /* Deep-link via hash on load */
    var hash = location.hash.replace('#', '');
    var validTabs = ['overview', 'watchlist', 'reviews', 'account'];
    var serverTab = '${not empty activeTab ? activeTab : ""}';
    var hasErrors = document.querySelector('.field-error');
    var initial = (validTabs.indexOf(hash) !== -1 ? hash : null)
               || (hasErrors ? 'account' : null)
               || serverTab
               || 'overview';
    activate(initial);

    /* Bio counter */
    var bioField = document.getElementById('fieldBio');
    var bioCount = document.getElementById('bio-count');
    if (bioField && bioCount) {
        bioCount.textContent = bioField.value.length;
        bioField.addEventListener('input', function () {
            bioCount.textContent = bioField.value.length;
        });
    }

    /* Username pencil-unlock + cooldown countdown */
    (function () {
        var editBtn  = document.getElementById('usernameEditBtn');
        var editInp  = document.getElementById('fieldUsername');
        var secsSpan = document.getElementById('usernameCountdownSecs');
        var lockedMsg = document.getElementById('usernameLockedMsg');
        if (!editBtn || !editInp) return;

        var secsLeft = parseInt(editBtn.getAttribute('data-secs') || '0', 10);

        if (secsLeft > 0) {
            var countdown = setInterval(function () {
                secsLeft = Math.max(0, secsLeft - 1);
                if (secsSpan) secsSpan.textContent = secsLeft;
                if (secsLeft <= 0) {
                    clearInterval(countdown);
                    editBtn.disabled = false;
                    editBtn.classList.remove('is-locked');
                    editBtn.title = 'Editar nombre de usuario';
                    if (lockedMsg) lockedMsg.style.display = 'none';
                }
            }, 1000);
        }

        editBtn.addEventListener('click', function () {
            if (editBtn.disabled) return;
            editInp.removeAttribute('readonly');
            editInp.classList.remove('profile-form-readonly');
            editInp.focus();
            editInp.select();
            editBtn.style.display = 'none';
        });
    }());
})();
</script>

</body>
</html>
