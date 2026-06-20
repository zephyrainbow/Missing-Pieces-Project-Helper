# Missing Pieces Project Helper

Scaffold and implementation guide for a civic full-stack system that highlights listed buildings by **time since last photo upload**.

## Target architecture

- **Frontend:** React + Leaflet (color-coded map pins: red/yellow/green)
- **Backend:** C# .NET Web API (spatial + upload validation logic)
- **Database:** PostgreSQL + PostGIS (NHLE spatial assets + photo timestamps)
- **Data source:** Historic England Open Data Hub / NHLE datasets

See implementation artifacts:

- Database schema: [`/database/schema.sql`](./database/schema.sql)
- API contract: [`/backend/openapi.yaml`](./backend/openapi.yaml)
- CI/CD workflows:
  - [`/.github/workflows/frontend.yml`](./.github/workflows/frontend.yml)
  - [`/.github/workflows/backend.yml`](./.github/workflows/backend.yml)

## Functional requirements covered

1. Store NHLE building geometry and metadata with `last_photo_uploaded_date`.
2. Calculate age-based urgency in SQL (`RED`, `YELLOW`, `GREEN`).
3. Serve spatial JSON data for map rendering and filtering.
4. Accept image uploads and capture EXIF/GPS metadata for proximity validation.
5. Automate frontend and backend CI/CD using GitHub Actions.
