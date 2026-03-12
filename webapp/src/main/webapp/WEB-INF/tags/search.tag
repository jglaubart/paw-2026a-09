<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="placeholder" required="false" %>
<%@ attribute name="value" required="false" %>
<%@ attribute name="error" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="search-wrapper">
    <input type="text"
           name="<c:out value="${name}" />"
           placeholder="<c:out value="${placeholder}" />"
           value="<c:out value="${value}" />"
           class="search-input ${not empty error ? 'search-input-error' : ''}" />
    <c:if test="${not empty error}">
        <span class="search-error-msg"><c:out value="${error}" /></span>
    </c:if>
</div>