# PRD — Plataforma tipo Letterboxd para obras de teatro

## 1. Resumen del producto

Este proyecto busca construir una plataforma de descubrimiento y seguimiento de obras de teatro, inspirada en Letterboxd, pero adaptada a las particularidades del teatro en vivo.

A diferencia del cine, donde una película suele ser una entidad única, en teatro una misma obra puede tener múltiples producciones distintas. Por eso, el sistema debe modelar de forma explícita tres niveles:

- **Obra**: el texto o pieza teatral base.
- **Producción**: una puesta específica de esa obra.
- **Función**: una ocurrencia puntual de una producción en una fecha y lugar determinados.

La plataforma estará centrada en ayudar al usuario a responder una pregunta concreta: **qué obra ver hoy**. Para eso, la experiencia principal girará alrededor de la exploración de **producciones**, no de obras abstractas.

En el MVP, la plataforma estará limitada a **Buenos Aires**, sin autenticación real, sin funcionalidades sociales y sin monetización. El catálogo será operado manualmente por el equipo, incluyendo perfiles de productoras gestionados de forma interna.

---

## 2. Problema

La oferta teatral suele estar fragmentada, dispersa entre sitios de ticketing, redes sociales, páginas de productoras y listados poco claros. Esto genera varios problemas:

- Descubrir qué obras están disponibles en un momento dado no es simple.
- La información relevante suele estar incompleta o mal estructurada.
- No existe una experiencia tipo Letterboxd bien adaptada al teatro.
- Las plataformas existentes no distinguen adecuadamente entre una **obra** y una **producción** concreta.
- El usuario no tiene una forma clara de registrar qué vio, puntuarlo o reseñarlo con el nivel de granularidad correcto.

Este producto busca resolver ese vacío con una experiencia moderna, centrada en catálogo, descubrimiento y registro personal.

---

## 3. Objetivo del producto

Construir una plataforma que permita:

- descubrir producciones teatrales activas en Buenos Aires,
- explorar su información principal de forma clara,
- distinguir entre obra y producción,
- calificar una obra y una producción por separado,
- escribir reseñas,
- guardar producciones en watchlist,
- ofrecer una base sólida para evolucionar luego hacia una comunidad social de teatro.

---

## 4. Visión del producto

La visión de largo plazo es construir una plataforma de referencia para el descubrimiento, registro y discusión de teatro, con una experiencia comparable a Letterboxd pero diseñada para el dominio teatral.

A futuro, el producto debería permitir:

- comunidad y actividad social,
- seguimiento de usuarios y productoras,
- perfiles públicos más completos,
- recomendaciones,
- listas curadas,
- contenido patrocinado,
- mayor sofisticación en exploración y filtros,
- operación real por parte de productoras verificadas.

---

## 5. Objetivo principal del MVP

Validar que existe valor real en una experiencia enfocada en **descubrir producciones teatrales** y registrar interacción básica del usuario con el catálogo.

El MVP debe demostrar que:
- la separación entre obra y producción tiene sentido para el usuario,
- una home centrada en producciones facilita el descubrimiento,
- ratings, reseñas y watchlist son interacciones relevantes,
- el catálogo puede operarse manualmente en una primera etapa,
- existe una base funcional sobre la cual luego agregar cuentas reales, comunidad y crecimiento del catálogo.

---

## 6. Métrica principal del producto

### Métrica principal
- **Cantidad de reseñas escritas**

### Señal principal de valor
- El usuario descubre una obra/producción que no conocía y la evalúa o guarda para verla.

### Métricas secundarias sugeridas
- cantidad de producciones vistas en detalle,
- cantidad de ratings enviados,
- cantidad de producciones agregadas a watchlist,
- CTR hacia links de compra de entradas,
- cantidad de producciones con interacción,
- cobertura del catálogo activo de Buenos Aires.

---

## 7. Alcance MVP

### 7.1 Cobertura geográfica
- Solo **Buenos Aires**

### 7.2 Gestión del catálogo
- El catálogo será cargado **manualmente** por el equipo.
- Existirá el concepto de **perfil de productora**, pero en el MVP será operado internamente por el equipo.
- No habrá onboarding real de productoras externas.

### 7.3 Autenticación y usuarios
- No habrá login real.
- Se usará un **usuario hardcodeado** para validar flujos funcionales.
- Las features personales se implementarán como prueba funcional, no como sistema multiusuario real.

