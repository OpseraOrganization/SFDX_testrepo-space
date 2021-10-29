/*******************************************************************************
Name         : Updateproduct 
Created By   : Satya
Company Name : Honeywell
Project      : AERO Sales 
Created Date : 12 March 2017
Usages       : This Trigger is update the Product Line record's Factored Probability field while creating the Product record. 
*******************************************************************************/
trigger Updateproduct on OpportunityLineItem (before insert,before update) {
   if(AvoidRecursion.isFirstRun_Updateproduct()){
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            List<OpportunityLineItem> lstOppLiniitemUpdate = new List<OpportunityLineItem>();
            set<Id> opptId = new set<Id>();
             //Get Set of Opportunity Line Item Id's
            //Iterate through the Opportunity Line Items
            for(OpportunityLineItem opptli : trigger.new){
                opptId.add(opptli.OpportunityId);
            }
             //Get Opportunity which are associated to the Opportunity Line Items
            List<Opportunity> lstOpportunity = [SELECT Id, Combined_Probability__c, StageName,ATR_Probability__c, Program_Go_Probability__c from Opportunity WHERE Id in: opptId];
            for(Opportunity oppt : lstOpportunity){
                for(OpportunityLineItem oli: trigger.new){
                    //Need to do a check if the current Opportunity product's Opportunity Id is equals to the Opportunity Id that is on the iteration.
                    if(oli.OpportunityID == oppt.Id){
                        if(oppt.StageName =='Closed Won'){
                            oli.Forecast_Factor_AI__c = 100;
                        }
                        if(oppt.StageName =='Closed Lost' || oppt.StageName =='Closed Cancelled'){
                            oli.Forecast_Factor_AI__c = 0;
                        }
                       /* if(oli.Type__c !='Booked'){
                            oli.Probability__c = oppt.Combined_Probability__c;                            
                            lstOppLiniitemUpdate.add(oli);
                        }else{
                            oli.Probability__c =100;                           
                            lstOppLiniitemUpdate.add(oli);
                        }*/
                    }
                }
            }
        }
    }
    }
}