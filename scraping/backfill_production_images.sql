-- Backfill production images from scraping/images.csv
-- Usage:
--   psql -h <host> -U <user> -d <db> -v images_csv='"/abs/path/to/scraping/images.csv"' -f scraping/backfill_production_images.sql

BEGIN;

CREATE TEMP TABLE staging_images_csv (
    image_id BIGINT,
    entity_type TEXT,
    entity_id BIGINT,
    entity_name TEXT,
    source_url TEXT,
    mime_type TEXT,
    sha256 TEXT,
    content_base64 TEXT,
    temp_file TEXT
);

-- \if :{?images_csv}
-- \else
-- \set images_csv 'scraping/images.csv'
-- \endif
-- \copy staging_images_csv (image_id, entity_type, entity_id, entity_name, source_url, mime_type, sha256, content_base64, temp_file) FROM :'images_csv' WITH (FORMAT csv, HEADER true)
\copy staging_images_csv (image_id, entity_type, entity_id, entity_name, source_url, mime_type, sha256, content_base64, temp_file) FROM '/tmp/images.csv' WITH (FORMAT csv, HEADER true)
INSERT INTO images (content_type, content, source_url, sha256)
SELECT
    COALESCE(NULLIF(s.mime_type, ''), 'image/jpeg') AS content_type,
    decode(s.content_base64, 'base64') AS content,
    NULLIF(s.source_url, '') AS source_url,
    NULLIF(s.sha256, '') AS sha256
FROM staging_images_csv s
WHERE s.entity_type = 'production'
ON CONFLICT (sha256) DO NOTHING;

UPDATE productions p
SET image_id = i.id
FROM staging_images_csv s
JOIN images i ON i.sha256 = s.sha256
WHERE s.entity_type = 'production'
  AND s.entity_id = p.id
  AND p.image_id IS NULL;

UPDATE productions p
SET image_id = i.id
FROM staging_images_csv s
JOIN images i ON i.sha256 = s.sha256
WHERE s.entity_type = 'production'
  AND p.image_id IS NULL
  AND p.image_url IS NOT NULL
  AND p.image_url = s.source_url;

COMMIT;

-- Validation
SELECT COUNT(*) AS productions_total FROM productions;
SELECT COUNT(*) AS productions_with_image_id FROM productions WHERE image_id IS NOT NULL;
SELECT COUNT(*) AS productions_missing_image_id_with_legacy_url
FROM productions
WHERE image_id IS NULL
  AND image_url IS NOT NULL
  AND image_url <> '';
