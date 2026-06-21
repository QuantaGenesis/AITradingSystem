---
id: exchange
title: Exchange Adapter Integration Guide
sidebar_position: 3
---

# Exchange Adapter Integration Guide

AITradingSystem uses the **Adapter Pattern** to connect the central execution engine to various crypto and financial exchanges. By design, the core system is completely agnostic of exchange-specific API structures, rate limits, and response shapes. All communication is standardized.

This guide walks you through building and registering a custom exchange adapter (e.g. for OANDA, Kraken, or a custom simulator).

---

## 1. Class Architecture

All exchange adapters must inherit from `ExchangeBase` defined in [app/exchanges/base.py](file:///home/x/AITradingSystem/AITradingSystem-backend/app/exchanges/base.py) and implement its abstract methods.

### Base Initialization

Your constructor should accept the following standard parameters and delegate them to `super().__init__`:

```python
from app.exchanges.base import ExchangeBase, StandardizedResponse, StandardizedOrder, StandardizedPosition

class MyCustomExchange(ExchangeBase):
    def __init__(self, api_key: str, api_secret: str, symbol: str, exchange_name: str, 
                 leverage: int = 20, sandbox: bool = False, mode: bool = False, margin_mode: bool = True, **kwargs):
        super().__init__(
            api_key=api_key,
            api_secret=api_secret,
            symbol=symbol,
            exchange_name=exchange_name,
            leverage=leverage,
            sandbox=sandbox,
            mode=mode,
            margin_mode=margin_mode,
            **kwargs
        )
```

---

## 2. Core Interface Methods

You must implement the following abstract methods:

### Initialization & Configuration

* **`_initialize_exchange(self)`**: Set up the exchange API client (e.g. `ccxt`, raw HTTP clients, or SDKs) using `self.api_key` and `self.api_secret`.
* **`enable_demo_trading(self, enable: bool)`**: Toggle the client endpoints between Live and Testnet/Sandbox mode.
* **`set_position_mode(self, mode)`**: Set the symbol's position mode (`hedge` vs. `one-way`).
* **`set_leverage(self, leverage)`**: Configure margin leverage (e.g. `1x` to `100x`) on the exchange.
* **`set_margin_mode(self, margin_mode)`**: Toggle between Isolated (True) and Cross (False) margin modes.

### Order Placement & Management

* **`create_market_order(self, side, quantity, params=None)`**: Execute an immediate market order. Returns a `StandardizedResponse(data=StandardizedOrder)`.
* **`create_limit_order(self, side, quantity, price, params=None)`**: Place a limit order at a specific price. Returns a `StandardizedResponse(data=StandardizedOrder)`.
* **`cancel_all_orders(self)`**: Cancel all open orders for the initialized symbol.
* **`get_open_orders(self)`**: Retrieve active pending orders.
* **`fetch_order_by_id(self, order_id: str)`**: Fetch the state of a single order.

### Position Management

* **`fetch_positions(self)`**: Fetch active open positions. Returns a `StandardizedResponse(data=List[StandardizedPosition])`.
* **`close_position(self, side=None, params=None, position=None)`**: Close a specific position.
* **`fetch_position_close_pnl(self, ...)`**: Query realized PnL, fees, and exit price when a position closes.

### Market Data

* **`fetch_ohlcv(self, timeframe="1m", limit=5)`**: Fetch historical candlesticks to feed current market state to the UI or strategy logic.

---

## 3. Standardizing Responses

To ensure compatibility, your adapter must wrap all data returns in a `StandardizedResponse` using helper methods:

```python
# Standardized success wrap
return self._create_success_response(
    data=StandardizedOrder(
        id="exchange-order-id-123",
        symbol=self.symbol,
        side=self._parse_order_side(side),
        order_type=OrderType.MARKET,
        quantity=quantity,
        status=OrderStatus.FILLED,
        average_price=last_price,
    )
)

# Standardized error wrap
except Exception as e:
    return self._create_error_response(
        error=f"Order failed on exchange: {str(e)}",
        error_code="EXCHANGE_ORDER_ERROR"
    )
```

---

## 4. Registering the Adapter

Once your adapter is written (e.g., in `app/exchanges/my_exchange.py`), register it with the core factory:

1. Import your class inside [app/exchanges/\_\_init\_\_.py](file:///home/x/AITradingSystem/AITradingSystem-backend/app/exchanges/__init__.py).
2. Call `ExchangeFactory.register_manager()` to bind it to a identifier.

```python
# In app/exchanges/__init__.py
from .my_exchange import MyExchange

ExchangeFactory.register_manager("my_exchange_id", MyExchange)
```

Once registered, any Trade Account created in the UI dashboard with the exchange name `my_exchange_id` will automatically load your custom adapter class for placing orders and syncing positions.
