-- ============================================
-- Platea — Datos reales de Alternativa Teatral
-- Fuente: alternativateatral.com (marzo 2026)
-- ============================================

-- 1. Usuario demo
INSERT INTO users (email, password) VALUES ('demo@platea.com', 'demo1234');

-- 2. Obras (pieza teatral base)
INSERT INTO obras (title, synopsis, genre) VALUES
('La Revista del Cervantes',
 'Nuestro teatro nacional se lo debía a la revista. Con una puesta espléndida, esta gran producción celebra el género que supo reunir lo popular y lo artístico en escena, con música, humor y espectáculo en vivo.',
 'Revista'),
('Doradas',
 'Cinco actrices populares, reconocidas y con historias muy distintas entre sí, se reúnen a ensayar una obra de teatro. Pero detrás de cada ensayo hay algo que cada una carga y que se va revelando.',
 'Drama'),
('El ávido espectador',
 'Un grupo de amigos se reúne para ver una película. Mientras esperan que todos lleguen y que empiece la función, lo que se va revelando es mucho más que una tarde de cine.',
 'Drama'),
('Nacha & Favero',
 'Porque hay historias que todavía no se han contado. Nacha Guevara y Alberto Favero protagonizan un espectáculo íntimo que repasa su historia de amor y creación artística a lo largo de décadas.',
 'Musical'),
('A navegar, Piratas!',
 'Una aventura teatral para toda la familia donde el público es parte de la historia. Los piratas necesitan ayuda para encontrar el tesoro y los chicos son los héroes de esta misión.',
 'Infantil'),
('La bella durmiente y el ladrón', NULL, 'Infantil'),
('Experiencia Queen — Greatest Hits Tour 2026',
 'El show promete llevar al público a revivir los grandes éxitos de Queen con un despliegue audiovisual, vestuario y performance que homenajea la legendaria banda inglesa.',
 'Musical'),
('Alma Mahler — Sinfonía de vida, arte y seducción',
 'Un texto poético que cuenta la potente historia de Alma Mahler, musa y protagonista de la vida cultural europea de principios del siglo XX, que amó a los artistas más importantes de su época.',
 'Drama'),
('Tamorto (romance de arlequín y la muerte)', NULL, 'Comedia'),
('Circo Transatlántico', NULL, 'Circo'),
('Crónica de una fuga', NULL, 'Drama'),
('Me encantaría que gustes de mí', NULL, 'Comedia'),
('Un mar incógnito', NULL, 'Drama'),
('Perla Guaraní', NULL, 'Drama'),
('Carnelli, algo que tiembla cederá', NULL, 'Drama'),
('La ceremonia, el suicidio de una idea y la decadencia del poder', NULL, 'Drama'),
('AMOR/VENENO — Tangos y Boleros', NULL, 'Musical'),
('¡HARTAZGO! — A la gran familia argentina, salud', NULL, 'Comedia'),
('Hansel y Gretel', NULL, 'Infantil'),
('Los tres chanchitos',
 'Las desventuras de tres chanchitos perseguidos por el lobo feroz, una historia clásica reimaginada con humor y música para toda la familia.',
 'Infantil'),
('Art', NULL, 'Comedia'),
('Hamlet', NULL, 'Tragedia'),
('Un jueves largo y verde', NULL, 'Drama'),
('Diente por diente', NULL, 'Drama'),
-- Obras nuevas scrapeadas
('La Wagner',
 'En La Wagner, cuatro mujeres, como cuatro valquirias, se montan sobre la música de Richard Wagner y arremeten con la tarea de desactivar estereotipos y denunciar prejuicios relacionados con la feminidad, la violencia, la sexualidad, el erotismo y la pornografía.',
 'Danza'),
('Ricardo Behrens — INMERSIVO',
 'Humor y Teatralidad generados de manera espontánea. En un clima de ameno y festivo convivio el público es invitado a co-crear juego teatral sobre el escenario. Un show de HUMOR SIN LÍMITES que sorprende desde el minuto 1.',
 'Improvisación'),
('I Love Stand Up — Stand up show',
 'El show de mayor crecimiento y mejor crítica por parte del público. Comediantes que tocan temas de la vida cotidiana con un tono humorístico, reflexionando y haciéndo reír al público.',
 'Stand up'),
('Nada del Amor me produce envidia',
 'Un melodrama musical cuyo anclaje es el mundo de las cancionistas argentinas de los años 30. Tomando como punto de partida el mítico cachetazo que aparentemente Libertad Lamarque le habría dado a Eva Perón, se creó un espectáculo centrado en el drama de una costurera de barrio.',
 'Musical'),
