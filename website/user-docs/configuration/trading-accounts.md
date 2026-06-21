---
id: trading-accounts
title: Trade Accounts
sidebar_position: 2
---

# Trade Accounts

A **trade account** holds the exchange API credentials that the execution engine uses to place real orders. You create and manage trade accounts in the **Trade Ops** section.

---

## Creating a trade account

1. Go to **Trade Ops** in the sidebar.
2. Click **Add Account** (or click **Edit** next to an existing account).
3. Fill in the configuration details:
   - **Name**: A human-readable label for the account (e.g. `bybit_btc_main`).
   - **Exchange**: Select from **binance**, **okx**, or **bybit**.
   - **API Key** / **API Secret**: Your exchange API keys.
   - **Passphrase**: Required for **okx** accounts; optional or empty for others.
   - **Mode**: Choose Simulated, Sandbox, or Live (see [Trading Modes](../user-guide/trading-modes)).
4. Save. The system will attempt to validate the credentials against the exchange immediately.

---

## Binding to a trading group

A trade account must be **bound** to a specific trading group before execution can happen.

1. Go to **Trading Groups**.
2. Select the group you want to link.
3. In the **Trade Account** panel, select the account you created.
4. Click **Bind**.

:::note
You can only bind one trade account to a group at a time. Unbind first before switching to a different account.
:::

---

## Deleting a trade account

Accounts with existing order history are **protected** — they cannot be hard-deleted to preserve audit trails. You can:

- **Unbind** the account from all groups (stops new orders)
- **Archive** the account by leaving it unbound

If you need to remove an account that has no order history, unbind it from all groups first, then delete.

---

## Security note

Exchange API keys are stored encrypted in the database. Use **API keys with minimal permissions** — enable only futures trading (not withdrawals). Create a dedicated sub-account on the exchange for AITradingSystem if possible.
