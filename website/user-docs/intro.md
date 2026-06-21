---
id: intro
title: Introduction
sidebar_position: 1
---

# AITradingSystem

**AITradingSystem** is a self-hosted, event-driven platform that connects AI-powered market signal analysis to automated trade execution.

It is built around four core ideas:

1. **Triggers are independent.** A trigger is any service that monitors a data source (news APIs, market indicators, social feeds) and publishes structured signals when something worth trading happens. You can run multiple triggers simultaneously, each specializing in a different market or data source.

2. **Trading groups discuss before they act.** When a trigger fires a signal, it is delivered to one or more AI trading groups. Each group runs a multi-agent discussion — analyst, strategist, risk manager — and the group leader makes a final BUY / SELL / NO_TRADE decision.

3. **The platform handles execution.** Once a decision is made, the execution engine places the order on the configured exchange using the group's leverage, margin, and TP/SL settings. Everything is logged and synchronized.

4. **Absolute Modularity.** Every component is plug-and-play. You can write custom triggers and trading groups tailored to your needs, and easily register custom exchange adapters. The central gateway routes messages agnostic of their source and destination implementations.

---

## Who is this for?

| Audience | What you'll do |
|---|---|
| **Operators** (you) | Deploy the platform via Docker, configure trading groups, connect exchange accounts, and monitor the dashboard. |
| **Trigger developers** | Build new signal sources — news scrapers, RSI bots, social monitors — using the trigger integration template. |
| **Strategy developers** | Create or customize trading group logic, LLM providers, system prompts, and decision pipelines. |

---

## What you get out of the box

- 🐳 **One-command Docker Compose deployment** — database, backend API, and frontend dashboard in a single stack.
- 📡 **WebSocket event gateway** — the backbone that connects all components with authentication and routing built in.
- 🧑‍💼 **Admin dashboard** — configure everything via a web UI: markets, symbols, triggers, trading groups, trade accounts.
- 📊 **Execution monitoring** — live order/position tracking with PnL and discussion logs.
- 🔒 **Security hardened** — single-session token enforcement, role-scoped permissions, startup secret guard, security headers.

---

## Next steps

<div style={{display: 'flex', gap: '1rem', flexWrap: 'wrap', marginTop: '1.5rem'}}>
  <a href="/user-guide/quick-start" style={{flex: '1', minWidth: '200px', padding: '1rem', border: '1px solid #1f2937', borderRadius: '8px', textDecoration: 'none', color: 'inherit'}}>
    <strong style={{color: '#10b981'}}>⚡ Quick Start →</strong>
    <p style={{margin: '0.5rem 0 0', fontSize: '0.85rem', color: '#9ca3af'}}>Install in 5 minutes with Docker Compose.</p>
  </a>
  <a href="/user-guide/installation/docker" style={{flex: '1', minWidth: '200px', padding: '1rem', border: '1px solid #1f2937', borderRadius: '8px', textDecoration: 'none', color: 'inherit'}}>
    <strong style={{color: '#10b981'}}>🐳 Installation Guide →</strong>
    <p style={{margin: '0.5rem 0 0', fontSize: '0.85rem', color: '#9ca3af'}}>Full setup walkthrough with all options.</p>
  </a>
</div>
