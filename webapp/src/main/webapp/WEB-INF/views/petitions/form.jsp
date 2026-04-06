<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Subir obra a Platea</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/alert.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/play-petition-form.css" />
    <script src="${pageContext.request.contextPath}/js/components/play-petition-form.js" defer></script>
</head>
<body>
<c:url var="heroImageUrl" value="/images/Portadas/hamilton.jpg" />
<c:set var="maxUploadMb" value="5" />

<paw:navbar />

<section class="petition-hero">
    <div class="petition-hero-backdrop" style="background-image: linear-gradient(90deg, rgba(20,20,20,0.94) 0%, rgba(20,20,20,0.74) 45%, rgba(20,20,20,0.88) 100%), url('${heroImageUrl}');"></div>
    <div class="petition-hero-content">
        <p class="petition-hero-kicker">Convocatoria Platea</p>
        <h1 class="petition-hero-title">Traé tu obra a la cartelera</h1>
        <p class="petition-hero-copy">Armamos un flujo de dos pasos para que cargues rápido lo esencial y completes después una ficha con el tono editorial del resto del sitio.</p>
        <div class="petition-hero-pills">
            <span class="petition-hero-pill">Revision manual</span>
            <span class="petition-hero-pill">Ficha curada</span>
            <span class="petition-hero-pill">Respuesta por mail</span>
        </div>
    </div>
</section>

