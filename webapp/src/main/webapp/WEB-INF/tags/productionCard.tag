<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="title"     required="true" %>
<%@ attribute name="imageUrl"  required="false" %>
<%@ attribute name="venue"     required="false" %>
<%@ attribute name="rating"    required="false" %>
<%@ attribute name="badge"     required="false" %>
<%@ attribute name="detailUrl" required="false" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${not empty detailUrl}">
    <c:url var="resolvedDetailUrl" value="${detailUrl}" />
</c:if>
<c:choose>
    <c:when test="${not empty imageUrl}">
        <c:url var="resolvedImageUrl" value="${imageUrl}" />
    </c:when>
    <c:otherwise>
        <c:url var="resolvedImageUrl" value="/images/placeholder.jpg" />
    </c:otherwise>
</c:choose>

<article class="production-card ${not empty resolvedDetailUrl ? 'production-card-clickable' : ''}">
    <c:choose>
        <c:when test="${not empty resolvedDetailUrl}">
            <a href="${resolvedDetailUrl}" class="production-card-link">
                <div class="production-card-media">
                    <c:choose>
                        <c:when test="${not empty imageUrl}">
                            <img class="production-card-image"
                                 src="${resolvedImageUrl}"
                                 alt="${fn:escapeXml(title)}" />
                        </c:when>
                        <c:otherwise>
                            <div class="production-card-placeholder" aria-hidden="true"></div>
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${not empty rating}">
                        <span class="production-card-rating-pill">
                            <span class="production-card-rating-pill-star" aria-hidden="true">★</span>
                            <c:out value="${rating}" />
                        </span>
                    </c:if>
                    <c:if test="${not empty badge}">
                        <span class="production-card-badge"><c:out value="${badge}" /></span>
                    </c:if>
                </div>
            </a>
        </c:when>
        <c:otherwise>
            <div class="production-card-media">
                <c:choose>
                    <c:when test="${not empty imageUrl}">
                        <img class="production-card-image"
                             src="${resolvedImageUrl}"
                             alt="${fn:escapeXml(title)}" />
                    </c:when>
                    <c:otherwise>
                        <div class="production-card-placeholder" aria-hidden="true"></div>
                    </c:otherwise>
                </c:choose>
                <c:if test="${not empty rating}">
                    <span class="production-card-rating-pill">
                        <span class="production-card-rating-pill-star" aria-hidden="true">★</span>
                        <c:out value="${rating}" />
                    </span>
                </c:if>
                <c:if test="${not empty badge}">
                    <span class="production-card-badge"><c:out value="${badge}" /></span>
                </c:if>
            </div>
        </c:otherwise>
    </c:choose>

    <div class="production-card-info">
        <h3 class="production-card-title"><c:out value="${title}" /></h3>
        <c:if test="${not empty venue}">
            <div class="production-card-meta">
                <c:if test="${not empty venue}">
                    <span class="production-card-venue"><c:out value="${venue}" /></span>
                </c:if>
            </div>
        </c:if>
    </div>
</article>
