# db-guide

Guia de referencia para tocar la base de datos sin romper entornos existentes.

## Estructura de carpetas

- `db/schema/`: definicion base de tablas y constraints.
- `db/seed/`: datos iniciales para bootstrap local.
- `db/migrations/`: cambios incrementales para bases ya existentes.
- `db/db-guide.md`: esta guia.

## Objetivo

Este proyecto usa un esquema hibrido:

- `schema.sql` define la estructura base actual.
- `seed.sql` carga datos iniciales solo cuando la tabla `productions` esta vacia.
- `migration_*.sql` preserva la evolucion incremental para bases existentes.

No reemplazar migraciones por cambios directos en `schema.sql` cuando hay que preservar datos.

## Orden de ejecucion actual

La app ejecuta scripts desde `WebConfig.databaseInitializer` en este orden:

1. `db/schema/schema.sql`
2. `db/migrations/migration_add_shows_location_columns.sql`
3. `db/seed/seed.sql` (solo si no hay producciones)
4. `db/migrations/migration_users_role.sql`
5. `db/migrations/migration_backfill_shows_location_from_seed_theaters.sql`
6. `db/migrations/migration_play_petitions.sql`
7. `db/migrations/migration_images_for_productions.sql`
8. `db/migrations/migration_drop_legacy_image_urls.sql`
9. `db/migrations/migration_backfill_play_ratings_from_production_ratings.sql`
10. `db/migrations/migration_review_email_identity.sql`
11. `db/migrations/migration_reviews_per_obra.sql`
12. `db/migrations/migration_users_username.sql`
13. `db/migrations/migration_users_image.sql`
14. `db/migrations/migration_users_bio.sql`

Despues de eso se ejecuta logica Java de post-proceso:

- hash de passwords legacy
- avatar default para usuarios sin imagen

## Reglas para nuevas migraciones

1. Crear un archivo nuevo `migration_<tema>.sql` (no editar migraciones historicas ya publicadas).
2. Hacerla idempotente (`IF NOT EXISTS`, `ON CONFLICT`, etc.).
3. Si cambia datos, hacerlo de forma segura y reversible en lo posible.
4. Agregar el `runScript(...)` en `WebConfig` respetando dependencias.
5. No meter scripts de chequeo o arreglos puntuales en el flujo automatico.

## Que NO hacer

- No borrar migraciones usadas por entornos compartidos.
- No ejecutar scripts manuales en startup.
- No asumir que todos los entornos arrancan desde cero.

## Checklist antes de mergear cambios de DB

1. Probar en DB vacia (bootstrap completo).
2. Probar en DB con datos existentes (sin perdida de datos).
3. Verificar que la app levanta sin errores de SQL.
4. Verificar login/perfil/peticiones (tocan columnas migradas de `users` e `images`).
5. Confirmar que no hay referencias a archivos SQL inexistentes.

## Nota para futuras IA

Si tenes que limpiar estructura de scripts, prioriza compatibilidad:

- primero preservar ejecucion actual,
- luego ordenar carpetas y nombres,
- y recien al final evaluar una baseline.
