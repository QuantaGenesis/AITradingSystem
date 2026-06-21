---
id: trading-groups
title: Trading Groups
sidebar_position: 4
---

# Trading Groups

A **trading group** represents the core logical unit that manages strategy execution and risk management for a specific market symbol. 

AITradingSystem offers **two flexible ways** to deploy and use a trading group, catering to both AI-agent workflows and traditional quantitative algorithmic strategies:

### 1. AI-Driven (Multi-Agent Team)
- **How it works**: Connects via WebSocket, listens for signal events pushed by Trigger services, orchestrates a structured group discussion among configured AI agents (e.g. Technical Analyst, News Analyst, Risk Analyst, and Group Leader), and makes a final trade decision.
- **Best for**: Qualitative analysis, sentiment analysis, multi-dimensional market reviews, and reasoning-based strategies using LLMs.

### 2. Direct/Algorithmic Strategy (No LLM Required)
- **How it works**: Connects via WebSocket using the trading group token. It implements a local programmatic strategy (such as RSI, MACD, or Bollinger Bands) by subscribing directly to market data feeds or receiving external signals. When its conditions are met, it sends a correctly formatted trade decision event directly to the platform.
- **Best for**: Traditional high-frequency, logic-driven, or indicator-based strategies. This mode completely bypasses triggers and LLM discussion overhead, minimizing latency and API costs.

---

## Creating a trading group

1. Go to **Trading Groups**.
2. Click **Add Group** and fill in:
   - **Market** — e.g. `crypto`
   - **Symbol** — e.g. `BTCUSDT`
   - **Interval** — e.g. `15m`
   - **Leverage** — multiplier applied to the group's margin
   - **Margin (USDT)** — default capital per trade
   - **Position Mode** — `oneway` or `hedge`
3. Under the **Trade Account** section of the group settings, select the configured exchange account from the dropdown list and click **Bind**.
4. Add **members** — each member needs a role, provider, model, and system prompt.
5. Ensure at least one member has the `group_leader` role.
6. Save and copy the auto-generated **token** immediately.

---

## Members and roles

| Role | Purpose |
|---|---|
| `group_leader` | **Required.** Makes the final decision after consulting all other members. |
| `technical_analyst` | Analyzes price charts and technical indicators |
| `news_analyst` | Interprets the news payload from the trigger event |
| `risk_analyst` | Evaluates risk-reward, leverage, and position sizing |
| `experience_retriever` | Retrieves relevant past trade lessons (future capability) |

Each member can use a different LLM provider and model. The group leader typically uses your most capable model.

---

## Discussion flow

When a trigger event arrives:

```
Receive event
     │
     ▼
Fetch market data (OHLCV snapshot from Binance)
     │
     ▼
All non-leader members analyze in parallel (LLM calls)
     │
     ▼
Leader synthesizes opinions + makes final decision
     │
     ▼
Send decision back to backend (post_trade event)
     │
     ▼
Execution engine places order (if account is bound)
```

---

## Test Event

Use the **Test Event** button to fire a simulated trigger event directly from the dashboard. This is the fastest way to validate your group setup without running a real trigger service.

Select a preset (immediate / macro / market shock) and observe:
- Discussion logs for each member
- The leader's final decision
- Whether the execution hook fires (in Simulated mode)

---

## Connecting a trading group service

Like triggers, trading group services run as standalone Python worker processes. To deploy and run:

1. Clone the trading group repository:
   ```bash
   git clone https://github.com/QuantaGenesis/AITradingSystem-tradinggroup.git
   cd AITradingSystem-tradinggroup
   ```
2. Copy the environment configuration file:
   ```bash
   cp .env.example .env
   ```
3. Open `.env` and set the required variables:
   - **`TRADING_GROUP_TOKEN`**: Paste your copied trading group token.
   - **`EVENT_WS_URL`**: Point to the gateway event server (default: `ws://localhost:8000/ws/events`).
   - Also configure any provider API keys, model fallbacks, or tools.
4. Synchronize dependencies using `uv` and start the agent service:
   ```bash
   uv sync
   python3 run.py
   ```

See the [Trading Group Integration Guide](/dev-guide/integration/trading-group) for the full protocol.
