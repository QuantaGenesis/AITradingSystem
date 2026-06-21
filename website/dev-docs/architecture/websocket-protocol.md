---
id: websocket-protocol
title: WebSocket Protocol
sidebar_position: 3
---

# WebSocket Protocol

The core backend orchestrator provides a single WebSocket gateway endpoint for all real-time communication: `/ws/events`.

## Authentication

Clients authenticate by passing a token in the query string. The parameter name determines the client's role:

- **Triggers**: `?trigger_token=<TOKEN>`
- **Trading Groups**: `?trading_group_token=<TOKEN>`

:::danger Security rules
- Passing both tokens simultaneously results in rejection (Code 1008).
- Passing an invalid token results in rejection (Code 1008).
- Only **one active connection per token** is permitted. A second connection attempt with an already-active token is rejected (Code 1008).
:::

## Connection Lifecycle

1. **Connect**: Client connects to `wss://api.quantagenesis.space/ws/events?trading_group_token=xxx`.
2. **Ack**: The server responds immediately with a configuration payload.
3. **Listen Loop**: The client listens for pushed events.
4. **Publish**: The client sends JSON messages asynchronously.
5. **Close**: The server or client closes the connection.

### The Initial Ack Message

Upon successful authentication, the server sends a configuration payload. This is crucial for trading groups, as it contains their specific configuration (symbol, leverage, members, LLM settings) without requiring a separate REST call.

```json
{
  "ok": true,
  "message": "connected",
  "client_id": "trading_group:<uuid>",
  "targets": ["trade_crypto_btcusdt_15m"],
  "config": {
    "group_id": "uuid",
    "group_name": "trade_crypto_btcusdt_15m",
    "market": "crypto",
    "symbol": "BTCUSDT",
    "interval": "15m",
    "members": [ ... ]
  }
}
```

## Message Structure

All messages sent over the WebSocket are JSON strings. The top-level discriminator is the `type` field.

### System Messages

Used for logs, discussion results, and errors.

```json
{
  "type": "system",
  "level": "error",
  "code": "AGENT_RECURSION_LIMIT",
  "message": "Agent hit recursion limit",
  "detail": { ... }
}
```

### Event Messages

Used for business events.

```json
{
  "type": "event",
  "event_type": "immediate",
  "priority": 7,
  "targets": ["trade_crypto_btcusdt_15m"],
  "title": "BTC dump after CPI",
  "payload": "CPI higher than expected..."
}
```

## Server Responses to Client Sends

When a client sends a message, the server processes it and sends an acknowledgment:

- **Event accepted**: `{"ok": true, "message": "accepted", "id": "<uuid>", "dispatched_clients": 1}`
- **System logged**: `{"ok": true, "message": "logged"}`
- **Validation error**: `{"ok": false, "message": "validation_error", "detail": "..."}`
