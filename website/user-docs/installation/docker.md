---
id: docker
title: Docker Compose Setup
sidebar_position: 1
---

# Docker Compose Setup

AITradingSystem ships as a ready-to-run Docker Compose stack. This page covers everything from prerequisites to production hardening.

## Architecture overview

```
┌─────────────────────────────────────────────┐
│  Host machine                               │
│                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │ database │  │ backend  │  │ frontend │  │
│  │ Postgres │  │ FastAPI  │  │ Nginx    │  │
│  │ :5432    │  │ :8000    │  │ :3333    │  │
│  └──────────┘  └──────────┘  └──────────┘  │
└─────────────────────────────────────────────┘
```

- **database** — PostgreSQL 17 with pgvector extension
- **backend** — FastAPI REST API + WebSocket gateway; auto-runs Alembic migrations on start
- **frontend** — Vue 3 SPA served by Nginx; includes a proxy from `/api` → backend

Trigger services and trading group services run as **separate processes** outside this stack. They connect to the backend via WebSocket.

---

## Install script

The repository includes an interactive install script that handles prerequisites, environment setup, and service management.

To download and run:

```bash
wget https://raw.githubusercontent.com/QuantaGenesis/AITradingSystem/main/install.sh
chmod +x install.sh
./install.sh setup
./install.sh start
```

---

## Manual installation

### 1. Clone the repository

```bash
git clone https://github.com/QuantaGenesis/AITradingSystem.git
cd AITradingSystem
```

### 2. Configure environment

```bash
cp .env.example .env
```

Edit `.env` — see the [Environment Reference](./environment) for every variable.

### 3. Start the stack

```bash
docker compose up -d
```

### 4. Check health

```bash
docker compose ps
docker compose logs backend --tail 30
```

Look for `Application startup complete.` in the backend logs. The first boot runs Alembic migrations — this takes a few extra seconds.

---

## Updating

```bash
git pull
docker compose pull        # pull latest images (if pre-built)
docker compose up -d       # restart with new images
```

If there are schema migrations they run automatically on backend restart.

---

## Production checklist

| Item | Action |
|---|---|
| **Strong secrets** | Set unique `POSTGRES_PASSWORD`, `AUTH_SECRET`, `ADMIN_PASSWORD` |
| **CORS locked down** | Set `CORS_ORIGINS=https://your-frontend.com` |
| **Reverse proxy / TLS** | Put Nginx or Caddy in front; enable HTTPS |
| **Firewall** | Backend (`8000`) must not be exposed directly to the internet |
| **Volume backups** | Schedule regular backups of `postgres_data_ai` volume |
| **Log rotation** | Configure Docker log drivers for long-running deployments |

---

## Port reference

| Service | Internal port | Default host port |
|---|---|---|
| backend | 8000 | `127.0.0.1:8888` |
| frontend | 80 | `3333` |
| database | 5432 | *(not exposed by default)* |

The backend is deliberately bound to `127.0.0.1` only — use a reverse proxy to expose it.
