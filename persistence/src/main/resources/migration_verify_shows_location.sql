-- Verification queries for shows location migration.

SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'shows'
  AND column_name IN ('address', 'barrio', 'ciudad_partido', 'provincia')
ORDER BY column_name;

SELECT
    COUNT(*) AS total_shows,
    COUNT(ciudad_partido) AS with_ciudad_partido,
    COUNT(address) AS with_address,
    COUNT(barrio) AS with_barrio,
    COUNT(provincia) AS with_provincia
FROM shows;
