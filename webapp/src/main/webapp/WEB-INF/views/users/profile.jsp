<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/auth.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/production-card.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/section-row.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/user-profile.css" />
</head>
<body>

<paw:navbar />

<c:url var="carteleraUrl"      value="/cartelera" />
<c:url var="updateUsernameUrl" value="/users/me/username" />
<c:url var="updatePictureUrl"  value="/users/me/picture" />
<c:url var="updatePersonalUrl" value="/users/me/personal" />

<%-- Compute avatar initial safely --%>
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

<%-- Profile Hero — compact banner --%>
<section class="profile-hero">
    <div class="profile-hero-content">

        <%-- Avatar with picture-change overlay --%>
        <div class="profile-hero-avatar-wrap">
            <c:choose>
                <c:when test="${not empty currentUserImageId}">
                    <c:url var="userPfpUrl" value="/images/${currentUserImageId}" />
                    <img class="profile-hero-avatar-img" src="${userPfpUrl}" alt="Avatar" />
                </c:when>
                <c:otherwise>
                    <span class="profile-hero-avatar-placeholder" aria-hidden="true">
                        <c:out value="${avatarInitial}" />
                    </span>
                </c:otherwise>
            </c:choose>

            <form action="${updatePictureUrl}" method="post" enctype="multipart/form-data" class="user-profile-picture-form">
                <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                <label for="pictureInput" class="user-profile-picture-label" title="Cambiar foto de perfil">
                    <span class="user-profile-picture-icon" aria-hidden="true">&#9998;</span>
                </label>
                <input type="file" name="picture" accept="image/*" id="pictureInput"
                       class="user-profile-picture-input"
                       onchange="this.form.submit()" />
            </form>
        </div>

        <%-- Name + email + stats --%>
        <div class="profile-hero-info">
            <p class="profile-hero-kicker">Platea — Cuenta personal</p>
            <h1 class="profile-hero-name">
                <c:choose>
                    <c:when test="${not empty currentUsername}"><c:out value="${currentUsername}" /></c:when>
                    <c:otherwise><spring:message code="profile.title" /></c:otherwise>
                </c:choose>
            </h1>
            <p class="profile-hero-email"><c:out value="${currentUserEmail}" /></p>
            <div class="profile-hero-stats">
                <span class="profile-hero-stat">
                    <span class="profile-hero-stat-value"><c:out value="${fn:length(reviews)}" /></span>
                    <span class="profile-hero-stat-label">reseñas</span>
                </span>
                <span class="profile-hero-stat-sep" aria-hidden="true"></span>
                <span class="profile-hero-stat">
                    <span class="profile-hero-stat-value"><c:out value="${fn:length(watchlist)}" /></span>
                    <span class="profile-hero-stat-label">watchlist</span>
                </span>
            </div>
        </div>

    </div>
</section>

<%-- Profile Tab Nav — sticky below navbar --%>
<nav class="profile-nav" aria-label="Secciones del perfil">
    <div class="profile-nav-inner" role="tablist">
        <button class="profile-tab" role="tab" aria-selected="true"  data-profile-tab="watchlist">Watchlist</button>
        <button class="profile-tab" role="tab" aria-selected="false" data-profile-tab="reviews">Reseñas</button>
        <button class="profile-tab" role="tab" aria-selected="false" data-profile-tab="account">Mi cuenta</button>
    </div>
</nav>

