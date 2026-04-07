<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear cuenta — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/auth-form.css" />
</head>
<body>

<paw:navbar />

<main class="auth-page">
    <div class="auth-card">
        <h1 class="auth-title">Crear cuenta</h1>

        <c:if test="${emailTaken}">
            <p class="auth-error">Ya existe una cuenta con ese email.</p>
        </c:if>

        <c:url var="registerUrl" value="/register" />
        <form action="${registerUrl}" method="post" class="auth-form">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

            <div class="auth-field">
                <label class="auth-label" for="email">Email</label>
                <input id="email" name="email" type="email" class="auth-input"
                       placeholder="tu-mail@ejemplo.com" required autofocus />
            </div>

            <div class="auth-field">
                <label class="auth-label" for="password">Contraseña</label>
                <input id="password" name="password" type="password" class="auth-input"
                       placeholder="••••••••" required minlength="6" />
            </div>

            <button type="submit" class="btn btn-primary btn-lg auth-submit">Crear cuenta</button>
        </form>

        <p class="auth-switch">
            ¿Ya tenés cuenta?
            <c:url var="loginUrl" value="/login" />
            <a href="${loginUrl}" class="auth-link">Iniciá sesión</a>
        </p>
    </div>
</main>

</body>
</html>