('NoNiNaS Tango — Vida y obra de Astor Piazzolla',
 'Un recorrido por la vida y obra musical de Astor Piazzolla que combina tango, teatro y música en vivo para homenajear al gran compositor argentino.',
 'Tango');

-- 3. Productoras
INSERT INTO productoras (name, bio, instagram, website) VALUES
('Teatro Nacional Cervantes', 'El teatro nacional de la República Argentina, dedicado a la producción y difusión de las artes escénicas.', 'https://instagram.com/teatrocervantes', 'https://teatrocervantes.gob.ar'),
('Paseo La Plaza', 'Complejo teatral ubicado en la Avenida Corrientes, uno de los principales polos culturales de Buenos Aires.', 'https://instagram.com/paseodelaplaza', 'https://www.paseodelaplaza.com.ar'),
('Timbre 4', 'Compañía y sala independiente fundada por Claudio Tolcachir en el barrio de Boedo.', 'https://instagram.com/timbre4', 'https://timbre4.com'),
('Grupo Catalinas Sur', 'Teatro comunitario del barrio de La Boca, referente del movimiento de teatro comunitario argentino.', 'https://instagram.com/catalinassur', 'https://catalinassur.com.ar');

-- 4. Producciones (puestas reales en cartelera marzo 2026)
INSERT INTO productions (name, obra_id, productora_id, synopsis, direction, theater, start_date, end_date, image_url, instagram, website) VALUES
-- Teatro Nacional Cervantes
('La Revista del Cervantes',
 (SELECT id FROM obras WHERE title = 'La Revista del Cervantes'),
 (SELECT id FROM productoras WHERE name = 'Teatro Nacional Cervantes'),
 'Nuestro teatro nacional se lo debía a la revista. Con una puesta espléndida, esta gran producción celebra el género que supo reunir lo popular y lo artístico en escena.',
 'Pablo Maritano', 'Teatro Nacional Cervantes', '2026-03-01', '2026-05-31',
 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/37/000297537.jpg',
 NULL, 'https://alternativateatral.com/obra95254-la-revista-del-cervantes'),

('Doradas — Temporada 2026',
 (SELECT id FROM obras WHERE title = 'Doradas'),
 (SELECT id FROM productoras WHERE name = 'Teatro Nacional Cervantes'),
 'Cinco actrices populares, reconocidas y con historias muy distintas entre sí, se reúnen a ensayar una obra de teatro. Pero detrás de cada ensayo hay algo que cada una carga y que se va revelando.',
 'José María Muscari', 'Teatro Nacional Cervantes', '2026-03-19', '2026-05-24',
 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/68/000311468.jpg',
 NULL, 'https://alternativateatral.com/obra99872-doradas'),

('Doradas — Temporada 2010',
  (SELECT id FROM obras WHERE title = 'Doradas'),
  (SELECT id FROM productoras WHERE name = 'Teatro Nacional Cervantes'),
  'Cinco actrices populares que actuaron toda la vida pero que ahora en su madurez artística llegan por primera vez al prestigio del CERVANTES Una obra escrita con la colaboración de la inteligencia artificial que combina confesiones personales e ingredientes retro Un manifiesto sobre la fama , el paso del tiempo y las emociones maquilladas DORADAS es quizás el pretexto para verlas a ellas nuevamente refulgentes',
  'José María Muscari', 'Teatro del Sur', '2010-04-01', '2010-11-30',
  'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/68/000311468.jpg',
  NULL, NULL),

('El ávido espectador',
 (SELECT id FROM obras WHERE title = 'El ávido espectador'),
 (SELECT id FROM productoras WHERE name = 'Teatro Nacional Cervantes'),
 'Un grupo de amigos se reúne para ver una película. Mientras esperan que todos lleguen y que empiece la función, lo que se va revelando es mucho más que una tarde de cine.',
 'Carolina Adamovsky', 'Teatro Nacional Cervantes', '2026-03-01', '2026-05-10',
 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/24/000310824.jpg',
 NULL, 'https://alternativateatral.com/obra99674-el-avido-espectador'),

('Nacha & Favero',
 (SELECT id FROM obras WHERE title = 'Nacha & Favero'),
 (SELECT id FROM productoras WHERE name = 'Teatro Nacional Cervantes'),
 'Porque hay historias que todavía no se han contado. Nacha Guevara y Alberto Favero protagonizan un espectáculo íntimo que repasa su historia de amor y creación artística.',
 NULL, 'Teatro Nacional Cervantes', '2026-04-08', '2026-05-27',
 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/08/000311208.jpg',
 NULL, 'https://alternativateatral.com/obra99811-nacha-favero'),