### 7.4 Funcionalidades incluidas en MVP
- Home con producciones
- Cartelera de obras/producciones en Buenos Aires
- Búsqueda de producciones
- Filtros por género y disponibilidad
- Página de detalle de producción
- Página de obra
- Perfil de productora
- Perfil de usuario hardcodeado
- Rating de obra
- Rating de producción
- Reseña general de obra
- Watchlist de producciones
- Links de compra/redirección

### 7.5 Funcionalidades excluidas del MVP
- login real,
- múltiples usuarios reales,
- feed social,
- follow entre usuarios,
- follow a productoras,
- likes,
- comentarios,
- listas personalizadas,
- recomendaciones personalizadas,
- monetización,
- sponsoreo,
- moderación avanzada,
- actualización en tiempo real por parte de productoras,
- administración compleja de disponibilidad,
- deduplicación de obras.

---

## 8. Alcance post-MVP / alcance total del proyecto

### 8.1 Usuarios y comunidad
- usuarios registrados reales,
- perfiles públicos completos,
- historial de actividad,
- seguimiento entre usuarios,
- seguimiento de productoras,
- feed social de actividad,
- likes y comentarios,
- listas personalizadas.

### 8.2 Productoras
- registro real de productoras,
- aprobación/moderación de perfiles,
- carga y edición directa de producciones,
- actualización de funciones y disponibilidad,
- mejor gestión del catálogo y control editorial.

### 8.3 Descubrimiento
- filtros más avanzados,
- búsqueda por más criterios,
- recomendaciones personalizadas,
- contenido destacado o patrocinado,
- navegación más rica por géneros, autores y productoras.

### 8.4 Monetización
- producciones sponsoreadas o destacadas en home,
- etiquetado explícito de contenido patrocinado.

---

## 9. Usuarios y roles

## 9.1 Roles en el MVP

### Visitante
Puede:
- navegar la home,
- buscar producciones,
- usar filtros,
- ver detalles de producciones,
- ver detalles de obras,
- ver perfiles de productoras.

### Productora (operada internamente)
Puede:
- tener perfil propio,
- cargar obras nuevas,
- cargar producciones,
- asociar producciones a obras,
- completar información relevante.

**Nota:** en el MVP este rol existe a nivel de producto/modelo, pero será usado por el equipo internamente.

## 9.2 Roles en el alcance total

### Usuario registrado
Podrá:
- puntuar obras,
- puntuar producciones,
- escribir reseñas,
- guardar producciones en watchlist,
- seguir usuarios y productoras,
- interactuar con el feed,
- crear listas.

### Admin
Podrá:
- moderar contenido,
- administrar catálogo,
- aprobar productoras,
- resolver conflictos de calidad de datos,
- gestionar contenido destacado.

---

## 10. Modelo conceptual del dominio

## 10.1 Obra

Representa la pieza teatral base, independiente de una puesta específica.

### Campos esperados
- título,
- sinopsis general,
- género,
- dirección/autores relevantes si aplica,
- metadatos editoriales adicionales.

### Consideraciones
- Una obra puede tener múltiples producciones.
- Una reseña general de obra pertenece a esta entidad.
- El rating de obra evalúa el valor del texto o pieza teatral en sí, no la puesta concreta.

---

## 10.2 Producción

Representa una puesta concreta de una obra.

### Campos mínimos definidos
- nombre,
- obra asociada,
- poster,
- sinopsis,
- dirección,
- género,
- teatro,
- fechas,
- links.

### Campos adicionales sugeridos
- productora,
- estado,
- próxima función,
- Instagram opcional,
- web opcional,
- links externos opcionales.

### Consideraciones
- La producción es la unidad principal de descubrimiento en la plataforma.
- Los resultados de búsqueda deben devolver **producciones**.
- El rating de producción evalúa una puesta específica.
- La watchlist guarda **producciones**.
- Una producción no puede tener múltiples sedes simultáneas.
- Una producción puede tener varias temporadas o reposiciones.

---

## 10.3 Función

Representa una ocurrencia puntual de una producción.

### Campos esperados
- producción asociada,
- fecha,
- hora,
- sala / teatro,
- estado de disponibilidad si se implementa más adelante.

### Consideraciones
- En el MVP no será una entidad central para interacción del usuario.
- Se elimina del alcance MVP la funcionalidad de “marcar como visto”.
- Sigue siendo relevante en el modelo para determinar disponibilidad y cartelera.

