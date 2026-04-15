<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="title"       required="false" %>
<%@ attribute name="description" required="false" %>
<%@ attribute name="imageUrl"    required="false" %>
<%@ attribute name="badge"       required="false" %>
<%@ attribute name="rating"      required="false" %>
<%@ attribute name="ticketUrl"   required="false" %>
<%@ attribute name="slides"      required="false" type="java.util.List" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:set var="heroBadge" value="${not empty badge ? badge : 'DESTACADO'}" />
<c:set var="hasSlides" value="${not empty slides and fn:length(slides) > 0}" />
<c:url var="heroSliderScriptUrl" value="/js/components/hero-slider.js" />
<c:if test="${not empty imageUrl}">
    <c:url var="resolvedImageUrl" value="${imageUrl}" />
</c:if>
<c:if test="${not empty ticketUrl}">
    <c:url var="resolvedTicketUrl" value="${ticketUrl}" />
</c:if>

<c:choose>
    <c:when test="${hasSlides}">
        <section class="hero hero-slider" data-hero-slider data-hero-slider-interval="6500">
            <div class="hero-slides">
                <c:forEach var="slide" items="${slides}" varStatus="status">
                    <c:set var="slideImageUrl" value="${not empty slide.imageUrl ? slide.imageUrl : pageContext.request.contextPath.concat('/images/Portadas/hamlet.jpg')}" />
                    <c:set var="slideSynopsis" value="${slide.synopsis}" />
                    <c:set var="slideSynopsisTruncated" value="${false}" />
                    <c:if test="${not empty slideSynopsis and fn:length(slideSynopsis) > 225}">
                        <c:set var="slideSynopsisTruncated" value="${true}" />
                        <c:set var="slideSynopsis" value="${fn:substring(slideSynopsis, 0, 222).concat('...')}" />
                    </c:if>
                    <c:url var="slideResolvedImageUrl" value="${slideImageUrl}" />
                    <c:url var="slideDetailUrl" value="/obras/${slide.obraId}">
                        <c:param name="produccionId" value="${slide.id}" />
                    </c:url>

                    <article class="hero-slide ${status.first ? 'hero-slide-active' : ''}" data-hero-slide aria-hidden="${status.first ? 'false' : 'true'}">
                        <img class="hero-bg-image"
                             src="${slideResolvedImageUrl}"
                             alt=""
                             aria-hidden="true" />
                        <div class="hero-gradient" aria-hidden="true"></div>

                        <div class="hero-body">
                            <div class="hero-content">
                                <div class="hero-badges">
                                    <span class="hero-badge hero-badge-featured">
                                        <c:out value="${heroBadge}" />
                                    </span>
                                    <c:if test="${not empty slide.theater}">
                                        <span class="hero-badge hero-badge-venue">
                                            <c:out value="${slide.theater}" />
                                        </span>
                                    </c:if>
                                </div>

                                <h1 class="hero-title"><c:out value="${slide.name}" /></h1>

                                <c:if test="${not empty slideSynopsis}">
                                    <p class="hero-description">
                                        <c:out value="${slideSynopsis}" />
                                        <c:if test="${slideSynopsisTruncated}">
                                            <a href="${slideDetailUrl}" class="hero-description-more">Ver mas</a>
                                        </c:if>
                                    </p>
                                </c:if>

                                <div class="hero-actions">
                                    <paw:button text="Ver Obra"
                                                href="${slideDetailUrl}"
                                                variant="cta"
                                                cssClass="hero-primary-action" />
                                </div>
                            </div>
                        </div>
                    </article>
                </c:forEach>
            </div>

            <div class="hero-slider-nav" aria-label="Selección destacada">
                <c:forEach var="slide" items="${slides}" varStatus="status">
                    <button type="button"
                            class="hero-slider-dot ${status.first ? 'hero-slider-dot-active' : ''}"
                            data-hero-slider-dot
                            data-hero-slide-index="${status.index}"
                            aria-label="Ir al slide ${status.index + 1}"></button>
                </c:forEach>
            </div>
        </section>
        <script src="${heroSliderScriptUrl}" defer></script>
    </c:when>
    <c:otherwise>
        <section class="hero">
            <c:if test="${not empty imageUrl}">
                <img class="hero-bg-image"
                     src="${resolvedImageUrl}"
                     alt=""
                     aria-hidden="true" />
            </c:if>
            <div class="hero-gradient" aria-hidden="true"></div>

            <div class="hero-body">
                <div class="hero-content">
                    <div class="hero-badges">
                        <span class="hero-badge hero-badge-featured">
                            <c:out value="${heroBadge}" />
                        </span>
                        <c:if test="${not empty rating}">
                            <span class="hero-badge hero-badge-rating">
                                <span class="hero-badge-star" aria-hidden="true">★</span>
                                <c:out value="${rating}" />
                            </span>
                        </c:if>
                    </div>

                    <h1 class="hero-title"><c:out value="${title}" /></h1>

                    <c:if test="${not empty description}">
                        <p class="hero-description"><c:out value="${description}" /></p>
                    </c:if>

                    <c:if test="${not empty resolvedTicketUrl}">
                        <div class="hero-actions">
                            <paw:button text="Ver Obra"
                                        href="${resolvedTicketUrl}"
                                        variant="cta"
                                        cssClass="hero-primary-action" />
                        </div>
                    </c:if>
                </div>
            </div>
        </section>
    </c:otherwise>
</c:choose>
