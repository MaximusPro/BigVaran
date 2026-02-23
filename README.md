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
   ```
2. Copy files to the correct MetaTrader 4 folders:
```bash
BigVaran.mq4
BigVaran Mode APB.mq4      →  MQL4\Experts\
iAPB.mqh
LibFastTMALine.mqh
SimpleFunc.mqh             →  MQL4\Include\
```
3. Restart MetaTrader 4  
or right-click inside the Navigator panel → **Refresh**.

4. Drag the **BigVaran** (or **BigVaran Mode APB**) expert advisor onto any chart.  
Make sure the **AutoTrading** button in the toolbar is enabled (green).

## Recommended Settings

These are example default values — always optimize and test your own parameter sets.

| Parameter              | Default / Example     | Description                                          |
|------------------------|-----------------------|------------------------------------------------------|
| MagicNumber            | 20232025             | Unique magic number to identify EA's trades          |
| LotSize                | 0.10                 | Fixed lot size (used when money management is off)   |
| UseMoneyManagement     | true                 | Enable automatic risk-based position sizing          |
| RiskPercent            | 1.0 – 2.0            | Risk per trade as % of account balance               |
| MaxSpread              | 25 – 40              | Maximum allowed spread (in points)                   |
| APB_Period             | 34                   | Period for Adaptive Price Bands                      |
| TMA_Fast_Period        | 21                   | Period of fast Triangular Moving Average             |
| TMA_Slow_Period        | 89                   | Period of slow Triangular Moving Average             |
| UseTrailing            | true                 | Enable trailing stop                                 |
| TrailingStart          | 80                   | Profit in points to start trailing                   |
| TrailingStep           | 40                   | Trailing stop distance / step                        |

> Always check the full list of input parameters in the EA properties dialog for the actual defaults used in your version.

## Usage Recommendations

- **Backtest first** — run in Strategy Tester with modeling quality ≥ 99%
- Test on a **demo account** for at least 1–3 months before going live
- Avoid trading during very low liquidity hours and major news releases (unless filters are strengthened)
- Not recommended for timeframes below **M30** without major strategy adaptation
- Regularly monitor actual spread, slippage and broker execution quality

## Strategy Tester Results (example / placeholder)

Replace with your real backtest or forward test results.

| Period       | Symbol   | Timeframe | Net Profit | Max Drawdown | Profit Factor | Trades |
|--------------|----------|-----------|------------|--------------|---------------|--------|
| 2020–2025    | EURUSD   | H1        | +142%      | 11.8%        | 1.87          | 378    |
| 2022–2025    | XAUUSD   | H4        | +295%      | 19.4%        | 2.12          | 164    |

*(Insert real screenshots from MT4 Strategy Tester here if possible)*

## License

[MIT License](LICENSE)  
You are free to use, modify and distribute this software.  
No warranty is provided.

## Author

- **MaximusPro**  
- GitHub: https://github.com/MaximusPro

## Contributing

- Found a bug? → Please open an **Issue**
- Have improvements for filters, money management, trailing logic? → Pull Requests are welcome
- Achieved good live or demo results? → Feel free to share (screenshots appreciated)

Good luck and profitable trading! 🚀
