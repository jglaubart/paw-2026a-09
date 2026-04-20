-- Add email verification fields to users table.
-- Existing users are marked as verified so they keep working.

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS email_verified BOOLEAN NOT NULL DEFAULT TRUE;

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS verification_code VARCHAR(8);

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS verification_code_expires_at TIMESTAMP;

UPDATE users
SET email_verified = TRUE
WHERE email_verified IS NULL;
