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
</head>
<body>
<c:url var="loginActionUrl" value="/login" />
<c:url var="registerUrl" value="/register" />
<spring:message code="auth.login.registered" var="registeredMessage" />
<spring:message code="auth.login.error" var="errorMessage" />
<spring:message code="auth.login.loggedOut" var="loggedOutMessage" />
<spring:message code="auth.login.unverified" var="unverifiedMessage" />

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

            <form action="${loginActionUrl}" method="post" class="auth-form">
                <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />

                <div class="auth-field">
                    <label class="auth-label" for="email"><spring:message code="auth.field.emailOrUsername" /></label>
                    <input id="email" name="email" type="text" class="auth-input" maxlength="255" required autocomplete="username" autofocus />
                </div>

                <div class="auth-field">
                    <label class="auth-label" for="password"><spring:message code="auth.field.password" /></label>
                    <input id="password" name="password" type="password" class="auth-input" minlength="8" maxlength="72" required autocomplete="current-password" />
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
