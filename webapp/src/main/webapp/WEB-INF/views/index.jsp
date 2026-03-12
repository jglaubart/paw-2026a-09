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
</head>
<body>

    <header class="header">
        <h1>Platea</h1>
        <paw:search name="search" placeholder="Buscar obras..." />
    </header>

    <main>
        <h2>Cartelera</h2>
        <div class="obras-grid">
            <paw:card title="El Principito"
                detailUrl="/obras/1"
                imageUrl="${pageContext.request.contextPath}/images/Portadas/principito.jpg"
            />
            <paw:card title="Hamlet"
                detailUrl="/obras/2"
                imageUrl="${pageContext.request.contextPath}/images/Portadas/hamlet.jpg"
            />
            <paw:card title="Hamilton"
                detailUrl="/obras/3"
                imageUrl="${pageContext.request.contextPath}/images/Portadas/hamilton.jpg"
            />
        </div>

        <h2>Botones</h2>
        <paw:button text="Botón pequeño" size="sm" />
        <paw:button text="Botón mediano" size="md" />
        <paw:button text="Botón grande" size="lg" />
        <paw:button text="Botón deshabilitado" disabled="${true}" />

        <h2>Buscador con error</h2>
        <paw:search name="email" placeholder="Email" error="El email no es válido" />
    </main>

</body>
</html>