<main class="petition-form-page">
    <section class="petition-form-shell petition-form-layout">
        <aside class="petition-form-sidebar">
            <div class="petition-form-sidebar-card">
                <p class="petition-form-kicker">Carga guiada</p>
                <h2>Como evaluamos una postulacion</h2>
                <ol class="petition-form-checklist">
                    <li>Revisamos identidad visual, sinopsis y datos clave de programacion.</li>
                    <li>Validamos que la ficha pueda transformarse en una obra y una produccion base.</li>
                    <li>Te notificamos la decision por el email de contacto que cargues.</li>
                </ol>
            </div>

            <div class="petition-form-sidebar-card petition-form-sidebar-card-accent">
                <p class="petition-form-sidebar-title">Antes de enviar</p>
                <p class="petition-form-sidebar-copy">Los campos con <span class="petition-form-required">*</span> son obligatorios. La imagen de portada puede pesar hasta <c:out value="${maxUploadMb}" /> MB.</p>
            </div>
        </aside>

        <section class="petition-form-content">
            <div class="petition-form-header">
                <p class="petition-form-kicker">Carga de contenido</p>
                <h2>Postulá tu obra para Platea</h2>
                <p class="petition-form-lead">Completá lo esencial primero y después agregá los datos opcionales para que el equipo pueda revisar tu propuesta.</p>
            </div>

            <c:if test="${created}">
                <div class="petition-form-alert">
                    <paw:alert variant="success" title="Solicitud enviada" message="Recibimos tu petición y te enviamos un correo de confirmación al email informado." showClose="false" />
                </div>
            </c:if>

            <c:if test="${not empty errors['global']}">
                <div class="petition-form-alert">
                    <paw:alert variant="error" title="No pudimos enviar la petición" message="${errors['global']}" showClose="false" />
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/subir-obra" method="post" enctype="multipart/form-data" class="petition-form-card" data-play-petition-form>
                <section class="petition-form-step">
                    <div class="petition-form-step-heading">
                        <span class="petition-form-step-number">1</span>
                        <div>
                            <h3>Lo esencial</h3>
                            <p>La información mínima para poder evaluar y publicar la obra.</p>
                        </div>
                    </div>

                    <div class="petition-form-grid petition-form-grid-two">
                        <div class="petition-form-field petition-form-field-full">
                            <label for="title">Título de la obra <span class="petition-form-required">*</span></label>
                            <input id="title" name="title" type="text" value="${fn:escapeXml(form.title)}" placeholder="Hamlet" />
                            <c:if test="${not empty errors['title']}"><span class="petition-form-error"><c:out value="${errors['title']}" /></span></c:if>
                        </div>

                        <div class="petition-form-field petition-form-field-full">
                            <label for="synopsis">Sinopsis <span class="petition-form-required">*</span></label>
                            <textarea id="synopsis" name="synopsis" rows="5" placeholder="Contá en uno o dos párrafos de qué trata la obra."><c:out value="${form.synopsis}" /></textarea>
                            <c:if test="${not empty errors['synopsis']}"><span class="petition-form-error"><c:out value="${errors['synopsis']}" /></span></c:if>
                        </div>

                        <div class="petition-form-field petition-form-field-full">
                            <span class="petition-form-label">Géneros <span class="petition-form-required">*</span></span>
                            <div class="petition-form-genre-grid">
                                <c:forEach var="genre" items="${genres}">
                                    <c:set var="genreToken" value=",${genre.id}," />
                                    <label class="petition-form-genre-option">
                                        <input type="checkbox" name="genreIds" value="${genre.id}" <c:if test="${fn:contains(selectedGenreIdsCsv, genreToken)}">checked="checked"</c:if> />
                                        <span><c:out value="${genre.name}" /></span>
                                    </label>
                                </c:forEach>
                            </div>
                            <c:if test="${not empty errors['genreIds']}"><span class="petition-form-error"><c:out value="${errors['genreIds']}" /></span></c:if>
                        </div>

                        <div class="petition-form-field">
                            <label for="durationMinutes">Duración aproximada (minutos) <span class="petition-form-required">*</span></label>
                            <input id="durationMinutes" name="durationMinutes" type="number" min="1" value="${fn:escapeXml(form.durationMinutes)}" placeholder="95" />
                            <c:if test="${not empty errors['durationMinutes']}"><span class="petition-form-error"><c:out value="${errors['durationMinutes']}" /></span></c:if>
                        </div>

                        <div class="petition-form-field">
                            <label for="language">Idioma</label>
                            <input id="language" name="language" type="text" value="${fn:escapeXml(form.language)}" placeholder="Castellano" />
                        </div>

                        <div class="petition-form-field">
                            <label for="theater">Teatro / sala <span class="petition-form-required">*</span></label>
                            <input id="theater" name="theater" type="text" value="${fn:escapeXml(form.theater)}" placeholder="Teatro Metropolitan" />
                            <c:if test="${not empty errors['theater']}"><span class="petition-form-error"><c:out value="${errors['theater']}" /></span></c:if>
                        </div>

                        <div class="petition-form-field">
                            <label for="theaterAddress">Dirección de la sala <span class="petition-form-required">*</span></label>
                            <input id="theaterAddress" name="theaterAddress" type="text" value="${fn:escapeXml(form.theaterAddress)}" placeholder="Av. Corrientes 1343" />
                            <c:if test="${not empty errors['theaterAddress']}"><span class="petition-form-error"><c:out value="${errors['theaterAddress']}" /></span></c:if>
                        </div>

                        <div class="petition-form-field">
                            <label for="startDate">Inicio de temporada <span class="petition-form-required">*</span></label>
                            <input id="startDate" name="startDate" type="date" value="${fn:escapeXml(form.startDate)}" />
                            <c:if test="${not empty errors['startDate']}"><span class="petition-form-error"><c:out value="${errors['startDate']}" /></span></c:if>
                        </div>

                        <div class="petition-form-field">
                            <label for="director">Dirección <span class="petition-form-required">*</span></label>
                            <input id="director" name="director" type="text" value="${fn:escapeXml(form.director)}" placeholder="Nombre del director o directora" />
                            <c:if test="${not empty errors['director']}"><span class="petition-form-error"><c:out value="${errors['director']}" /></span></c:if>
                        </div>

                        <div class="petition-form-field petition-form-field-full petition-form-upload-field">
                            <label for="coverImage">Imagen de portada <span class="petition-form-required">*</span></label>
                            <input id="coverImage" name="coverImage" type="file" accept="image/*" data-max-bytes="5242880" />
                            <p class="petition-form-hint">Subí un afiche o una imagen promocional en formato imagen. Tamaño máximo: <c:out value="${maxUploadMb}" /> MB.</p>
                            <c:if test="${not empty errors['coverImage']}"><span class="petition-form-error"><c:out value="${errors['coverImage']}" /></span></c:if>
                            <span class="petition-form-error petition-form-error-hidden" data-cover-image-size-error>La imagen excede el tamaño máximo permitido de <c:out value="${maxUploadMb}" /> MB.</span>
                        </div>

                        <div class="petition-form-field petition-form-field-full">
                            <label for="petitionerEmail">Email de contacto <span class="petition-form-required">*</span></label>
                            <input id="petitionerEmail" name="petitionerEmail" type="email" value="${fn:escapeXml(form.petitionerEmail)}" placeholder="produccion@ejemplo.com" />
                            <p class="petition-form-hint">Usamos este mail para confirmar la recepción y comunicar la decisión del equipo.</p>
                            <c:if test="${not empty errors['petitionerEmail']}"><span class="petition-form-error"><c:out value="${errors['petitionerEmail']}" /></span></c:if>
                        </div>
                    </div>
                </section>

                <section class="petition-form-step">
                    <div class="petition-form-step-heading">
                        <span class="petition-form-step-number">2</span>
                        <div>
                            <h3>Completá tu ficha</h3>
                            <p>La última fecha es obligatoria; el resto suma contexto para publicar una ficha mucho más útil.</p>
                        </div>
                    </div>

                    <div class="petition-form-grid petition-form-grid-two">
                        <div class="petition-form-field">
                            <label for="endDate">Última fecha de la producción <span class="petition-form-required">*</span></label>
                            <input id="endDate" name="endDate" type="date" value="${fn:escapeXml(form.endDate)}" />
                            <c:if test="${not empty errors['endDate']}"><span class="petition-form-error"><c:out value="${errors['endDate']}" /></span></c:if>
                        </div>

                        <div class="petition-form-field">
                            <label for="schedule">Días y horarios de función</label>
                            <input id="schedule" name="schedule" type="text" value="${fn:escapeXml(form.schedule)}" placeholder="Viernes y sábados 21 hs" />
                        </div>

                        <div class="petition-form-field petition-form-field-full">
                            <label for="ticketUrl">Link de venta de entradas</label>
                            <input id="ticketUrl" name="ticketUrl" type="url" value="${fn:escapeXml(form.ticketUrl)}" placeholder="https://alternativateatral.com/..." />
                            <c:if test="${not empty errors['ticketUrl']}"><span class="petition-form-error"><c:out value="${errors['ticketUrl']}" /></span></c:if>
                        </div>

                        <div class="petition-form-field petition-form-field-full">
                            <div class="petition-form-extra-dates-head">
                                <label>Fechas adicionales de función</label>
                                <button type="button" class="petition-form-add-date" data-add-date-button>Agregar fecha</button>
                            </div>
                            <div class="petition-form-extra-dates" data-additional-dates>
                                <c:choose>
                                    <c:when test="${not empty form.additionalShowDates}">
                                        <c:forEach var="extraDate" items="${form.additionalShowDates}">
                                            <input type="date" name="additionalShowDates" value="${fn:escapeXml(extraDate)}" class="petition-form-extra-date-input" />
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="date" name="additionalShowDates" value="" class="petition-form-extra-date-input" />
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <p class="petition-form-hint">Podés sumar fechas puntuales extra además del inicio y del cierre de la producción.</p>
                            <c:if test="${not empty errors['additionalShowDates']}"><span class="petition-form-error"><c:out value="${errors['additionalShowDates']}" /></span></c:if>
                        </div>
                    </div>
                </section>

                <div class="petition-form-actions">
                    <div class="petition-form-actions-copy">
                        <p class="petition-form-actions-title">Una vez enviada, la revisamos manualmente.</p>
                        <p class="petition-form-actions-text">Si aprobamos la petición, generamos automáticamente la obra y su producción base dentro de Platea.</p>
                    </div>
                    <button type="submit" class="btn btn-md petition-form-submit">Enviar petición</button>
                </div>
            </form>
        </section>
    </section>
</main>
</body>
</html>
