<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html>
<head>
    <title>Platea</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/card.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/alert.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/play-detail.css" />
</head>
<body>

    <header class="header">
        <h1>Platea componentes</h1>
        <paw:search name="search" placeholder="Buscar obras..." minlength="3" maxlength="60" />
    </header>

    <main>
     <h2>Cartelera</h2>
     <div class="obras-grid">
         <paw:card title="El Principito"
            imageUrl="${pageContext.request.contextPath}/images/Portadas/principito.jpg"
         />
         <paw:card title="Hamlet"
            imageUrl="${pageContext.request.contextPath}/images/Portadas/hamlet.jpg"
         />
         <paw:card title="Hamilton"
            imageUrl="${pageContext.request.contextPath}/images/Portadas/hamilton.jpg"
         />
     </div>

     <h2>Vista detallada</h2>
     <paw:playDetail
        title="Hamlet"
        imageUrl="${pageContext.request.contextPath}/images/Portadas/hamlet.jpg"
        productionName="Compania Nacional de Teatro Clasico"
        year="2026"
        location="Buenos Aires"
        averageRating="9.1"
        summary="Una reinterpretacion contemporanea de Hamlet con una puesta intensa, elenco coral y una produccion que combina clasico y moderno sin perder fuerza dramatica."
        otherEditions="2024;Teatro San Martin;Buenos Aires~2021;Complejo Atlas;Mar del Plata~2018;Teatro Municipal;Cordoba~2012;Productora Sur;Rosario"
        seen="${true}"
        inWishlist="${true}"
        currentlyRunning="${true}"
        expiringSoon="${true}"
     />

     <h2>Botones</h2>
     <paw:button text="Botón pequeño" size="sm" />
     <paw:button text="Botón mediano" size="md" />
     <paw:button text="Botón grande" size="lg" />
     <paw:button text="Botón deshabilitado" disabled="${true}" />

     <h2>Alertas</h2>
     <div class="alerts-grid">
            <paw:alert
                variant="info"
                title="Cartelera actualizada"
                message="Hay nuevas funciones disponibles para este fin de semana." />
            <paw:alert
                variant="success"
                title="Obra agregada"
                message="Hamlet 2026 se guardo correctamente en tu wishlist." />
            <paw:alert
                variant="warning"
                title="Pocas entradas"
                message="La función 'Hamlet 2026' de la wishlist está por finalizar." />
            <paw:alert
                variant="error"
                title="No se pudo cargar"
                message="La productora de la obra no esta disponible en este momento." />
        </div>

        <h2>Buscador con error</h2>
        <paw:search name="email"
            type="email"
            placeholder="Email"
            required="${true}"
            maxlength="80"
            error="El email no es válido" />
    </main>

</body>
</html>
