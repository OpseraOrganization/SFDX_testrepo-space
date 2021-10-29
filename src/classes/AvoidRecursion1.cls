public Class AvoidRecursion1{
    private static integer callsCount = 0;
    public static integer checkCount(){
        callsCount = callsCount+1;
        return callsCount;
    }
    
     private static boolean firstRun = true;
    
    public static boolean isFirstRun(){
        if(firstRun){
          firstRun = false;
          return true;
        }else{
            return firstRun;
        }
    }
    
    private static boolean firstRun_Opportunity_Prod_Update_RevenueSchedule= true;
    public static boolean isFirstRun_Opportunity_Prod_Update_RevenueSchedule(){
        if(firstRun_Opportunity_Prod_Update_RevenueSchedule){
          firstRun_Opportunity_Prod_Update_RevenueSchedule = false;
          return true;
        }else{
            return firstRun_Opportunity_Prod_Update_RevenueSchedule;
        }
    }  
    }