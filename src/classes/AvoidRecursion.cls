/************************************
Name         : AvoidRecursion
Created By   : Chiranjeevi Gogulakonda
Company Name : NTT Data
Project      : M&PM Simulation Phase2
Created Date : 15 May 2017
Test Class   : 
Usages       : To Avoid Recusion in OppAfterUpdateHelperClass
*************************************/ 
public Class AvoidRecursion{
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
    
    private static boolean atrAutomation = true;
    
    public static boolean isAtrAutomation(){
        if(atrAutomation){
          atrAutomation = false;
          return true;
        }else{
            return atrAutomation;
        }
    }
    private static boolean firstRun_OpportunityProduct_UpdateTechSales = true;
    public static boolean isFirstRun_OpportunityProduct_UpdateTechSales(){
        if(firstRun_OpportunityProduct_UpdateTechSales){
          firstRun_OpportunityProduct_UpdateTechSales = false;
          return true;
        }else{
            return firstRun_OpportunityProduct_UpdateTechSales;
        }
    }
    private static boolean firstRun_preventOpportunityProductChange = true;
    public static boolean isFirstRun_preventOpportunityProductChange(){
        if(firstRun_preventOpportunityProductChange){
          firstRun_preventOpportunityProductChange = false;
          return true;
        }else{
            return firstRun_preventOpportunityProductChange;
        }
    }
    private static boolean firstRun_Releatedcustomerstories = true;
    public static boolean isFirstRun_Releatedcustomerstories(){
        if(firstRun_Releatedcustomerstories){
          firstRun_Releatedcustomerstories = false;
          return true;
        }else{
            return firstRun_Releatedcustomerstories;
        }
    }
    
    private static boolean firstRun_updateProductProductLine= true;
    public static boolean isFirstRun_UpdateProductProductLine(){
        if(firstRun_updateProductProductLine){
          firstRun_updateProductProductLine = false;
          return true;
        }else{
            return firstRun_updateProductProductLine;
        }
    }

   private static boolean firstRun_preventScheduleChange= true;
    public static boolean isFirstRun_preventScheduleChange(){
        if(firstRun_preventScheduleChange){
          firstRun_preventScheduleChange = false;
          return true;
        }else{
            return firstRun_preventScheduleChange;
        }
    }
    
    private static boolean firstRun_Updateproduct= true;
    public static boolean isFirstRun_Updateproduct(){
        if(firstRun_Updateproduct){
          firstRun_Updateproduct = false;
          return true;
        }else{
            return firstRun_Updateproduct;
        }
    }
    
   
    /*private static boolean oppAfterUpdateHelper= true;
    public static boolean isOppAfterUpdateHelper(){
        if(oppAfterUpdateHelper){
          oppAfterUpdateHelper = false;
          return true;
        }else{
            return oppAfterUpdateHelper;
        }
    }*/
}