-- Paseo La Plaza
('A navegar, Piratas!',
 (SELECT id FROM obras WHERE title = 'A navegar, Piratas!'),
 (SELECT id FROM productoras WHERE name = 'Paseo La Plaza'),
 'Una aventura teatral para toda la familia donde el público es parte de la historia. Los piratas necesitan ayuda para encontrar el tesoro y los chicos son los héroes.',
 'Leandro Montgómery', 'Paseo La Plaza', '2026-01-01', '2026-03-29',
 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/09/000311109.jpg',
 NULL, 'https://alternativateatral.com/obra99604-a-navegar-piratas'),

('La bella durmiente y el ladrón',
  (SELECT id FROM obras WHERE title = 'La bella durmiente y el ladrón'),
  (SELECT id FROM productoras WHERE name = 'Paseo La Plaza'),
  'En un reino muy, pero muy lejano, se celebra con alegría el nacimiento de la tan esperada princesa. Todo el pueblo es invitado a la gran fiesta… excepto el hada malvada, que por un imperdonable error queda fuera del festejo. Enfurecida, lanza un temible hechizo sobre la pequeña princesita. Pero las hadas madrinas, ingeniosas y amorosas, logran esconder dentro de la maldición una chispa de esperanza. Años más tarde, en el día de su cumpleaños número dieciséis, nuestra heroína se cruza inesperadamente con un joven aventurero, simpático y audaz, quien, junto a su inseparable y divertido secuaz Mercurio, la arrastrará a vivir una aventura que cambiará su destino para siempre. Entre los disparatados consejos de sus hadas madrinas, la constante amenaza del hada malvada y el descubrimiento de su propio coraje, Aurora aprenderá que ser princesa no es solo esperar… sino atreverse.', NULL, 'Paseo La Plaza', '2026-03-01', '2026-07-31', 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/62/000309562.jpg',
  NULL, NULL),

-- Salas independientes
('Experiencia Queen — Greatest Hits Tour 2026',
 (SELECT id FROM obras WHERE title = 'Experiencia Queen — Greatest Hits Tour 2026'),
 NULL,
 'El show promete llevar al público a revivir los grandes éxitos de Queen con un despliegue audiovisual, vestuario y performance que homenajea la legendaria banda inglesa.',
 NULL, 'Teatro Maipú', '2026-06-04', '2026-06-04',
 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/66/000309666.jpg',
 NULL, 'https://alternativateatral.com/obra99326-experiencia-queen-greatest-hits-tour-2026'),

('Alma Mahler — Sinfonía de vida, arte y seducción',
 (SELECT id FROM obras WHERE title = 'Alma Mahler — Sinfonía de vida, arte y seducción'),
 NULL,
 'Un texto poético que cuenta la potente historia de Alma Mahler, musa y protagonista de la vida cultural europea de principios del siglo XX.',
 'Pablo Gorlero', 'Centro Cultural de la Cooperación', '2026-03-01', '2026-04-26',
 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/60/000312060.jpg',
 NULL, 'https://alternativateatral.com/obra89650-alma-mahler-sinfonia-de-vida-arte-y-seduccion'),

('Tamorto (romance de arlequín y la muerte)',
  (SELECT id FROM obras WHERE title = 'Tamorto (romance de arlequín y la muerte)'),
  NULL,
  '“Arlequín está enfermo. Una adivinadora le predijo que el día que dedicara más tiempo al sueño que a la botella, moriría a las doce de la noche en punto. Son las ocho y aún duerme. A Pierrot, el mejor amigo de Arlequín, se le ocurre retrasar el reloj, aunque sea dos horas para que lo atienda la Dottora, cosa que a Arlequín le divierte. Colombina, la mujer de Pierrot, tiene una cita furtiva con Arlequín. Pierrot, lleno de celos decide vengarse adelantando el reloj.La muerte llega a las 12:00 de la noche...Las Cartas están echadas.”', NULL, 'Auditorio AIC Abasto', '2026-03-01', '2026-05-30',
  'https://img.alternativateatral.com/scripts/es/fotos/obras/100x75/22/000272422.jpg',
  NULL, NULL),

('Circo Transatlántico',
  (SELECT id FROM obras WHERE title = 'Circo Transatlántico'),
  NULL,
  'Circo Transatlántico toma como base el conflicto del protagonista de Trans-Atlantyk: un polaco recien llegado a Argentina, a los pocos dias se desata la Segunda Guerra Mundial y se ve forzado a permanecer en Buenos Aires. Enfrentado así a una comunidad exiliada que intenta imponerle el deber nacionalista, moral y patriótico. Pero lo hace desde el código del clown, exponiendo el absurdo de estas tensiones con una poética del ridículo, la dislocación y el exceso.', NULL, 'Teatro El Extranjero', '2026-03-01', '2026-05-30', 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/87/000311687.jpg',
  NULL, NULL),

