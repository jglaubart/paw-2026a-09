<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="text" required="true" %>
<%@ attribute name="size" required="false" %>
<%@ attribute name="cssClass" required="false" %>
<%@ attribute name="disabled" required="false" type="java.lang.Boolean" %>
<%@ attribute name="ariaLabel" required="false" %>
<%@ attribute name="href" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="btnSize" value="${not empty size ? size : 'md'}" />
<c:set var="btnCssClass" value="${not empty cssClass ? cssClass : ''}" />
<c:set var="btnDisabled" value="${disabled ne null ? disabled : false}" />
<c:set var="classes" value="btn btn-${btnSize} ${btnCssClass}" />

<c:if test="${not empty href}">
    <c:url var="resolvedHref" value="${href}" />
</c:if>

<c:choose>
    <c:when test="${not empty href and not btnDisabled}">
        <a href="${resolvedHref}"
           class="${classes}"
           <c:if test="${not empty ariaLabel}">aria-label="<c:out value="${ariaLabel}" />"</c:if>>
            <c:out value="${text}" />
        </a>
    </c:when>
    <c:otherwise>
        <button type="button"
                class="${classes}"
                <c:if test="${not empty ariaLabel}">aria-label="<c:out value="${ariaLabel}" />"</c:if>
                <c:if test="${btnDisabled}">disabled</c:if>>
            <c:out value="${text}" />
        </button>
    </c:otherwise>
</c:choose>
