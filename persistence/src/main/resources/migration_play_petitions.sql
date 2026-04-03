-- Migration: Play Petitions feature
-- Creates images, genres, play_petitions, and petition_genres tables

CREATE TABLE IF NOT EXISTS images (
    id      SERIAL PRIMARY KEY,
    content_type VARCHAR(100) NOT NULL DEFAULT 'image/jpeg',
    content BYTEA NOT NULL
);

ALTER TABLE images
    ADD COLUMN IF NOT EXISTS content_type VARCHAR(100) NOT NULL DEFAULT 'image/jpeg';

CREATE TABLE IF NOT EXISTS genres (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS play_petitions (
    id                    SERIAL PRIMARY KEY,
    title                 VARCHAR(255) NOT NULL,
    synopsis              TEXT NOT NULL,
    duration_minutes      INT NOT NULL,
    theater               VARCHAR(255) NOT NULL,
    theater_address       VARCHAR(500),
    start_date            DATE NOT NULL,
    end_date              DATE,
    cover_image_id        INT REFERENCES images(id),
    director              VARCHAR(255) NOT NULL,
    petitioner_email      VARCHAR(255) NOT NULL,
    schedule              TEXT,
    ticket_url            VARCHAR(500),
    language              VARCHAR(100) NOT NULL DEFAULT 'Castellano',
    status                VARCHAR(20) NOT NULL DEFAULT 'PENDING'
                          CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED')),
    admin_notes           TEXT,
    created_at            TIMESTAMP NOT NULL DEFAULT NOW(),
    resolved_at           TIMESTAMP,
    created_obra_id       INT REFERENCES obras(id),
    created_production_id INT REFERENCES productions(id)
);

CREATE TABLE IF NOT EXISTS petition_genres (
    petition_id INT NOT NULL REFERENCES play_petitions(id),
    genre_id    INT NOT NULL REFERENCES genres(id),
    PRIMARY KEY (petition_id, genre_id)
);

-- Seed predefined genres
INSERT INTO genres (name) VALUES
    ('Drama'),
    ('Comedia'),
    ('Musical'),
    ('Unipersonal'),
    ('Infantil'),
    ('Tragedia'),
    ('Danza'),
    ('Stand Up'),
    ('Improvisacion'),
    ('Circo'),
    ('Tango'),
    ('Revista')
ON CONFLICT (name) DO NOTHING;