('Crónica de una fuga',
  (SELECT id FROM obras WHERE title = 'Crónica de una fuga'),
  NULL,
  'La Fundación SAGAI te invita a una función especial de “Crónica de una fuga”, el reconocido largometraje dirigido por Adrián Caetano, en el marco de una jornada de reflexión a 50 años del golpe cívico-militar.', NULL, 'Fundación SAGAI', '2026-03-01', '2026-05-30', 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/01/000312101.jpg',
  NULL, NULL),

('Me encantaría que gustes de mí',
  (SELECT id FROM obras WHERE title = 'Me encantaría que gustes de mí'),
  NULL,
  'Fernanda Rosetti es una profesora de literatura de un colegio secundario que busca el amor desde su soledad más absoluta. Vive intensamente entre lo cotidiano y su imaginación, llena de amores vertiginosos que parecen ocuparlo todo. Entre las paredes de su departamento de Once, intenta escribir una nouvelle sobre su compulsión a amar y la búsqueda de sí misma.', NULL, 'Beckett Teatro', '2026-03-01', '2026-05-30', 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/61/000246561.jpg',
  NULL, NULL),

('Un mar incógnito',
  (SELECT id FROM obras WHERE title = 'Un mar incógnito'),
  NULL,
  'Ellas se sumergen mar adentro, se mueven con las mareas y descienden a las profundidades. Alguna vez fueron peces, pero ahora el mar las sorprende, con su íntima inmensidad. ¿Cómo es volver a navegar un mar nuestro? ¿Qué rastros oceánicos son los que llevan en sus cuerpos? ¿Qué historias y voces encuentran en el espacio abisal? Una obra de movimiento inspirada en las profundidades del Mar Argentino y la memoria del submarino Ara San Juan', NULL, 'Centro Cultural de la Cooperación', '2026-03-01', '2026-05-30', 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/08/000305708.jpg',
  NULL, NULL),

('Perla Guaraní',
  (SELECT id FROM obras WHERE title = 'Perla Guaraní'),
  NULL,
  'Perla espera machete en mano, agazapada como un yaguareté, la entrada de su clientela. Zapatitos de cuero es lo que tiene para vender. Cierra la puerta de lo que parece el interior de un rancho y frente a nuestros ojos se convierte en un personaje erótico y peligroso: condensa en su cuerpo a la serpiente y al encantador. Un Litoral exuberante, ominoso, se arrastra y se manifiesta en ella como una llaga abierta. Su historia, la música, su voz son un narcótico, la carnada que nos atrae al anzuelo. Como en toda transacción donde las pasiones se ponen en venta, nosotros, los que disfrutamos de su encantamiento, tendremos que elegir entre un comprarle un zapatito o, por un costo mayor, un tramo de su tragedia.', NULL, 'Fundación SAGAI', '2026-03-01', '2026-05-30', 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/79/000296779.jpg',
  NULL, NULL),

('Carnelli, algo que tiembla cederá',
  (SELECT id FROM obras WHERE title = 'Carnelli, algo que tiembla cederá'),
  NULL,
  'Esta obra se inspira en la vida de María Luisa Carnelli, la primera letrista de tango, quien bajo seudónimo de varón escribió letras para composiciones de Filiberto, De Caro y Canaro entre otros. Con formato documental periodístico entre ficción testimonial, música y lecturas se compone un homenaje a una mujer que desafió las convenciones de su tiempo, dejando un legado imborrable en la cultura del tango y en la lucha social.', NULL, 'Centro Cultural de la Cooperación', '2026-03-01', '2026-05-30', 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/97/000307397.jpg',
  NULL, NULL),

('La ceremonia',
  (SELECT id FROM obras WHERE title = 'La ceremonia, el suicidio de una idea y la decadencia del poder'),
  NULL,
  'RECORRIENDO ESCENARIOS DE Argentina, México, Uruguay, Brasil, Croacia, Serbia, Italia, Suiza, Francia y Chile', NULL, 'Sala del Café Artigas', '2026-03-01', '2026-05-30', 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/000161987.jpg',
  NULL, NULL),

('AMOR/VENENO — Tangos y Boleros',
  (SELECT id FROM obras WHERE title = 'AMOR/VENENO — Tangos y Boleros'),
  NULL,
  'AMOR / VENENO es un espectáculo íntimo de música en vivo y narrativa escénica donde las canciones se convierten en capítulos de una misma historia. Entre tangos y boleros, la noche recorre los distintos estados del amor: el deseo que promete eternidad, los encuentros que parecen destino, las dudas que se cuelan en silencio y las heridas que dejan los recuerdos. Desde quien espera un beso que lo cambie todo hasta quien intenta olvidar, cada canción revela un momento de ese viaje inevitable entre la pasión y la nostalgia. Con banda en vivo y una puesta cercana, AMOR / VENENO propone una experiencia donde la música y el relato se entrelazan para atravesar lo que todos alguna vez vivimos: amar, perder, recordar… y volver.', NULL, 'Teatro El Desguace', '2026-03-01', '2026-05-30', 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/53/000311853.jpg',
  NULL, NULL),

