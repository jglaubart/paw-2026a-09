-- ============================================
-- Platea — Datos reales de Alternativa Teatral
-- Fuente: alternativateatral.com (marzo 2026)
-- ============================================

-- 1. Usuario demo
INSERT INTO users (email, password) VALUES ('demo@platea.com', 'demo1234');

-- 2. Obras (pieza teatral base)
INSERT INTO obras (title, synopsis, genre) VALUES
('La Revista del Cervantes', NULL, 'Revista'),
('Doradas', NULL, 'Drama'),
('El ávido espectador', NULL, 'Drama'),
('Nacha & Favero', NULL, 'Musical'),
('A navegar, Piratas!', NULL, 'Infantil'),
('La bella durmiente y el ladrón', NULL, 'Infantil'),
('Experiencia Queen — Greatest Hits Tour 2026', NULL, 'Musical'),
('Alma Mahler — Sinfonía de vida, arte y seducción', NULL, 'Drama'),
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
('Los tres chanchitos', NULL, 'Infantil'),
('Art', NULL, 'Comedia'),
('Hamlet', NULL, 'Tragedia'),
('Un jueves largo y verde', NULL, 'Drama'),
('Diente por diente', NULL, 'Drama');

-- 3. Productoras
INSERT INTO productoras (name, bio, instagram, website) VALUES
('Teatro Nacional Cervantes', 'El teatro nacional de la República Argentina, dedicado a la producción y difusión de las artes escénicas.', 'https://instagram.com/teatrocervantes', 'https://teatrocervantes.gob.ar'),
('Paseo La Plaza', 'Complejo teatral ubicado en la Avenida Corrientes, uno de los principales polos culturales de Buenos Aires.', 'https://instagram.com/paseodelaplaza', 'https://www.paseodelaplaza.com.ar'),
('Timbre 4', 'Compañía y sala independiente fundada por Claudio Tolcachir en el barrio de Boedo.', 'https://instagram.com/timbre4', 'https://timbre4.com'),
('Grupo Catalinas Sur', 'Teatro comunitario del barrio de La Boca, referente del movimiento de teatro comunitario argentino.', 'https://instagram.com/catalinassur', 'https://catalinassur.com.ar');

-- 4. Producciones (puestas reales en cartelera marzo 2026)
INSERT INTO productions (name, obra_id, productora_id, synopsis, direction, theater, start_date, end_date, genre, instagram, website) VALUES
-- Teatro Nacional Cervantes
('La Revista del Cervantes',
 (SELECT id FROM obras WHERE title = 'La Revista del Cervantes'),
 (SELECT id FROM productoras WHERE name = 'Teatro Nacional Cervantes'),
 NULL, NULL, 'Teatro Nacional Cervantes', '2026-03-01', '2026-06-30', 'Revista',
 NULL, 'https://alternativateatral.com/obra95254-la-revista-del-cervantes'),

('Doradas',
 (SELECT id FROM obras WHERE title = 'Doradas'),
 (SELECT id FROM productoras WHERE name = 'Teatro Nacional Cervantes'),
 NULL, NULL, 'Teatro Nacional Cervantes', '2026-03-01', '2026-06-30', 'Drama',
 NULL, 'https://alternativateatral.com/obra99872-doradas'),

('El ávido espectador',
 (SELECT id FROM obras WHERE title = 'El ávido espectador'),
 (SELECT id FROM productoras WHERE name = 'Teatro Nacional Cervantes'),
 NULL, NULL, 'Teatro Nacional Cervantes', '2026-03-01', '2026-06-30', 'Drama',
 NULL, 'https://alternativateatral.com/obra99674-el-avido-espectador'),

('Nacha & Favero',
 (SELECT id FROM obras WHERE title = 'Nacha & Favero'),
 (SELECT id FROM productoras WHERE name = 'Teatro Nacional Cervantes'),
 NULL, NULL, 'Teatro Nacional Cervantes', '2026-03-01', '2026-05-30', 'Musical',
 NULL, 'https://alternativateatral.com/obra99811-nacha-favero'),

-- Paseo La Plaza
('A navegar, Piratas!',
 (SELECT id FROM obras WHERE title = 'A navegar, Piratas!'),
 (SELECT id FROM productoras WHERE name = 'Paseo La Plaza'),
 NULL, NULL, 'Paseo La Plaza', '2026-03-01', '2026-07-31', 'Infantil',
 NULL, 'https://alternativateatral.com/obra99604-a-navegar-piratas'),

