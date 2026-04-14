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
    <title><spring:message code="auth.register.pageTitle" /></title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/auth.css" />
</head>
<body>
<c:url var="registerActionUrl" value="/register" />
<c:url var="loginUrl" value="/login" />

<paw:navbar />

<main class="auth-page">
    <section class="auth-shell">
        <aside class="auth-panel auth-panel-copy">
            <p class="auth-kicker"><spring:message code="auth.register.kicker" /></p>
            <h1 class="auth-title"><spring:message code="auth.register.title" /></h1>
            <p class="auth-copy"><spring:message code="auth.register.copy" /></p>
        </aside>

        <section class="auth-panel auth-panel-form">
            <div class="auth-card">
                <form:form action="${registerActionUrl}" method="post" modelAttribute="registerForm" class="auth-form">
                    <label class="auth-label" for="username"><spring:message code="auth.field.username" /></label>
                    <form:input id="username" path="username" type="text" class="auth-input" maxlength="30" />
                    <form:errors path="username" element="span" cssClass="auth-field-error" />

                    <label class="auth-label" for="email"><spring:message code="auth.field.email" /></label>
                    <form:input id="email" path="email" type="email" class="auth-input" maxlength="255" />
                    <form:errors path="email" element="span" cssClass="auth-field-error" />

                    <label class="auth-label" for="password"><spring:message code="auth.field.password" /></label>
                    <form:password id="password" path="password" class="auth-input" minlength="8" maxlength="72" />
                    <form:errors path="password" element="span" cssClass="auth-field-error" />

                    <label class="auth-label" for="repeatPassword"><spring:message code="auth.field.repeatPassword" /></label>
                    <form:password id="repeatPassword" path="repeatPassword" class="auth-input" minlength="8" maxlength="72" />
                    <form:errors path="repeatPassword" element="span" cssClass="auth-field-error" />

                    <button type="submit" class="btn btn-primary btn-md auth-submit"><spring:message code="auth.register.submit" /></button>
                </form:form>

                <p class="auth-footer-copy">
                    <spring:message code="auth.register.hasAccount" />
                    <a href="${loginUrl}" class="auth-inline-link"><spring:message code="auth.register.loginLink" /></a>
                </p>
            </div>
        </section>
    </section>
</main>
</body>
</html>
