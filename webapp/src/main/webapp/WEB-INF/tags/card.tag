<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="imageUrl" required="false" %>
<%@ attribute name="detailUrl" required="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:set var="imgSrc" value="${not empty imageUrl ? imageUrl : '/images/placeholder.jpg'}" />

<div class="obra-card">
    <a href="<c:out value="${detailUrl}" />" class="obra-card-link">
        <div class="obra-card-img-wrapper">
            <img src="${imgSrc}" alt="<c:out value="${title}" />" class="obra-card-img" />
            <div class="obra-card-wishlist">
                <paw:button text="♡" cssClass="btn-wishlist" />
            </div>
        </div>
        <p class="obra-card-title"><c:out value="${title}" /></p>
    </a>
</div>