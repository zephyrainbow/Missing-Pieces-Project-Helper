CREATE EXTENSION IF NOT EXISTS postgis;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'building_grade') THEN
        CREATE TYPE building_grade AS ENUM ('I', 'II*', 'II');
    END IF;
END $$;

CREATE TABLE IF NOT EXISTS listed_buildings (
    building_id BIGINT PRIMARY KEY,
    name TEXT NOT NULL,
    grade building_grade NOT NULL,
    geom geometry(GEOMETRY, 4326) NOT NULL,
    last_photo_uploaded_date TIMESTAMPTZ NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_listed_buildings_geom
    ON listed_buildings USING GIST (geom);

CREATE TABLE IF NOT EXISTS building_photos (
    photo_id BIGSERIAL PRIMARY KEY,
    building_id BIGINT NOT NULL REFERENCES listed_buildings(building_id) ON DELETE CASCADE,
    uploaded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    image_url TEXT NOT NULL,
    exif_latitude DOUBLE PRECISION NULL,
    exif_longitude DOUBLE PRECISION NULL,
    exif_captured_at TIMESTAMPTZ NULL,
    uploaded_by TEXT NULL,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS idx_building_photos_building_id_uploaded_at
    ON building_photos (building_id, uploaded_at DESC);

CREATE OR REPLACE VIEW building_photo_audit AS
SELECT
    b.building_id,
    b.name,
    b.grade,
    b.geom,
    b.last_photo_uploaded_date,
    AGE(NOW(), b.last_photo_uploaded_date) AS age_since_last_photo,
    CASE
        WHEN b.last_photo_uploaded_date IS NULL THEN 'RED'
        WHEN b.last_photo_uploaded_date < NOW() - INTERVAL '10 years' THEN 'RED'
        WHEN b.last_photo_uploaded_date < NOW() - INTERVAL '3 years' THEN 'YELLOW'
        ELSE 'GREEN'
    END AS urgency_status
FROM listed_buildings b;

CREATE OR REPLACE FUNCTION sync_last_photo_uploaded_date()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE listed_buildings
    SET last_photo_uploaded_date = COALESCE(
        GREATEST(last_photo_uploaded_date, NEW.uploaded_at),
        NEW.uploaded_at
    ),
    updated_at = NOW()
    WHERE building_id = NEW.building_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_sync_last_photo_uploaded_date ON building_photos;
CREATE TRIGGER trg_sync_last_photo_uploaded_date
AFTER INSERT ON building_photos
FOR EACH ROW EXECUTE FUNCTION sync_last_photo_uploaded_date();