('¡HARTAZGO!',
  (SELECT id FROM obras WHERE title = '¡HARTAZGO! — A la gran familia argentina, salud'),
  NULL,
  'Diciembre 2001, familia disfuncional, burgueses de medio pelo que antaño supieron brillar... el país a punto de estallar, ¡¡¡la casa a punto de estallar... BOOOM!!! Sosteniendo la última mascarada, tanta mentira travestida en verdad, ¡es mejor no pensar... ¡Arrancó! HARTAZGO es una comedia negra sobre la argentinidad y los vínculos familiares. Comedia oscura dónde se cruzan todos los fetiches escénicos: Los 80s, Travestismo, las traiciones familiares, melodrama, Lesbianismo, matriarcas perversas, hijxs que se rebelan, venganzas y humor, bastante humor, para contar la historia de una familia en un país a punto de estallar en pleno diciembre del 2001. Es un culebrón teatral impregnado de denuncia social que pone al descubierto el solapado avance del fascismo con aquella huida en helicóptero. La derecha siempre estuvo ahí, agazapada esperando la noche para avanzar, despacio, monstruosa, impune... Todo esto y mucho más es lo que vas a encontrar hasta el HARTAZGO. Una obra estrenada en Feliza Bar Cultural en el 2023, lleva un recorrido de más de 30 funciones en la cartelera del under porteño.', NULL, 'Teatro El Deseo', '2026-03-01', '2026-05-30', 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/56/000312056.jpg',
  NULL, NULL),

('Hansel y Gretel',
  (SELECT id FROM obras WHERE title = 'Hansel y Gretel'),
  NULL,
  '¿Quécontamos? Las aventuras de dos hermanos en un peligroso bosque enfrentados a una particular bruja. ¿Qué rescatamos? Las diferentes versiones de una misma situación dependiendo siempre de los intereses de quién la cuenta.', NULL, 'La Galera Encantada', '2026-03-01', '2026-07-31', 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/49/000294949.jpg',
  NULL, NULL),

('Los tres chanchitos',
 (SELECT id FROM obras WHERE title = 'Los tres chanchitos'),
 NULL,
 'Las desventuras de tres chanchitos perseguidos por el lobo feroz, una historia clásica reimaginada con humor y música para toda la familia.',
 'Héctor Presa', 'La Galera Encantada', '2026-03-01', '2026-07-31',
 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/00/000291400.jpg',
 NULL, NULL),

('Un jueves largo y verde',
  (SELECT id FROM obras WHERE title = 'Un jueves largo y verde'),
  NULL,
  '19° Ciclo TEATRO X LA JUSTICIAObra Inédita seleccionada para la edición 2025.Nicolás vio a Delia en una plaza un jueves donde todo era invisible, donde sobrevolaba la desesperanza, donde no había nada más que tristeza. Delia aparece ofreciéndole a Nicolás una oportunidad donde pensaba que no existía. Delia baila en los recuerdos de su conciencia. Nicolas logró verla y luego Nunca Más.', NULL, 'Tadron Teatro', '2026-03-01', '2026-05-30', 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/78/000303778.jpg',
  NULL, NULL),

('Diente por diente',
  (SELECT id FROM obras WHERE title = 'Diente por diente'),
  NULL,
  'Una novia de punta en blanco sufre un golpe de mala suerte el día de su tan ansiado casamiento, ese accidente le dejará una marca inesperada, transformando su sueño en una pesadilla. Pero eso no es todo: una rata gigante se presenta en medio de su fiesta, desencadenando un sin fin de temores y oscuridades, propios de nuestros miedos más profundos. Antes de continuar con la fiesta la novia deberá enfrentarse con sus miedos y exorcizarlos para encontrarse nuevamente con ella.', NULL, 'Sala del Café Artigas', '2026-03-01', '2026-05-30', 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/38/000300838.jpg',
  NULL, NULL),

-- Producciones nuevas scrapeadas
('La Wagner',
 (SELECT id FROM obras WHERE title = 'La Wagner'),
 NULL,
 'En La Wagner, cuatro mujeres, como cuatro valquirias, se montan sobre la música de Richard Wagner y arremeten con la tarea de desactivar estereotipos y denunciar prejuicios relacionados con la feminidad, la violencia, la sexualidad, el erotismo y la pornografía.',
 'Pablo Rotemberg', 'Espacio Callejón', '2026-03-31', '2026-03-31',
 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/08/000185508.jpg',
 NULL, 'https://alternativateatral.com/obra29154-la-wagner'),

