-- Migration: add username column to users
ALTER TABLE users ADD COLUMN IF NOT EXISTS username VARCHAR(100) NOT NULL DEFAULT '';
