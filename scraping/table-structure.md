# Estructura propuesta de tablas (scraping + imagenes binarias)

## 1) Tabla `images`

```sql
CREATE TABLE images (
    id BIGSERIAL PRIMARY KEY,
    source_url TEXT,
    mime_type VARCHAR(100) NOT NULL,
    sha256 CHAR(64) NOT NULL UNIQUE,
    content BYTEA NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
```

- Guarda la imagen binaria en `BYTEA`.
- `sha256` evita duplicados de contenido.
- `source_url` conserva trazabilidad del origen.

## 2) Tabla `productoras` (ajuste)

```sql
ALTER TABLE productoras
ADD COLUMN image_id BIGINT REFERENCES images(id);
```

- Cada productora referencia su imagen por FK (`image_id`).

## 3) Tabla `productions` (ajustes)

```sql
ALTER TABLE productions
ADD COLUMN image_id BIGINT REFERENCES images(id),
ADD COLUMN barrio VARCHAR(120),
ADD COLUMN ciudad_partido VARCHAR(120),
ADD COLUMN localidad VARCHAR(255);
```

- `image_id` apunta a `images`.
- `localidad` sigue la regla: `barrio - ciudad/partido` o solo el dato existente.

## 4) Tabla `shows` (ajustes)

```sql
ALTER TABLE shows
ADD COLUMN barrio VARCHAR(120),
ADD COLUMN ciudad_partido VARCHAR(120),
ADD COLUMN localidad VARCHAR(255);
```

- Permite persistir localidad por funcion (snapshot del scraping).
- Alternativa: derivarla por join con `productions` si se quiere evitar redundancia.

## 5) Relacion sugerida

- `productions.image_id -> images.id`
- `productoras.image_id -> images.id`
- `shows.production_id -> productions.id`

## Archivos generados en este run

- `scraping-output/productions.csv`
- `scraping-output/shows.csv`
- `scraping-output/images.csv`

## Carpeta temporal usada para descargas de imagenes

- `/var/folders/3h/8pn15t990kjg8nnvszcsf9zw0000gn/T/platea-images-cache-_rpfy0qf`

