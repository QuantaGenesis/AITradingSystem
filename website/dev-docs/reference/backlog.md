---
id: backlog
title: Backlog & Pending Features
sidebar_position: 4
---

# Backlog & Pending Features

The following architectural features are designed but not yet implemented in the current runtime:

## Experience System (pgvector)
The database schema supports `experiences` utilizing the `pgvector` extension. However, the runtime pipeline to extract lessons from closed trades via an LLM and the retrieval augmented generation (RAG) loop to inject them into the `experience_retriever` role are currently pending.

## Real-time Exchange User Streams
The Execution Engine currently relies on polling to synchronize order and position state (`ORDER_SYNC_INTERVAL_S`). A real-time WebSocket user data stream from exchanges (e.g., Binance User Data Stream) is needed to reduce latency when positions are manually closed outside the system.

## Scheduled and Conditional Events
The `events` schema supports `trigger_at` (for Scheduled Events) and `condition` (for Conditional Events). However, the background workers (Scheduler and Watcher) required to evaluate these conditions and trigger downstream immediate events are not yet built.

## Multi-Exchange Hedging
The position manager logic is currently optimized for single-exchange linear futures (`oneway` mode). Full support for `hedge` mode and cross-exchange arbitrage routing is pending further development of the Risk Manager module.
