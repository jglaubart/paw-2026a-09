-- Migration: add location columns to existing shows table without data loss
-- Safe to run multiple times.

ALTER TABLE shows ADD COLUMN IF NOT EXISTS address VARCHAR(255);
ALTER TABLE shows ADD COLUMN IF NOT EXISTS barrio VARCHAR(120);
ALTER TABLE shows ADD COLUMN IF NOT EXISTS ciudad_partido VARCHAR(120);
ALTER TABLE shows ADD COLUMN IF NOT EXISTS provincia VARCHAR(120);
