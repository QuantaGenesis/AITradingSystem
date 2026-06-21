---
id: troubleshooting
title: Troubleshooting
sidebar_position: 8
---

# Troubleshooting

## No orders appearing

1. Check that the trade account is **bound** to the trading group.
2. Confirm the account **Mode** — in Simulated mode, orders are emulated; check the discussions panel to see if decisions are being made.
3. Check **Trade Ops → System Logs** filtered to `error` level for the group's source ID.

## Account deletion is blocked

Accounts with existing order history cannot be hard-deleted (audit protection). Unbind the account from all trading groups first, then delete.

## Execution fails with credential error

Inspect the system log entry — the `code` and `detail` fields contain the exchange's error message. Common causes:
- API key permissions too restrictive (requires futures trading permission)
- Wrong API endpoint (testnet key used in live mode or vice versa)
- Signature mismatch — check system clock synchronization

## Trigger shows Offline

The trigger's status is based on whether it has sent any event or system message in the last 5 minutes. Possible causes:
- The trigger service process stopped — check its logs
- The trigger is running but sending no events (all articles filtered out as low priority)
- WebSocket connection lost — the trigger should auto-reconnect with exponential backoff

## Backend won't start — AUTH_SECRET error

```
RuntimeError: AUTH_SECRET is not configured or is set to an insecure placeholder value.
```

Generate a proper secret and update your `.env`:

```bash
python3 -c "import secrets; print(secrets.token_hex(32))"
```

## Two triggers with the same token

Only **one active WebSocket session** is allowed per token. If a second instance tries to connect, it will be rejected with code `1008`. Check for accidentally duplicated `.env` files across trigger instances.

## Safe rollout order

Always follow: **Simulated → Sandbox → Live**

Never go directly to Live mode. Use Simulated to validate the full decision flow, Sandbox to validate exchange connectivity, and only then enable Live.
