---
id: experiences
title: Experiences
sidebar_position: 10
---

# Experiences

The Experience System (currently in development) is designed to learn from every completed trade.

When a position is closed, the system will extract the discussion logs, the market context, and the final PnL. An LLM will review this package to extract a "lesson learned."

These lessons will be stored as vector embeddings. During future discussions, the `experience_retriever` role will search for past lessons relevant to the current market conditions and inject them into the discussion, allowing the AI agents to learn from past mistakes and successes.
