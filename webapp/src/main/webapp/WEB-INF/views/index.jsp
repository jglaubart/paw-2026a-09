<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Platea — Descubrí teatro en Buenos Aires</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/hero.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/production-card.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/section-row.css" />
</head>
<body>

    <paw:navbar />

    <paw:hero
        title="Hamlet en Palermo"
        description="Una reinvención brutal del clásico shakesperiano bajo las luces de neón del Teatro Regina. La locura nunca fue tan urbana."
        imageUrl="${pageContext.request.contextPath}/images/Portadas/hamlet.jpg"
        badge="DESTACADO"
        rating="4.9/5.0"
    />

    <main>
        <paw:sectionRow title="Tendencia" subtitle="Lo que todos están hablando">
            <paw:productionCard
                title="Ciudad de Furia"
                imageUrl="${pageContext.request.contextPath}/images/Portadas/hamlet.jpg"
                venue="Teatro Gran Rex"
                rating="4.9"
                badge="TOP1"
            />
            <paw:productionCard
                title="Líneas de Fuga"
                imageUrl="${pageContext.request.contextPath}/images/Portadas/principito.jpg"
                venue="Konex"
                rating="4.7"
            />
            <paw:productionCard
                title="Replay: El Musical"
                imageUrl="${pageContext.request.contextPath}/images/Portadas/hamilton.jpg"
                venue="Teatro Ópera"
                rating="4.8"
            />
            <paw:productionCard
                title="Ecos en el Vacío"
                imageUrl="${pageContext.request.contextPath}/images/Portadas/hamlet.jpg"
                venue="Teatro El Picadero"
                rating="4.6"
            />
        </paw:sectionRow>
    </main>

</body>
</html>
