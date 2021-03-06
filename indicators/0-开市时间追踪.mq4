/*
各主要市场交易时间（北京时间）：

悉尼：06：00---15：00

东京：08：00---15：30

香港：09：00---16：00

法兰克福：15：00---23：00

伦敦：15：30---23：30（冬令时间16：30---00：30） 

纽约：20：20---03：00（冬令时间21：20---04：00）

每年三月的第二个星期日是为夏令时间的开始，至每年十一月的第一个星期日结束，其他时间为冬令时！


外汇交易时间最活跃交易时段:

1.亚洲交易时段最活跃(北京时间05:00-17:00)

2.欧洲交易时段最活跃(北京时间15:00-24:00)

3.北美交易时段最活跃(北京时间20:00-05:00)

北京时间晚上8点到晚上12点是欧洲和美国的重叠交易时段，市场通常在这个时间段最活跃。
*///
#property indicator_separate_window
#property strict

#property indicator_minimum 0.0
#property indicator_maximum 9.0
#property indicator_buffers 4
#property indicator_color1 Lime
#property indicator_color2 Red
#property indicator_color3 Blue
#property indicator_color4 Yellow

extern bool   启用冬令时=false;
extern int    平台与北京时差=5;

 string iname = " 开市时间追踪";
//// 
 string 悉尼开市 = "06:00";
 string 悉尼收市 = "15:00";
 string 东京开市 = "08:00";
 string 东京收市 = "15:30";
 string 伦敦开市 = "15:30"; // 夏令时，冬令时+1
 string 伦敦收市 = "23:30";
 string 纽约开市 = "20:20";
 string 纽约收市 = "03:00";

double lundonBuff[];
double newyorBuff[];
double sydneyBuff[];
double tokyoBuff[];

int dhour;
int init() {   
   IndicatorShortName(iname);
   SetIndexBuffer(0, lundonBuff);
   SetIndexLabel(0, "伦敦");
   SetIndexBuffer(1, newyorBuff);
   SetIndexLabel(1, "纽约");
   SetIndexBuffer(2, sydneyBuff);
   SetIndexLabel(2, "悉尼");
   SetIndexBuffer(3, tokyoBuff);
   SetIndexLabel(3, "东京");
   
   if(启用冬令时==true)
     {
       伦敦开市 = "16:30";
       伦敦收市 = "00:30";
       纽约开市 = "21:20";
       纽约收市 = "04:00";      
     }
   int defHour = MathAbs(TimeHour(TimeCurrent()) - TimeHour(TimeLocal()));
   Print("off hour:---> ",defHour);
   
   dhour = 平台与北京时差;
   悉尼开市 = TimeHour(StrToTime(悉尼开市))-dhour;
   悉尼收市 = TimeHour(StrToTime(悉尼收市))-dhour;
   东京开市 = TimeHour(StrToTime(东京开市))-dhour;
   东京收市 = TimeHour(StrToTime(东京收市))-dhour;
   伦敦开市 = iif(TimeHour(StrToTime(伦敦开市)),dhour)-dhour;
   伦敦收市 = iif(TimeHour(StrToTime(伦敦收市)),dhour)-dhour;
   纽约开市 = iif(TimeHour(StrToTime(纽约开市)),dhour)-dhour;
   纽约收市 = iif(TimeHour(StrToTime(纽约收市)),dhour)-dhour;
   return (0);
}

int start() {
   if(启用冬令时==true)
      {
         Drawtext("lundon", "                        伦敦[16:30-00:30]", Time[0], 9, Lime);
         Drawtext("newyor", "                        纽约[21:20-04:00]", Time[0], 7, Red);
         Drawtext("sydney", "                        悉尼[06:00-15:00]", Time[0], 5, Blue);
         Drawtext("tokyo",  "                        东京[08:00-15:30]", Time[0], 3, Yellow);
      }
   else
     {
         Drawtext("lundon", "                        伦敦[15:30-23:30]", Time[0], 9, Lime);
         Drawtext("newyor", "                        纽约[20:20-03:00]", Time[0], 7, Red);
         Drawtext("sydney", "                        悉尼[06:00-15:00]", Time[0], 5, Blue);
         Drawtext("tokyo",  "                        东京[08:00-15:30]", Time[0], 3, Yellow);
     }
   int limit = Bars - IndicatorCounted();
   if (limit < Bars) limit++;
   for (int i = limit - 1; i >= 0; i--) {
      if (isMarketOpen(伦敦开市, 伦敦收市, Time[i])) lundonBuff[i] = 8;
      else lundonBuff[i] = EMPTY_VALUE;
      if (isMarketOpen(纽约开市, 纽约收市, Time[i])) newyorBuff[i] = 6;
      else newyorBuff[i] = EMPTY_VALUE;
      if (isMarketOpen(悉尼开市, 悉尼收市, Time[i])) sydneyBuff[i] = 4;
      else sydneyBuff[i] = EMPTY_VALUE;
      if (isMarketOpen(东京开市, 东京收市, Time[i])) tokyoBuff[i] = 2;
      else tokyoBuff[i] = EMPTY_VALUE;
   }
   return (0);
}

bool isMarketOpen(string shour, string ehour, datetime chour) {
   string strdate = TimeToString(chour,TIME_DATE) + " " ; //
   //string strdate = TimeYear(chour) + "." + TimeMonth(chour) + "." + TimeDay(chour) + " ";
   datetime stime = StrToTime(strdate + shour);
   datetime etime = StrToTime(strdate + ehour);
   if (stime < etime && (chour >= stime && chour <= etime)) return (TRUE);
   if (stime > etime && (chour >= stime || chour <= etime)) return (TRUE);
   return (FALSE);
}

void DrawL(string name, string txt, int x, int y, int fontsize) {
   ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(name, txt, fontsize, "Arial ", Yellow);
   ObjectSet(name, OBJPROP_CORNER, 0);
   ObjectSet(name, OBJPROP_XDISTANCE, x);
   ObjectSet(name, OBJPROP_YDISTANCE, y);
}

void Drawtext(string name, string txt, datetime time1, double price1, color clrcolor) {
   ObjectCreate(name, OBJ_TEXT, FindWindow(), 0, 0);
   ObjectSetText(name, txt, 8, "Times New Roman", clrcolor);
   ObjectSet(name, OBJPROP_TIME1, time1);
   ObjectSet(name, OBJPROP_PRICE1, price1);
}

int FindWindow() {
   return (WindowFind(iname));
}

int deinit() {
   ObjectsDeleteAll(FindWindow(), OBJ_TEXT);
   return (0);
}
int iif(int h1,int h2)
{
   if(h1>=h2) return(h1);
   else if(h1<h2) return(h1+24);
   return h1;
}