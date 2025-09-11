//+-------------------------------------------------------------------------+
//|   Identification du plus haut et plus bas prix sur une période donnée   |
//+-------------------------------------------------------------------------+
void Identify_High_Low(int nbDays){
   datetime timeTwoDaysAgo = iTime(Symbol(), PERIOD_D1, nbDays-1);
   double higher = 0;
   double lowest = DBL_MAX;
   int i = 1; //Dernière bougie cloturée      
   
   while(true){
      datetime timeCandleIndex = iTime(Symbol(), PERIOD_M30, i);
      if (timeCandleIndex < timeTwoDaysAgo) break;
      
      //Exclusion des weekends
      int dayOfWeek = TimeDayOfWeek(timeCandleIndex);
      if (dayOfWeek == 0 || dayOfWeek == 6) {
         i++;
         continue;
      }
      
      double highPriceAtCandleIndex = iHigh(Symbol(), PERIOD_M30, i);
      double lowPriceAtCandleIndex = iLow(Symbol(), PERIOD_M30, i );
      
      if (highPriceAtCandleIndex > higher) higher = highPriceAtCandleIndex;
      if(lowPriceAtCandleIndex < lowest) lowest = lowPriceAtCandleIndex;
      
      i++;
   }
   
   Print("Le prix le plus bas est : ", lowest , " / Le prix le plus Haut est : ", higher);
}
