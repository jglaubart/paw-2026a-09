-- Platea — Database Schema
-- Run once against your local PostgreSQL database: platea

CREATE TABLE IF NOT EXISTS images (
    id      SERIAL PRIMARY KEY,
    content BYTEA NOT NULL
);

CREATE TABLE IF NOT EXISTS obras (
    id       SERIAL PRIMARY KEY,
    title    VARCHAR(255) NOT NULL,
    synopsis TEXT,
    genre    VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS productoras (
    id        SERIAL PRIMARY KEY,
    name      VARCHAR(255) NOT NULL,
    bio       TEXT,
    image_id  INT REFERENCES images(id),
    instagram VARCHAR(255),
    website   VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS productions (
    id            SERIAL PRIMARY KEY,
    name          VARCHAR(255) NOT NULL,
    obra_id       INT NOT NULL REFERENCES obras(id),
    productora_id INT REFERENCES productoras(id),
    synopsis      TEXT,
    direction     VARCHAR(255),
    theater       VARCHAR(255),
    start_date    DATE,
    end_date      DATE,
    image_id      INT REFERENCES images(id),
    genre         VARCHAR(100),
    instagram     VARCHAR(255),
    website       VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS shows (
    id            SERIAL PRIMARY KEY,
    production_id INT NOT NULL REFERENCES productions(id),
    show_date     DATE NOT NULL,
    show_time     TIME NOT NULL,
    theater       VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS users (
    id       SERIAL PRIMARY KEY,
    email    VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS play_ratings (
    id         SERIAL PRIMARY KEY,
    user_id    INT NOT NULL REFERENCES users(id),
    obra_id    INT NOT NULL REFERENCES obras(id),
    score      INT NOT NULL CHECK (score >= 1 AND score <= 10),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, obra_id)
);

CREATE TABLE IF NOT EXISTS production_ratings (
    id            SERIAL PRIMARY KEY,
    user_id       INT NOT NULL REFERENCES users(id),
    production_id INT NOT NULL REFERENCES productions(id),
    score         INT NOT NULL CHECK (score >= 1 AND score <= 10),
    created_at    TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, production_id)
);

CREATE TABLE IF NOT EXISTS reviews (
    id                 SERIAL PRIMARY KEY,
    user_id            INT NOT NULL REFERENCES users(id),
    obra_id            INT NOT NULL REFERENCES obras(id),
    body               TEXT NOT NULL,
    rating_id          INT NOT NULL REFERENCES play_ratings(id),
    contains_spoilers  BOOLEAN NOT NULL DEFAULT FALSE,
    created_at         TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, obra_id)
);

CREATE TABLE IF NOT EXISTS watchlist (
    user_id       INT NOT NULL REFERENCES users(id),
    production_id INT NOT NULL REFERENCES productions(id),
    added_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, production_id)
);
