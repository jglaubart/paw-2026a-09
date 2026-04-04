INSERT INTO play_ratings (user_id, obra_id, score, created_at)
SELECT DISTINCT ON (pr.user_id, p.obra_id)
    pr.user_id,
    p.obra_id,
    pr.score,
    pr.created_at
FROM production_ratings pr
JOIN productions p ON pr.production_id = p.id
LEFT JOIN play_ratings existing ON existing.user_id = pr.user_id AND existing.obra_id = p.obra_id
WHERE existing.id IS NULL
ORDER BY pr.user_id, p.obra_id, pr.created_at DESC, pr.id DESC;
