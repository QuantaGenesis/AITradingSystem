---
id: trade-ops
title: Trade Ops
sidebar_position: 7
---

# Trade Ops

The Trade Ops section is where you manage execution accounts, view order history, and monitor system logs.

---

## Trade Accounts

Manage the exchange API keys that allow the system to place real orders.
See the [Trade Accounts](../configuration/trading-accounts) configuration guide for details on setting up and binding accounts.

---

## Order History

View a consolidated list of all orders placed by the system across all trading groups.
You can filter by group, status, and time range.

---

## System Logs

A filtered view of system messages (`type="system"`). This is the primary place to look when troubleshooting issues with execution, trigger connectivity, or trading group discussions.

You can filter by:
- **Level**: `info`, `warn`, `error`
- **Source**: Which component generated the log
- **Code**: The specific event code (e.g., `DECISION_MADE`, `ORDER_FILLED`)