('Ricardo Behrens — INMERSIVO',
 (SELECT id FROM obras WHERE title = 'Ricardo Behrens — INMERSIVO'),
 NULL,
 'Humor y Teatralidad generados de manera espontánea. En un clima de ameno y festivo convivio el público es invitado a co-crear juego teatral sobre el escenario.',
 'Ricardo Behrens', 'La Sede Teatro', '2026-04-18', '2026-05-16',
 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/51/000294651.jpg',
 NULL, 'https://alternativateatral.com/obra4346-ricardo-behrens-inmersivo'),

('I Love Stand Up — Stand up show',
 (SELECT id FROM obras WHERE title = 'I Love Stand Up — Stand up show'),
 NULL,
 'El show de mayor crecimiento y mejor crítica por parte del público. Comediantes que tocan temas de la vida cotidiana con un tono humorístico, reflexionando y haciéndo reír al público.',
 NULL, 'The Cavern Buenos Aires', '2026-01-01', '2026-12-25',
 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/44/000199744.jpg',
 NULL, 'https://alternativateatral.com/obra25225-i-love-stand-up-stand-up-show'),

('Nada del Amor me produce envidia',
 (SELECT id FROM obras WHERE title = 'Nada del Amor me produce envidia'),
 NULL,
 'Un melodrama musical cuyo anclaje es el mundo de las cancionistas argentinas de los años 30. Tomando como punto de partida el mítico cachetazo que aparentemente Libertad Lamarque le habría dado a Eva Perón.',
 'Diego Lerman', 'Fundación SAGAI', '2026-04-13', '2026-04-13',
 'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/07/000295707.jpg',
 NULL, 'https://alternativateatral.com/obra12329-nada-del-amor-me-produce-envidia'),

('NoNiNaS Tango — Vida y obra de Astor Piazzolla',
  (SELECT id FROM obras WHERE title = 'NoNiNaS Tango — Vida y obra de Astor Piazzolla'),
  NULL,
  'Un recorrido por la vida y obra musical de Astor Piazzolla Noninas Tango es un espectáculo audiovisual en el que se combinan la música, la actuación y la imagen. Nos permite recorrer la vida personal y musical de Astor Piazzolla desde una visión poética, relatada por las mujeres que mejor lo conocieron: Nadia Boulanger, Amelita Baltar, Dedé Piazzolla, Laura Escalada, Lulú Ferrer, Zita Troilo. Ellas nos invitan a conocer distintas facetas de su personalidad y su vida musical.',
  'Clarisa Álvarez', 'Centro Municipal de Arte', '2026-03-27', '2026-03-27',
  'https://img.alternativateatral.com/scripts/es/fotos/obras/resumen/81/000304981.jpg',
  NULL, 'https://alternativateatral.com/obra68522-noninas-tango-vida-y-obra-de-astor-piazzolla');

-- 5. Funciones (shows reales — datos de la cartelera marzo/abril 2026)

-- La Revista del Cervantes (múltiples días)
INSERT INTO shows (production_id, show_date, show_time, theater) VALUES
((SELECT id FROM productions WHERE name = 'La Revista del Cervantes'), '2026-03-27', '20:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'La Revista del Cervantes'), '2026-03-28', '20:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'La Revista del Cervantes'), '2026-03-29', '20:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'La Revista del Cervantes'), '2026-04-03', '20:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'La Revista del Cervantes'), '2026-04-04', '20:30', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'La Revista del Cervantes'), '2026-04-05', '20:00', 'Teatro Nacional Cervantes'),

-- Doradas
((SELECT id FROM productions WHERE name = 'Doradas — Temporada 2026'), '2026-03-27', '18:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'Doradas — Temporada 2026'), '2026-03-28', '18:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'Doradas — Temporada 2026'), '2026-03-29', '18:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'Doradas — Temporada 2026'), '2026-04-03', '18:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'Doradas — Temporada 2026'), '2026-04-04', '18:00', 'Teatro Nacional Cervantes'),

-- El ávido espectador
((SELECT id FROM productions WHERE name = 'El ávido espectador'), '2026-03-27', '21:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'El ávido espectador'), '2026-03-28', '21:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'El ávido espectador'), '2026-03-29', '21:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'El ávido espectador'), '2026-04-03', '21:00', 'Teatro Nacional Cervantes'),

