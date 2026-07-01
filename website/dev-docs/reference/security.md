---
id: security
title: Security
sidebar_position: 3
---

# Security

AITradingSystem incorporates several security controls to protect the backend API and execution environment.

## Token Enforcement

- **Single Session Policy**: A WebSocket token can only be active on one connection at a time. This prevents multiple instances of a trigger or trading group from duplicating signals or decisions.
- **Role Isolation**: Trigger tokens cannot be used to authenticate as a trading group, and vice versa.

## Event Guards

- **Forbidden Events**: The gateway authorizes by event `category`. Triggers may send only `category: "signal"`; trading groups may send only `category: "decision"`.
- **Server-Owned Source**: Clients must not send `source` or `source_id`. The server injects the authenticated identity into persisted rows and outbound event frames.

## Startup Guards

The backend will refuse to start if it detects insecure placeholder values in the `.env` file for critical secrets:
- `AUTH_SECRET` must not be `dev-insecure-secret` or empty.
- Startup fails with a `RuntimeError` if conditions aren't met.

## Network Security

- **CORS Origins**: The REST API validates Cross-Origin Resource Sharing based on the `CORS_ORIGINS` environment variable.
- **Security Headers**: The FastAPI application automatically injects:
  - `X-Content-Type-Options: nosniff`
  - `X-Frame-Options: DENY`
  - `Cache-Control: no-store`
- **Internal Binding**: The FastAPI application inside the Docker container binds only to `127.0.0.1`. It should be exposed to the internet only via a reverse proxy (like Nginx) that handles TLS termination.
