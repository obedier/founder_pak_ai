---
description: "Phase 2: Create project skeleton with typed contracts, stubs, and schema"
---

# Kit Scaffold (Phase 2)

Create the project skeleton so agents can build against real types from sprint 1.
After this phase, the project builds, type-checks, and all endpoints return stubs.

## Steps

### 1. Create project structure
Per docs/ARCHITECTURE.md. Include `/src/`, `/tests/unit/`, `/tests/integration/`,
`/tests/e2e/` (if applicable), `/scripts/`.

### 2. Initialize project
- package.json / pyproject.toml / go.mod / etc.
- Install core dependencies from tech stack decisions
- TypeScript/linting/formatting config (if applicable)
- .gitignore
- .env.example with all needed env vars (no real values)

### 3. Implement shared types
From docs/API_CONTRACTS.md, create typed interfaces for:
- All request/response bodies
- All entity types
- All enum/union types
- All error response shapes
Put in a shared types directory importable by both frontend and backend.

### 4. Create database schema
From docs/DATA_MODEL.md: migration files for all entities, seed script with
representative test data.

**Database setup**:
- If using SQLite: no setup needed, use a file-based DB
- If using Postgres: check if `psql` is available. If so, create the dev database.
  If not, use SQLite as a dev fallback and note Postgres as a production requirement.
- If using Supabase/Firebase/cloud DB: create the schema files but skip local migration.
  Note the cloud setup step in docs/OPEN_QUESTIONS.md for human attention.
- Prefer the simplest DB that works for the MVP. Don't use Postgres if SQLite suffices.

### 5. Create API stubs
For every endpoint in docs/API_CONTRACTS.md: route handler returning
hardcoded response matching the contract shape. All stubs type-check.
Correct HTTP status codes.

### 6. Create test scaffolding
From docs/TEST_STRATEGY.md: set up test runner and config. One example test
per category (unit, integration, e2e). Verify test runner works.

### 7. Verify
- Project builds without errors
- Type-checking passes
- All stub endpoints respond correctly
- Example tests pass

## Completion
Proceed to Phase 2.5 (test generation).
