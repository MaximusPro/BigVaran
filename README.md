# BigVaran

**BigVaran** is an Expert Advisor (trading robot) and a set of supporting indicators / libraries for **MetaTrader 4** (MQL4), with partial compatibility elements for **MetaTrader 5** (MQL5).  

It implements a trend-following / breakout strategy based on:

- Adaptive Price Bands (**APB** channel)
- Fast and slow **Triangular Moving Average** (TMA) lines
- Impulse filters and false breakout rejection logic
- Position management with trailing stop and risk control

The strategy aims to capture strong directional moves while avoiding ranging / choppy market conditions.

![Strategy example](https://via.placeholder.com/800x450.png?text=BigVaran+on+chart+—+add+your+screenshot+here)  
*(Replace with real chart screenshots showing entries, channel, TMA lines and trades)*

## Repository Contents

| File                        | Purpose                                                                 |
|-----------------------------|-------------------------------------------------------------------------|
| `BigVaran.mq4`              | Main Expert Advisor (core trading logic)                                |
| `BigVaran Mode APB.mq4`     | Alternative EA version with stronger focus on APB channel signals      |
| `iAPB.mqh`                  | Adaptive Price Bands calculation / indicator functions                  |
| `LibFastTMALine.mqh`        | Optimized library for fast Triangular Moving Average computation        |
| `SimpleFunc.mqh`            | Collection of helper functions (math, trade utils, etc.)                |

## Requirements

- MetaTrader 4 terminal (build 600+ recommended)
- Recommended timeframes: **H1** – **H4**
- Instruments: trending pairs / assets (Forex majors, Gold, indices, liquid cryptocurrencies)
- Broker with low spread and fast execution (ECN / STP preferred)

## Installation

1. Download the repository:

   ```bash
   git clone https://github.com/MaximusPro/BigVaran.git
