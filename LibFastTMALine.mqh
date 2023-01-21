//+------------------------------------------------------------------+
//|                                      LibFastTMALineIndicator.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#define DEFAULT_PARAMETERS 0




struct ParametersiTMALine
  {
   int               TimeFrame;
   int               TMAPeriod;
   double            ATRMultiplier;
   int               ATRPeriod;
   double            TrendThreshold;
   bool              ShowCenterLine;
  };

struct BuffersiTMALine
  {
   double            tma[];
   double            upperBand[];
   double            lowerBand[];
   double            bull[];
   double            bear[];
   double            neutral[];
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class iTMALine
  {

private:
   ParametersiTMALine Data;
   BuffersiTMALine   Buff;
   int               BufferSize;
   bool              Default;

   double            CalcTma(int inx);
   void              DrawCenterLine(int shift, double slope);
   int               MTF;
public:
                     iTMALine(void);
                     iTMALine(int Param);
                    ~iTMALine();

   int               Refresh();
   void              SetParameters(ParametersiTMALine&);
   void              SetParameters(int CopyTimeFrame = DEFAULT_PARAMETERS, int    CopyTMAPeriod = 45, double CopyATRMultiplier = 1.272, int    CopyATRPeriod = 100,
                                   double CopyTrendThreshold = 0.5, bool   CopyShowCenterLine = true, int Buffer = DEFAULT_PARAMETERS);
   BuffersiTMALine   GetBuffers();
   double            GetBufftma(int IndexBar);
   double            GetBuffUpperBand(int IndexBar);
   double            GetBuffLowerBand(int IndexBar);
   double            GetBuffBull(int IndexBar);
   double            GetBuffBear(int IndexBar);
   double            GetBuffNeutral(int IndexBar);
   void              SetBufferSize(int Size);


  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
iTMALine::iTMALine(void)
  {
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
iTMALine::iTMALine(int Param)
  {
   if(Param == DEFAULT_PARAMETERS)
     {
      Data.TimeFrame = Period();
      Data.TMAPeriod = 45;
      Data.ATRMultiplier = 1.272;
      Data.ATRPeriod = 100;
      Data.TrendThreshold = 0.5;
      Data.ShowCenterLine = true;
      BufferSize = Bars;
      Default = true;
     }
   else
      Default = false;
   MTF = Data.TimeFrame;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
iTMALine::~iTMALine()
  {
   ArrayFree(Buff.tma);
   ArrayFree(Buff.lowerBand);
   ArrayFree(Buff.upperBand);
   ArrayFree(Buff.bull);
   ArrayFree(Buff.bear);
   ArrayFree(Buff.neutral);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void iTMALine::SetParameters(int CopyTimeFrame=0,int CopyTMAPeriod=45,double CopyATRMultiplier=1.272000,int CopyATRPeriod=100,double
                             CopyTrendThreshold=0.500000,bool CopyShowCenterLine=true, int Buffer = DEFAULT_PARAMETERS)
  {
   if(CopyTimeFrame == DEFAULT_PARAMETERS)
      Data.TimeFrame = Period();
   else
      Data.TimeFrame = CopyTimeFrame;
   if(Buffer == DEFAULT_PARAMETERS || Buffer < 0)
     {
      BufferSize = Bars;
      Default = true;
     }
   else
     {
      BufferSize = Buffer;
      Default = false;
     }
   Data.TMAPeriod = CopyTMAPeriod;
   Data.ATRMultiplier = CopyATRMultiplier;
   Data.ATRPeriod = CopyATRPeriod;
   Data.TrendThreshold = CopyTrendThreshold;
   Data.ShowCenterLine = CopyShowCenterLine;
   MTF = Data.TimeFrame;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void iTMALine::SetParameters(ParametersiTMALine &ParametersTMA)
  {
   Data = ParametersTMA;
   MTF = Data.TimeFrame;
   BufferSize = Bars;
   Default = true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int iTMALine::Refresh(void)
  {
//int counted_bars=BufferSize;
   int i,limit;

//if(counted_bars<0)
//return(-1);
//if(counted_bars>0)
//counted_bars--;
   double barsPerTma = (MTF / _Period);
//limit=(int)MathMin(Bars-1,Bars-counted_bars+ Data.TMAPeriod * barsPerTma);
   if(Default == false)
     {
      limit = BufferSize;
     }
   else
      limit = 999;
   ArrayResize(Buff.tma, BufferSize+2);
   ArrayResize(Buff.upperBand, BufferSize+2);
   ArrayResize(Buff.lowerBand, BufferSize+2);
   ArrayResize(Buff.bull, BufferSize+2);
   ArrayResize(Buff.bear, BufferSize+2);
   ArrayResize(Buff.neutral, BufferSize+2);
   int mtfShift = 0;
   int lastMtfShift = 999;
   double tmaVal = Buff.tma[limit+1];
   double range = 0;

   double slope = 0;
   double prevTma = Buff.tma[limit+1];
   double prevSlope = 0;


   for(i=limit; i>=0; i--)
     {
      if(MTF == _Period)
        {
         mtfShift = i;
        }
      else
        {
         mtfShift = iBarShift(_Symbol,MTF,Time[i]);
        }

      if(mtfShift == lastMtfShift)
        {
         Buff.tma[i] =Buff.tma[i+1] + ((tmaVal - prevTma) * (1/barsPerTma));
         Buff.upperBand[i] =  Buff.tma[i] + range;
         Buff.lowerBand[i] = Buff.tma[i] - range;
         //DrawCenterLine(i, slope);
         continue;
        }

      lastMtfShift = mtfShift;
      prevTma = tmaVal;
      tmaVal = CalcTma(mtfShift);

      range = iATR(NULL,MTF,Data.ATRPeriod,mtfShift+10)*Data.ATRMultiplier;
      if(range == 0)
         range = 1;

      if(barsPerTma > 1)
        {
         Buff.tma[i] =prevTma + ((tmaVal - prevTma) * (1/barsPerTma));
        }
      else
        {
         Buff.tma[i] =tmaVal;
        }
      Buff.upperBand[i] = Buff.tma[i]+range;
      Buff.lowerBand[i] = Buff.tma[i]-range;

      slope = (tmaVal-prevTma) / ((range / Data.ATRMultiplier) * 0.1);
     }
   for(i = limit; i>=0; i--)
     {
      if(mtfShift == lastMtfShift)
        {
         DrawCenterLine(i, slope);
        }
     }
   return 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iTMALine::CalcTma(int inx)
  {
   double dblSum  = (Data.TMAPeriod+1)*iClose(_Symbol,MTF,inx);
   double dblSumw = (Data.TMAPeriod+1);
   int jnx, knx;

   for(jnx = 1, knx = Data.TMAPeriod; jnx <= Data.TMAPeriod; jnx++, knx--)
     {
      dblSum  += (knx * iClose(_Symbol,MTF,inx+jnx));
      dblSumw += knx;

      /*
      if ( jnx <= inx )
      {
         if (iTime(_Symbol,MTF,inx-jnx) > Time[0])
         {
            //Print (" MTF ", MTF , " inx ", inx," jnx ", jnx, " iTime(_Symbol,MTF,inx-jnx) ", TimeToStr(iTime(_Symbol,MTF,inx-jnx)), " Time[0] ", TimeToStr(Time[0]));
            continue;
         }
         dblSum  += ( knx * iClose(_Symbol,MTF,inx-jnx) );
         dblSumw += knx;
      }
      */
     }

   return(dblSum / dblSumw);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void iTMALine::DrawCenterLine(int shift, double slope)
  {

   Buff.bull[shift] = NULL;
   Buff.bear[shift] = NULL;
   Buff.neutral[shift] = NULL;
   if(Data.ShowCenterLine)
     {
      if(slope > Data.TrendThreshold)
        {
         Buff.bull[shift] = Buff.tma[shift];
        }
      else
         if(slope < -1 * Data.TrendThreshold)
           {
            Buff.bear[shift] = Buff.tma[shift];
           }
         else
           {
            Buff.neutral[shift] = Buff.tma[shift];
           }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BuffersiTMALine iTMALine::GetBuffers()
  {
   return Buff;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iTMALine::GetBuffBear(int IndexBar)
  {
   return Buff.bear[IndexBar];
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iTMALine::GetBuffBull(int IndexBar)
  {
   return Buff.bull[IndexBar];
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iTMALine::GetBuffLowerBand(int IndexBar)
  {
   return Buff.lowerBand[IndexBar];
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iTMALine::GetBuffUpperBand(int IndexBar)
  {
//Print("UPPERBAND+ ", Buff.upperBand[IndexBar]);
   return Buff.upperBand[IndexBar];
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iTMALine::GetBuffNeutral(int IndexBar)
  {
   return Buff.neutral[IndexBar];
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iTMALine::GetBufftma(int IndexBar)
  {
   return Buff.tma[IndexBar];
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void iTMALine::SetBufferSize(int Size)
  {
   if(Size == NULL)
     {
      BufferSize = Bars;
      Default = true;
     }
   else
     {
      BufferSize = Size;
      Default = false;
     }

  }
//+------------------------------------------------------------------+
