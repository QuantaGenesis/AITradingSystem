---
id: install-script
title: Install Script
sidebar_position: 3
---

# Install Script

The `install.sh` script automates the full deployment process on a fresh Linux server.

## What it does

The script supports two installation modes:

### Option A: Docker Installation
1. **Dependency Verification**: Confirms `docker` is installed.
2. **Repository Cloning**: Clones the backend and frontend repositories if they do not already exist in the current folder.
3. **Secret Generation**: Automatically generates a secure value for `AUTH_SECRET` in `.env` if not already set.
4. **Database Configuration**:
   - **Self-hosted Database**: Prompts for a PostgreSQL password, automatically generates a `docker-compose.yml` with PostgreSQL and pgvector, and sets up a database container.
   - **External Database**: Prompts for an external database URL, and generates a `docker-compose.yml` without a database container.
5. **Container Orchestration**: Builds the Docker containers when running `setup`.

### Option B: Direct Installation (Bare-metal)
1. **Dependency Verification**: Confirms `python3`, `uv`, `node`, and `pnpm` are installed and available in the system PATH.
2. **Repository Cloning**: Clones the backend and frontend repositories if they do not already exist in the current folder.
3. **Secret Generation**: Automatically generates a secure value for `AUTH_SECRET` in `.env` if not already set.
4. **Database Configuration**: Prompts for the connection URL of an existing PostgreSQL database.
5. **Backend Setup**: Synchronizes Python dependencies using `uv` (creates virtual environments and links them).
6. **Frontend Setup**: Installs and builds frontend dependencies using `pnpm`.

## Usage

1. Create a folder and enter it:
   ```bash
   mkdir AITradingSystem
   cd AITradingSystem
   ```

2. Download the installation script:
   ```bash
   wget https://raw.githubusercontent.com/QuantaGenesis/AITradingSystem/main/install.sh
   chmod +x install.sh
   ```

3. Run the interactive setup to configure your environment:
   ```bash
   ./install.sh setup
   ```

4. Once the setup completes, start the application:
   ```bash
   ./install.sh start
   ```

## Script source

The script lives at the root of the repository: [`install.sh`](https://github.com/QuantaGenesis/AITradingSystem/blob/main/install.sh).

:::note
The script is designed to be idempotent — running it again on an existing installation pulls the latest images and restarts the stack without data loss.
:::
