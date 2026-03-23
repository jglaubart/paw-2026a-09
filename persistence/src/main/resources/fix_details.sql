UPDATE obras SET synopsis = 'Un grupo de amigos se reune para discutir una obra que acaban de ver. Estructura de cajas chinas donde descubren que la obra habla de ellos mismos.' WHERE id = 3;
UPDATE obras SET synopsis = 'Version divertida del clasico cuento de hadas donde la princesa y un simpatico ladron viven una aventura inesperada.' WHERE id = 6;
UPDATE obras SET synopsis = 'Obra poetica que retrata la vida de Alma Mahler, mujer adelantada a su tiempo que lucho entre su talento como compositora y la vida domestica.' WHERE id = 8;
UPDATE obras SET synopsis = 'Romance teatral entre arlequin y la muerte. Comedia que mezcla el humor con lo existencial.' WHERE id = 9;
UPDATE obras SET synopsis = 'Espectaculo circense que cruza el Atlantico con acrobacia, humor y poesia.' WHERE id = 10;
UPDATE obras SET synopsis = 'Drama basado en la fuga real de un grupo de detenidos durante la ultima dictadura militar argentina.' WHERE id = 11;
UPDATE obras SET synopsis = 'Comedia contemporanea sobre las relaciones, el deseo y la dificultad de conectar con el otro.' WHERE id = 12;
UPDATE obras SET synopsis = 'Exploracion teatral sobre lo desconocido, el misterio y los territorios inexplorados del alma.' WHERE id = 13;
UPDATE obras SET synopsis = 'Drama que explora la identidad guarani y la resistencia cultural a traves del teatro.' WHERE id = 14;
UPDATE obras SET synopsis = 'Obra dramatica contemporanea sobre la fragilidad, la resistencia y aquello que esta a punto de ceder.' WHERE id = 15;

-- Producciones sin director que matchearon mal
UPDATE productions SET direction = 'Carolina Adamovsky', synopsis = 'Homenaje postumo al teatro de Alejandro Zingman. Estructura de cajas chinas.' WHERE obra_id = 3;
UPDATE productions SET direction = 'Pablo Gorlero', synopsis = 'Raquel Ameri, Fabian Vena y Julian Menini. Musica original y proyecciones visuales.' WHERE obra_id = 8;

-- Verificar cuantas producciones no tienen director
