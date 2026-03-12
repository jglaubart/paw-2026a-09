<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="placeholder" required="false" %>
<%@ attribute name="value" required="false" %>
<%@ attribute name="error" required="false" %>
<%@ attribute name="type" required="false" %>
<%@ attribute name="required" required="false" type="java.lang.Boolean" %>
<%@ attribute name="minlength" required="false" %>
<%@ attribute name="maxlength" required="false" %>
<%@ attribute name="pattern" required="false" %>
<%@ attribute name="title" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="search-wrapper">
    <input type="<c:out value="${not empty type ? type : 'text'}" />"
           name="<c:out value="${name}" />"
           placeholder="<c:out value="${placeholder}" />"
           value="<c:out value="${value}" />"
           class="search-input ${not empty error ? 'search-input-error' : ''}"
           <c:if test="${required}">required</c:if>
           <c:if test="${not empty minlength}">minlength="<c:out value="${minlength}" />"</c:if>
           <c:if test="${not empty maxlength}">maxlength="<c:out value="${maxlength}" />"</c:if>
           <c:if test="${not empty pattern}">pattern="<c:out value="${pattern}" />"</c:if>
           <c:if test="${not empty title}">title="<c:out value="${title}" />"</c:if> />
    <c:if test="${not empty error}">
        <span class="search-error-msg"><c:out value="${error}" /></span>
    </c:if>
</div>
