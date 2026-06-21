---
id: trigger
title: Trigger Integration Guide
sidebar_position: 1
---

# Trigger Integration Guide

A **trigger** is a standalone service that connects to the AITradingSystem backend, monitors an external data source, and sends event messages when something significant happens.

## Connection

Connect via WebSocket using the token provided in the admin UI:

```
ws://localhost:8000/ws/events?trigger_token=<YOUR_TOKEN>
```

Upon successful connection, the server sends a configuration ack:

```json
{
  "ok": true,
  "message": "connected",
  "client_id": "trigger_social_twitter",
  "targets": ["trade_crypto_btcusdt_15m", "trade_crypto_ethusdt_15m"],
  "config": {
    "trigger_name": "social_twitter",
    "provider_name": "openrouter",
    "model_name": "openai/gpt-4o-mini"
  }
}
```

The `targets` array contains the names of all active trading groups. You will use this array to route your events.

## Sending Events

When your trigger detects a signal, send an `immediate` event:

```json
{
  "type": "event",
  "event_type": "immediate",
  "priority": 7,
  "targets": ["trade_crypto_btcusdt_15m"],
  "title": "BTC dump after CPI data",
  "payload": "CPI higher than expected at 3.5%. BTC dropped 2.4% in 15 minutes.",
  "tags": ["btc", "cpi", "macro"]
}
```

:::warning
Triggers are **not allowed** to send `post_trade` events. Attempting to do so will result in a `forbidden_event` error from the server.
:::

## Sending Logs

Send system logs to report errors or significant state changes in your trigger:

```json
{
  "type": "system",
  "level": "info",
  "code": "TRIGGER_HEARTBEAT",
  "message": "Twitter monitor processed 1500 tweets in the last 5 minutes.",
  "detail": {}
}
```

The trigger's "Online" status in the dashboard is determined by checking if the trigger has sent any `event` or `system` message within the last 5 minutes. Sending a periodic heartbeat is recommended if your trigger is quiet.
