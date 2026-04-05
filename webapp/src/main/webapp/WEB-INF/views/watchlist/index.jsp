<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de producciones vistas — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/user-lists.css" />
</head>
<body>

    <paw:navbar />

    <c:url var="carteleraUrl" value="/cartelera" />

    <main class="user-list-page">

        <header class="user-list-header">
            <h1 class="user-list-title">Ya las vi</h1>
            <p class="user-list-subtitle">Obras que marcaste como vistas</p>
        </header>

        <c:choose>
            <c:when test="${not empty seenObras}">
                <div class="user-list-grid">
                    <c:forEach var="o" items="${seenObras}">
                        <c:url var="obraUrl" value="/obras/${o.id}" />
                        <a href="${obraUrl}" class="user-list-obra-card">
                            <div class="user-list-obra-info">
                                <span class="user-list-obra-title"><c:out value="${o.title}" /></span>
                                <c:if test="${not empty o.genre}">
                                    <span class="user-list-obra-genre"><c:out value="${o.genre}" /></span>
                                </c:if>
                            </div>
                            <span class="user-list-obra-seen-badge" aria-hidden="true">✓ Vista</span>
                        </a>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="user-list-empty">
                    <span class="user-list-empty-icon" aria-hidden="true">✓</span>
                    <p class="user-list-empty-text">Todavía no marcaste ninguna obra como vista.</p>
                    <p class="user-list-empty-hint">Cuando veas una obra, marcala desde su página.</p>
                    <a href="${carteleraUrl}" class="btn btn-primary btn-md">
                        Ver cartelera
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

</body>
</html>
--%>
