---
id: roles
title: Roles
sidebar_position: 2
---

# Roles

This is a reference for the default roles defined in the system. When a trading group connects to the backend, it receives a list of its members, and each member is assigned a role.

The trading group logic uses the role code to route the appropriate prompt and data to the LLM agent.

| Role Code | System Prompt / Duty |
|---|---|
| `group_leader` | **Required.** Synthesizes the opinions of all other members. Must output a final decision format containing `action` (BUY/SELL/NO_TRADE), `confidence_pct`, `take_profit`, and `stop_loss`. |
| `technical_analyst` | Receives OHLCV candle data. Analyzes trend, support/resistance, and momentum. |
| `news_analyst` | Receives the event payload (news article, social post). Analyzes sentiment and potential market impact. |
| `risk_analyst` | Focuses on capital preservation. Evaluates the risk/reward ratio of proposed trade setups. |
| `experience_retriever` | (Future) Automatically retrieves past trades with similar contexts and surfaces lessons learned. |
