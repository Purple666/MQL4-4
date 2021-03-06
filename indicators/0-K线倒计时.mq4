//+------------------------------------------------------------------+
//|                                                      0-K线倒计时.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectDelete("valTime");
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   CandleTime();
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void CandleTime()
  {
   int m,tmp;
   string s,txt="";

//if(CandleTime_Enabled==TRUE)
     {
      m=Time[0]+60*Period()-TimeCurrent();
      tmp=m%60;
      m=(m-tmp)/60;
      if(m>=0)
        {
         s=tmp;
         if(StringLen(s)==1) s="0"+s;
        }
      if(ObjectFind("valTime")==-1)
        {
         ObjectCreate("valTime",OBJ_TEXT,0,0,0);
         ObjectSet("valTime",OBJPROP_SELECTABLE,false);
        }

      txt="                      <--"+m+":"+s+"  "+DoubleToString((Ask-Bid)/Point,0);
      ObjectSetText("valTime",txt,14,"Verdana",clrWhite);
      ObjectMove("valTime",0,Time[0],Ask);

     }
//else
//  {
//   if(ObjectFind("valTime")!=-1)
//      ObjectDelete("valTime");
//  }
  }
//+------------------------------------------------------------------+
