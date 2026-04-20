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
    <title>Mi Watchlist — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/user-lists.css" />

    <fmt:setLocale value="es_AR" />
</head>
<body>

    <paw:navbar activeSection="watchlist" />

    <c:url var="carteleraUrl" value="/cartelera" />
    <c:set var="wishlistCount" value="${fn:length(wishlist)}" />

    <%-- ── Pre-compute status counts (live / upcoming / ended).
           Presentation-level derivation from startDate/endDate — the
           controller keeps passing wishlist as-is. ── --%>
    <jsp:useBean id="todayBean" class="java.util.Date" />
    <fmt:formatDate value="${todayBean}" pattern="yyyy-MM-dd" var="todayStr" />

    <c:set var="countLive" value="0" />
    <c:set var="countUpcoming" value="0" />
    <c:set var="countEnded" value="0" />

    <c:forEach var="p" items="${wishlist}">
        <c:set var="startStr" value="" />
        <c:set var="endStr" value="" />
        <c:if test="${not empty p.startDate}">
            <fmt:formatDate value="${p.startDate}" pattern="yyyy-MM-dd" var="startStr" />
        </c:if>
        <c:if test="${not empty p.endDate}">
            <fmt:formatDate value="${p.endDate}" pattern="yyyy-MM-dd" var="endStr" />
        </c:if>
        <c:choose>
            <c:when test="${not empty endStr and endStr < todayStr}">
                <c:set var="countEnded" value="${countEnded + 1}" />
            </c:when>
            <c:when test="${not empty startStr and startStr > todayStr}">
                <c:set var="countUpcoming" value="${countUpcoming + 1}" />
            </c:when>
            <c:otherwise>
                <c:set var="countLive" value="${countLive + 1}" />
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <main class="user-list-page">

        <header class="user-list-hero ${wishlistCount == 0 ? 'user-list-hero-empty' : ''}">
            <div class="user-list-hero-main">
                <span class="user-list-kicker">Tu watchlist</span>
                <h1 class="user-list-title">Producciones que <em>querés ver</em></h1>
                <p class="user-list-subtitle">Guardá acá las producciones que te interesan. Cuando marques una como vista, pasa a tu historial automáticamente.</p>
                <c:if test="${wishlistCount > 0}">
                    <div class="user-list-counts" aria-label="Resumen de la watchlist">
                        <span class="user-list-count">
                            <span class="user-list-count-num"><c:out value="${wishlistCount}" /></span>
                            <span class="user-list-count-label">Guardadas</span>
                        </span>
                        <c:if test="${countLive > 0}">
                            <span class="user-list-count">
                                <span class="user-list-count-num user-list-count-num-accent"><c:out value="${countLive}" /></span>
                                <span class="user-list-count-label">En cartel</span>
                            </span>
                        </c:if>
                        <c:if test="${countUpcoming > 0}">
                            <span class="user-list-count">
                                <span class="user-list-count-num"><c:out value="${countUpcoming}" /></span>
                                <span class="user-list-count-label">Próximamente</span>
                            </span>
                        </c:if>
                        <c:if test="${countEnded > 0}">
                            <span class="user-list-count">
                                <span class="user-list-count-num user-list-count-num-soft"><c:out value="${countEnded}" /></span>
                                <span class="user-list-count-label">Terminaron</span>
                            </span>
                        </c:if>
                    </div>
                </c:if>
            </div>

            <c:if test="${wishlistCount > 0}">
                <aside class="user-list-sidepanel user-list-sidepanel-cool" aria-label="Próximas funciones">
                    <div class="user-list-sidepanel-head">
                        <span>Próximas funciones</span>
                        <c:if test="${countLive + countUpcoming > 0}">
                            <span class="user-list-sidepanel-head-accent-cool">
                                <c:out value="${countLive + countUpcoming}" /> activas
                            </span>
                        </c:if>
                    </div>

                    <c:set var="upcomingShown" value="0" />
                    <c:forEach var="p" items="${wishlist}">
                        <c:if test="${upcomingShown < 3 and not empty p.startDate}">
                            <c:set var="endStr" value="" />
                            <c:if test="${not empty p.endDate}">
                                <fmt:formatDate value="${p.endDate}" pattern="yyyy-MM-dd" var="endStr" />
                            </c:if>
                            <c:set var="isActive" value="${empty endStr or endStr >= todayStr}" />
                            <c:if test="${isActive}">
                                <c:url var="upcomingUrl" value="/obras/${p.obraId}">
                                    <c:param name="produccionId" value="${p.id}" />
                                </c:url>
                                <a href="${upcomingUrl}" class="user-list-upcoming-row">
                                    <span class="user-list-upcoming-date" aria-hidden="true">
                                        <span class="user-list-upcoming-date-day"><fmt:formatDate value="${p.startDate}" pattern="dd" /></span>
                                        <span class="user-list-upcoming-date-month"><fmt:formatDate value="${p.startDate}" pattern="MMM" /></span>
                                    </span>
                                    <span class="user-list-upcoming-body">
                                        <span class="user-list-upcoming-name"><c:out value="${p.name}" /></span>
                                        <c:if test="${not empty p.theater}">
                                            <span class="user-list-upcoming-sub"><c:out value="${p.theater}" /></span>
                                        </c:if>
                                    </span>
                                </a>
                                <c:set var="upcomingShown" value="${upcomingShown + 1}" />
                            </c:if>
                        </c:if>
                    </c:forEach>

                    <c:if test="${upcomingShown == 0}">
                        <p class="user-list-breakdown-empty">Sin funciones próximas en tu lista.</p>
                    </c:if>
                </aside>
            </c:if>
        </header>

        <c:choose>
            <c:when test="${wishlistCount > 0}">
                <ul class="user-list-grid" role="list">
                    <c:forEach var="p" items="${wishlist}">
                        <c:url var="detailUrl" value="/obras/${p.obraId}">
                            <c:param name="produccionId" value="${p.id}" />
                        </c:url>
                        <c:set var="prodRating" value="${productionRatings[p.id]}" />

                        <c:set var="startStr" value="" />
                        <c:set var="endStr" value="" />
                        <c:if test="${not empty p.startDate}">
                            <fmt:formatDate value="${p.startDate}" pattern="yyyy-MM-dd" var="startStr" />
                        </c:if>
                        <c:if test="${not empty p.endDate}">
                            <fmt:formatDate value="${p.endDate}" pattern="yyyy-MM-dd" var="endStr" />
                        </c:if>
                        <c:choose>
                            <c:when test="${not empty endStr and endStr < todayStr}">
                                <c:set var="statusKey"  value="ended" />
                                <c:set var="statusText" value="Terminó" />
                            </c:when>
                            <c:when test="${not empty startStr and startStr > todayStr}">
                                <c:set var="statusKey"  value="upcoming" />
                                <c:set var="statusText" value="Próximamente" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="statusKey"  value="live" />
                                <c:set var="statusText" value="En cartel" />
                            </c:otherwise>
                        </c:choose>

                        <li>
                            <a href="${detailUrl}" class="user-list-obra-card">
                                <div class="user-list-obra-poster">
                                    <c:choose>
                                        <c:when test="${not empty p.imageUrl}">
                                            <c:url var="posterUrl" value="${p.imageUrl}" />
                                            <img class="user-list-obra-poster-img" src="${fn:escapeXml(posterUrl)}" alt="" loading="lazy" />
                                        </c:when>
                                        <c:otherwise>
                                            <div class="user-list-obra-poster-placeholder" aria-hidden="true"></div>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="user-list-obra-poster-badge user-list-obra-poster-badge-${statusKey}"><c:out value="${statusText}" /></span>
                                </div>

                                <div class="user-list-obra-info">
                                    <h3 class="user-list-obra-title"><c:out value="${p.name}" /></h3>
                                    <div class="user-list-obra-meta">
                                        <c:if test="${not empty p.theater}">
                                            <span class="user-list-obra-theater"><c:out value="${p.theater}" /></span>
                                        </c:if>
                                        <c:if test="${not empty p.theater and not empty p.startDate}">
                                            <span class="user-list-obra-dot" aria-hidden="true"></span>
                                        </c:if>
                                        <c:if test="${not empty p.startDate}">
                                            <span class="user-list-obra-dates">
                                                <c:choose>
                                                    <c:when test="${not empty p.endDate}">
                                                        <fmt:formatDate value="${p.startDate}" pattern="dd MMM" />
                                                        <span aria-hidden="true"> — </span>
                                                        <fmt:formatDate value="${p.endDate}"   pattern="dd MMM yyyy" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        Desde <fmt:formatDate value="${p.startDate}" pattern="dd MMM yyyy" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </c:if>
                                    </div>
                                    <c:if test="${not empty p.synopsis}">
                                        <p class="user-list-obra-synopsis"><c:out value="${p.synopsis}" /></p>
                                    </c:if>
                                </div>

                                <div class="user-list-obra-meta-right">
                                    <c:choose>
                                        <c:when test="${not empty prodRating and prodRating ne 'N/A'}">
                                            <span class="user-list-rating" aria-label="Puntuación del público: ${prodRating} sobre 10">
                                                <span class="user-list-rating-star" aria-hidden="true">★</span>
                                                <span class="user-list-rating-value"><c:out value="${prodRating}" /><span class="user-list-rating-scale" aria-hidden="true"> /10</span></span>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="user-list-rating-empty" aria-label="Sin puntuaciones aún">Sin rating</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="user-list-obra-cta" aria-hidden="true">
                                        Ver detalle
                                        <span class="user-list-obra-cta-arrow">→</span>
                                    </span>
                                </div>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <div class="user-list-empty">
                    <span class="user-list-empty-icon" aria-hidden="true">♡</span>
                    <p class="user-list-empty-text">Tu watchlist está vacía.</p>
                    <p class="user-list-empty-hint">Explorá la cartelera y agregá producciones que te interesen para seguirlas desde acá.</p>
                    <a href="${carteleraUrl}" class="btn btn-primary btn-md">
                        Ver cartelera
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

</body>
</html>
