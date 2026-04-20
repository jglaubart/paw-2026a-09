<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Postulación de <c:out value="${request.name}" /> — Admin</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/productora.css" />
</head>
<body>
    <paw:navbar />

    <c:url var="backUrl"      value="/admin/productoras/postulaciones" />
    <c:url var="approveUrl"   value="/admin/productoras/postulaciones/${request.id}/aprobar" />
    <c:url var="rejectUrl"    value="/admin/productoras/postulaciones/${request.id}/rechazar" />
    <c:url var="changesUrl"   value="/admin/productoras/postulaciones/${request.id}/cambios" />

    <main class="productora-admin-detail">
        <header class="productora-admin-detail-header">
            <a href="${backUrl}" class="productora-form-back">← Volver</a>
            <h1 class="productora-admin-detail-title"><c:out value="${request.name}" /></h1>
            <span class="productora-admin-detail-status productora-history-status-${fn:toLowerCase(request.status)}">
                <c:out value="${request.status}" />
            </span>
        </header>

        <section class="productora-admin-detail-body">
            <div class="productora-admin-detail-grid">
                <div>
                    <h3>Identidad</h3>
                    <dl class="productora-admin-dl">
                        <dt>Nombre</dt><dd><c:out value="${request.name}" /></dd>
                        <dt>CUIT</dt><dd><c:out value="${request.cuit}" /></dd>
                        <dt>Email de contacto</dt><dd><c:out value="${request.contactEmail}" /></dd>
                        <dt>Bio</dt><dd class="productora-admin-dl-long"><c:out value="${request.bio}" /></dd>
                        <c:if test="${not empty request.instagram}">
                            <dt>Instagram</dt><dd><c:out value="${request.instagram}" /></dd>
                        </c:if>
                        <c:if test="${not empty request.website}">
                            <dt>Sitio web</dt><dd><c:out value="${request.website}" /></dd>
                        </c:if>
                    </dl>
                </div>

                <div>
                    <h3>Equipo</h3>
                    <dl class="productora-admin-dl">
                        <dt>Cantidad</dt><dd><c:out value="${request.teamSize}" /></dd>
                        <dt>Integrantes</dt><dd class="productora-admin-dl-long"><c:out value="${request.teamDescription}" /></dd>
                    </dl>
                </div>

                <div>
                    <h3>Antecedentes</h3>
                    <p class="productora-admin-dl-long"><c:out value="${request.previousWorks}" /></p>
                </div>
            </div>
        </section>

        <c:if test="${request.status == 'PENDING' or request.status == 'CHANGES_REQUESTED'}">
            <section class="productora-admin-actions">
                <h3>Decidir</h3>

                <form action="${approveUrl}" method="post" class="productora-admin-action-form">
                    <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                    <label>
                        <span>Nota interna (opcional)</span>
                        <textarea name="adminNotes" rows="2"></textarea>
                    </label>
                    <button type="submit" class="btn btn-primary btn-md">Aprobar</button>
                </form>

                <form action="${changesUrl}" method="post" class="productora-admin-action-form">
                    <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                    <label>
                        <span>Mensaje general para el postulante</span>
                        <textarea name="adminNotes" rows="2"></textarea>
                    </label>
                    <fieldset class="productora-admin-feedback-fields">
                        <legend>Feedback por campo (opcional)</legend>
                        <label><span>Nombre</span><input type="text" name="feedback[name]" /></label>
                        <label><span>CUIT</span><input type="text" name="feedback[cuit]" /></label>
                        <label><span>Email</span><input type="text" name="feedback[contactEmail]" /></label>
                        <label><span>Bio</span><input type="text" name="feedback[bio]" /></label>
                        <label><span>Equipo</span><input type="text" name="feedback[teamDescription]" /></label>
                        <label><span>Antecedentes</span><input type="text" name="feedback[previousWorks]" /></label>
                    </fieldset>
                    <button type="submit" class="btn btn-ghost btn-md">Pedir cambios</button>
                </form>

                <form action="${rejectUrl}" method="post" class="productora-admin-action-form">
                    <input type="hidden" name="${_csrf.parameterName}" value="${fn:escapeXml(_csrf.token)}" />
                    <label>
                        <span>Motivo (se comparte con el postulante)</span>
                        <textarea name="adminNotes" rows="2"></textarea>
                    </label>
                    <button type="submit" class="btn btn-danger btn-md">Rechazar</button>
                </form>
            </section>
        </c:if>
    </main>
</body>
</html>
