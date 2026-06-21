---
id: automated-trading
title: Automated Trading Workflow
sidebar_position: 2
---

# Automated Trading Setup Guide

This guide walks you through the step-by-step process of configuring a complete, end-to-end automated trading pipeline in AITradingSystem.

The automated trading pipeline consists of three integrated components:
1. **Trade Accounts** (Exchanges) — Stores API keys for order placement.
2. **Trading Groups** (AI Agents) — Performs discussion and executes trades.
3. **Triggers** (Analyzers) — Monitors signals and fires events.

```
┌─────────────────┐       ┌─────────────────┐       ┌──────────────────────┐
│ Trigger Service │ ────► │ Backend Gateway │ ────► │ Trading Group (AI)   │
│ (Analyzers)     │  WS   │ (Central Hub)   │  WS   │ (Analyst/Leader)     │
└─────────────────┘       └────────┬────────┘       └──────────┬───────────┘
                                   │                           │
                                   │                           ▼
                                   │                    [Decision Made]
                                   │                           │
                                   ▼                           ▼
                           ┌───────────────┐           ┌───────────────┐
                           │   Trade Ops   │ ◄──────── │   Execution   │
                           │  (Exchange)   │   Bind    │   (Orders)    │
                           └───────────────┘           └───────────────┘
```

---

## Step 1 — Add Exchange API Keys (Trade Ops)

First, add your exchange API credentials to the system. This allows the execution engine to place orders on your behalf when a trading group reaches a decision.

1. Navigate to **Trade Ops** in the sidebar.
2. Under the **Add Account / Edit Account** form, enter:
   - **Account Name**: A unique identifier (e.g. `bybit_btc_live`).
   - **Exchange**: Choose from **binance**, **okx**, or **bybit**.
   - **API Key** / **API Secret**: Credentials from your exchange account.
   - **Passphrase**: Required if you selected **okx**.
3. Toggle the switches for your preferred mode:
   - **Active**: Check to enable the account.
   - **Simulated**: If enabled, the system logs trades internally and runs them offline without hitting the exchange API. Disable for real/sandbox API execution.
   - **Sandbox**: Enable to direct calls to the exchange's Testnet/Demo Trading environment.
   - **Margin Mode**: Toggle to select **Isolated** (checked) or **Cross** (unchecked).
   - **Trading Mode**: Toggle to select **Hedge** (checked) or **One-way** (unchecked).
4. Click **Save Account**. The system will validate your credentials.

> [!WARNING]
> Always use API keys with minimal permissions. Enable **Futures Trading** only, and **disable withdrawals** for safety.

---

## Step 2 — Configure and Bind a Trading Group

Next, set up the AI agent team responsible for deciding trades for your target symbol.

1. Go to **Trading Groups** in the sidebar.
2. Click **Add Group** and specify your parameters:
   - **Group Name**: e.g., `btc_trend_followers`.
   - **Market**: `crypto`.
   - **Symbol**: e.g., `BTCUSDT`.
   - **Interval**: e.g., `15m`.
   - **Leverage**: Multiplier (e.g. `5` for 5x leverage).
   - **Margin**: Capital per trade in USDT (e.g. `100.0`).
   - **Position Mode**: Match the setting on your exchange (e.g. `oneway`).
3. Add **members** to your group:
   - Configure a technical analyst, news analyst, risk analyst, etc.
   - Assign models/providers (e.g., OpenRouter or Litellm endpoints).
   - **Requirement**: Ensure at least one member is designated as the `group_leader`.
4. In the **Trade Account** section of the group settings, select the account you created in Step 1 (e.g., `bybit_btc_live`) and click **Bind**.
5. Save the group configuration.
6. Once saved, copy the auto-generated **Trading Group Token** from the dashboard table and store it securely.

---

## Step 3 — Configure a Trigger (Signal Source)

Set up a trigger definition in the UI to register the signal source that will feed events to your trading group.

1. Go to **Triggers** in the sidebar.
2. Click **Add Trigger**.
3. Enter a descriptive **Trigger Name** (e.g., `news_analyzer` or `rsi_indicator`).
4. Select the default model provider for parsing signals.
5. Click **Save**.
6. Locate your trigger in the table, copy the auto-generated **Trigger Token**, and store it securely.

---

## Step 4 — Run the Trigger Service (Analyzer)

Now deploy the physical trigger service that listens to market sources, processes them with LLMs, and sends events to the platform.

1. Clone the repository to your host:
   ```bash
   git clone https://github.com/QuantaGenesis/AITradingSystem-analyzer.git
   cd AITradingSystem-analyzer
   ```
2. Copy the environment template:
   ```bash
   cp .env.example .env
   ```
3. Open `.env` in a text editor and populate the following keys:
   - **`EVENT_WS_TRIGGER_TOKEN`**: Paste the **Trigger Token** copied in Step 3.
   - **`EVENT_WS_URL`**: Set to the central backend event gateway, usually `ws://localhost:8000/ws/events`.
   - Configure your news providers (e.g. `NEWS_PROVIDERS=["alpaca"]` or `["coindesk"]`) and their respective API keys if necessary.
   - Configure your LLM library parameters (e.g., `LLM_LIBRARY=litellm`, `API_KEY=your_llm_api_key`).
4. Sync dependencies and run the service:
   ```bash
   uv sync
   python3 run.py
   ```
5. Confirm the status changes to **🟢 Online** under the **Triggers** view in the dashboard.

---

## Step 5 — Run the Trading Group Service

Finally, choose and deploy the service that processes events and makes trade decisions. You have two options depending on your strategy model:

### Option A — Run the Multi-Agent AI Service (LLM-based)
This service receives trigger signals, orchestrates an AI agent discussion, and posts trade decisions back to the gateway.

1. Clone the repository to your host:
   ```bash
   git clone https://github.com/QuantaGenesis/AITradingSystem-tradinggroup.git
   cd AITradingSystem-tradinggroup
   ```
2. Copy the environment template:
   ```bash
   cp .env.example .env
   ```
3. Open `.env` in a text editor and populate the keys:
   - **`TRADING_GROUP_TOKEN`**: Paste the **Trading Group Token** copied in Step 2.
   - **`EVENT_WS_URL`**: Set to the central backend event gateway, usually `ws://localhost:8000/ws/events`.
   - Configure the LLM parameters (e.g., `LLM_LIBRARY=litellm`, `API_KEY=your_llm_api_key`).
4. Sync dependencies and run the service:
   ```bash
   uv sync
   python3 run.py
   ```
5. The service will connect via WebSocket and await signals. When a signal matches the group's name, the agent discussion will fire automatically, and orders will execute on the bound account.

### Option B — Run a Custom Algorithmic Client (Direct Execution)
Alternatively, you can write or run a custom logic bot (such as an RSI/MACD strategy script) that does not use LLMs or trigger services.
1. Create a script that connects to the event gateway WebSocket using your trading group token:
   `ws://localhost:8000/ws/events?trading_group_token=<TRADING_GROUP_TOKEN>`
2. Subscribe to market data internally (via public exchange feeds or custom endpoints).
3. When your local algorithm detects a signal (e.g. RSI crosses below 30 or above 70), send a `post_trade` event payload directly via the WebSocket connection.
4. The system will receive the trade event and execute it on the bound trade account immediately.

See the [Trading Group Integration Guide](/dev-guide/integration/trading-group) for developer code templates and specifications.