('La bella durmiente y el ladrón',
 (SELECT id FROM obras WHERE title = 'La bella durmiente y el ladrón'),
 (SELECT id FROM productoras WHERE name = 'Paseo La Plaza'),
 NULL, NULL, 'Paseo La Plaza', '2026-03-01', '2026-07-31', 'Infantil',
 NULL, NULL),

-- Salas independientes
('Experiencia Queen — Greatest Hits Tour 2026',
 (SELECT id FROM obras WHERE title = 'Experiencia Queen — Greatest Hits Tour 2026'),
 NULL,
 NULL, NULL, 'Teatro Maipú', '2026-03-01', '2026-05-31', 'Musical',
 NULL, 'https://alternativateatral.com/obra99326-experiencia-queen-greatest-hits-tour-2026'),

('Alma Mahler — Sinfonía de vida, arte y seducción',
 (SELECT id FROM obras WHERE title = 'Alma Mahler — Sinfonía de vida, arte y seducción'),
 NULL,
 NULL, NULL, 'Centro Cultural de la Cooperación', '2026-03-01', '2026-05-30', 'Drama',
 NULL, 'https://alternativateatral.com/obra89650-alma-mahler-sinfonia-de-vida-arte-y-seduccion'),

('Tamorto (romance de arlequín y la muerte)',
 (SELECT id FROM obras WHERE title = 'Tamorto (romance de arlequín y la muerte)'),
 NULL,
 NULL, NULL, 'Auditorio AIC Abasto', '2026-03-01', '2026-05-30', 'Comedia',
 NULL, NULL),

('Circo Transatlántico',
 (SELECT id FROM obras WHERE title = 'Circo Transatlántico'),
 NULL,
 NULL, NULL, 'Teatro El Extranjero', '2026-03-01', '2026-05-30', 'Circo',
 NULL, NULL),

('Crónica de una fuga',
 (SELECT id FROM obras WHERE title = 'Crónica de una fuga'),
 NULL,
 NULL, NULL, 'Fundación SAGAI', '2026-03-01', '2026-05-30', 'Drama',
 NULL, NULL),

('Me encantaría que gustes de mí',
 (SELECT id FROM obras WHERE title = 'Me encantaría que gustes de mí'),
 NULL,
 NULL, NULL, 'Beckett Teatro', '2026-03-01', '2026-05-30', 'Comedia',
 NULL, NULL),

('Un mar incógnito',
 (SELECT id FROM obras WHERE title = 'Un mar incógnito'),
 NULL,
 NULL, NULL, 'Centro Cultural de la Cooperación', '2026-03-01', '2026-05-30', 'Drama',
 NULL, NULL),

('Perla Guaraní',
 (SELECT id FROM obras WHERE title = 'Perla Guaraní'),
 NULL,
 NULL, NULL, 'Fundación SAGAI', '2026-03-01', '2026-05-30', 'Drama',
 NULL, NULL),

('Carnelli, algo que tiembla cederá',
 (SELECT id FROM obras WHERE title = 'Carnelli, algo que tiembla cederá'),
 NULL,
 NULL, NULL, 'Centro Cultural de la Cooperación', '2026-03-01', '2026-05-30', 'Drama',
 NULL, NULL),

('La ceremonia',
 (SELECT id FROM obras WHERE title = 'La ceremonia, el suicidio de una idea y la decadencia del poder'),
 NULL,
 NULL, NULL, 'Sala del Café Artigas', '2026-03-01', '2026-05-30', 'Drama',
 NULL, NULL),

('AMOR/VENENO — Tangos y Boleros',
 (SELECT id FROM obras WHERE title = 'AMOR/VENENO — Tangos y Boleros'),
 NULL,
 NULL, NULL, 'Teatro El Desguace', '2026-03-01', '2026-05-30', 'Musical',
 NULL, NULL),

('¡HARTAZGO!',
 (SELECT id FROM obras WHERE title = '¡HARTAZGO! — A la gran familia argentina, salud'),
 NULL,
 NULL, NULL, 'Teatro El Deseo', '2026-03-01', '2026-05-30', 'Comedia',
 NULL, NULL),

('Hansel y Gretel',
 (SELECT id FROM obras WHERE title = 'Hansel y Gretel'),
 NULL,
 NULL, NULL, 'La Galera Encantada', '2026-03-01', '2026-07-31', 'Infantil',
 NULL, NULL),

('Los tres chanchitos',
 (SELECT id FROM obras WHERE title = 'Los tres chanchitos'),
 NULL,
 NULL, NULL, 'La Galera Encantada', '2026-03-01', '2026-07-31', 'Infantil',
 NULL, NULL),

