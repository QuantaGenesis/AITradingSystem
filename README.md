# AITradingSystem

<div align="center">
  <p><strong>Event-driven AI trading platform — from market signals to decisions to execution.</strong></p>
</div>

AITradingSystem is a self-hosted platform that connects market triggers to multi-agent AI trading groups, producing reasoned decisions and executing orders on your own infrastructure.

## 📖 Documentation

**[Read the full documentation →](https://docs.quantagenesis.space)**

The documentation covers:
- Complete installation and configuration guides
- Dashboard and trading group walkthroughs
- Developer integration guides for building custom triggers

## ⚡ Quick Start

Get the system running via Docker Compose in under 5 minutes.

### 1. Clone and Configure

```bash
git clone https://github.com/your-org/AITradingSystem.git
cd AITradingSystem
cp .env.example .env
```

Edit `.env` and set the required variables:
```dotenv
POSTGRES_PASSWORD=your_secure_password
AUTH_SECRET=your_32_char_hex_secret
ADMIN_PASSWORD=your_admin_password
```

### 2. Start the Stack

```bash
docker compose up -d
```

### 3. Open Dashboard

Navigate to `http://localhost:3333` and log in with the `admin` account.

## 🧱 Architecture

The platform runs as a set of independent standalone services connected to a central FastAPI backend over WebSocket:

- **Orchestrator Backend**: Validates, persists, and routes events.
- **Trigger Services**: Monitor external data (news, market, social) and publish signals.
- **Trading Group Services**: Run a multi-agent AI discussion on incoming signals and send trade decisions.
- **Execution Engine**: Translates decisions into real orders on Binance or OANDA.

## 📄 License

This project is open-source. See the LICENSE file for details.
