-- Migrate the demo seed user to a BCrypt-encoded password.
-- The hash below encodes "password" with BCrypt cost 10.
-- Only updates rows that still carry the original plain-text value.
UPDATE users
SET    password = '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG'
WHERE  email    = 'demo@platea.com'
AND    password = 'demo1234';
