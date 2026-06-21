---
id: trading-modes
title: Trading Modes
sidebar_position: 5
---

# Trading Modes

AITradingSystem supports three execution modes. Always follow the **Simulated → Sandbox → Live** progression.

---

## Simulated

No exchange API call is made. The system emulates fills internally to validate:
- Routing from trigger → group → execution
- State updates in the database
- Post-trade feedback loops and experience extraction

**Use for:** Initial setup, integration testing, prompt engineering.

---

## Sandbox

Requests are sent to the exchange's testnet or demo endpoints (when supported).

**Use for:** Validating real API credentials, testing order placement logic, checking exchange-specific behavior safely.

:::note
Not all exchanges offer a testnet. Check your exchange's documentation. Binance Futures has a dedicated testnet at `testnet.binancefuture.com`.
:::

---

## Live

Real orders are placed on the exchange mainnet with real capital.

**Use for:** Production trading only, after your simulated and sandbox checks are stable.

:::danger
Only switch to Live mode when:
- The trigger is producing accurate signals
- The trading group discussion produces sensible decisions
- TP/SL levels are correctly configured
- You have validated at least one full cycle in Sandbox mode
:::

---

## Switching modes

Change the mode on the **Trade Account** settings page in Trade Ops. The change takes effect immediately for new orders — existing open positions are not affected.
