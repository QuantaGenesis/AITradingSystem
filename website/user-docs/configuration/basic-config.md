---
id: basic-config
title: Basic Configuration
sidebar_position: 1
---

# Basic Configuration

Before creating triggers or trading groups, you need to populate the system's **lookup dictionaries** via the **Basic Config** page in the admin dashboard.

These dictionaries define the vocabulary the rest of the system uses.

---

## Markets

A **market** defines the broad asset class. Examples:

| Name | Description |
|---|---|
| `crypto` | Cryptocurrency markets (Binance, etc.) |
| `forex` | Foreign exchange (OANDA, etc.) |
| `stocks` | Equity markets |

---

## Symbols

A **symbol** is a specific tradeable instrument within a market. Examples: `BTCUSDT`, `ETHUSDT`, `EURUSD`.

---

## Intervals

An **interval** sets the primary timeframe for the trading group's analysis. Examples: `1m`, `5m`, `15m`, `1h`, `4h`, `1d`.

---

## Providers

A **provider** is an LLM API integration. You configure the provider name and the API key. Members of trading groups reference a provider + model combination.

Supported provider types include OpenRouter, LiteLLM-compatible endpoints, and gpt4free.

---

## Roles

**Roles** define the function of each AI member inside a trading group.

| Role Code | Function |
|---|---|
| `group_leader` | Synthesizes opinions, makes the final BUY/SELL/NO_TRADE decision. **At least one required.** |
| `technical_analyst` | Analyzes price action, chart patterns, and indicators |
| `news_analyst` | Interprets news events and macro impact |
| `risk_analyst` | Evaluates position sizing, risk/reward, and exposure |
| `experience_retriever` | Surfaces relevant past trade lessons (future capability) |

:::important
Every trading group **must** have at least one member with the `group_leader` role. The service will refuse to process events if no leader is found in the group configuration.
:::

---

## Recommended setup order

1. Add markets → Add symbols → Add intervals
2. Add at least one provider (you'll need an API key)
3. Add roles (`group_leader` is the minimum)
4. Proceed to create Triggers and Trading Groups