-- Nacha & Favero
((SELECT id FROM productions WHERE name = 'Nacha & Favero'), '2026-04-08', '20:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'Nacha & Favero'), '2026-04-15', '20:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'Nacha & Favero'), '2026-04-22', '20:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'Nacha & Favero'), '2026-05-06', '20:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'Nacha & Favero'), '2026-05-13', '20:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'Nacha & Favero'), '2026-05-27', '20:00', 'Teatro Nacional Cervantes'),

-- A navegar Piratas
((SELECT id FROM productions WHERE name = 'A navegar, Piratas!'), '2026-03-28', '16:15', 'Paseo La Plaza'),
((SELECT id FROM productions WHERE name = 'A navegar, Piratas!'), '2026-03-29', '16:15', 'Paseo La Plaza'),

-- La bella durmiente
((SELECT id FROM productions WHERE name = 'La bella durmiente y el ladrón'), '2026-03-28', '17:30', 'Paseo La Plaza'),
((SELECT id FROM productions WHERE name = 'La bella durmiente y el ladrón'), '2026-03-29', '17:30', 'Paseo La Plaza'),
((SELECT id FROM productions WHERE name = 'La bella durmiente y el ladrón'), '2026-04-04', '17:30', 'Paseo La Plaza'),
((SELECT id FROM productions WHERE name = 'La bella durmiente y el ladrón'), '2026-04-05', '17:30', 'Paseo La Plaza'),

-- Experiencia Queen
((SELECT id FROM productions WHERE name = 'Experiencia Queen — Greatest Hits Tour 2026'), '2026-06-04', '20:00', 'Teatro Maipú'),

-- Alma Mahler
((SELECT id FROM productions WHERE name = 'Alma Mahler — Sinfonía de vida, arte y seducción'), '2026-03-29', '20:00', 'Centro Cultural de la Cooperación'),
((SELECT id FROM productions WHERE name = 'Alma Mahler — Sinfonía de vida, arte y seducción'), '2026-04-05', '20:00', 'Centro Cultural de la Cooperación'),
((SELECT id FROM productions WHERE name = 'Alma Mahler — Sinfonía de vida, arte y seducción'), '2026-04-12', '20:00', 'Centro Cultural de la Cooperación'),
((SELECT id FROM productions WHERE name = 'Alma Mahler — Sinfonía de vida, arte y seducción'), '2026-04-26', '20:00', 'Centro Cultural de la Cooperación'),

-- Tamorto
((SELECT id FROM productions WHERE name = 'Tamorto (romance de arlequín y la muerte)'), '2026-03-29', '19:30', 'Auditorio AIC Abasto'),
((SELECT id FROM productions WHERE name = 'Tamorto (romance de arlequín y la muerte)'), '2026-04-05', '19:30', 'Auditorio AIC Abasto'),

-- Circo Transatlántico
((SELECT id FROM productions WHERE name = 'Circo Transatlántico'), '2026-03-29', '20:00', 'Teatro El Extranjero'),
((SELECT id FROM productions WHERE name = 'Circo Transatlántico'), '2026-04-05', '20:00', 'Teatro El Extranjero'),

-- Crónica de una fuga
((SELECT id FROM productions WHERE name = 'Crónica de una fuga'), '2026-03-25', '18:30', 'Fundación SAGAI'),
((SELECT id FROM productions WHERE name = 'Crónica de una fuga'), '2026-04-01', '18:30', 'Fundación SAGAI'),

-- Me encantaría que gustes de mí
((SELECT id FROM productions WHERE name = 'Me encantaría que gustes de mí'), '2026-03-26', '20:30', 'Beckett Teatro'),
((SELECT id FROM productions WHERE name = 'Me encantaría que gustes de mí'), '2026-04-02', '20:30', 'Beckett Teatro'),
((SELECT id FROM productions WHERE name = 'Me encantaría que gustes de mí'), '2026-04-09', '20:30', 'Beckett Teatro'),

-- Un mar incógnito
((SELECT id FROM productions WHERE name = 'Un mar incógnito'), '2026-03-26', '20:30', 'Centro Cultural de la Cooperación'),
((SELECT id FROM productions WHERE name = 'Un mar incógnito'), '2026-04-02', '20:30', 'Centro Cultural de la Cooperación'),

-- Perla Guaraní
((SELECT id FROM productions WHERE name = 'Perla Guaraní'), '2026-03-23', '20:00', 'Fundación SAGAI'),
((SELECT id FROM productions WHERE name = 'Perla Guaraní'), '2026-03-30', '20:00', 'Fundación SAGAI'),
((SELECT id FROM productions WHERE name = 'Perla Guaraní'), '2026-04-06', '20:00', 'Fundación SAGAI'),

