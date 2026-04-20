-- ============================================================================
-- Migration: add phone column to productora_requests
-- ============================================================================

ALTER TABLE productora_requests
    ADD COLUMN IF NOT EXISTS phone VARCHAR(50);
