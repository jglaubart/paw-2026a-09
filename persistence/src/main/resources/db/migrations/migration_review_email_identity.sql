ALTER TABLE users
    ALTER COLUMN password DROP NOT NULL;

ALTER TABLE production_reviews
    ADD COLUMN IF NOT EXISTS user_id INT REFERENCES users(id),
    ADD COLUMN IF NOT EXISTS production_id INT REFERENCES productions(id);

UPDATE production_reviews pr
SET user_id = ratings.user_id,
    production_id = ratings.production_id
FROM production_ratings ratings
WHERE pr.rating_id = ratings.id
  AND (pr.user_id IS NULL OR pr.production_id IS NULL);

ALTER TABLE production_reviews
    ALTER COLUMN rating_id DROP NOT NULL;

ALTER TABLE production_reviews
    ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE production_reviews
    ALTER COLUMN production_id SET NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS production_reviews_user_production_idx
    ON production_reviews(user_id, production_id);

UPDATE users
SET password = NULL
WHERE password = '';
