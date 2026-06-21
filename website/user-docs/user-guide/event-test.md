---
id: event-test
title: Event Test
sidebar_position: 9
---

# Event Test

The Event Test page allows you to manually inject events into the system as if they came from a real trigger. This is an essential tool for testing and validating your trading group configurations without waiting for real market events.

---

## Sending a Test Event

1. Go to **Event Test**.
2. Select a **Preset** (e.g., Immediate Event, Macro Event) to populate the payload, or write your own JSON payload.
3. Ensure the `targets` array includes the name of the trading group you want to test.
4. Click **Send Event**.

You can then switch to the **Trading Groups** page and view the discussion logs to see how the group reacted to your simulated event.
