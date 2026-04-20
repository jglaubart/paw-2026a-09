<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
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
<c:url var="forgotUrl" value="/forgot-password" />
<c:url var="loginUrl" value="/login" />

<paw:navbar />

<main class="auth-page auth-page-login">
    <section class="auth-shell">
        <div class="auth-card">
            <div class="auth-card-header">
                <h1 class="auth-card-title"><spring:message code="auth.reset.invalid.title" /></h1>
                <p class="auth-card-subtitle"><spring:message code="auth.reset.invalid.body" /></p>
            </div>

            <div class="auth-actions-stack">
                <a href="${forgotUrl}" class="btn btn-primary btn-md"><spring:message code="auth.reset.invalid.request" /></a>
                <a href="${loginUrl}" class="auth-inline-link"><spring:message code="auth.forgot.backToLogin" /></a>
            </div>
        </div>
    </section>
</main>
</body>
</html>
