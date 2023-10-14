//+------------------------------------------------------------------+
//|                                                   SimpleFunc.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
int LastOrderOP()
  {
//Print("StartLastOrderOP");
   if(OrderSelect(OrdersHistoryTotal()-1, SELECT_BY_POS, MODE_HISTORY)==true)
     {
      return OrderType();
     }
   return -1;
  }

//+------------------------------------------------------------------+
//|Function for calculate take profit and stop loss                                                                  |
//+------------------------------------------------------------------+
#define BUY 0
#define SELL 1
double CalculatePnL(double FirstPrice, double SecondPrice, double Lot, bool OP)
  {
   if(OP == BUY)
     {
      return NormalizeDouble((SecondPrice-FirstPrice)*Lot*100, Digits);
     }
   if(OP == SELL)
     {
      return NormalizeDouble((FirstPrice-SecondPrice)*Lot*100, Digits);
     }
   return 0;
  }

//+------------------------------------------------------------------+
//| Finding a range in points between two prices.                                                                 |
//+------------------------------------------------------------------+
int PointsToRange(double Price1, double Price2, double PPoint)
  {
   if(Price1>Price2)
      return((int)NormalizeDouble((Price1-Price2)/PPoint, 0));
   if(Price1<Price2)
      return ((int)NormalizeDouble((Price2-Price1)/PPoint, 0));
   return 0;
  }

//+------------------------------------------------------------------+
//|Open Buy Order.                                                                  |
//+------------------------------------------------------------------+
int BuyOrder(int TakeProfit, int StopLoss, double VVolume, int MAGICNumber, string CComment)
  {

   double minstoplevel = MarketInfo(Symbol(), MODE_STOPLEVEL);
   double NormalST;
   double NormalTP;
   if(StopLoss == 0)
     {
      NormalST = 0;
     }
   else
     {
      NormalST = NormalizeDouble(Bid+minstoplevel-StopLoss*Point, Digits);
     }
   if(TakeProfit == 0)
     {
      NormalTP = 0;
     }
   else
     {
      NormalTP = NormalizeDouble(Bid+minstoplevel+TakeProfit*Point, Digits);
     }
   int ticket = OrderSend(Symbol(), OP_BUY, NormalizeDouble(VVolume, 2), Ask, 3, NormalST, NormalTP, CComment, MAGICNumber, 0, clrGreen);
   return ticket;
  }

//+------------------------------------------------------------------+
//|Open Sell Order.                                                                  |
//+------------------------------------------------------------------+
int SellOrder(int TakeProfit, int StopLoss, double VVolume, int MAGICNumber, string CComment)
  {

   double minstoplevel = MarketInfo(Symbol(), MODE_STOPLEVEL);
   double NormalST;
   double NormalTP;
   if(StopLoss == 0)
     {
      NormalST = 0;
     }
   else
     {
      NormalST = NormalizeDouble(Ask+minstoplevel+StopLoss*Point, Digits);
     }
   if(TakeProfit == 0)
     {
      NormalTP = 0;
     }
   else
     {
      NormalTP = NormalizeDouble(Ask-minstoplevel-TakeProfit*Point, Digits);
     }
   int ticket = OrderSend(Symbol(), OP_SELL, NormalizeDouble(VVolume, 2), Bid, 3, NormalST, NormalTP, CComment, MAGICNumber, 0, clrRed);
   return ticket;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|Risk control for the deposit.                                                                  |
//+------------------------------------------------------------------+
int GoodDep = 0;
int ControlDepRisk(int DepositRisk)
  {
//Print("ControlDepRisk: ", DepositRisk);
   if(GoodDep!=0)
     {
      int CurrentDep = (int)(NormalizeDouble(AccountBalance(), 0));
      int DepMinusRisk = (int)NormalizeDouble(GoodDep-DepositRisk, 0);
      //Print("DepMinusRisk: ", DepMinusRisk);
      //Print("CurrentDep: ", CurrentDep);
      if(DepMinusRisk <= CurrentDep)
        {
         return 1;
        }
      else
         return 0;
     }
   else
     {
      GoodDep = (int)NormalizeDouble(AccountBalance(), 0);
      return 1;
     }
   return 0;
  }

//+------------------------------------------------------------------+
//|Dynamically calculates the lot for the specified risk per deposit.                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double DynamicLot(int DepositRisk, double StartLot, bool DynamicLots)
  {
   if(DynamicLots == true && GoodDep != 0)
     {
      double GoodDepPercentRisk = NormalizeDouble(DepositRisk*100/GoodDep, Digits);
      double DifferencePercentRisk;
      if((int)AccountBalance() > GoodDep)
        {
         DifferencePercentRisk = NormalizeDouble(((int)AccountBalance()-GoodDep)*100/GoodDep, Digits);
         double AddedLot = NormalizeDouble(DifferencePercentRisk*StartLot/GoodDepPercentRisk, 2);
         return (StartLot+AddedLot);
        }
     }
   else
     {
      GoodDep = (int)NormalizeDouble(AccountBalance(), 0);
     }
   return StartLot;
  }

//+------------------------------------------------------------------+
//|Function to control whether the order is closed or not.                                                                  |
//+------------------------------------------------------------------+
bool IsOrderClose(int ticket)
  {
   for(int i = OrdersTotal() -1;  i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==true)
        {
         if(OrderTicket() == ticket)
            return false;
        }
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MaxLots(string CopySymbol)
  {
   double LotSize = MarketInfo(CopySymbol, MODE_LOTSIZE);
   if(LotSize!=0)
     {
      int Leverage = AccountLeverage();
      double OneLot = NormalizeDouble(LotSize/Leverage, Digits);
      double MaxLot = AccountBalance()/OneLot;
      return MaxLot;
     }
   return 0;
  }
//+------------------------------------------------------------------+
