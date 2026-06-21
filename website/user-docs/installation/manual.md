---
id: manual
title: Manual Installation (Bare-metal)
sidebar_position: 4
---

# Manual Installation (Bare-metal)

If you prefer to deploy AITradingSystem manually without using the interactive `install.sh` script, follow this step-by-step bare-metal installation guide.

---

## Prerequisites

Before starting, ensure your system has the following tools installed and added to your `PATH`:

- **Python** ≥ 3.10 (available as `python3`)
- **uv** (high-performance Python package installer)
- **Node.js** (LTS version recommended)
- **pnpm** (Node package manager)
- **PostgreSQL** (a running database instance is required)

---

## Step 1 — Create Project Directory

Create a unified directory to store both the frontend and backend services:

```bash
mkdir AITradingSystem
cd AITradingSystem
```

---

## Step 2 — Clone the Repositories

Clone the frontend and backend repositories into your project folder:

```bash
# Clone Backend Repository
git clone https://github.com/QuantaGenesis/AITradingSystem-backend.git

# Clone Frontend Repository
git clone https://github.com/QuantaGenesis/AITradingSystem-frontend.git
```

Your folder structure should look like this:
```
AITradingSystem/
├── AITradingSystem-backend/
└── AITradingSystem-frontend/
```

---

## Step 3 — Configure Environment Variables

Each repository requires its own `.env` file for configuration.

### 1. Configure the Backend
Navigate to the backend directory, copy the template, and edit it:

```bash
cd AITradingSystem-backend
cp .env.example .env
```

Open `.env` and fill in the required fields:
- **`DATABASE_URL`**: Set your PostgreSQL connection string (e.g. `postgresql+psycopg://postgres:password@localhost:5432/tradingos`).
- **`AUTH_SECRET`**: Set a unique 32-character security key. Generate one with:
  ```bash
  python3 -c "import secrets; print(secrets.token_hex(32))"
  ```
- **`ADMIN_PASSWORD`**: Choose a strong password for your admin account.
- Update other optional variables like `CORS_ORIGINS`, sync intervals, or LLM models as needed.

### 2. Configure the Frontend
Navigate to the frontend directory and create a `.env` file:

```bash
cd ../AITradingSystem-frontend
touch .env
```

Open the frontend `.env` file and add the URL of your backend API:
```dotenv
VITE_API_BASE_URL=http://127.0.0.1:8000
```

---

## Step 4 — Install and Start the Backend

Navigate back to the backend directory, sync dependencies, run Alembic migrations to set up the database tables, and run the service:

```bash
cd ../AITradingSystem-backend

# Sync dependencies using uv
uv sync

# Run database migrations
uv run alembic upgrade head

# Start the FastAPI server
uv run app/main.py --host 127.0.0.1 --port 8000
```

The backend API is now running at `http://127.0.0.1:8000`. Keep this terminal open or run it using a process manager like `pm2` or `nohup`.

---

## Step 5 — Install and Start the Frontend

In a new terminal window, navigate to the frontend directory, install dependencies, compile the production build, and serve the application:

```bash
cd AITradingSystem/AITradingSystem-frontend

# Install dependencies
pnpm install

# Build for production
pnpm run build

# Start the local preview server on port 3333
pnpm run preview --host 127.0.0.1 --port 3333
```

The frontend dashboard is now running and accessible at `http://127.0.0.1:3333`.
