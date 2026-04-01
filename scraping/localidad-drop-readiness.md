# Localidad drop readiness

Se normalizo `localidad` para que sea 100% derivable desde `ciudad_partido` + `barrio`.

Regla aplicada:

```sql
CASE WHEN ciudad_partido = 'CABA' AND barrio IS NOT NULL AND barrio <> ''
     THEN barrio || ' - CABA'
     ELSE ciudad_partido
END
```

## Verificacion
- `productions.csv`: rows=1181, localidad actualizada=872, mismatches=0
- `shows.csv`: rows=1443, localidad actualizada=1102, mismatches=0

## SQL sugerido para eliminar `localidad`

```sql
ALTER TABLE productions DROP COLUMN localidad;
ALTER TABLE shows DROP COLUMN localidad;
```

## SQL util para reconstruir `localidad` on-the-fly

```sql
SELECT
  p.id,
  CASE
    WHEN p.ciudad_partido = 'CABA' AND COALESCE(NULLIF(p.barrio, ''), '') <> ''
      THEN p.barrio || ' - CABA'
    ELSE p.ciudad_partido
  END AS localidad_display
FROM productions p;
```
