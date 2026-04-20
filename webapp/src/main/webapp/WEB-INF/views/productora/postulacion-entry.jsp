<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar productora — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/productora.css" />
</head>
<body>
    <paw:navbar />

    <c:url var="formUrl" value="/productoras/postular/nueva" />

    <main class="productora-entry">
        <section class="productora-entry-hero">
            <span class="productora-kicker">Para productoras y compañías</span>
            <h1 class="productora-title">Llevá tu productora a <em>Platea</em></h1>
            <p class="productora-lede">Una vez aprobada tu postulación, vas a poder publicar obras, cargar funciones y gestionar tu equipo desde un panel propio.</p>
            <div class="productora-cta-row">
                <a href="${formUrl}" class="btn btn-primary btn-md">Comenzar postulación</a>
            </div>
            <p class="productora-fine">Las revisiones toman entre 2 y 5 días hábiles.</p>
        </section>

        <section class="productora-steps">
            <h2 class="productora-steps-title">Qué vamos a pedirte</h2>
            <ol class="productora-steps-list">
                <li class="productora-step">
                    <span class="productora-step-num">1</span>
                    <div>
                        <h3 class="productora-step-name">Identidad</h3>
                        <p class="productora-step-desc">Nombre, CUIT, bio y redes.</p>
                    </div>
                </li>
                <li class="productora-step">
                    <span class="productora-step-num">2</span>
                    <div>
                        <h3 class="productora-step-name">Equipo</h3>
                        <p class="productora-step-desc">Quiénes forman parte y cuántos son.</p>
                    </div>
                </li>
                <li class="productora-step">
                    <span class="productora-step-num">3</span>
                    <div>
                        <h3 class="productora-step-name">Antecedentes</h3>
                        <p class="productora-step-desc">Obras previas o documentación que respalde la postulación.</p>
                    </div>
                </li>
            </ol>
        </section>

        <c:if test="${not empty history}">
            <section class="productora-history">
                <h2 class="productora-history-title">Postulaciones anteriores</h2>
                <ul class="productora-history-list">
                    <c:forEach var="r" items="${history}">
                        <c:url var="statusUrl" value="/productoras/postular/estado" />
                        <li class="productora-history-row">
                            <div>
                                <span class="productora-history-name"><c:out value="${r.name}" /></span>
                                <span class="productora-history-status productora-history-status-${fn:toLowerCase(r.status)}"><c:out value="${r.status}" /></span>
                            </div>
                            <a href="${statusUrl}" class="productora-history-link">Ver →</a>
                        </li>
                    </c:forEach>
                </ul>
            </section>
        </c:if>
    </main>
</body>
</html>
