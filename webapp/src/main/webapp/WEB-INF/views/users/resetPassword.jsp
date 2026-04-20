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
    <title><spring:message code="auth.reset.pageTitle" /></title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/alert.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/auth.css" />
</head>
<body>
<c:url var="resetActionUrl" value="/reset-password" />
<c:url var="loginUrl" value="/login" />
<c:url var="forgotUrl" value="/forgot-password" />
<spring:message code="auth.reset.expired" var="expiredMessage" />

<paw:navbar />

<main class="auth-page auth-page-register">
    <section class="auth-shell">
        <div class="auth-card">
            <div class="auth-card-header">
                <h1 class="auth-card-title"><spring:message code="auth.reset.title" /></h1>
                <p class="auth-card-subtitle"><spring:message code="auth.reset.subtitle" /></p>
            </div>

            <c:if test="${resetError eq 'expired'}">
                <div class="auth-alert">
                    <paw:alert variant="warning" message="${expiredMessage}" showClose="false" />
                </div>
                <div class="auth-actions-stack">
                    <a href="${forgotUrl}" class="btn btn-primary btn-md"><spring:message code="auth.reset.invalid.request" /></a>
                </div>
            </c:if>

            <c:if test="${resetError ne 'expired'}">
                <form:form action="${resetActionUrl}" method="post" modelAttribute="resetPasswordForm" class="auth-form">
                    <form:hidden path="token" />

                    <div class="auth-field">
                        <label class="auth-label" for="password"><spring:message code="auth.reset.password" /></label>
                        <form:password id="password" path="password" class="auth-input" minlength="8" maxlength="72" autocomplete="new-password" autofocus="autofocus" />
                        <form:errors path="password" element="span" cssClass="auth-field-error" />
                    </div>

                    <div class="auth-field">
                        <label class="auth-label" for="repeatPassword"><spring:message code="auth.reset.repeatPassword" /></label>
                        <form:password id="repeatPassword" path="repeatPassword" class="auth-input" minlength="8" maxlength="72" autocomplete="new-password" />
                        <form:errors path="repeatPassword" element="span" cssClass="auth-field-error" />
                    </div>

                    <button type="submit" class="btn btn-primary btn-md auth-submit"><spring:message code="auth.reset.submit" /></button>
                </form:form>

                <p class="auth-footer-copy">
                    <a href="${loginUrl}" class="auth-inline-link"><spring:message code="auth.forgot.backToLogin" /></a>
                </p>
            </c:if>
        </div>
    </section>
</main>
</body>
</html>
