ALTER TABLE productions
    ADD COLUMN IF NOT EXISTS duration_minutes INT;

ALTER TABLE productions
    ADD COLUMN IF NOT EXISTS language VARCHAR(100) NOT NULL DEFAULT 'Castellano';

ALTER TABLE play_petitions
    ADD COLUMN IF NOT EXISTS petitioner_user_id INT REFERENCES users(id);

UPDATE play_petitions pp
SET petitioner_user_id = u.id
FROM users u
WHERE pp.petitioner_user_id IS NULL
  AND LOWER(pp.petitioner_email) = LOWER(u.email);

ALTER TABLE play_petitions
    ADD COLUMN IF NOT EXISTS source_obra_id INT REFERENCES obras(id);

ALTER TABLE play_petitions
    ADD COLUMN IF NOT EXISTS source_production_id INT REFERENCES productions(id);

ALTER TABLE play_petitions
    DROP CONSTRAINT IF EXISTS play_petitions_status_check;

ALTER TABLE play_petitions
    ADD CONSTRAINT play_petitions_status_check
    CHECK (status IN ('PENDING', 'CHANGES_REQUESTED', 'APPROVED', 'REJECTED'));

UPDATE play_petitions
SET status = 'CHANGES_REQUESTED'
WHERE status = 'REJECTED';

CREATE TABLE IF NOT EXISTS petition_field_feedback (
    petition_id INT NOT NULL REFERENCES play_petitions(id),
    field_key   VARCHAR(80) NOT NULL,
    comment     TEXT NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (petition_id, field_key)
);
