---
id: intro
title: Developer Introduction
sidebar_position: 1
---

# Developer Introduction

Welcome to the Developer Guide for AITradingSystem.

This section is intended for engineers and technical users who want to understand the underlying architecture of the system or build new integrations (such as custom signal triggers, specialized trading groups, or custom exchange adapters).

## Core Philosophy: Plug-and-Play Modularity

AITradingSystem is designed to be completely decoupled. The core orchestrator handles authentication, persistence, routing, and execution, but does not dictate how signals are analyzed or how decisions are reached. 

This lets developers:
- **Build custom Triggers**: Write services in any language that scan news, read API endpoints, or process indicator feeds, and publish signals over standard WebSockets.
- **Implement custom Trading Group Strategies**: Use the default multi-agent AI discussion service, or build lightweight, deterministic algorithmic bots (like RSI or grid traders) that execute orders directly.
- **Register custom Exchange Adapters**: Implement a subclass of `ExchangeBase` in the backend to support new trading venues seamlessly, leveraging the system's core order lifecycle and position synchronization out of the box.

## What you will find here

- **[Architecture Overview](./architecture/overview)**: How the frontend, backend, database, and standalone services communicate without traditional message brokers.
- **[Event System](./architecture/event-system)**: The core data models driving the platform.
- **[Integration Guides](./integration/trigger)**: Step-by-step instructions for building new Triggers and Trading Groups using WebSocket.
- **[Reference](./reference/event-types)**: Comprehensive lists of event types, system roles, and security policies.

If you are just looking to install and operate the system, please refer to the **[User Guide](/user-guide/intro)** instead.
