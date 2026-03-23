-- Actualizar sinopsis de obras
UPDATE obras SET synopsis = 'Espectaculo de revista estrenado en 1922 por la Compania Internacional de Grandes Revistas. Pieza historica del teatro argentino.' WHERE title = 'La Revista del Cervantes';
UPDATE obras SET synopsis = 'Cinco actrices consagradas se reunen por primera vez en el Cervantes en la madurez de sus carreras. Un manifiesto sobre la fama, el paso del tiempo y las emociones fabricadas.' WHERE title = 'Doradas';
UPDATE obras SET synopsis = 'Un grupo de amigos se reune para discutir una obra de teatro que acaban de ver. A traves de una estructura absurda de cajas chinas, los espectadores descubren que la obra contiene mas sobre ellos mismos de lo esperado.' WHERE title = 'El avido espectador';
UPDATE obras SET synopsis = 'Espectaculo musical que celebra la trayectoria de dos grandes figuras de la escena argentina.' WHERE title = 'Nacha & Favero';
UPDATE obras SET synopsis = 'Aventura teatral para toda la familia donde dos jovenes piratas reciben un misterioso mensaje en una botella que los invita a competir por el titulo de Pirata del Anio.' WHERE title = 'A navegar, Piratas!';
UPDATE obras SET synopsis = 'Version divertida y original del clasico cuento de hadas donde la princesa y un simpatico ladron viven una aventura inesperada.' WHERE title = 'La bella durmiente y el ladron';
UPDATE obras SET synopsis = 'Show que recrea los mas grandes exitos de Queen en una sola noche, transportando al publico a los iconicos conciertos de la banda.' WHERE title = 'Experiencia Queen — Greatest Hits Tour 2026';
UPDATE obras SET synopsis = 'Obra poetica que retrata la vida de Alma Mahler, una mujer adelantada a su tiempo que lucho entre su talento como compositora y las responsabilidades domesticas.' WHERE title = 'Alma Mahler — Sinfonia de vida, arte y seduccion';
UPDATE obras SET synopsis = 'Romance teatral entre arlequin y la muerte. Comedia que mezcla el humor con lo existencial.' WHERE title = 'Tamorto (romance de arlequin y la muerte)';
UPDATE obras SET synopsis = 'Espectaculo circense que cruza el Atlantico con acrobacia, humor y poesia.' WHERE title = 'Circo Transatlantico';
UPDATE obras SET synopsis = 'Drama basado en la fuga real de un grupo de detenidos durante la ultima dictadura militar argentina.' WHERE title = 'Cronica de una fuga';
UPDATE obras SET synopsis = 'Comedia contemporanea sobre las relaciones, el deseo y la dificultad de conectar con el otro.' WHERE title = 'Me encantaria que gustes de mi';
UPDATE obras SET synopsis = 'Exploracion teatral sobre lo desconocido, el misterio y los territorios inexplorados del alma humana.' WHERE title = 'Un mar incognito';
UPDATE obras SET synopsis = 'Drama que explora la identidad guarani y la resistencia cultural a traves del teatro.' WHERE title = 'Perla Guarani';
UPDATE obras SET synopsis = 'Obra dramatica contemporanea sobre la fragilidad, la resistencia y aquello que esta a punto de ceder.' WHERE title = 'Carnelli, algo que tiembla cedera';
UPDATE obras SET synopsis = 'Reflexion teatral sobre el poder, la ideologia y su decadencia.' WHERE title = 'La ceremonia, el suicidio de una idea y la decadencia del poder';
UPDATE obras SET synopsis = 'Espectaculo musical de tangos y boleros que fusiona dos tradiciones musicales latinoamericanas en una velada intima.' WHERE title = 'AMOR/VENENO — Tangos y Boleros';
UPDATE obras SET synopsis = 'Comedia acida sobre la familia argentina contemporanea, sus contradicciones y hartazgos cotidianos.' WHERE title = '¡HARTAZGO! — A la gran familia argentina, salud';
UPDATE obras SET synopsis = 'Adaptacion teatral del clasico cuento de los hermanos Grimm para toda la familia.' WHERE title = 'Hansel y Gretel';
UPDATE obras SET synopsis = 'Version teatral del clasico cuento infantil de los tres cerditos y el lobo feroz.' WHERE title = 'Los tres chanchitos';
UPDATE obras SET synopsis = 'Tres amigos cuestionan su relacion cuando uno compra un cuadro completamente blanco por una fortuna.' WHERE title = 'Art';
UPDATE obras SET synopsis = 'El principe de Dinamarca enfrenta la traicion, la locura y la venganza tras el asesinato de su padre.' WHERE title = 'Hamlet';
UPDATE obras SET synopsis = 'Drama experimental sobre un dia que se estira y se transforma en algo inesperado.' WHERE title = 'Un jueves largo y verde';
UPDATE obras SET synopsis = 'Drama que explora la justicia, la venganza y el vacio existencial.' WHERE title = 'Diente por diente';

-- Actualizar directores en producciones
UPDATE productions SET direction = 'Jose Maria Muscari' WHERE name = 'Doradas';
UPDATE productions SET direction = 'Carolina Adamovsky' WHERE name = 'El avido espectador';
UPDATE productions SET direction = 'Pablo Gorlero' WHERE name = 'Alma Mahler — Sinfonia de vida, arte y seduccion';
UPDATE productions SET direction = 'Leandro Montgomery' WHERE name = 'A navegar, Piratas!';

-- Actualizar sinopsis en producciones
UPDATE productions SET synopsis = 'Cristina Albero, Marta Albertini, Judith Gabbani, Carolina Papaleo y Ginette Reynal por primera vez en el Cervantes. Escrita con colaboracion de inteligencia artificial. 70 minutos.' WHERE name = 'Doradas';
UPDATE productions SET synopsis = 'Estructura de cajas chinas donde los espectadores descubren que la obra habla de ellos mismos. Homenaje postumo al teatro de Alejandro Zingman.' WHERE name = 'El avido espectador';
UPDATE productions SET synopsis = 'Raquel Ameri protagoniza esta obra poetica con musica original, proyecciones visuales y fragmentos de las composiciones de Mahler. Con Fabian Vena y Julian Menini en piano.' WHERE name = 'Alma Mahler — Sinfonia de vida, arte y seduccion';
UPDATE productions SET synopsis = 'Dos jovenes piratas reciben un misterioso mensaje en una botella. Aventura familiar de la Compania Rueda Magica.' WHERE name = 'A navegar, Piratas!';
UPDATE productions SET synopsis = 'Recreacion de los mas grandes exitos de Queen con vestuario autentico e instrumentos originales.' WHERE name = 'Experiencia Queen — Greatest Hits Tour 2026';
