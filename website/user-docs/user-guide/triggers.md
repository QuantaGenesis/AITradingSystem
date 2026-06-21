---
id: triggers
title: Triggers
sidebar_position: 3
---

# Triggers

A **trigger** is a standalone service that monitors a data source and publishes market signals to the platform when it detects something worth trading.

---

## What triggers do

```
Data source (news, market data, social)
        │
        ▼
  Trigger service  ──── WebSocket ────►  Backend Gateway
                                              │
                                              ▼
                                       Trading Group(s)
```

The trigger authenticates with a token, subscribes to the gateway, and sends `event` messages whenever it detects a significant signal. It never places orders directly.

---

## Creating a trigger

1. Go to **Triggers** in the sidebar.
2. Click **Add Trigger**.
3. Enter a name (e.g. `news_crypto_coindesk`). The name becomes the trigger's identity across the platform.
4. Select the default provider and model for this trigger's LLM analysis.
5. Save. The backend generates a unique **token** — copy it immediately.

---

## Connecting a trigger service

Each trigger is a standalone process (like the news analyzer) that runs outside Docker Compose. To deploy and run:

1. Clone the trigger repository:
   ```bash
   git clone https://github.com/QuantaGenesis/AITradingSystem-analyzer.git
   cd AITradingSystem-analyzer
   ```
2. Copy the environment configuration file:
   ```bash
   cp .env.example .env
   ```
3. Open `.env` and set the required variables:
   - **`EVENT_WS_TRIGGER_TOKEN`**: Paste your copied trigger token.
   - **`EVENT_WS_URL`**: Point to the gateway event server (default: `ws://localhost:8000/ws/events`).
   - Also configure any news provider keys and LLM settings.
4. Synchronize dependencies using `uv` and start the trigger service:
   ```bash
   uv sync
   python3 run.py
   ```

Once started, the trigger service will connect to the gateway. Its status in the dashboard will change to **🟢 Online** once it successfully establishes a connection.

---

## Trigger status

| Status | Meaning |
|---|---|
| 🟢 Online | Connected and recently active |
| 🔴 Offline | Not connected or no recent activity |

---

## Security: one session per token

Each trigger token allows **exactly one active WebSocket connection** at a time. If the same token tries to connect while already active, the new connection is rejected with code `1008`. This prevents duplicate signals from the same trigger.

---

## Reference implementations

| Name | Description |
|---|---|
| `AITradingSystem-analyzer` | News analyzer using LangChain + OpenRouter |
| Analyzer v2 (gpt4free) | Identical architecture, uses free LLM APIs |

See the [Trigger Integration Guide](/dev-guide/integration/trigger) to build your own.
