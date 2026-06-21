---
id: trading-group
title: Trading Group Integration Guide
sidebar_position: 2
---

# Trading Group Integration Guide

A **trading group** is a standalone service that connects to the backend, receives market events, runs AI-driven discussion among its members, and sends trade decisions.

## Connection

Connect via WebSocket:

```
ws://localhost:8000/ws/events?trading_group_token=<YOUR_TOKEN>
```

The ack message contains the full configuration for the group, including its members and their roles.

## Receiving Events

Your service should enter a listen loop. The server will push event messages whenever a trigger sends an event whose `targets` include your `group_name`.

```json
{
  "type": "event",
  "event_type": "immediate",
  "id": "uuid-of-persisted-event",
  "source_id": "social_monitor_twitter",
  "priority": 7,
  "targets": ["trade_crypto_btcusdt_15m"],
  "title": "BTC dumps after CPI data",
  "payload": "...",
  "tags": ["btc", "cpi"]
}
```

## Sending Trade Decisions

When the group decides to trade, send a `post_trade` event. The `payload` field must be a JSON-encoded string.

```json
{
  "type": "event",
  "event_type": "post_trade",
  "priority": 7,
  "targets": ["trade_execution"],
  "title": "[trade_crypto_btcusdt_15m] decision ready",
  "payload": "{\"source_id\":\"group_name\",\"symbol\":\"BTCUSDT\",\"signal\":{\"action\":\"SHORT\",\"qty\":0.0,\"margin_usd\":100.0}}",
  "condition": {
    "domain": "trade_decision",
    "trace": {
      "correlation_id": "uuid"
    }
  }
}
```

:::important
- `condition.domain` MUST be `"trade_decision"`.
- The `payload` MUST be a JSON-encoded string.
- Set `qty` to `0.0` to let the backend calculate the quantity based on the `margin_usd` and current price.
:::

## Sending Discussion Logs

After a discussion, log the results via a system message:

```json
{
  "type": "system",
  "level": "info",
  "code": "TRADING_GROUP_DISCUSSION_LOG",
  "message": "discussion completed",
  "detail": {
    "group_id": "uuid",
    "member_opinions": [...],
    "decision": { ... }
  }
}
```

The backend parses the `detail` field and persists it to the `trading_group_discussions` table for display in the UI and for future experience extraction.

---

## Direct / Algorithmic Trading Group Client (No LLM, No Triggers)

If you do not need the LLM-based multi-agent discussion workflow, you can write a lightweight custom bot (in Python, Node.js, Go, etc.) that executes trades directly based on mathematical algorithms (like RSI, MACD, or Bollinger Bands) or external signals.

### Integration Steps

1. **Establish WebSocket Connection**: Connect using the unique Trading Group token:
   ```
   ws://localhost:8000/ws/events?trading_group_token=<YOUR_TRADING_GROUP_TOKEN>
   ```
2. **Listen or Pull Data**: You can query market data feeds directly in your bot, or use the system's WebSocket connection to listen for other events.
3. **Dispatch Orders**: Send a `post_trade` event with the correctly structured payload when your strategy triggers.

### Python Code Template

Here is a ready-to-use template for a direct algorithmic trading bot:

```python
import asyncio
import json
import websockets
from loguru import logger

# Configuration
TOKEN = "your_trading_group_token_here"
WS_URL = f"ws://localhost:8000/ws/events?trading_group_token={TOKEN}"
SYMBOL = "BTCUSDT"

async def monitor_market_and_trade():
    async with websockets.connect(WS_URL) as ws:
        logger.info("Connected to AITradingSystem event gateway.")
        
        # Parse the connection ACK response
        ack = await ws.recv()
        logger.info(f"Received ACK: {ack}")
        
        # Example of sending a BUY trade decision directly.
        # In practice, you would calculate indicators (e.g. RSI) and trigger this.
        logger.info("Strategy triggered: Sending BUY order...")
        
        trade_payload = {
            "source_id": "rsi_algorithmic_bot",
            "symbol": SYMBOL,
            "signal": {
                "action": "LONG",  # LONG, SHORT, or CLOSE
                "qty": 0.0,        # 0.0 lets the backend auto-calculate based on margin_usd
                "margin_usd": 50.0 # Trade size in USD
            }
        }
        
        trade_event = {
            "type": "event",
            "event_type": "post_trade",
            "priority": 10,
            "targets": ["trade_execution"],
            "title": f"[Direct Algorithmic Strategy] LONG {SYMBOL}",
            "payload": json.dumps(trade_payload),
            "condition": {
                "domain": "trade_decision",
                "trace": {
                    "correlation_id": "direct_algo_run_001"
                }
            }
        }
        
        await ws.send(json.dumps(trade_event))
        logger.info("Trade decision event successfully sent.")

if __name__ == "__main__":
    asyncio.run(monitor_market_and_trade())
```
