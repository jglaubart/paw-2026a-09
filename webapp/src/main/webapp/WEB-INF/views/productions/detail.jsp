<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${production.name}" /> — Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/hero.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/play-detail.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/production-detail-page.css" />
</head>
<body>

    <paw:navbar />

    <c:set var="imgUrl" value="${not empty production.imageUrl ? production.imageUrl : pageContext.request.contextPath.concat('/images/Portadas/hamlet.jpg')}" />
    <c:if test="${obra != null}">
        <c:url var="obraUrl" value="/obras/${obra.id}" />
    </c:if>
    <c:if test="${productora != null}">
        <c:url var="productoraUrl" value="/productoras/${productora.id}" />
    </c:if>
    <%-- <c:url var="watchlistActionUrl" value="/productions/${production.id}/watchlist" /> --%>
    <c:url var="rateActionUrl" value="/productions/${production.id}/rate" />
    <c:if test="${production.website != null}">
        <c:url var="productionWebsiteUrl" value="${production.website}" />
    </c:if>
    <c:if test="${production.instagram != null}">
        <c:url var="productionInstagramUrl" value="${production.instagram}" />
    </c:if>

    <paw:hero
        title="${fn:escapeXml(production.name)}"
        description="${fn:escapeXml(production.synopsis)}"
        imageUrl="${imgUrl}"
        badge="PRODUCCIÓN"
    />

    <main class="production-detail-page">
        <section class="play-detail">
            <div class="play-detail-body">
                <div class="play-detail-info">
                    <h1 class="play-detail-title"><c:out value="${production.name}" /></h1>

                    <c:if test="${obra != null}">
                        <p class="play-detail-meta">
                            Obra: <a href="${obraUrl}" class="production-detail-link"><c:out value="${obra.title}" /></a>
                        </p>
                    </c:if>

                    <c:if test="${productora != null}">
                        <p class="play-detail-meta">
                            Productora: <a href="${productoraUrl}" class="production-detail-link"><c:out value="${productora.name}" /></a>
                        </p>
                    </c:if>

                    <c:if test="${production.theater != null}">
                        <p class="play-detail-meta">Teatro: <c:out value="${production.theater}" /></p>
                    </c:if>

                    <c:if test="${production.direction != null}">
                        <p class="play-detail-meta">Dirección: <c:out value="${production.direction}" /></p>
                    </c:if>

                    <c:if test="${production.genre != null}">
                        <p class="play-detail-meta">Género: <c:out value="${production.genre}" /></p>
                    </c:if>

                    <c:if test="${production.startDate != null}">
                        <p class="play-detail-meta">
                            Desde: <c:out value="${production.startDate}" />
                            <c:if test="${production.endDate != null}">
                                — Hasta: <c:out value="${production.endDate}" />
                            </c:if>
                        </p>
                    </c:if>

                    <c:if test="${production.synopsis != null}">
                        <div class="play-detail-summary">
                            <h3>Sinopsis</h3>
                            <p><c:out value="${production.synopsis}" /></p>
                        </div>
                    </c:if>

                    <%-- Rating promedio --%>
                    <c:if test="${avgRating != null}">
                        <div class="play-detail-rating production-detail-rating">
                            <span class="production-detail-rating-star">★</span>
                            <span class="production-detail-rating-value"><c:out value="${String.format('%.1f', avgRating)}" />/10</span>
                        </div>
                    </c:if>

                    <div class="production-detail-links">
                        <c:if test="${production.website != null}">
                            <a href="${productionWebsiteUrl}" target="_blank" rel="noopener noreferrer" class="btn btn-primary btn-md">Comprar Entradas</a>
                        </c:if>
                        <c:if test="${production.instagram != null}">
                            <a href="${productionInstagramUrl}" target="_blank" rel="noopener noreferrer" class="production-detail-external-link">Instagram</a>
                        </c:if>
                    </div>
                </div>

                <div class="play-detail-sidebar production-detail-sidebar">
                    <%--
                    <div class="production-detail-panel">
                        <h3 class="production-detail-panel-title">Watchlist</h3>
                        <form action="${watchlistActionUrl}" method="post">
                            <c:choose>
                                <c:when test="${inWatchlist}">
                                    <input type="hidden" name="action" value="remove" />
                                    <button type="submit" class="btn btn-danger btn-md production-detail-watchlist-btn">Quitar de Watchlist</button>
                                </c:when>
                                <c:otherwise>
                                    <input type="hidden" name="action" value="add" />
                                    <button type="submit" class="btn btn-primary btn-md production-detail-watchlist-btn">Agregar a Watchlist</button>
                                </c:otherwise>
                            </c:choose>
                        </form>
                    </div>
                    --%>

                    <div class="production-detail-panel">
                        <h3 class="production-detail-panel-title">Calificar Producción</h3>
                        <c:if test="${userScore != null}">
                            <p class="production-detail-score">Tu puntaje: <c:out value="${userScore}" />/10</p>
                        </c:if>
                        <form action="${rateActionUrl}" method="post" class="production-detail-rate-form">
                            <select name="score" class="production-detail-score-select">
                                <c:forEach var="i" begin="1" end="10">
                                    <option value="${i}" ${userScore != null && userScore == i ? 'selected' : ''}><c:out value="${i}" /></option>
                                </c:forEach>
                            </select>
                            <button type="submit" class="btn btn-primary btn-md production-detail-rate-btn">Calificar</button>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </main>

</body>
</html>
