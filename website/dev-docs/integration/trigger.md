---
id: trigger
title: Trigger Integration Guide
sidebar_position: 1
---

# Trigger Integration Guide

A trigger monitors an external data source and sends market signals to the backend.

## Connection

```text
ws://localhost:8000/ws/events?trigger_token=<YOUR_TOKEN>
```

The connection ACK includes the trigger config and connected trading groups.

```json
{
  "kind": "ack",
  "ok": true,
  "message": "connected",
  "client_id": "trigger:social_twitter:<connection-id>",
  "subscriptions": ["__trigger_config__", "social_twitter"],
  "config": {
    "name": "social_twitter",
    "provider_name": "openrouter",
    "model_name": "openai/gpt-4o-mini",
    "trading_groups": []
  }
}
```

## Sending Signals

```json
{
  "kind": "event",
  "category": "signal",
  "priority": 7,
  "targets": ["trade_crypto_btcusdt_15m"],
  "title": "BTC dump after CPI data",
  "payload": {
    "signal_type": "immediate",
    "sentiment": "bearish",
    "action_window": "now",
    "analysis": "CPI higher than expected at 3.5%. BTC dropped 2.4% in 15 minutes.",
    "affected_symbols": ["BTCUSDT"]
  },
  "tags": ["btc", "cpi", "macro"],
  "trace": {
    "correlation_id": "source-run-id",
    "causation_id": "source-item-id"
  }
}
```

The `payload` field is a JSON object. Do not send a JSON string.

:::warning
Triggers are not allowed to send `category: "decision"` events. Attempting to do so returns `forbidden_event`.
:::

## Sending Logs

```json
{
  "kind": "log",
  "level": "info",
  "code": "TRIGGER_HEARTBEAT",
  "message": "Twitter monitor processed 1500 tweets in the last 5 minutes.",
  "detail": {}
}
```

Do not send `source` or `source_id`; the gateway injects source identity from the trigger token.

