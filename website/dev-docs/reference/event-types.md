---
id: event-types
title: Event Types
sidebar_position: 1
---

# Event Types

This reference lists the specific event payloads used across the platform.

## Event Discriminator

All JSON payloads sent over WebSocket must include a `type` field at the root level:
- `event`: For business events.
- `system`: For technical logs.

## Business Events (`type: "event"`)

### Immediate Event

Fired by triggers to announce market signals.

```json
{
  "type": "event",
  "event_type": "immediate",
  "priority": 7,
  "targets": ["group_alpha"],
  "title": "BTC dump",
  "payload": "Details...",
  "tags": ["btc"]
}
```

### Post-Trade Decision

Fired by trading groups to request order placement.

```json
{
  "type": "event",
  "event_type": "post_trade",
  "priority": 7,
  "targets": ["trade_execution"],
  "title": "Decision ready",
  "payload": "{\"signal\": {\"action\": \"BUY\", \"qty\": 0.0}}",
  "condition": {
    "domain": "trade_decision",
    "trace": {"correlation_id": "uuid"}
  }
}
```

## System Events (`type: "system"`)

### Standard Log

Used to log errors or info messages.

```json
{
  "type": "system",
  "level": "error",
  "code": "SOME_ERROR_CODE",
  "message": "Human readable message",
  "detail": {}
}
```

### Discussion Log

Special log code parsed by the backend to store discussion results.

```json
{
  "type": "system",
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
