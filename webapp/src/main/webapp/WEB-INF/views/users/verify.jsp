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
    <title><spring:message code="auth.verify.pageTitle" /></title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/alert.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/auth.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/auth-verify.css" />
</head>
<body>
<c:url var="verifyActionUrl" value="/register/verify" />
<c:url var="resendActionUrl" value="/register/verify/resend" />
<c:url var="registerUrl" value="/register" />

<paw:navbar />

<main class="auth-page auth-page-verify">
    <section class="auth-shell">
        <div class="auth-card">
            <div class="auth-card-header">
                <h1 class="auth-card-title"><spring:message code="auth.verify.title" /></h1>
                <p class="auth-verify-subtitle">
                    <c:choose>
                        <c:when test="${not empty pendingEmail}">
                            <spring:message code="auth.verify.subtitle" arguments="${fn:escapeXml(pendingEmail)}" htmlEscape="false" />
                        </c:when>
                        <c:otherwise>
                            <spring:message code="auth.verify.subtitle" arguments="" htmlEscape="false" />
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>

            <c:if test="${verifyError eq 'invalid'}">
                <spring:message code="auth.verify.error.invalid" var="verifyErrorInvalid" />
                <div class="auth-alert"><paw:alert variant="error" message="${verifyErrorInvalid}" showClose="false" /></div>
            </c:if>
            <c:if test="${verifyError eq 'expired'}">
                <spring:message code="auth.verify.error.expired" var="verifyErrorExpired" />
                <div class="auth-alert"><paw:alert variant="warning" message="${verifyErrorExpired}" showClose="false" /></div>
            </c:if>
            <c:if test="${verifyNotice eq 'resent'}">
                <spring:message code="auth.verify.success.resent" var="verifyNoticeResent" />
                <div class="auth-alert"><paw:alert variant="success" message="${verifyNoticeResent}" showClose="false" /></div>
            </c:if>

            <form:form action="${verifyActionUrl}" method="post" modelAttribute="verifyEmailForm" class="auth-form auth-verify-form">
                <div class="auth-field auth-verify-field">
                    <label class="auth-label" for="code"><spring:message code="auth.verify.codeLabel" /></label>
                    <div class="auth-verify-code-wrapper">
                        <form:input id="code" path="code" type="text" inputmode="numeric" autocomplete="one-time-code"
                                    maxlength="4" minlength="4" pattern="\d{4}" required="required" autofocus="autofocus"
                                    cssClass="auth-input auth-verify-code-input" />
                        <div class="auth-verify-code-boxes" aria-hidden="true">
                            <span class="auth-verify-code-box"></span>
                            <span class="auth-verify-code-box"></span>
                            <span class="auth-verify-code-box"></span>
                            <span class="auth-verify-code-box"></span>
                        </div>
                    </div>
                    <form:errors path="code" element="span" cssClass="auth-field-error" />
                </div>

                <button type="submit" class="btn btn-primary btn-md auth-submit"><spring:message code="auth.verify.submit" /></button>
            </form:form>

            <form action="${resendActionUrl}" method="post" class="auth-verify-resend-form">
                <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                <button type="submit" class="auth-verify-resend-btn"><spring:message code="auth.verify.resend" /></button>
            </form>

            <p class="auth-footer-copy">
                <a href="${registerUrl}" class="auth-inline-link"><spring:message code="auth.verify.changeEmail" /></a>
            </p>
        </div>
    </section>
</main>

<script>
    (function () {
        const input = document.getElementById('code');
        const boxes = document.querySelectorAll('.auth-verify-code-box');
        if (!input || !boxes.length) return;

        const render = () => {
            const value = input.value.replace(/\D/g, '').slice(0, 4);
            if (value !== input.value) input.value = value;
            boxes.forEach((box, idx) => {
                box.textContent = value[idx] || '';
                box.classList.toggle('is-filled', !!value[idx]);
                box.classList.toggle('is-focus', idx === value.length && document.activeElement === input);
            });
        };

        input.addEventListener('input', render);
        input.addEventListener('focus', render);
        input.addEventListener('blur', render);
        render();
    })();
</script>
</body>
</html>