---

## 10.4 Productora

Representa una cuenta/perfil especial asociado a una organización que monta producciones.

### Campos esperados
- nombre,
- descripción o bio,
- imagen/logo,
- links externos opcionales,
- Instagram opcional,
- web opcional,
- listado de producciones.

### Consideraciones
- En el MVP las productoras no se autogestionan.
- Una productora puede crear una obra nueva si no existe.
- La deduplicación de obras queda fuera del MVP.

---

## 10.5 Usuario

En el MVP habrá un único usuario hardcodeado.

### Perfil de usuario MVP
Debe poder mostrar:
- ratings de obra,
- ratings de producción,
- reseñas,
- watchlist,
- historial personal que se implemente localmente para demo.

### Consideraciones
- Este perfil no representa todavía una arquitectura multiusuario real.
- Debe quedar explícito en desarrollo que estas features son de validación funcional.

---

## 10.6 Rating

### Tipos de rating
- rating de obra,
- rating de producción.

### Reglas
- Escala de **1 a 10**
- Se puede calificar sin reseña.
- No se puede escribir reseña sin calificar.
- Rating de obra y rating de producción deben almacenarse por separado.

---

## 10.7 Review / reseña

### Tipos
- reseña general de obra,
- reseña específica de producción (post-MVP o si se implementa en evolución posterior).

### Regla definida
- Las reseñas de obra y de producción deben ser entidades distintas.

### Justificación
Mezclar en una misma reseña la valoración del texto teatral con la valoración de una puesta concreta contamina el modelo y dificulta futuras funcionalidades.

---

## 10.8 Watchlist

### Definición
- La watchlist guarda **producciones**, no obras abstractas.

### Justificación
La plataforma está centrada en descubrir qué ver efectivamente. Desde esa lógica, la unidad accionable es la producción.

---

## 11. Estructura de navegación esperada

## 11.1 Home
Pantalla principal centrada en **producciones**.

Debe mostrar:
- producciones destacadas/editoriales,
- producciones disponibles,
- tendencias si se implementa como criterio editorial,
- acceso a búsqueda,
- acceso a cartelera.

## 11.2 Cartelera
Vista orientada a producciones con funciones futuras en Buenos Aires.

## 11.3 Catálogo histórico
Vista orientada a producciones pasadas o sin funciones futuras registradas.

## 11.4 Búsqueda
Devuelve **producciones** como resultado, pero debe indexar:
- nombre de la producción,
- nombre de la obra,
- nombre de la productora,
- teatro.

## 11.5 Filtros
MVP:
- género,
- disponibilidad.

## 11.6 Detalle de producción
Debe incluir:
- nombre,
- obra asociada,
- sinopsis,
- poster,
- productora,
- teatro,
- fechas,
- links de compra,
- rating de producción,
- acceso a guardar en watchlist.

## 11.7 Detalle de obra
Debe incluir:
- información general de la obra,
- reseñas de obra,
- rating de obra,
- listado de producciones asociadas.

## 11.8 Perfil de productora
Debe incluir:
- identidad visual,
- bio,
- links externos opcionales,
- Instagram/web opcional,
- listado de producciones.

## 11.9 Perfil de usuario
Debe incluir:
- watchlist,
- ratings,
- reseñas,
- historial personal visible en demo.

---

## 12. Requisitos funcionales MVP

## 12.1 Catálogo
- El sistema debe permitir crear obras.
- El sistema debe permitir crear producciones asociadas a obras.
- El sistema debe permitir asociar cada producción a una productora.
- El sistema debe permitir cargar fechas y links por producción.
- El sistema debe permitir clasificar producciones por disponibilidad.

## 12.2 Descubrimiento
- El sistema debe mostrar una home centrada en producciones.
- El sistema debe ofrecer una vista de cartelera actual.
- El sistema debe ofrecer una vista de catálogo histórico.
- El sistema debe permitir buscar producciones.
- El sistema debe permitir filtrar por género y disponibilidad.

## 12.3 Interacción personal
- El sistema debe permitir puntuar una obra de 1 a 10.
- El sistema debe permitir puntuar una producción de 1 a 10.
- El sistema debe permitir escribir una reseña general de obra solo si existe rating asociado.
- El sistema debe permitir guardar una producción en watchlist.
- El sistema debe mostrar el perfil del usuario hardcodeado con su actividad básica.

