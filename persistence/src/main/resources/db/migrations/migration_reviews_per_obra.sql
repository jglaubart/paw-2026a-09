ALTER TABLE production_reviews
    ADD COLUMN IF NOT EXISTS obra_id INT REFERENCES obras(id);

UPDATE production_reviews pr
SET obra_id = p.obra_id
FROM productions p
WHERE pr.production_id = p.id
  AND pr.obra_id IS NULL;

DELETE FROM production_reviews pr
USING production_reviews newer
WHERE pr.id < newer.id
  AND pr.user_id = newer.user_id
  AND pr.obra_id = newer.obra_id;

ALTER TABLE production_reviews
    ALTER COLUMN obra_id SET NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS production_reviews_user_obra_idx
    ON production_reviews(user_id, obra_id);
