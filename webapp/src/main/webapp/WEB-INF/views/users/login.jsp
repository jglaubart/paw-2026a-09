<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="auth.login.pageTitle" /></title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/alert.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/auth.css" />
    <script src="${pageContext.request.contextPath}/js/components/auth-password-toggle.js" defer></script>
</head>
<body>
<c:url var="loginActionUrl" value="/login" />
<c:url var="registerUrl" value="/register" />
<c:url var="forgotUrl" value="/forgot-password" />
<spring:message code="auth.login.registered" var="registeredMessage" />
<spring:message code="auth.login.error" var="errorMessage" />
<spring:message code="auth.login.loggedOut" var="loggedOutMessage" />
<spring:message code="auth.login.unverified" var="unverifiedMessage" />
<spring:message code="auth.login.passwordReset" var="passwordResetMessage" />
<spring:message code="auth.password.toggle.show" var="showPasswordAriaLabel" />
<spring:message code="auth.password.toggle.hide" var="hidePasswordAriaLabel" />

<paw:navbar />

<main class="auth-page auth-page-login">
    <section class="auth-shell">
        <div class="auth-card">
            <div class="auth-card-header">
                <h1 class="auth-card-title"><spring:message code="auth.login.title" /></h1>
            </div>

            <c:if test="${registered}">
                <div class="auth-alert"><paw:alert variant="success" message="${registeredMessage}" showClose="false" /></div>
            </c:if>
            <c:if test="${hasError}">
                <div class="auth-alert"><paw:alert variant="error" message="${errorMessage}" showClose="false" /></div>
            </c:if>
            <c:if test="${loggedOut}">
                <div class="auth-alert"><paw:alert variant="info" message="${loggedOutMessage}" showClose="false" /></div>
            </c:if>
            <c:if test="${unverified}">
                <div class="auth-alert"><paw:alert variant="warning" message="${unverifiedMessage}" showClose="false" /></div>
            </c:if>
            <c:if test="${passwordReset}">
                <div class="auth-alert"><paw:alert variant="success" message="${passwordResetMessage}" showClose="false" /></div>
            </c:if>

            <form action="${loginActionUrl}" method="post" class="auth-form">
                <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />

                <div class="auth-field">
                    <label class="auth-label" for="email"><spring:message code="auth.field.emailOrUsername" /></label>
                    <input id="email" name="email" type="text" class="auth-input" maxlength="255" required autocomplete="username" autofocus />
                </div>

                <div class="auth-field">
                    <label class="auth-label" for="password"><spring:message code="auth.field.password" /></label>
                    <div class="auth-password-control">
                        <input id="password" name="password" type="password" class="auth-input" minlength="8" maxlength="72" required autocomplete="current-password" data-password-input="true" />
                        <button type="button" class="auth-password-toggle" data-password-toggle="true" aria-controls="password" aria-label="${fn:escapeXml(showPasswordAriaLabel)}" data-aria-show="${fn:escapeXml(showPasswordAriaLabel)}" data-aria-hide="${fn:escapeXml(hidePasswordAriaLabel)}">
                            <span class="auth-password-toggle-icon auth-password-toggle-icon-show" aria-hidden="true">
                                <svg viewBox="0 0 24 24" focusable="false">
                                    <path d="M2.25 12s3.75-6.75 9.75-6.75S21.75 12 21.75 12s-3.75 6.75-9.75 6.75S2.25 12 2.25 12Z" />
                                    <circle cx="12" cy="12" r="3.25" />
                                </svg>
                            </span>
                            <span class="auth-password-toggle-icon auth-password-toggle-icon-hide" aria-hidden="true">
                                <svg viewBox="0 0 24 24" focusable="false">
                                    <path d="M2.25 12s3.75-6.75 9.75-6.75S21.75 12 21.75 12s-3.75 6.75-9.75 6.75S2.25 12 2.25 12Z" />
                                    <path d="M4.5 4.5 19.5 19.5" />
                                </svg>
                            </span>
                        </button>
                    </div>
                </div>

                <div class="auth-form-options">
                    <a href="${forgotUrl}" class="auth-forgot-link"><spring:message code="auth.login.forgotPassword" /></a>
                </div>

                <button type="submit" class="btn btn-primary btn-md auth-submit"><spring:message code="auth.login.submit" /></button>
            </form>

            <p class="auth-footer-copy">
                <spring:message code="auth.login.noAccount" />
                <a href="${registerUrl}" class="auth-inline-link"><spring:message code="auth.login.registerLink" /></a>
            </p>
        </div>
    </section>
</main>
</body>
</html>
