---
id: execution
title: Execution Engine
sidebar_position: 4
---

# Execution Engine

The Execution Engine is the backend module responsible for translating trading group decisions into actual exchange orders.

## Architecture

The engine uses an adapter pattern to support multiple exchanges:

- **Execution Gateway Interface**: Defines abstract methods for `create_market_order`, `create_limit_order`, `fetch_positions`, etc.
- **Concrete Adapters**: `BinanceGateway`, `OandaGateway`, etc.

## The Execution Flow

1. A trading group reaches a decision and sends a `post_trade` event via WebSocket.
2. The WebSocket gateway receives the event. If `condition.domain == "trade_decision"`, it passes the payload to the Execution Engine.
3. The Execution Engine maps the payload to an `OrderRequest`.
4. It checks the linked **Trade Account** to see what mode is active:
   - **Simulated**: Skips the exchange entirely; simulates a successful fill.
   - **Sandbox / Live**: Calls the relevant Exchange Adapter to place the order.
5. The order status is saved to the database.

## Position Sync Loop

Because exchanges do not push all state changes instantly via WebSocket to our current adapter implementation, the backend runs a background polling loop to synchronize state.

- **Loop interval**: Defined by `ORDER_SYNC_INTERVAL_S` in `.env`.
- **Order sync**: Checks the exchange for fills on pending limit orders and records them in the database.
- **Position sync**: Compares local database positions against the exchange's position snapshot.
- **Unrealized PnL**: Calculated on the fly using the latest 1-minute close prices from the exchange and stored in the database.

If a position is closed manually on the exchange (outside of AITradingSystem), the sync loop detects this drop in net size and updates the local position status to `closed`, calculating the final realized PnL.
