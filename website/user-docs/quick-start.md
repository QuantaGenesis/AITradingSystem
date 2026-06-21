---
id: quick-start
title: Quick Start
sidebar_position: 2
---

# Quick Start

Get AITradingSystem running in under 5 minutes.

## Prerequisites

Choose your installation method below. The requirements differ depending on whether you run via Docker or Direct (bare-metal) execution.

### Installation Mode Requirements

#### Option A: Docker Installation (Recommended)
- **Docker Engine** ≥ 24 ([Install Docker](https://docs.docker.com/engine/install/))
- **Docker Compose** v2 (typically included with Docker Desktop; run using `docker compose`, not `docker-compose`)

#### Option B: Direct Installation (Bare-metal)
- **Python** ≥ 3.10 (available as `python3`)
- **uv** (high-performance Python package installer and resolver)
- **Node.js** (LTS version recommended)
- **pnpm** (fast, disk-space efficient package manager)
- **PostgreSQL** database (a running database instance is required for direct mode)

### Global Requirements
- **Memory**: 2 GB RAM minimum (4 GB recommended for production)
- **Exchange API Key**: Binance or OANDA (needed only for live execution)

---

## Step 1 — Run the installation script

```bash
mkdir AITradingSystem
cd AITradingSystem
wget https://raw.githubusercontent.com/QuantaGenesis/AITradingSystem/main/install.sh
chmod +x install.sh
./install.sh setup
./install.sh start
```

The script will interactively guide you through:
- Selecting between Docker and Direct (Bare-metal) installation
- Creating your database configuration
- Automatically generating strong secrets for `.env`
- Pulling repositories and starting the services

---

## Step 2 — Check the status

If you chose Docker installation, check that everything is healthy:

```bash
docker compose ps
```

```
NAME                STATUS
tradingos-db        healthy
tradingos-backend   running
tradingos-frontend  running
```

---

## Step 3 — Open the dashboard

Navigate to `http://localhost:3333` (or the port set by `FRONTEND_PORT` in your `.env`).

Log in with:
- **Username**: `admin` (or `ADMIN_USERNAME` from `.env`)
- **Password**: the value you set for `ADMIN_PASSWORD`

---

## Step 4 — Run the workflow

Follow these steps in the dashboard to complete your first end-to-end run:

1. **Basic Config** — add at least one market (e.g. `crypto`), symbol (`BTCUSDT`), interval (`15m`), provider, and role.
2. **Triggers** — create a trigger instance and confirm it shows as **online**.
3. **Trading Groups** — create a group for your symbol, add members (at least one `group_leader`).
4. **Trade Ops** — create a trade account and bind it to your group.
5. **Test Event** — send a test event from the Trading Groups page and watch the discussion + decision flow in real time.
6. **Monitor** — review orders, stats, and system logs in Trade Ops.

---

## What's next?

- 📋 [Docker Compose Setup](./installation/docker) — docker configuration and production hardening
- 💻 [Manual Installation (Bare-metal)](./installation/manual) — step-by-step setup using Python, uv, and pnpm
- ⚙️ [Configuration](./configuration/basic-config) — markets, symbols, providers, roles explained
- 🔌 [Build a Trigger](/dev-guide/integration/trigger) — add your own signal source