('Un jueves largo y verde',
 (SELECT id FROM obras WHERE title = 'Un jueves largo y verde'),
 NULL,
 NULL, NULL, 'Tadron Teatro', '2026-03-01', '2026-05-30', 'Drama',
 NULL, NULL),

('Diente por diente',
 (SELECT id FROM obras WHERE title = 'Diente por diente'),
 NULL,
 NULL, NULL, 'Sala del Café Artigas', '2026-03-01', '2026-05-30', 'Drama',
 NULL, NULL);

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
((SELECT id FROM productions WHERE name = 'Doradas'), '2026-03-27', '18:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'Doradas'), '2026-03-28', '18:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'Doradas'), '2026-03-29', '18:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'Doradas'), '2026-04-03', '18:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'Doradas'), '2026-04-04', '18:00', 'Teatro Nacional Cervantes'),

-- El ávido espectador
((SELECT id FROM productions WHERE name = 'El ávido espectador'), '2026-03-27', '21:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'El ávido espectador'), '2026-03-28', '21:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'El ávido espectador'), '2026-03-29', '21:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'El ávido espectador'), '2026-04-03', '21:00', 'Teatro Nacional Cervantes'),

-- Nacha & Favero
((SELECT id FROM productions WHERE name = 'Nacha & Favero'), '2026-03-25', '20:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'Nacha & Favero'), '2026-04-01', '20:00', 'Teatro Nacional Cervantes'),
((SELECT id FROM productions WHERE name = 'Nacha & Favero'), '2026-04-08', '20:00', 'Teatro Nacional Cervantes'),

-- A navegar Piratas (sábados y domingos)
((SELECT id FROM productions WHERE name = 'A navegar, Piratas!'), '2026-03-28', '16:15', 'Paseo La Plaza'),
((SELECT id FROM productions WHERE name = 'A navegar, Piratas!'), '2026-03-29', '16:15', 'Paseo La Plaza'),
((SELECT id FROM productions WHERE name = 'A navegar, Piratas!'), '2026-04-04', '16:15', 'Paseo La Plaza'),
((SELECT id FROM productions WHERE name = 'A navegar, Piratas!'), '2026-04-05', '16:15', 'Paseo La Plaza'),

-- La bella durmiente (sábados y domingos)
((SELECT id FROM productions WHERE name = 'La bella durmiente y el ladrón'), '2026-03-28', '17:30', 'Paseo La Plaza'),
((SELECT id FROM productions WHERE name = 'La bella durmiente y el ladrón'), '2026-03-29', '17:30', 'Paseo La Plaza'),
((SELECT id FROM productions WHERE name = 'La bella durmiente y el ladrón'), '2026-04-04', '17:30', 'Paseo La Plaza'),
((SELECT id FROM productions WHERE name = 'La bella durmiente y el ladrón'), '2026-04-05', '17:30', 'Paseo La Plaza'),

-- Experiencia Queen (jueves)
((SELECT id FROM productions WHERE name = 'Experiencia Queen — Greatest Hits Tour 2026'), '2026-03-26', '20:00', 'Teatro Maipú'),
((SELECT id FROM productions WHERE name = 'Experiencia Queen — Greatest Hits Tour 2026'), '2026-04-02', '20:00', 'Teatro Maipú'),
((SELECT id FROM productions WHERE name = 'Experiencia Queen — Greatest Hits Tour 2026'), '2026-04-09', '20:00', 'Teatro Maipú'),

-- Alma Mahler (domingos)
((SELECT id FROM productions WHERE name = 'Alma Mahler — Sinfonía de vida, arte y seducción'), '2026-03-29', '20:00', 'Centro Cultural de la Cooperación'),
((SELECT id FROM productions WHERE name = 'Alma Mahler — Sinfonía de vida, arte y seducción'), '2026-04-05', '20:00', 'Centro Cultural de la Cooperación'),
((SELECT id FROM productions WHERE name = 'Alma Mahler — Sinfonía de vida, arte y seducción'), '2026-04-12', '20:00', 'Centro Cultural de la Cooperación'),

-- Tamorto (domingos)
((SELECT id FROM productions WHERE name = 'Tamorto (romance de arlequín y la muerte)'), '2026-03-29', '19:30', 'Auditorio AIC Abasto'),
((SELECT id FROM productions WHERE name = 'Tamorto (romance de arlequín y la muerte)'), '2026-04-05', '19:30', 'Auditorio AIC Abasto'),

-- Circo Transatlántico (domingos)
((SELECT id FROM productions WHERE name = 'Circo Transatlántico'), '2026-03-29', '20:00', 'Teatro El Extranjero'),
((SELECT id FROM productions WHERE name = 'Circo Transatlántico'), '2026-04-05', '20:00', 'Teatro El Extranjero'),

-- Crónica de una fuga (miércoles)
((SELECT id FROM productions WHERE name = 'Crónica de una fuga'), '2026-03-25', '18:30', 'Fundación SAGAI'),
((SELECT id FROM productions WHERE name = 'Crónica de una fuga'), '2026-04-01', '18:30', 'Fundación SAGAI'),

-- Me encantaría que gustes de mí (jueves)
((SELECT id FROM productions WHERE name = 'Me encantaría que gustes de mí'), '2026-03-26', '20:30', 'Beckett Teatro'),
((SELECT id FROM productions WHERE name = 'Me encantaría que gustes de mí'), '2026-04-02', '20:30', 'Beckett Teatro'),
((SELECT id FROM productions WHERE name = 'Me encantaría que gustes de mí'), '2026-04-09', '20:30', 'Beckett Teatro'),

-- Un mar incógnito (jueves)
((SELECT id FROM productions WHERE name = 'Un mar incógnito'), '2026-03-26', '20:30', 'Centro Cultural de la Cooperación'),
((SELECT id FROM productions WHERE name = 'Un mar incógnito'), '2026-04-02', '20:30', 'Centro Cultural de la Cooperación'),

-- Perla Guaraní (lunes)
((SELECT id FROM productions WHERE name = 'Perla Guaraní'), '2026-03-23', '20:00', 'Fundación SAGAI'),
((SELECT id FROM productions WHERE name = 'Perla Guaraní'), '2026-03-30', '20:00', 'Fundación SAGAI'),
((SELECT id FROM productions WHERE name = 'Perla Guaraní'), '2026-04-06', '20:00', 'Fundación SAGAI'),

-- Carnelli (jueves)
((SELECT id FROM productions WHERE name = 'Carnelli, algo que tiembla cederá'), '2026-03-26', '20:00', 'Centro Cultural de la Cooperación'),
((SELECT id FROM productions WHERE name = 'Carnelli, algo que tiembla cederá'), '2026-04-02', '20:00', 'Centro Cultural de la Cooperación'),

-- La ceremonia (jueves)
((SELECT id FROM productions WHERE name = 'La ceremonia'), '2026-03-26', '20:30', 'Sala del Café Artigas'),
((SELECT id FROM productions WHERE name = 'La ceremonia'), '2026-04-02', '20:30', 'Sala del Café Artigas'),

-- AMOR/VENENO (domingos)
((SELECT id FROM productions WHERE name = 'AMOR/VENENO — Tangos y Boleros'), '2026-03-29', '16:00', 'Teatro El Desguace'),
((SELECT id FROM productions WHERE name = 'AMOR/VENENO — Tangos y Boleros'), '2026-04-05', '16:00', 'Teatro El Desguace'),

-- ¡HARTAZGO! (domingos)
((SELECT id FROM productions WHERE name = '¡HARTAZGO!'), '2026-03-29', '21:00', 'Teatro El Deseo'),
((SELECT id FROM productions WHERE name = '¡HARTAZGO!'), '2026-04-05', '21:00', 'Teatro El Deseo'),

-- Hansel y Gretel (domingos)
((SELECT id FROM productions WHERE name = 'Hansel y Gretel'), '2026-03-29', '16:00', 'La Galera Encantada'),
((SELECT id FROM productions WHERE name = 'Hansel y Gretel'), '2026-04-05', '16:00', 'La Galera Encantada'),

-- Los tres chanchitos (lunes)
((SELECT id FROM productions WHERE name = 'Los tres chanchitos'), '2026-03-23', '16:00', 'La Galera Encantada'),
((SELECT id FROM productions WHERE name = 'Los tres chanchitos'), '2026-03-30', '16:00', 'La Galera Encantada'),

-- Un jueves largo y verde (martes)
((SELECT id FROM productions WHERE name = 'Un jueves largo y verde'), '2026-03-24', '20:00', 'Tadron Teatro'),
((SELECT id FROM productions WHERE name = 'Un jueves largo y verde'), '2026-03-31', '20:00', 'Tadron Teatro'),

-- Diente por diente (domingos)
((SELECT id FROM productions WHERE name = 'Diente por diente'), '2026-03-29', '20:00', 'Sala del Café Artigas'),
((SELECT id FROM productions WHERE name = 'Diente por diente'), '2026-04-05', '20:00', 'Sala del Café Artigas');