## 12.4 Productoras
- El sistema debe permitir representar una productora como tipo especial de perfil.
- El sistema debe permitir asociar múltiples producciones a una productora.
- El sistema debe mostrar un perfil público de productora.

## 12.5 Enlaces externos
- El sistema debe permitir redireccionar a links de compra por producción.
- El sistema puede mostrar Instagram/web opcionales en el perfil de productora.

---

## 13. Requisitos funcionales post-MVP

- login y registro reales,
- múltiples usuarios,
- seguimiento de usuarios,
- seguimiento de productoras,
- feed social,
- likes,
- comentarios,
- listas personalizadas,
- recomendaciones,
- administración directa por productoras,
- actualización de funciones y disponibilidad en tiempo real,
- contenido patrocinado,
- moderación.

---

## 14. Requisitos no funcionales

## 14.1 Calidad del modelo
El sistema debe reflejar correctamente la separación entre:
- obra,
- producción,
- función.

Esta separación no es opcional. Es una decisión central del producto.

## 14.2 Claridad del alcance
El MVP debe implementarse sin vender falsa completitud:
- no hay autenticación real,
- no hay multiusuario real,
- no hay ecosistema social real,
- no hay marketplace ni monetización,
- no hay operación externa real por productoras.

## 14.3 Extensibilidad
La arquitectura debe permitir crecer hacia:
- multiusuario,
- interacción social,
- recomendaciones,
- mayor complejidad editorial,
- administración distribuida de catálogo.

## 14.4 Consistencia de datos
Aunque la deduplicación quede fuera del MVP, el sistema debe dejar preparada una estructura que permita resolver duplicados más adelante.

---

## 15. Definición de disponibilidad

Para el MVP:

- **Disponible**: la producción tiene al menos una función futura.
- **No disponible**: la producción no tiene funciones futuras.

Esto debe usarse tanto para filtros como para clasificación de cartelera/histórico.

---

## 16. Definición de vistas principales del catálogo

## 16.1 Cartelera
- producciones con funciones futuras registradas.

## 16.2 Catálogo histórico
- producciones sin funciones futuras registradas,
- producciones finalizadas,
- producciones pasadas conservadas con valor editorial o histórico.

---

## 17. Supuestos y restricciones

- El MVP cubre únicamente Buenos Aires.
- El catálogo será curado/cargado internamente.
- No habrá autenticación real.
- No habrá usuario real múltiple.
- No habrá social.
- No habrá monetización.
- No habrá autogestión real de productoras.
- No habrá deduplicación de obras.
- No habrá actualización compleja de disponibilidad por parte de terceros.

---

## 18. Riesgos principales

### 18.1 Calidad de datos
Si el catálogo se carga manualmente, la calidad y consistencia de datos depende del equipo.

### 18.2 Ambigüedad entre obra y producción
Si la UI no hace evidente esta diferencia, el usuario puede no entender qué está puntuando.

### 18.3 MVP engañoso
Como habrá un usuario hardcodeado, existe riesgo de sobreestimar qué tan avanzado está el sistema realmente.

### 18.4 Escalabilidad editorial
Sin deduplicación ni workflows de catalogación, el crecimiento del catálogo puede generar inconsistencias.

---

## 19. Decisiones cerradas

- La home se centra en **producciones**.
- La búsqueda devuelve **producciones**.
- La watchlist guarda **producciones**.
- El usuario puede calificar **obra** y **producción** por separado.
- El rating es de **1 a 10**.
- Se puede calificar sin reseñar.
- No se puede reseñar sin calificar.
- Las reseñas de obra y producción son entidades separadas.
- La disponibilidad se define por existencia de funciones futuras.
- Las productoras son un tipo especial de perfil.
- En MVP, productoras y catálogo se gestionan internamente.
- La deduplicación queda fuera del MVP.
- El MVP usa usuario hardcodeado.

---

## 20. Fuera de alcance explícito del MVP

- autenticación real,
- registro real de usuarios,
- usuarios múltiples,
- marcar producciones o funciones como vistas,
- feed social,
- comentarios,
- likes,
- follow,
- listas custom,
- recomendaciones personalizadas,
- moderación,
- monetización,
- contenido patrocinado,
- administración externa real por productoras,
- deduplicación de obras,
- features complejas de disponibilidad en tiempo real.
