//+------------------------------------------------------------------+
//|                                                         iAPB.mqh |
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

struct BuffersiAPB
  {
   double            HighBuffer[];
   double            LowBuffer[];
   double            OpenBuffer[];
   double            CloseBuffer[];
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class iAPB
  {
   BuffersiAPB       Buffers;
   int               Start();
   int               BufferSize;
   bool              Default;
private:

public:
                     //iAPB(void);
                     iAPB(int BuffSize = NULL);
                    ~iAPB(void);
   BuffersiAPB       GetBuffers();
   void              SetBuffSize(int BuffSize);
   double            GetHighBuffer(int IndexBar);
   double            GetLowBuffer(int IndexBar);
   double            GetOpenBuffer(int IndexBar);
   double            GetCloseBuffer(int IndexBar);
   int               GetBuffSize();

  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*iAPB::iAPB(void)
  {
   BufferSize = Bars;
   Default = true;
   Start();
  }
*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
iAPB::iAPB(int BuffSize = NULL)
  {
   if(BuffSize == NULL || BuffSize < 0)
     {
      BufferSize = Bars;
      Default = true;
     }
   else
     {
      BufferSize = BuffSize;
      Default = false;
     }
   Start();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
iAPB::~iAPB(void)
  {
      ArrayFree(Buffers.CloseBuffer);
      ArrayFree(Buffers.HighBuffer);
      ArrayFree(Buffers.LowBuffer);
      ArrayFree(Buffers.OpenBuffer);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BuffersiAPB iAPB::GetBuffers()
  {
   return Buffers;
  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iAPB::GetHighBuffer(int IndexBar)
  {
   return Buffers.HighBuffer[IndexBar];
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iAPB::GetLowBuffer(int IndexBar)
  {
   return Buffers.LowBuffer[IndexBar];
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iAPB::GetOpenBuffer(int IndexBar)
  {
   return Buffers.OpenBuffer[IndexBar];
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iAPB::GetCloseBuffer(int IndexBar)
  {
   return Buffers.CloseBuffer[IndexBar];
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int iAPB::Start()
  {
   ArrayResize(Buffers.HighBuffer, BufferSize+2);
   ArrayResize(Buffers.LowBuffer, BufferSize+2);
   ArrayResize(Buffers.OpenBuffer, BufferSize+2);
   ArrayResize(Buffers.CloseBuffer, BufferSize+2);

   for(int i = 0; i < BufferSize-1; i++)
     {
      Buffers.OpenBuffer[i] = (Open[i+1]+Close[i+1])/2;
      Buffers.CloseBuffer[i] = (Open[i]+High[i]+Low[i]+Close[i])/4;
      Buffers.HighBuffer[i] = MathMax(MathMax(High[i], Open[i]), Close[i]);
      Buffers.LowBuffer[i] = MathMin(MathMin(Low[i], Open[i]), Close[i]);
     }
   return 0;
  }
//+------------------------------------------------------------------+

int iAPB::GetBuffSize(void)
{
   return BufferSize;
}