<main class="user-profile-page">

    <%-- Watchlist panel --%>
    <div data-profile-panel="watchlist" role="tabpanel">
        <c:choose>
            <c:when test="${not empty watchlist}">
                <paw:sectionRow title="Mi Watchlist" subtitle="Producciones que quiero ver">
                    <c:forEach var="p" items="${watchlist}">
                        <c:url var="watchlistItemUrl" value="/obras/${p.obraId}">
                            <c:param name="produccionId" value="${p.id}" />
                        </c:url>
                        <paw:productionCard
                            title="${fn:escapeXml(p.name)}"
                            imageUrl="${not empty p.imageUrl ? p.imageUrl : ''}"
                            venue="${fn:escapeXml(p.theater)}"
                            rating="${productionRatings[p.id]}"
                            detailUrl="${watchlistItemUrl}"
                        />
                    </c:forEach>
                </paw:sectionRow>
            </c:when>
            <c:otherwise>
                <div class="profile-shell">
                    <div class="profile-card profile-empty-card">
                        <h2 class="profile-card-title">Mi Watchlist</h2>
                        <p class="profile-empty-text">Tu watchlist está vacía. Explorá producciones y agregalas.</p>
                        <paw:button text="Ver cartelera" href="${carteleraUrl}" variant="cta" />
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- Reviews panel --%>
    <div data-profile-panel="reviews" role="tabpanel" hidden>
        <div class="profile-shell">
            <section class="profile-reviews-section">
                <h2 class="profile-section-title"><spring:message code="profile.reviews.title" /></h2>
                <c:choose>
                    <c:when test="${not empty reviews}">
                        <div class="profile-reviews-list">
                            <c:forEach var="r" items="${reviews}">
                                <c:url var="reviewObraUrl" value="/obras/${r.obraId}" />
                                <div class="user-profile-review-card">
                                    <c:if test="${r.productionImageId != null}">
                                        <c:url var="reviewImgUrl" value="/images/${r.productionImageId}" />
                                        <a href="${reviewObraUrl}" class="user-profile-review-img-link">
                                            <img class="user-profile-review-img" src="${reviewImgUrl}" alt="${fn:escapeXml(r.obraTitle)}" />
                                        </a>
                                    </c:if>
                                    <div class="user-profile-review-content">
                                        <a href="${reviewObraUrl}" class="user-profile-review-link">
                                            <c:out value="${not empty r.obraTitle ? r.obraTitle : 'Ver obra'}" />
                                        </a>
                                        <p class="user-profile-review-body"><c:out value="${r.body}" /></p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="profile-card profile-empty-card">
                            <h2 class="profile-card-title"><spring:message code="profile.reviews.empty" /></h2>
                            <p class="profile-empty-text">Todavía no escribiste ninguna reseña. Contanos qué te pareció una obra.</p>
                            <paw:button text="Ver cartelera" href="${carteleraUrl}" variant="cta" />
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </div>

    <%-- Account / settings panel --%>
    <div data-profile-panel="account" role="tabpanel" hidden>
        <div class="profile-shell">

            <%-- Datos personales --%>
            <div class="profile-card">
                <p class="profile-card-kicker">Identidad</p>
                <h2 class="profile-card-title">Datos personales</h2>
                <form:form modelAttribute="updatePersonalDataForm" action="${updatePersonalUrl}" method="post" cssClass="profile-settings-form">
                    <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />

                    <div class="profile-settings-grid">
                        <div class="profile-edit-field">
                            <label class="profile-edit-label" for="personalUsername">Nombre de usuario</label>
                            <form:input path="username" id="personalUsername" cssClass="auth-input profile-edit-input"
                                        placeholder="${fn:escapeXml(currentUsername)}" maxlength="30" />
                            <form:errors path="username" cssClass="field-error" element="span" />
                        </div>

                        <div class="profile-edit-field">
                            <label class="profile-edit-label">Email</label>
                            <input type="text" class="auth-input profile-edit-input profile-edit-readonly"
                                   value="${fn:escapeXml(currentUserEmail)}" readonly aria-readonly="true" />
                            <span class="profile-edit-hint">El email no se puede cambiar.</span>
                        </div>

                        <div class="profile-edit-field profile-edit-field-full">
                            <label class="profile-edit-label" for="personalBio">Bio</label>
                            <form:textarea path="bio" id="personalBio" cssClass="auth-input profile-edit-input profile-edit-textarea"
                                           placeholder="${fn:escapeXml(not empty currentUserBio ? currentUserBio : 'Contá algo sobre vos…')}"
                                           maxlength="300" rows="3" />
                            <form:errors path="bio" cssClass="field-error" element="span" />
                            <span class="profile-edit-hint">Máximo 300 caracteres.</span>
                        </div>
                    </div>

                    <paw:button text="Guardar datos" type="submit" variant="cta" cssClass="profile-edit-submit" />
                </form:form>
            </div>

        </div>
    </div>

</main>

<script>
    (function () {
        var tabs   = document.querySelectorAll('[data-profile-tab]');
        var panels = document.querySelectorAll('[data-profile-panel]');

        function activate(name) {
            tabs.forEach(function (t) {
                var active = t.dataset.profileTab === name;
                t.classList.toggle('profile-tab-active', active);
                t.setAttribute('aria-selected', active ? 'true' : 'false');
            });
            panels.forEach(function (p) {
                p.hidden = p.dataset.profilePanel !== name;
            });
        }

        tabs.forEach(function (tab) {
            tab.addEventListener('click', function () {
                activate(tab.dataset.profileTab);
            });
        });

        /* Server can force a tab (e.g. on validation errors), else open watchlist */
        var serverTab = '${not empty activeTab ? activeTab : ""}';
        var hasFormErrors = document.querySelector('.field-error');
        activate(serverTab || (hasFormErrors ? 'account' : 'watchlist'));
    })();
</script>

</body>
</html>
