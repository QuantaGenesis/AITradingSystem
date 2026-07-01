---
id: event-types
title: Event Types
sidebar_position: 1
---

# Event Types

WebSocket frames use `kind` as the top-level discriminator.

| `kind` | Description |
|---|---|
| `event` | Business/domain event |
| `log` | Operational log |
| `ack` | Server acknowledgement |

Business events use `category`.

## Signal

Sent by triggers.

```json
{
  "kind": "event",
  "category": "signal",
  "priority": 7,
  "targets": ["group_alpha"],
  "title": "BTC dump",
  "payload": {
    "signal_type": "immediate",
    "analysis": "Details...",
    "affected_symbols": ["BTCUSDT"]
  },
  "tags": ["btc"],
  "trace": {
    "correlation_id": "uuid"
  }
}
```

## Decision

Sent by trading groups.

```json
{
  "kind": "event",
  "category": "decision",
  "priority": 7,
  "title": "[group_alpha] BUY BTCUSDT @ 62000.0",
  "payload": {
    "symbol": "BTCUSDT",
    "trade_account_id": null,
    "action": "BUY",
    "confidence_pct": 80,
    "reasoning": "Team consensus is bullish.",
    "entry": 62000.0,
    "stop_loss": 61000.0,
    "take_profit": 64000.0,
    "margin_usdt": 100.0
  },
  "trace": {
    "correlation_id": "uuid",
    "causation_id": "trigger-event-uuid",
    "decision_id": "decision-uuid"
  }
}
```

Do not JSON-stringify the decision payload. The gateway derives `side`, `qty`, `order_type`, and execution routing internally.

## Config Update

Sent by the backend.

```json
{
  "kind": "event",
  "category": "config_update",
  "title": "group_config_changed",
  "payload": {
    "reason": "member_updated",
    "config": {}
  }
}
```

## Log

```json
{
  "kind": "log",
  "level": "info",
  "code": "TRADING_GROUP_DISCUSSION_LOG",
  "message": "Discussion finished",
  "detail": {
    "group_id": "uuid",
    "member_opinions": [],
    "decision": {}
  }
}
```
