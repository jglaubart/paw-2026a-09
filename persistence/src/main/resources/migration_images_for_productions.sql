-- Migration: map productions/productoras images to images table

CREATE TABLE IF NOT EXISTS images (
    id SERIAL PRIMARY KEY,
    content_type VARCHAR(100) NOT NULL DEFAULT 'image/jpeg',
    content BYTEA NOT NULL
);

ALTER TABLE images
    ADD COLUMN IF NOT EXISTS content_type VARCHAR(100) NOT NULL DEFAULT 'image/jpeg';

ALTER TABLE images
    ADD COLUMN IF NOT EXISTS source_url TEXT;

ALTER TABLE images
    ADD COLUMN IF NOT EXISTS sha256 CHAR(64);

CREATE UNIQUE INDEX IF NOT EXISTS ux_images_sha256 ON images(sha256);

ALTER TABLE productions
    ADD COLUMN IF NOT EXISTS image_id INT;

ALTER TABLE productoras
    ADD COLUMN IF NOT EXISTS image_id INT;

ALTER TABLE productions
    DROP CONSTRAINT IF EXISTS productions_image_id_fkey;

ALTER TABLE productions
    ADD CONSTRAINT productions_image_id_fkey
    FOREIGN KEY (image_id) REFERENCES images(id);

ALTER TABLE productoras
    DROP CONSTRAINT IF EXISTS productoras_image_id_fkey;

ALTER TABLE productoras
    ADD CONSTRAINT productoras_image_id_fkey
    FOREIGN KEY (image_id) REFERENCES images(id);

CREATE INDEX IF NOT EXISTS idx_productions_image_id ON productions(image_id);
CREATE INDEX IF NOT EXISTS idx_productoras_image_id ON productoras(image_id);