-- Carnelli
((SELECT id FROM productions WHERE name = 'Carnelli, algo que tiembla cederá'), '2026-03-26', '20:00', 'Centro Cultural de la Cooperación'),
((SELECT id FROM productions WHERE name = 'Carnelli, algo que tiembla cederá'), '2026-04-02', '20:00', 'Centro Cultural de la Cooperación'),

-- La ceremonia
((SELECT id FROM productions WHERE name = 'La ceremonia'), '2026-03-26', '20:30', 'Sala del Café Artigas'),
((SELECT id FROM productions WHERE name = 'La ceremonia'), '2026-04-02', '20:30', 'Sala del Café Artigas'),

-- AMOR/VENENO
((SELECT id FROM productions WHERE name = 'AMOR/VENENO — Tangos y Boleros'), '2026-03-29', '16:00', 'Teatro El Desguace'),
((SELECT id FROM productions WHERE name = 'AMOR/VENENO — Tangos y Boleros'), '2026-04-05', '16:00', 'Teatro El Desguace'),

-- ¡HARTAZGO!
((SELECT id FROM productions WHERE name = '¡HARTAZGO!'), '2026-03-29', '21:00', 'Teatro El Deseo'),
((SELECT id FROM productions WHERE name = '¡HARTAZGO!'), '2026-04-05', '21:00', 'Teatro El Deseo'),

-- Hansel y Gretel
((SELECT id FROM productions WHERE name = 'Hansel y Gretel'), '2026-03-29', '16:00', 'La Galera Encantada'),
((SELECT id FROM productions WHERE name = 'Hansel y Gretel'), '2026-04-05', '16:00', 'La Galera Encantada'),

-- Los tres chanchitos
((SELECT id FROM productions WHERE name = 'Los tres chanchitos'), '2026-03-23', '16:00', 'La Galera Encantada'),
((SELECT id FROM productions WHERE name = 'Los tres chanchitos'), '2026-03-28', '16:00', 'La Galera Encantada'),

-- Un jueves largo y verde
((SELECT id FROM productions WHERE name = 'Un jueves largo y verde'), '2026-03-24', '20:00', 'Tadron Teatro'),
((SELECT id FROM productions WHERE name = 'Un jueves largo y verde'), '2026-03-31', '20:00', 'Tadron Teatro'),

-- Diente por diente
((SELECT id FROM productions WHERE name = 'Diente por diente'), '2026-03-29', '20:00', 'Sala del Café Artigas'),
((SELECT id FROM productions WHERE name = 'Diente por diente'), '2026-04-05', '20:00', 'Sala del Café Artigas'),

-- La Wagner
((SELECT id FROM productions WHERE name = 'La Wagner'), '2026-03-31', '21:00', 'Espacio Callejón'),

-- Ricardo Behrens INMERSIVO
((SELECT id FROM productions WHERE name = 'Ricardo Behrens — INMERSIVO'), '2026-04-18', '21:00', 'La Sede Teatro'),
((SELECT id FROM productions WHERE name = 'Ricardo Behrens — INMERSIVO'), '2026-05-16', '21:00', 'La Sede Teatro'),

-- I Love Stand Up
((SELECT id FROM productions WHERE name = 'I Love Stand Up — Stand up show'), '2026-03-29', '21:00', 'The Cavern Buenos Aires'),
((SELECT id FROM productions WHERE name = 'I Love Stand Up — Stand up show'), '2026-03-30', '21:00', 'The Cavern Buenos Aires'),
((SELECT id FROM productions WHERE name = 'I Love Stand Up — Stand up show'), '2026-04-05', '21:00', 'The Cavern Buenos Aires'),
((SELECT id FROM productions WHERE name = 'I Love Stand Up — Stand up show'), '2026-04-06', '21:00', 'The Cavern Buenos Aires'),
((SELECT id FROM productions WHERE name = 'I Love Stand Up — Stand up show'), '2026-04-07', '22:30', 'The Cavern Buenos Aires'),
((SELECT id FROM productions WHERE name = 'I Love Stand Up — Stand up show'), '2026-04-11', '22:30', 'The Cavern Buenos Aires'),
((SELECT id FROM productions WHERE name = 'I Love Stand Up — Stand up show'), '2026-04-12', '22:30', 'The Cavern Buenos Aires'),

-- Nada del Amor me produce envidia
((SELECT id FROM productions WHERE name = 'Nada del Amor me produce envidia'), '2026-04-13', '20:00', 'Fundación SAGAI'),

-- NoNiNaS Tango
((SELECT id FROM productions WHERE name = 'NoNiNaS Tango — Vida y obra de Astor Piazzolla'), '2026-03-27', '20:00', 'Centro Municipal de Arte');
