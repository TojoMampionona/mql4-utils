//+------------------------------------------------------------------+
//|                                           Mon premier expert.mq4 |
//|                  Tojo Mampionona Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Tojo Mampionona Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//  Dynamic variables                                                |
//+------------------------------------------------------------------+
input int nbDays = 2;
input ENUM_TIMEFRAMES UserPeriod = PERIOD_M1;
input bool debug = true;
input color lineColor = clrYellow;
input int lineStyle = STYLE_SOLID;
input int lineWidth = 2;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  double myHigh, myLow;
//---
   Identify_High_Low(nbDays,UserPeriod ,myHigh, myLow);
   return(INIT_SUCCEEDED);
  }
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectDelete("Ma ligne le plus Haut");
   ObjectDelete("Ma ligne le plus Bas");
  }
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
  
//+-------------------------------------------------------------------------+
//|   Identification du plus haut et plus bas prix sur une période donnée   |
//+-------------------------------------------------------------------------+
void Identify_High_Low(int nbDays, ENUM_TIMEFRAMES period ,double &highestPrice, double &lowestPrice){
   datetime timeTwoDaysAgo = iTime(Symbol(), PERIOD_D1, nbDays-1);
   
   if(debug) Print("Analyse depuis ", nbDays, " jours avant : ", timeTwoDaysAgo);
   
   highestPrice = 0;
   lowestPrice = DBL_MAX;
   int i = 1; //Dernière bougie cloturée 
      
   bool foundCandle = false;
   
   
   // Boucle sur les bougies du timeframe choisi
   for(i = 1; ; i++)
    {
        datetime timeCandleIndex = iTime(Symbol(), period, i);

        // Si la bougie est antérieure à timeTwoDaysAgo, arrêter
        if(timeCandleIndex < timeTwoDaysAgo) break;

        // Ignorer les weekends
        int dayOfWeek = TimeDayOfWeek(timeCandleIndex);
        if(dayOfWeek == 0 || dayOfWeek == 6) continue;

        double highPriceAtCandle = iHigh(Symbol(), period, i);
        double lowPriceAtCandle  = iLow(Symbol(), period, i);

        // Vérification de la validité des prix
        if(highPriceAtCandle == 0 || lowPriceAtCandle == 0) continue;

        foundCandle = true;

        if(highPriceAtCandle > highestPrice) highestPrice = highPriceAtCandle;
        if(lowPriceAtCandle < lowestPrice)   lowestPrice  = lowPriceAtCandle;
    }
    
    
    // Si aucune bougie valide trouvée
    if(!foundCandle)
    {
        if(debug) Print("Aucune bougie valide trouvée sur la période demandée.");
        return;
    }
    
   
   // --- Traçage de la ligne du plus haut ---
    if(ObjectFind(0, "Ma ligne le plus Haut") != -1)
    {
        ObjectSetDouble(0, "Ma ligne le plus Haut", OBJPROP_PRICE, highestPrice);
        ObjectSetInteger(0, "Ma ligne le plus Haut", OBJPROP_COLOR, lineColor);
        ObjectSetInteger(0, "Ma ligne le plus Haut", OBJPROP_STYLE, lineStyle);
        ObjectSetInteger(0, "Ma ligne le plus Haut", OBJPROP_WIDTH, lineWidth);
        if(debug) Print("Ligne du plus haut mise à jour : ", highestPrice);
    }
    else
    {
        ObjectCreate(0, "Ma ligne le plus Haut", OBJ_HLINE, 0, 0, highestPrice);
        ObjectSetInteger(0, "Ma ligne le plus Haut", OBJPROP_COLOR, lineColor);
        ObjectSetInteger(0, "Ma ligne le plus Haut", OBJPROP_STYLE, lineStyle);
        ObjectSetInteger(0, "Ma ligne le plus Haut", OBJPROP_WIDTH, lineWidth);
        if(debug) Print("Ligne du plus haut créée : ", highestPrice);
    }

    // --- Traçage de la ligne du plus bas ---
    if(ObjectFind(0, "Ma ligne le plus Bas") != -1)
    {
        ObjectSetDouble(0, "Ma ligne le plus Bas", OBJPROP_PRICE, lowestPrice);
        ObjectSetInteger(0, "Ma ligne le plus Bas", OBJPROP_COLOR, lineColor);
        ObjectSetInteger(0, "Ma ligne le plus Bas", OBJPROP_STYLE, lineStyle);
        ObjectSetInteger(0, "Ma ligne le plus Bas", OBJPROP_WIDTH, lineWidth);
        if(debug) Print("Ligne du plus bas mise à jour : ", lowestPrice);
    }
    else
    {
        ObjectCreate(0, "Ma ligne le plus Bas", OBJ_HLINE, 0, 0, lowestPrice);
        ObjectSetInteger(0, "Ma ligne le plus Bas", OBJPROP_COLOR, lineColor);
        ObjectSetInteger(0, "Ma ligne le plus Bas", OBJPROP_STYLE, lineStyle);
        ObjectSetInteger(0, "Ma ligne le plus Bas", OBJPROP_WIDTH, lineWidth);
        if(debug) Print("Ligne du plus bas créée : ", lowestPrice);
    }

   if(debug) Print("High = ", highestPrice, " / Low = ", lowestPrice);
}

