<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="message" required="true" %>
<%@ attribute name="title" required="false" %>
<%@ attribute name="variant" required="false" %>
<%@ attribute name="showClose" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:set var="alertVariant" value="${not empty variant ? variant : 'info'}" />
<c:set var="dismissButtonVisible" value="${showClose ne null ? showClose : true}" />

<div class="alert alert-${alertVariant}" role="alert">
    <div class="alert-content">
        <c:if test="${not empty title}">
            <p class="alert-title"><c:out value="${title}" /></p>
        </c:if>
        <p class="alert-message"><c:out value="${message}" /></p>
    </div>
    <c:if test="${dismissButtonVisible}">
        <paw:button text="×" size="sm" cssClass="alert-close" ariaLabel="Cerrar alerta" />
    </c:if>
</div>
