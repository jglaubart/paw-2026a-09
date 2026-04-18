ALTER TABLE users
    ADD COLUMN IF NOT EXISTS image_id INT;

ALTER TABLE users
    DROP CONSTRAINT IF EXISTS users_image_id_fkey;

ALTER TABLE users
    ADD CONSTRAINT users_image_id_fkey
    FOREIGN KEY (image_id) REFERENCES images(id);

CREATE INDEX IF NOT EXISTS idx_users_image_id ON users(image_id);
