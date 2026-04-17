-- Migration: backfill shows location fields from current seeded theater mapping.
-- This preserves existing non-null values.

UPDATE shows s
SET
    address = COALESCE(s.address, m.address),
    barrio = COALESCE(s.barrio, m.barrio),
    ciudad_partido = COALESCE(s.ciudad_partido, m.ciudad_partido),
    provincia = COALESCE(s.provincia, m.provincia)
FROM (
    VALUES
        ('Teatro Nacional Cervantes', 'Libertad 815', 'Retiro', 'CABA', 'Buenos Aires'),
        ('Paseo La Plaza', 'Av Corrientes 1660', 'San Nicolas', 'CABA', 'Buenos Aires'),
        ('Teatro Maipú', 'Maipú 380', NULL, 'Banfield', 'Buenos Aires'),
        ('Centro Cultural de la Cooperación', 'Corrientes 1543', 'San Nicolas', 'CABA', 'Buenos Aires'),
        ('Auditorio AIC Abasto', 'Humahuaca 3640', 'Almagro', 'CABA', 'CABA'),
        ('Teatro El Extranjero', 'Valentín Gómez 3378', 'Balvanera', 'CABA', 'Buenos Aires'),
        ('Fundación SAGAI', '25 de Mayo 586', 'San Nicolas', 'CABA', 'Buenos Aires'),
        ('Beckett Teatro', 'Guardia Vieja 3556', 'Almagro', 'CABA', 'Buenos Aires'),
        ('Sala del Café Artigas', 'José Gervasio Artigas 1850', 'Villa General Mitre', 'CABA', 'Buenos Aires'),
        ('Teatro El Desguace', 'México 3694', 'Almagro', 'CABA', 'Buenos Aires'),
        ('Teatro El Deseo', 'Saavedra 569', 'Balvanera', 'CABA', 'Buenos Aires'),
        ('La Galera Encantada', 'Humboldt 1591', 'Palermo', 'CABA', 'Buenos Aires'),
        ('Tadron Teatro', 'Niceto Vega 4802', 'Palermo', 'CABA', 'Buenos Aires'),
        ('Espacio Callejón', 'Humahuaca 3759', 'Almagro', 'CABA', 'Buenos Aires'),
        ('La Sede Teatro', 'Sarmiento 1495', 'San Nicolas', 'CABA', 'Buenos Aires'),
        ('The Cavern Buenos Aires', 'Av. Corrientes 1660', 'San Nicolas', 'CABA', 'Buenos Aires'),
        ('Centro Municipal de Arte', 'San Martín 797', NULL, 'Avellaneda', 'Buenos Aires')
) AS m(theater, address, barrio, ciudad_partido, provincia)
WHERE s.theater = m.theater;
