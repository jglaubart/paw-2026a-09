-- Migration: drop legacy URL columns after image_id rollout

ALTER TABLE productions
    DROP COLUMN IF EXISTS image_url;

ALTER TABLE productoras
    DROP COLUMN IF EXISTS image_url;

ALTER TABLE images
    DROP COLUMN IF EXISTS source_url;
