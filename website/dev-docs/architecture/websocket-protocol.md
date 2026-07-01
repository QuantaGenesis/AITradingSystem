---
id: websocket-protocol
title: WebSocket Protocol
sidebar_position: 3
---

# WebSocket Protocol

The backend exposes one real-time gateway: `/ws/events`.

## Authentication

Connect with exactly one token:

- Trigger: `ws://localhost:8000/ws/events?trigger_token=<TOKEN>`
- Trading Group: `ws://localhost:8000/ws/events?trading_group_token=<TOKEN>`

Passing both tokens, neither token, an invalid token, or a token that is already connected closes the socket with code `1008`.

## Envelope

Every frame is a JSON object with `kind`:

| `kind` | Purpose |
|---|---|
| `event` | Domain events: signals, decisions, config updates |
| `log` | Operational logs and discussion logs |
| `ack` | Server acknowledgements |

Event frames also include `category`:

| `category` | Sender | Description |
|---|---|---|
| `signal` | Trigger | Market signal routed to trading groups |
| `decision` | Trading Group | Trade decision routed to execution |
| `config_update` | Backend | Live config push |

`payload` is always a JSON object. Never send JSON encoded as a string.

## Connected ACK

```json
{
  "kind": "ack",
  "ok": true,
  "message": "connected",
  "client_id": "trading_group:<uuid>:<connection-uuid>",
  "subscriptions": ["trade_crypto_btcusdt_15m"],
  "config": {
    "group_id": "uuid",
    "group_name": "trade_crypto_btcusdt_15m",
    "market": "crypto",
    "symbol": "BTCUSDT",
    "interval": "15m",
    "members": []
  }
}
```

## Signal Event

```json
{
  "kind": "event",
  "category": "signal",
  "priority": 7,
  "targets": ["trade_crypto_btcusdt_15m"],
  "title": "BTC dump after CPI",
  "payload": {
    "signal_type": "immediate",
    "sentiment": "bearish",
    "action_window": "now",
    "analysis": "CPI higher than expected...",
    "affected_symbols": ["BTCUSDT"]
  },
  "tags": ["btc", "cpi"],
  "trace": {
    "correlation_id": "signal-run-id",
    "causation_id": "source-article-id"
  }
}
```

## Decision Event

```json
{
  "kind": "event",
  "category": "decision",
  "priority": 7,
  "title": "[trade_crypto_btcusdt_15m] SHORT BTCUSDT @ 62000.0",
  "payload": {
    "symbol": "BTCUSDT",
    "trade_account_id": "uuid-or-null",
    "action": "SHORT",
    "confidence_pct": 75,
    "reasoning": "Momentum confirmed by team analysis.",
    "entry": 62000.0,
    "stop_loss": 63000.0,
    "take_profit": 60000.0,
    "margin_usdt": 100.0
  },
  "trace": {
    "correlation_id": "signal-run-id",
    "causation_id": "trigger-event-uuid",
    "trigger_event_id": "trigger-event-uuid",
    "decision_id": "decision-uuid"
  }
}
```

## Log Frame

```json
{
  "kind": "log",
  "level": "error",
  "code": "AGENT_RECURSION_LIMIT",
  "message": "Agent hit recursion limit",
  "detail": {}
}
```

## Server ACKs

- Event accepted: `{"kind":"ack","ok":true,"message":"accepted","id":"<uuid>","dispatched_clients":1}`
- Log saved: `{"kind":"ack","ok":true,"message":"logged"}`
- Validation error: `{"kind":"ack","ok":false,"message":"validation_error","detail":[...]}`
