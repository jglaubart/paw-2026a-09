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

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/hero.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/play-detail.css" />
</head>
<body>

    <paw:navbar />

    <c:set var="imgUrl" value="${production.imageId != null ? pageContext.request.contextPath.concat('/images/').concat(production.imageId) : pageContext.request.contextPath.concat('/images/Portadas/hamlet.jpg')}" />

    <paw:hero
        title="${fn:escapeXml(production.name)}"
        description="${fn:escapeXml(production.synopsis)}"
        imageUrl="${imgUrl}"
        badge="PRODUCCIÓN"
    />

    <main>
        <section class="play-detail">
            <div class="play-detail-body">
                <div class="play-detail-info">
                    <h1 class="play-detail-title"><c:out value="${production.name}" /></h1>

                    <c:if test="${obra != null}">
                        <p class="play-detail-meta">
                            Obra: <a href="${pageContext.request.contextPath}/obras/${obra.id}" style="color: #7c3aed;"><c:out value="${obra.title}" /></a>
                        </p>
                    </c:if>

                    <c:if test="${productora != null}">
                        <p class="play-detail-meta">
                            Productora: <a href="${pageContext.request.contextPath}/productoras/${productora.id}" style="color: #7c3aed;"><c:out value="${productora.name}" /></a>
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
                        <div class="play-detail-rating">
                            <span style="color: #f5a623; font-size: 1.5rem;">★</span>
                            <span style="font-size: 1.3rem; font-weight: bold;"><c:out value="${String.format('%.1f', avgRating)}" />/10</span>
                        </div>
                    </c:if>

                    <%-- Links externos --%>
                    <div style="display: flex; gap: 1rem; margin-top: 1rem;">
                        <c:if test="${production.website != null}">
                            <a href="${fn:escapeXml(production.website)}" target="_blank" class="btn btn-md" style="background: #7c3aed; color: white; text-decoration: none; padding: 0.5rem 1rem; border-radius: 4px;">Comprar Entradas</a>
                        </c:if>
                        <c:if test="${production.instagram != null}">
                            <a href="${fn:escapeXml(production.instagram)}" target="_blank" style="color: #7c3aed;">Instagram</a>
                        </c:if>
                    </div>
                </div>

                <%-- Sidebar: Watchlist + Rating --%>
                <div class="play-detail-sidebar" style="display: flex; flex-direction: column; gap: 1.5rem;">

                    <%-- Watchlist --%>
                    <div style="background: rgba(255,255,255,0.06); border-radius: 8px; padding: 1.5rem;">
                        <h3 style="margin-bottom: 0.5rem;">Watchlist</h3>
                        <form action="${pageContext.request.contextPath}/productions/${production.id}/watchlist" method="post">
                            <c:choose>
                                <c:when test="${inWatchlist}">
                                    <input type="hidden" name="action" value="remove" />
                                    <button type="submit" class="btn btn-md" style="background: #e50914; color: white; border: none; cursor: pointer; width: 100%; padding: 0.5rem;">Quitar de Watchlist</button>
                                </c:when>
                                <c:otherwise>
                                    <input type="hidden" name="action" value="add" />
                                    <button type="submit" class="btn btn-md" style="background: #7c3aed; color: white; border: none; cursor: pointer; width: 100%; padding: 0.5rem;">Agregar a Watchlist</button>
                                </c:otherwise>
                            </c:choose>
                        </form>
                    </div>

                    <%-- Calificar producción --%>
                    <div style="background: rgba(255,255,255,0.06); border-radius: 8px; padding: 1.5rem;">
                        <h3 style="margin-bottom: 0.5rem;">Calificar Producción</h3>
                        <c:if test="${userScore != null}">
                            <p style="color: #f5a623;">Tu puntaje: <c:out value="${userScore}" />/10</p>
                        </c:if>
                        <form action="${pageContext.request.contextPath}/productions/${production.id}/rate" method="post" style="display: flex; gap: 0.5rem; align-items: center;">
                            <select name="score" style="background: rgba(255,255,255,0.1); color: white; border: 1px solid rgba(255,255,255,0.2); border-radius: 4px; padding: 0.4rem;">
                                <c:forEach var="i" begin="1" end="10">
                                    <option value="${i}" ${userScore != null && userScore == i ? 'selected' : ''}><c:out value="${i}" /></option>
                                </c:forEach>
                            </select>
                            <button type="submit" class="btn btn-md" style="background: #7c3aed; color: white; border: none; cursor: pointer; padding: 0.4rem 1rem;">Calificar</button>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </main>

</body>
</html>
