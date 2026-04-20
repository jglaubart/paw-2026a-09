<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="auth.forgot.pageTitle" /></title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/alert.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/auth.css" />
</head>
<body>
<c:url var="forgotActionUrl" value="/forgot-password" />
<c:url var="loginUrl" value="/login" />

<paw:navbar />

<main class="auth-page auth-page-login">
    <section class="auth-shell">
        <div class="auth-card">
            <div class="auth-card-header">
                <h1 class="auth-card-title"><spring:message code="auth.forgot.title" /></h1>
                <p class="auth-card-subtitle"><spring:message code="auth.forgot.subtitle" /></p>
            </div>

            <c:choose>
                <c:when test="${sent}">
                    <div class="auth-success-panel">
                        <p class="auth-success-title"><spring:message code="auth.forgot.sent.title" /></p>
                        <p class="auth-success-body"><spring:message code="auth.forgot.sent.body" /></p>
                        <c:if test="${not empty sentEmail}">
                            <p class="auth-success-email">
                                <span class="auth-success-email-prefix"><spring:message code="auth.forgot.sent.prefix" /></span>
                                <strong><c:out value="${sentEmail}" /></strong>
                            </p>
                        </c:if>
                    </div>
                    <div class="auth-actions-stack">
                        <a href="${forgotActionUrl}" class="btn btn-primary btn-md auth-submit auth-submit-link"><spring:message code="auth.forgot.sent.resend" /></a>
                        <a href="${loginUrl}" class="auth-inline-link"><spring:message code="auth.forgot.backToLogin" /></a>
                    </div>
                </c:when>
                <c:otherwise>
                    <form:form action="${forgotActionUrl}" method="post" modelAttribute="forgotPasswordForm" class="auth-form">
                        <div class="auth-field">
                            <label class="auth-label" for="email"><spring:message code="auth.field.email" /></label>
                            <form:input id="email" path="email" type="email" class="auth-input" maxlength="255" autocomplete="email" autofocus="autofocus" />
                            <form:errors path="email" element="span" cssClass="auth-field-error" />
                        </div>

                        <button type="submit" class="btn btn-primary btn-md auth-submit"><spring:message code="auth.forgot.submit" /></button>
                    </form:form>

                    <p class="auth-footer-copy">
                        <a href="${loginUrl}" class="auth-inline-link"><spring:message code="auth.forgot.backToLogin" /></a>
                    </p>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</main>
</body>
</html>
