<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="imageUrl" required="false" %>
<%@ attribute name="detailUrl" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:set var="imgSrc" value="${not empty imageUrl ? imageUrl : '/images/placeholder.jpg'}" />
<c:if test="${not empty detailUrl}">
    <c:url var="resolvedDetailUrl" value="${detailUrl}" />
</c:if>

<div class="obra-card ${not empty detailUrl ? 'obra-card-clickable' : ''}">
    <c:choose>
        <c:when test="${not empty detailUrl}">
            <a href="${resolvedDetailUrl}" class="obra-card-link">
                <div class="obra-card-img-wrapper">
                    <img src="${imgSrc}" alt="${fn:escapeXml(title)}" class="obra-card-img" />
                </div>
                <p class="obra-card-title"><c:out value="${title}" /></p>
            </a>
        </c:when>
        <c:otherwise>
            <div class="obra-card-content">
                <div class="obra-card-img-wrapper">
                    <img src="${imgSrc}" alt="${fn:escapeXml(title)}" class="obra-card-img" />
                </div>
                <p class="obra-card-title"><c:out value="${title}" /></p>
            </div>
        </c:otherwise>
    </c:choose>
    <div class="obra-card-wishlist">
        <paw:button text="♡" cssClass="btn-wishlist" />
    </div>
</div>
