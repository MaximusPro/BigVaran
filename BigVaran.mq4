//+------------------------------------------------------------------+
//|                                                     BigVaran.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include <LibFastTMALine.mqh>
#include <iAPB.mqh>
#include <SimpleFunc.mqh>

extern int MAGIC = 3478678;
extern double Lots = 0.1;
extern int StartTimeTrading = 8;
extern int EndTimeTrading = 18;

#define IS_BUFFER 0
#define IS_TWO_CANDLE 1

#define BLUE_CANDLE 5
#define RED_CANDLE 6

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int iAPBRedBlueCandle(BuffersiAPB &Buff, bool Option)
  {
   if(Option == IS_BUFFER)
     {
      if(Buff.CloseBuffer[1] < Buff.CloseBuffer[2])
        {
         return BLUE_CANDLE;
        }
      else
         return RED_CANDLE;
     }
   else
      if(Option == IS_TWO_CANDLE)
        {
         if(Buff.CloseBuffer[0] < Buff.CloseBuffer[1])
           {
            return BLUE_CANDLE;
           }
         else
            return RED_CANDLE;
        }
   return 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
struct LineTouchiTMA
  {
   bool              TouchUpperBand;
   bool              TouchLowerBand;
  };
LineTouchiTMA TouchLine = {false, false};
//TouchLine.TouchLowerBand = false;
//TouchLine.TouchUpperBand = false;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckTouchLineiTMA(double &CopyBuffLowerBand[], double &CopyBuffUpperBand[], double &CopyBuffCenterLine[])
  {
   if(NormalizeDouble(Close[1], 3) >= NormalizeDouble(CopyBuffLowerBand[1], 3) && NormalizeDouble(Open[1], 3) > NormalizeDouble(CopyBuffLowerBand[1], 3) && NormalizeDouble(Open[0], 3) >= NormalizeDouble(CopyBuffLowerBand[0], 3) && TouchLine.TouchLowerBand == false)
     {
      if(NormalizeDouble(Close[2], 3) <= NormalizeDouble(CopyBuffLowerBand[2], 3) && NormalizeDouble(Open[2], 3) <= NormalizeDouble(CopyBuffLowerBand[2], 3))
         TouchLine.TouchLowerBand = true;
      else
         if(NormalizeDouble(Open[2], 3) <= NormalizeDouble(CopyBuffLowerBand[2], 3) && NormalizeDouble(Close[2], 3) >= NormalizeDouble(CopyBuffLowerBand[2], 3))
            TouchLine.TouchLowerBand = true;
         else
            if(NormalizeDouble(Low[2], 3) <= NormalizeDouble(CopyBuffLowerBand[2], 3) && NormalizeDouble(Open[2], 3) >= NormalizeDouble(CopyBuffLowerBand[2], 3))
               TouchLine.TouchLowerBand = true;
            else
               if(NormalizeDouble(Low[2], 3) <= NormalizeDouble(CopyBuffLowerBand[2], 3) && NormalizeDouble(Open[2], 3) <= NormalizeDouble(CopyBuffLowerBand[2], 3) && NormalizeDouble(Close[2], 3) >= NormalizeDouble(CopyBuffLowerBand[2], 3))
                  TouchLine.TouchLowerBand = true;
               else
                  if(NormalizeDouble(Open[2], 3) <= NormalizeDouble(CopyBuffLowerBand[2], 3) && NormalizeDouble(Close[2], 3) >= NormalizeDouble(CopyBuffLowerBand[2], 3))
                     TouchLine.TouchLowerBand = true;
                  else
                     if(NormalizeDouble(Low[2], 3) <= NormalizeDouble(CopyBuffLowerBand[2], 3))
                        TouchLine.TouchLowerBand = true;
     }
   if(NormalizeDouble(Close[1], 3) <= NormalizeDouble(CopyBuffUpperBand[1], 3) && NormalizeDouble(Open[1], 3) < NormalizeDouble(CopyBuffUpperBand[1], 3) && NormalizeDouble(Open[0], 3) <= NormalizeDouble(CopyBuffUpperBand[0], 3) && TouchLine.TouchUpperBand == false)
     {
      if(NormalizeDouble(Close[2], 3) >= NormalizeDouble(CopyBuffUpperBand[2], 3) && NormalizeDouble(Open[2], 3) >= NormalizeDouble(CopyBuffUpperBand[2], 3))
         TouchLine.TouchUpperBand = true;
      else
         if(NormalizeDouble(Open[2], 3) >= NormalizeDouble(CopyBuffUpperBand[2], 3) && NormalizeDouble(Close[2], 3) <= NormalizeDouble(CopyBuffUpperBand[2], 3))
            TouchLine.TouchUpperBand = true;
         else
            if(NormalizeDouble(Low[2], 3) >= NormalizeDouble(CopyBuffUpperBand[2], 3) && NormalizeDouble(Open[2], 3) <= NormalizeDouble(CopyBuffUpperBand[2], 3))
               TouchLine.TouchUpperBand = true;
            else
               if(NormalizeDouble(Low[2], 3) >= NormalizeDouble(CopyBuffUpperBand[2], 3) && NormalizeDouble(Open[2], 3) >= NormalizeDouble(CopyBuffUpperBand[2], 3) && NormalizeDouble(Close[2], 3) <= NormalizeDouble(CopyBuffUpperBand[2], 3))
                  TouchLine.TouchUpperBand = true;
               else
                  if(NormalizeDouble(Open[2], 3) >= NormalizeDouble(CopyBuffUpperBand[2], 3) && NormalizeDouble(Close[2], 3) <= NormalizeDouble(CopyBuffUpperBand[2], 3))
                     TouchLine.TouchUpperBand = true;
                  else
                     if(NormalizeDouble(Low[2], 3) >= NormalizeDouble(CopyBuffUpperBand[2], 3))
                        TouchLine.TouchUpperBand = true;
     }
   if(Close[1] > CopyBuffCenterLine[1] && TouchLine.TouchLowerBand == true)
      TouchLine.TouchLowerBand = false;
   else
      if(Close[1] < CopyBuffCenterLine[1] && TouchLine.TouchUpperBand == true)
         TouchLine.TouchUpperBand = false;
   if(IsOrderClose(Ticket1) == false)
     {
      if(OrderSelect(Ticket1, SELECT_BY_TICKET)==true)
         if(OrderType() == OP_BUY)
            TouchLine.TouchLowerBand = false;
         else
            if(OrderType() == OP_SELL)
               TouchLine.TouchUpperBand = false;
     }
  }

#define HIGH_CANDLE 0
#define LOW_CANDLE 1
double HighLowCandleStopLoss(double LimitPrice, bool Trend)
  {
   double CurrentPrice = 0;
   if(Trend == HIGH_CANDLE)
      for(int i = 1; i < Bars-1; i++)
        {
         if(Close[i] > Close[i-1])
           {
            CurrentPrice = High[i];
           }
         else
            if(Close[i] < Close[i-1] && CurrentPrice != 0)
              {
               for(int k = i; k < Bars-1; k++)
                 {
                  if(Close[k] < Close[k-1] && CurrentPrice >= Close[k])
                    {
                     return CurrentPrice;;
                    }
                  else
                     if(Close[k] > Close[k-1] && CurrentPrice < Close[k])
                       {
                        break;
                       }
                 }
              }
        }
   else
      if(Trend == LOW_CANDLE)
         for(int i = 1; i < Bars-1; i++)
           {
            if(Close[i] < Close[i-1])
              {
               CurrentPrice = Low[i];
              }
            else
               if(Close[i] > Close[i-1] && CurrentPrice != 0)
                 {
                  for(int k = i; k < Bars-1; k++)
                    {
                     if(Close[k] > Close[k-1] && CurrentPrice <= Close[k])
                       {
                        return CurrentPrice;;
                       }
                     else
                        if(Close[k] < Close[k-1] && CurrentPrice > Close[k])
                          {
                           break;
                          }
                    }
                 }
           }
   return 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckRatio(int a, int b)
  {
   int Check = 0;
   if(a > b)
      Check = (int)NormalizeDouble(a/b, 0);
   else
      if(b > a)
         Check = (int)NormalizeDouble(b/a, 0);
   if(Check > 0)
      return true;
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TimeTrading(int StartTime, int EndTime)
  {
   MqlDateTime CurrentTime;
   TimeCurrent(CurrentTime);
   if(CurrentTime.hour >= StartTime && CurrentTime.hour < EndTime)
      return true;
   return false;
  }


bool OpenTicket = false;

struct StochLineCrossing2080
  {
   bool              TouchLine20;
   bool              TouchLine80;
  };
StochLineCrossing2080 LineTouch = {false, false};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void StochLineCrossing()
  {
   double IStochK = iStochastic(Symbol(), 5, 10, 3, 3, 0, 0, 1, 0);
   double IStochD = iStochastic(Symbol(), 5, 10, 3, 3, 0, 0, 0, 0);
   if(IStochK <= 20 && IStochD <= 20)
     {
      LineTouch.TouchLine20 = true;
      LineTouch.TouchLine80 = false;
     }
   else
      if(IStochD >= 80 && IStochK >= 80)
        {
         LineTouch.TouchLine80 = true;
         LineTouch.TouchLine20 = false;
        }

   if(OpenTicket == true || (LineTouch.TouchLine20 == LineTouch.TouchLine20 && LineTouch.TouchLine20 == true))
     {
      LineTouch.TouchLine20 = false;
      LineTouch.TouchLine80 = false;
      OpenTicket = false;
     }
//Print("StouchK: ", IStochK);
//Print("StouchD: ", IStochD);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double NearestFractal(int Mode)
  {
   if(Mode == MODE_UPPER)
     {
      for(int i = 0; i != Bars-1; i++)
        {
         double Fractal = iFractals(Symbol(), 5, MODE_UPPER, i);
         if(Fractal != NULL)
            return Fractal;
        }
     }
   else
      if(Mode == MODE_LOWER)
        {
         for(int i = 0; i != Bars-1; i++)
           {
            double Fractal = iFractals(Symbol(), 5, MODE_LOWER, i);
            if(Fractal != NULL)
               return Fractal;
           }
        }
   return 0;
  }



//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
int Ticket1 = -1;
int Ticket2 = -1;
bool IsStart = true;
void OnTick()
  {
//---

   if(Period() == PERIOD_M5)
     {
      iTMALine iTMA();
      iTMA.SetParameters(Period(), 56, 2.8, 100, 0.5, true, 100);
      iTMA.Refresh();
      iAPB APB(100);
      double StochasticK = iStochastic(Symbol(), 5, 10, 3, 3, 0, 0, 0, 0);
      double StochasticD = iStochastic(Symbol(), 5, 10, 3, 3, 0, 0, 1, 0);
      double FractalUpper = iFractals(Symbol(), 5, MODE_UPPER, 1);
      double FractalLower = iFractals(Symbol(), 5, MODE_LOWER, 1);
      //Print("FractalLower: ", FractalLower);
      //Print("NearestFractal: ", NearestFractal(MODE_LOWER));
      BuffersiTMALine BuffTMA = iTMA.GetBuffers();
      CheckTouchLineiTMA(BuffTMA.lowerBand, BuffTMA.upperBand, BuffTMA.tma);
      StochLineCrossing();
      //Print("iTMA.GetBufftma(0): ",iTMA.GetBufftma(1));


      if(IsStart == true)
        {
         for(int i = 0; i < OrdersTotal()-1; i++)
           {
            if(OrderSelect(i, SELECT_BY_TICKET) == true)
              {
               if(OrderMagicNumber() == MAGIC)
                 {
                  if(Ticket2 == -1)
                    {
                     Ticket2 = i;
                    }
                  else
                     if(Ticket2 != -1 && Ticket1 == -1)
                       {
                        Ticket1 = i;
                        break;
                       }
                 }
              }
           }
        }
      if(Ticket2 > -1)
        {
         //Print("2iTMA.GetBufftma(0): ", iTMA.GetBufftma(1));

         if(OrderSelect(Ticket2, SELECT_BY_TICKET) == true)
           {
            if(OrderType() == OP_BUY)
              {
               if(High[0] >= iTMA.GetBuffUpperBand(1))
                  if(OrderClose(Ticket2, OrderLots(), Bid, 0, clrBlueViolet) == true)
                    {
                     Print("OrderClose ticket: ", Ticket2);
                     Ticket2 = -1;
                     if(IsOrderClose(Ticket1) == false)
                        if(OrderClose(Ticket1, OrderLots(), Bid, 0, clrBlueViolet) == true)
                          {
                           Print("OrderClose ticket: ", Ticket1);
                           Ticket1 = -1;
                          }
                    }
                  else
                     Print("OrderClose Error: ", GetLastError());
              }
            else
               if(OrderType() == OP_SELL)
                 {
                  if(Low[0] <= iTMA.GetBuffLowerBand(1))
                     if(OrderClose(Ticket2, OrderLots(), Ask, 0, clrBlueViolet) == true)
                       {
                        Print("OrderClose ticket: ", Ticket2);
                        Ticket2 = -1;
                        if(IsOrderClose(Ticket1) == false)
                           if(OrderClose(Ticket1, OrderLots(), Bid, 0, clrBlueViolet) == true)
                             {
                              Print("OrderClose ticket: ", Ticket1);
                              Ticket1 = -1;
                             }
                       }
                     else
                        Print("OrderClose Error: ", GetLastError());
                 }
           }
        }
      if(Ticket1 > -1)
        {
         //Print("1iTMA.GetBufftma(0): ", iTMA.GetBufftma(1));
         if(OrderSelect(Ticket1, SELECT_BY_TICKET) == true)
           {
            if(OrderType() == OP_BUY)
              {

               if(NormalizeDouble(iTMA.GetBufftma(1), Digits) <= High[0] || NormalizeDouble(iTMA.GetBufftma(1), Digits) <= Open[0])
                 {
                  if(OrderClose(Ticket1, OrderLots(), Bid, 0, clrViolet) == true)
                    {
                     Ticket1 = -1;
                    }
                  else
                    {
                     Print("OrderClose Error: ", GetLastError());
                    }
                 }

              }
            else
               if(OrderType() == OP_SELL)
                 {
                  if(NormalizeDouble(iTMA.GetBufftma(1), Digits) >= High[0] || NormalizeDouble(iTMA.GetBufftma(1), Digits) >= Open[0])
                    {
                     if(OrderClose(Ticket1, OrderLots(), Ask, 0, clrViolet) == true)
                       {
                        Ticket1 = -1;
                       }
                     else
                       {
                        Print("OrderClose Error: ", GetLastError());
                       }
                    }

                 }
           }
        }
      //SellOrder(0,0, 0.1, MAGIC, "BigVaran 0.1");
      /*if(Ticket1 == -1)
        {
         for(int i = OrdersTotal()-1; i != -1; i--)
           {
            if(OrderSelect(i, SELECT_BY_POS) == true)
              {
               if(OrderMagicNumber()==MAGIC)
                 {
                  Ticket1 = OrderTicket();

                  break;
                 }
              }
           }

        }*/
      //Print("Ticket1 = ", Ticket1);
      //Print("Ticket2 = ", Ticket2);
      if(IsOrderClose(Ticket1) == true)
         Ticket1 = -1;
      if(IsOrderClose(Ticket2) == true)
         Ticket2 = -1;
      if(Ticket1 == -1 && Ticket2 == -1 && TimeTrading(StartTimeTrading, EndTimeTrading) == true)
        {
         //BUY
         //Print("StartControlOpenOrder{");
         if(Close[1] > iTMA.GetBuffLowerBand(0) &&  iAPBRedBlueCandle(APB.GetBuffers(), IS_BUFFER) == BLUE_CANDLE &&
            (TouchLine.TouchLowerBand == true && iTMA.GetBuffLowerBand(1) < Close[1]) && LineTouch.TouchLine20 == true && (StochasticK >= 20 || StochasticD >= 20))
           {

            //Print("TouchUpperBand = ", TouchLine.TouchUpperBand);
            //Print("TouchLoweBand = ", TouchLine.TouchLowerBand);
            int CurrentTakeProfit = PointsToRange(Ask, iTMA.GetBuffUpperBand(1), Point);
            int  CurrentStopLoss = PointsToRange(Ask, NearestFractal(MODE_LOWER), Point);
            int Spread = PointsToRange(Ask, Bid, Point);
            int RangeToCenterLine = PointsToRange(iTMA.GetBufftma(1), Ask, Point);
            if(Spread < RangeToCenterLine)
              {
               Ticket1 = BuyOrder(CurrentTakeProfit, CurrentStopLoss+4, Lots, MAGIC, "BigVaran 0.1");
               if(Ticket1 == -1)
                  Print("BuyOrder error: ", GetLastError());
               Ticket2 = BuyOrder(CurrentTakeProfit, CurrentStopLoss+4, Lots, MAGIC, "BigVaran 0.1");
               if(Ticket2 == -1)
                  Print("BuyOrder error: ", GetLastError());
               OpenTicket = true;
              }
            /*
            if(CurrentStopLoss >= 200 && CheckRatio(CurrentTakeProfit, CurrentStopLoss) == true)
              {
               Ticket1 = BuyOrder(CurrentTakeProfit, CurrentStopLoss, Lots, MAGIC, "BigVaran 0.1");
               if(Ticket1 == -1)
                  Print("BuyOrder error: ", GetLastError());
               Ticket2 = BuyOrder(CurrentTakeProfit, CurrentStopLoss, Lots, MAGIC, "BigVaran 0.1");
                  if(Ticket2 == -1)
                  Print("BuyOrder error: ", GetLastError());
               OpenTicket = true;
              }
            else
               if(CurrentStopLoss < 200)
                 {
                  if(CheckRatio(200, CurrentTakeProfit) == true)
                    {
                     Ticket1 = BuyOrder(CurrentTakeProfit, 200, Lots, MAGIC, "BigVaran 0.1");
                     if(Ticket1 == -1)
                        Print("BuyOrder error: ", GetLastError());
                     Ticket2 = BuyOrder(CurrentTakeProfit, 200, Lots, MAGIC, "BigVaran 0.1");
                      if(Ticket2 == -1)
                        Print("BuyOrder error: ", GetLastError());

                     OpenTicket = true;
                    }
                 }*/

           }

         //SELL

         else
            if(Close[1] < iTMA.GetBuffUpperBand(1) &&  iAPBRedBlueCandle(APB.GetBuffers(), IS_BUFFER) == RED_CANDLE &&
               (TouchLine.TouchUpperBand == true) && LineTouch.TouchLine80 == true && (StochasticK <= 80 || StochasticD <= 80))
              {
               //Print("TouchUpperBand = ", TouchLine.TouchUpperBand);
               //Print("TouchLoweBand = ", TouchLine.TouchLowerBand);
               int CurrentTakeProfit = PointsToRange(Bid, iTMA.GetBuffLowerBand(1), Point);
               int  CurrentStopLoss = PointsToRange(Bid, NearestFractal(MODE_UPPER), Point);
               int Spread = PointsToRange(Ask, Bid, Point);
               int RangeToCenterLine = PointsToRange(iTMA.GetBufftma(1), Bid, Point);
               if(Spread < RangeToCenterLine)
                 {
                  Ticket1 = SellOrder(CurrentTakeProfit, CurrentStopLoss+4, Lots, MAGIC, "BigVaran 0.1");
                  if(Ticket1 == -1)
                     Print("SellOrder error: ", GetLastError());
                  Ticket2 = SellOrder(CurrentTakeProfit, CurrentStopLoss+4, Lots, MAGIC, "BigVaran 0.1");
                  if(Ticket2 == -1)
                     Print("SellOrder error: ", GetLastError());

                  OpenTicket = true;
                 }
               /*if(CurrentStopLoss >= 200 && CheckRatio(CurrentTakeProfit, CurrentStopLoss) == true)
                 {
                  Ticket1 = SellOrder(CurrentTakeProfit, CurrentStopLoss, Lots, MAGIC, "BigVaran 0.1");
                  if(Ticket1 == -1)
                     Print("SellOrder error: ", GetLastError());
                  Ticket2 = SellOrder(CurrentTakeProfit, CurrentStopLoss, Lots, MAGIC, "BigVaran 0.1");
                  if(Ticket2 == -1)
                     Print("SellOrder error: ", GetLastError());

                  OpenTicket = true;
                 }
               else
                  if(CurrentStopLoss < 200)
                    {
                     if(CheckRatio(200, CurrentTakeProfit) == true)
                       {
                        Ticket1 = SellOrder(CurrentTakeProfit, 200, Lots, MAGIC, "BigVaran 0.1");
                        if(Ticket1 == -1)
                           Print("SellOrder error: ", GetLastError());
                        Ticket2 = SellOrder(CurrentTakeProfit, 200, Lots, MAGIC, "BigVaran 0.1");
                        if(Ticket2 == -1)
                           Print("SellOrder error: ", GetLastError());
                        OpenTicket = true;
                       }
                    }*/
              }
         //Print("EndControlOpenOrder}");
        }



     }
   else
      Comment("It's not M5 timeframe!");
  }
//+------------------------------------------------------------------+
