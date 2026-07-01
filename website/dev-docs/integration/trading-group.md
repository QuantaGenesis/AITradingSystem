---
id: trading-group
title: Trading Group Integration Guide
sidebar_position: 2
---

# Trading Group Integration Guide

A trading group service connects to the backend, receives trigger signals, runs analysis, and sends trade decisions.

## Connection

```text
ws://localhost:8000/ws/events?trading_group_token=<YOUR_TOKEN>
```

The first message is an ACK with group config:

```json
{
  "kind": "ack",
  "ok": true,
  "message": "connected",
  "client_id": "trading_group:<group-id>:<connection-id>",
  "subscriptions": ["trade_crypto_btcusdt_15m"],
  "config": {
    "group_id": "uuid",
    "group_name": "trade_crypto_btcusdt_15m",
    "market": "crypto",
    "symbol": "BTCUSDT",
    "interval": "15m",
    "leverage": 10,
    "margin_usdt": 100.0,
    "members": []
  }
}
```

## Receiving Signals

The gateway forwards signals whose `targets` include your group name.

```json
{
  "kind": "event",
  "category": "signal",
  "id": "trigger-event-uuid",
  "source": "social_monitor_twitter",
  "priority": 7,
  "targets": ["trade_crypto_btcusdt_15m"],
  "title": "BTC dumps after CPI data",
  "payload": {
    "signal_type": "immediate",
    "analysis": "CPI higher than expected...",
    "affected_symbols": ["BTCUSDT"]
  },
  "tags": ["btc", "cpi"],
  "trace": {
    "correlation_id": "signal-run-id"
  },
  "open_positions": []
}
```

## Sending Trade Decisions

Send a `decision` event. `payload` must be an object, not a JSON string.

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
  "tags": ["trade_execution", "decision_made", "trade_crypto_btcusdt_15m"],
  "trace": {
    "correlation_id": "signal-run-id",
    "causation_id": "trigger-event-uuid",
    "trigger_event_id": "trigger-event-uuid",
    "decision_id": "decision-uuid"
  }
}
```

Important rules:

- Do not send `source` or `source_id`; the server injects identity from your token.
- Do not send `targets`; the gateway routes decisions to execution internally.
- Do not send `side`, `qty`, `order_type`, or `price`; execution derives/fills those fields.
- `entry`, `stop_loss`, and `take_profit` must be positive JSON numbers such as `62000.0`. Legacy quoted plain decimals are accepted only for compatibility and are stored as numbers.

## Sending Discussion Logs

```json
{
  "kind": "log",
  "level": "info",
  "code": "TRADING_GROUP_DISCUSSION_LOG",
  "message": "discussion completed",
  "detail": {
    "group_id": "uuid",
    "member_opinions": [],
    "decision": {}
  },
  "trace": {
    "correlation_id": "signal-run-id",
    "decision_id": "decision-uuid"
  }
}
```

The backend persists `TRADING_GROUP_DISCUSSION_LOG` details to the `trading_group_discussions` table.

## Minimal Python Sender

```python
import asyncio
import json
import uuid
import websockets

TOKEN = "your_trading_group_token_here"
WS_URL = f"ws://localhost:8000/ws/events?trading_group_token={TOKEN}"
SYMBOL = "BTCUSDT"

async def send_decision():
    async with websockets.connect(WS_URL) as ws:
        ack = json.loads(await ws.recv())
        print("connected:", ack["client_id"])

        decision = {
            "kind": "event",
            "category": "decision",
            "priority": 10,
            "title": f"[Direct Strategy] BUY {SYMBOL} @ 62000.0",
            "payload": {
                "symbol": SYMBOL,
                "trade_account_id": None,
                "action": "BUY",
                "confidence_pct": 75,
                "reasoning": "Direct algorithmic signal.",
                "entry": 62000.0,
                "stop_loss": 61000.0,
                "take_profit": 64000.0,
                "margin_usdt": 50.0,
            },
            "trace": {
                "correlation_id": f"direct-{uuid.uuid4()}",
                "decision_id": str(uuid.uuid4()),
            },
        }

        await ws.send(json.dumps(decision))
        print(await ws.recv())

asyncio.run(send_decision())
```
