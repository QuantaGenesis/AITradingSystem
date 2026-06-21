---
id: environment
title: Environment Variables
sidebar_position: 2
---

# Environment Variables

All configuration is done via a `.env` file at the repository root. Copy `.env.example` to `.env` and fill in the required values.

## Required

These variables have no fallback and will cause the server to refuse to start if missing or left at insecure placeholder values.

| Variable | Description |
|---|---|
| `POSTGRES_PASSWORD` | Password for the PostgreSQL `postgres` user. Use a strong random string. |
| `AUTH_SECRET` | HMAC secret used to sign admin access tokens. Must be ≥ 32 characters and not a known placeholder. Generate with: `python3 -c "import secrets; print(secrets.token_hex(32))"` |
| `ADMIN_PASSWORD` | Password for the built-in admin account. |

:::danger Never use placeholder values in production
The backend will **refuse to start** if `AUTH_SECRET` is set to `dev-insecure-secret`, `change-me-please`, or is empty.
:::

---

## Optional

| Variable | Default | Description |
|---|---|---|
| `ADMIN_USERNAME` | `admin` | Login username for the admin account. |
| `CORS_ORIGINS` | `*` | Comma-separated allowed origins for the API. Set to your frontend URL in production (e.g. `https://app.quantagenesis.space`). |
| `FRONTEND_PORT` | `3333` | Host port for the frontend container. |
| `VITE_API_BASE_URL` | *(empty)* | If set, the frontend calls this URL for API requests instead of using the built-in Nginx proxy. Use when the frontend and backend are on separate subdomains. |
| `ORDER_SYNC_INTERVAL_S` | `60` | Background order/position sync interval in seconds (minimum 30). |
| `EXPERIENCE_EXTRACTION_ENABLED` | `true` | Enable the automatic LLM experience extraction loop. |
| `EXPERIENCE_EXTRACTION_INTERVAL_S` | `300` | Interval for the experience extraction cycle in seconds. |
| `EXPERIENCE_LLM_MODEL` | *(empty)* | LLM model used for experience extraction (LiteLLM format, e.g. `openrouter/openai/gpt-4o-mini`). |

---

## Complete `.env.example`

```dotenv
# Database
DATABASE_URL is built automatically from POSTGRES_PASSWORD — you don't need to set it manually.

POSTGRES_PASSWORD=        # ← REQUIRED: choose a strong password

# Auth secret — REQUIRED
# Generate: python3 -c "import secrets; print(secrets.token_hex(32))"
AUTH_SECRET=              # ← REQUIRED

# Admin login
ADMIN_USERNAME=admin
ADMIN_PASSWORD=           # ← REQUIRED

# CORS — set to your frontend URL in production
CORS_ORIGINS=*

# Frontend port on the host machine
FRONTEND_PORT=3333

# Set only if frontend and backend are on different subdomains
VITE_API_BASE_URL=

# Order sync
ORDER_SYNC_INTERVAL_S=60

# Experience system
EXPERIENCE_EXTRACTION_ENABLED=true
EXPERIENCE_EXTRACTION_INTERVAL_S=300
EXPERIENCE_LLM_MODEL=
```
