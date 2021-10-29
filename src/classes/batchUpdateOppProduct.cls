global class batchUpdateOppProduct implements Database.Batchable<sObject>,Schedulable{

   
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        String query = 'SELECT MasterLabel, Close_Date_Range_Max__c, Close_Date_Range_Min__c, Has_Product__c, Has_Schedule__c, Last_Modified_Owner_Range_Max__c, Last_Modified_Owner_Range_Min__c, Last_Modified_Range_Max__c, Last_Modified_Range_Min__c, OLI_Revenue_Type__c, Opp_Stage__c, Revenue_Start_Range_Max__c, Revenue_Start_Range_Min__c, Vertical__c, Win_Probability_Cap__c FROM SIOP_Forecast__mdt';
        system.debug('**********query'+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<SIOP_Forecast__mdt> scope){
      
        OpportunityLineItem OLIObj;
        OpportunityLineItem OLIObjs;
        List<OpportunityLineItem> OLIList = new List<OpportunityLineItem>();
        System.debug(scope.size()+'htr meta data are===='+scope);
        List<OpportunityLineItem> OppListVal = new List<OpportunityLineItem>();
        map<String, OpportunityLineItem> removeDup = new map<String, OpportunityLineItem>();
        
        List<OpportunityLineItem> OppList1 = [SELECT Id, Probability__c,Type__c, Opportunity.SBU__c, Opportunity.StageName, Opportunity.HasOpportunityLineItem, Has_Schedule__c, Revenue_Type__c, Opportunity.Last_Modified_User_Range__c, Revenue_Start_Range__c,closeddifferent_days__c, Opportunity.Last_Modified_Owner_Range__c FROM OpportunityLineItem WHERE Type__c = 'Forecast' AND Revenue_Type__c = 'RMU' and Opportunity.IsClosed = FALSE ];
    
        for(OpportunityLineItem OppList : OppList1){         
           if(OppList1.size() > 0){
               System.debug(OppListVal.size()+'the list is ----'+OppListVal);
               for(SIOP_Forecast__mdt siopForecast : scope){
                    OLIObj = new OpportunityLineItem();                   
                    Decimal prob =0.00;
             //Scenario where Vertical = Any and Opp Stage = Any
            if(siopForecast.Vertical__c == 'Any' && siopForecast.Opp_Stage__c == 'Any' && OppList.Type__c == 'Forecast' && OppList.Opportunity.HasOpportunityLineItem == siopForecast.Has_Product__c  && OppList.Has_Schedule__c == siopForecast.Has_Schedule__c && OppList.Revenue_Type__c == siopForecast.OLI_Revenue_Type__c  &&  OppList.closeddifferent_days__c <= siopForecast.Close_Date_Range_Max__c &&  OppList.closeddifferent_days__c >= siopForecast.Close_Date_Range_Min__c &&  OppList.Opportunity.Last_Modified_User_Range__c <= siopForecast.Last_Modified_Range_Max__c &&  OppList.Opportunity.Last_Modified_User_Range__c >= siopForecast.Last_Modified_Range_Min__c &&  OppList.Revenue_Start_Range__c <= siopForecast.Revenue_Start_Range_Max__c &&  OppList.Revenue_Start_Range__c >= siopForecast.Revenue_Start_Range_Min__c &&  OppList.Opportunity.Last_Modified_Owner_Range__c <= siopForecast.Last_Modified_Owner_Range_Max__c &&  OppList.Opportunity.Last_Modified_Owner_Range__c >= siopForecast.Last_Modified_Owner_Range_Min__c ){
                
                   if(OppList.Probability__c <= siopForecast.Win_Probability_Cap__c){
                        prob = OppList.Probability__c;
                    }
                    if(OppList.Probability__c > siopForecast.Win_Probability_Cap__c){
                        prob = siopForecast.Win_Probability_Cap__c;
                    }
                    if(prob >= 0.00){
                        OLIObj.id = OppList.Id;
                        OLIObj.Forecast_Factor_AI__c = prob;
                        OLIObj.SIOP_Forecast_ID__c = siopForecast.MasterLabel;                       
                        //OLIList.add(OLIObj);
                        removeDup.put(OppList.Id, OLIObj);                        
                 }
                  
           }
           //Scenario where Vertical != Any and Opp Stage = Any
            if(siopForecast.Vertical__c != 'Any' && siopForecast.Opp_Stage__c == 'Any' &&  OppList.Opportunity.SBU__c == siopForecast.Vertical__c && OppList.Type__c == 'Forecast' && OppList.Opportunity.HasOpportunityLineItem == siopForecast.Has_Product__c  && OppList.Has_Schedule__c == siopForecast.Has_Schedule__c && OppList.Revenue_Type__c == siopForecast.OLI_Revenue_Type__c  &&  OppList.closeddifferent_days__c <= siopForecast.Close_Date_Range_Max__c &&  OppList.closeddifferent_days__c >= siopForecast.Close_Date_Range_Min__c &&  OppList.Opportunity.Last_Modified_User_Range__c <= siopForecast.Last_Modified_Range_Max__c &&  OppList.Opportunity.Last_Modified_User_Range__c >= siopForecast.Last_Modified_Range_Min__c &&  OppList.Revenue_Start_Range__c <= siopForecast.Revenue_Start_Range_Max__c &&  OppList.Revenue_Start_Range__c >= siopForecast.Revenue_Start_Range_Min__c &&  OppList.Opportunity.Last_Modified_Owner_Range__c <= siopForecast.Last_Modified_Owner_Range_Max__c &&  OppList.Opportunity.Last_Modified_Owner_Range__c >= siopForecast.Last_Modified_Owner_Range_Min__c ){
               
                   if(OppList.Probability__c <= siopForecast.Win_Probability_Cap__c){
                        prob = OppList.Probability__c;
                    }
                    if(OppList.Probability__c > siopForecast.Win_Probability_Cap__c){
                        prob = siopForecast.Win_Probability_Cap__c;
                    }
                    if(prob >= 0.00){
                        OLIObj.id = OppList.Id;
                        OLIObj.Forecast_Factor_AI__c = prob;
                        OLIObj.SIOP_Forecast_ID__c = siopForecast.MasterLabel;                       
                        //OLIList.add(OLIObj);
                        removeDup.put(OppList.Id, OLIObj);                        
                    }
           }
           //Scenario where both vertical and Opp Stage != Any
           if(siopForecast.Vertical__c != 'Any' && siopForecast.Opp_Stage__c != 'Any'&&  OppList.Type__c == 'Forecast' &&  OppList.Opportunity.HasOpportunityLineItem == siopForecast.Has_Product__c  &&  OppList.Has_Schedule__c == siopForecast.Has_Schedule__c &&  OppList.Opportunity.SBU__c == siopForecast.Vertical__c && OppList.Opportunity.StageName == siopForecast.Opp_Stage__c &&  OppList.Revenue_Type__c == siopForecast.OLI_Revenue_Type__c  &&  OppList.closeddifferent_days__c <= siopForecast.Close_Date_Range_Max__c &&  OppList.closeddifferent_days__c >= siopForecast.Close_Date_Range_Min__c &&  OppList.Opportunity.Last_Modified_User_Range__c <= siopForecast.Last_Modified_Range_Max__c && OppList.Opportunity.Last_Modified_User_Range__c >= siopForecast.Last_Modified_Range_Min__c &&  OppList.Revenue_Start_Range__c <= siopForecast.Revenue_Start_Range_Max__c &&  OppList.Revenue_Start_Range__c >= siopForecast.Revenue_Start_Range_Min__c &&  OppList.Opportunity.Last_Modified_Owner_Range__c <= siopForecast.Last_Modified_Owner_Range_Max__c &&  OppList.Opportunity.Last_Modified_Owner_Range__c >= siopForecast.Last_Modified_Owner_Range_Min__c ){
               System.debug('the list is11111'+siopForecast);
              
               if(OppList.Probability__c <= siopForecast.Win_Probability_Cap__c){
                    prob = OppList.Probability__c;
                }
                if(OppList.Probability__c > siopForecast.Win_Probability_Cap__c){
                    prob = siopForecast.Win_Probability_Cap__c;
                }
                if(prob >= 0.00){
                    OLIObj.id = OppList.Id;
                    OLIObj.Forecast_Factor_AI__c = prob;
                    OLIObj.SIOP_Forecast_ID__c = siopForecast.MasterLabel;                       
                    //OLIList.add(OLIObj);
                    removeDup.put(OppList.Id, OLIObj);                        
                }
           }
           //Scenario where Vertical = Any but Stage != Any                      
           if(siopForecast.Vertical__c == 'Any' &&  OppList.Type__c == 'Forecast' &&  OppList.Opportunity.HasOpportunityLineItem == siopForecast.Has_Product__c  &&  OppList.Has_Schedule__c == siopForecast.Has_Schedule__c &&  OppList.Opportunity.StageName == siopForecast.Opp_Stage__c && OppList.Revenue_Type__c == siopForecast.OLI_Revenue_Type__c  &&  OppList.closeddifferent_days__c <= siopForecast.Close_Date_Range_Max__c &&  OppList.closeddifferent_days__c >= siopForecast.Close_Date_Range_Min__c &&  OppList.Revenue_Start_Range__c <= siopForecast.Revenue_Start_Range_Max__c &&  OppList.Revenue_Start_Range__c >= siopForecast.Revenue_Start_Range_Min__c  &&  OppList.Opportunity.Last_Modified_User_Range__c <= siopForecast.Last_Modified_Range_Max__c  &&  OppList.Opportunity.Last_Modified_User_Range__c >= siopForecast.Last_Modified_Range_Min__c &&  OppList.Opportunity.Last_Modified_Owner_Range__c <= siopForecast.Last_Modified_Owner_Range_Max__c &&  OppList.Opportunity.Last_Modified_Owner_Range__c >= siopForecast.Last_Modified_Owner_Range_Min__c ){
               System.debug('the list is2222'+siopForecast);
               
               if(OppList.Probability__c <= siopForecast.Win_Probability_Cap__c){
                    prob = OppList.Probability__c;
                }
                if(OppList.Probability__c > siopForecast.Win_Probability_Cap__c){
                    prob = siopForecast.Win_Probability_Cap__c;
                }
                if(prob >= 0.00){
                    OLIObj.id = OppList.Id;
                    OLIObj.Forecast_Factor_AI__c = prob;
                    OLIObj.SIOP_Forecast_ID__c = siopForecast.MasterLabel;                       
                    //OLIList.add(OLIObj);
                    removeDup.put(OppList.Id, OLIObj);                        
                }
           }               
                  //Scenario where Vertical != Any but Stage = Any and product is not scheduled                      
           if(siopForecast.Vertical__c != 'Any' &&  siopForecast.Opp_Stage__c == 'Any' && OppList.Type__c == 'Forecast' &&  OppList.Opportunity.HasOpportunityLineItem == siopForecast.Has_Product__c  &&  OppList.Has_Schedule__c == siopForecast.Has_Schedule__c && OppList.Opportunity.SBU__c == siopForecast.Vertical__c    && OppList.Revenue_Type__c == siopForecast.OLI_Revenue_Type__c && OppList.closeddifferent_days__c <= siopForecast.Close_Date_Range_Max__c &&  OppList.closeddifferent_days__c >= siopForecast.Close_Date_Range_Min__c &&  OppList.Opportunity.Last_Modified_User_Range__c <= siopForecast.Last_Modified_Range_Max__c  &&  OppList.Opportunity.Last_Modified_User_Range__c >= siopForecast.Last_Modified_Range_Min__c &&  OppList.Opportunity.Last_Modified_Owner_Range__c <= siopForecast.Last_Modified_Owner_Range_Max__c &&  OppList.Opportunity.Last_Modified_Owner_Range__c >= siopForecast.Last_Modified_Owner_Range_Min__c ){
               System.debug('the list is2222'+siopForecast);
               
               if(OppList.Probability__c <= siopForecast.Win_Probability_Cap__c){
                    prob = OppList.Probability__c;
                }
                if(OppList.Probability__c > siopForecast.Win_Probability_Cap__c){
                    prob = siopForecast.Win_Probability_Cap__c;
                }
                if(prob >= 0.00){
                    OLIObj.id = OppList.Id;
                    OLIObj.Forecast_Factor_AI__c = prob;
                    OLIObj.SIOP_Forecast_ID__c = siopForecast.MasterLabel;                       
                    //OLIList.add(OLIObj);
                    removeDup.put(OppList.Id, OLIObj);                        
                }
           }          
                                 
               }
            }
       }
        
        
        System.debug(removeDup.size()+'the map  is!!!!!'+removeDup);
        for(String idVal : removeDup.keySet()){
            OLIObjs = new OpportunityLineItem();
            OLIObjs.id = removeDup.get(idVal).id;
            OLIObjs.Forecast_Factor_AI__c = removeDup.get(idVal).Forecast_Factor_AI__c;
            OLIObjs.SIOP_Forecast_ID__c = removeDup.get(idVal).SIOP_Forecast_ID__c;
            OLIList.add(OLIObjs);
        }
           
     if(!Test.isRunningTest()){  
        if(OLIList.size()>0){
            System.debug('to update values======'+OLIList.size());
            update OLIList;
        }     
     }   
    }
    global void finish(Database.BatchableContext BC) {
    if(!Test.isRunningTest()){

        // execute any post-processing operations
        System.debug(LoggingLevel.INFO, '==Batch Job Complete==');
        }
    }
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
        batchUpdateOppProduct buop = new batchUpdateOppProduct();
        Database.executeBatch(buop,1);
        }
    }
     
}