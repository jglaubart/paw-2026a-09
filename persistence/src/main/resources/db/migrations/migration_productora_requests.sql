-- ============================================================================
-- Migration: Workflow de postulación de productora + membresías
-- Adaptado al schema real (columnas `id`, no `*_id`).
-- ============================================================================

-- 1) EXTENSIÓN DE `productoras` ────────────────────────────────────────────
ALTER TABLE productoras
    ADD COLUMN IF NOT EXISTS cuit           VARCHAR(20),
    ADD COLUMN IF NOT EXISTS contact_email  VARCHAR(255),
    ADD COLUMN IF NOT EXISTS status         VARCHAR(20)  NOT NULL DEFAULT 'APPROVED',
    ADD COLUMN IF NOT EXISTS created_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN IF NOT EXISTS approved_at    TIMESTAMP;

CREATE INDEX IF NOT EXISTS idx_productoras_name_lower ON productoras (LOWER(name));
CREATE INDEX IF NOT EXISTS idx_productoras_status     ON productoras (status);


-- 2) MEMBRESÍAS ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS productora_members (
    user_id        INT          NOT NULL REFERENCES users(id)        ON DELETE CASCADE,
    productora_id  INT          NOT NULL REFERENCES productoras(id)  ON DELETE CASCADE,
    role           VARCHAR(20)  NOT NULL DEFAULT 'MEMBER',
    joined_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, productora_id)
);

CREATE INDEX IF NOT EXISTS idx_prod_members_productora ON productora_members (productora_id);
CREATE INDEX IF NOT EXISTS idx_prod_members_user       ON productora_members (user_id);


-- 3) POSTULACIONES ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS productora_requests (
    id                    SERIAL       PRIMARY KEY,

    user_id               INT          NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    contact_email         VARCHAR(255) NOT NULL,

    name                  VARCHAR(120) NOT NULL,
    cuit                  VARCHAR(20)  NOT NULL,
    bio                   TEXT,
    instagram             VARCHAR(255),
    website               VARCHAR(255),
    cover_image_id        INT          REFERENCES images(id) ON DELETE SET NULL,

    team_description      TEXT,
    team_size             INT,

    previous_works        TEXT,
    supporting_doc_id     INT          REFERENCES images(id) ON DELETE SET NULL,

    status                VARCHAR(20)  NOT NULL DEFAULT 'PENDING',
    admin_notes           TEXT,
    created_at            TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at           TIMESTAMP,
    created_productora_id INT          REFERENCES productoras(id) ON DELETE SET NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_productora_requests_active
    ON productora_requests (user_id)
    WHERE status IN ('PENDING', 'CHANGES_REQUESTED');

CREATE INDEX IF NOT EXISTS idx_productora_requests_status ON productora_requests (status);
CREATE INDEX IF NOT EXISTS idx_productora_requests_user   ON productora_requests (user_id);


-- 4) FIELD-LEVEL FEEDBACK del admin ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS productora_request_field_feedback (
    request_id   INT          NOT NULL REFERENCES productora_requests(id) ON DELETE CASCADE,
    field_name   VARCHAR(60)  NOT NULL,
    feedback     TEXT         NOT NULL,
    PRIMARY KEY (request_id, field_name)
);


-- 5) FK BLANDA en play_petitions ──────────────────────────────────────────
ALTER TABLE play_petitions
    ADD COLUMN IF NOT EXISTS productora_id INT REFERENCES productoras(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_petitions_productora ON play_petitions (productora_id);


-- 6) SEED: productoras existentes quedan APPROVED ─────────────────────────
UPDATE productoras
   SET status      = 'APPROVED',
       approved_at = COALESCE(approved_at, created_at, CURRENT_TIMESTAMP)
 WHERE status IS NULL OR status = '';

-- 7) SEED: admin pasa a ser OWNER de todas las productoras existentes ─────
INSERT INTO productora_members (user_id, productora_id, role)
SELECT u.id, p.id, 'OWNER'
  FROM productoras p
  CROSS JOIN users u
 WHERE u.role = 'ROLE_ADMIN'
   AND NOT EXISTS (
         SELECT 1 FROM productora_members pm
          WHERE pm.productora_id = p.id AND pm.user_id = u.id
       );
