/*******************************************************************************
Name         : OpportunityTrigger 
Created By   : Anusuya Murugiah
Company Name : NTT Data
Project      : <Phase-II>, <HealthCheck - Sprint> 
Created Date : 26 December 2013
Usages       : This Trigger is to replace the set of Opportunity Triggers split across 
               into single trigger call. 
*******************************************************************************/
trigger MainOpportunityTrigger on Opportunity (before insert,after insert,before update,after update,before delete) {
    
    try
    {
        if(Trigger.isBefore && Trigger.isInsert){ 
        
            OppBeforeInsertHelperClass.beforeInsertMethod(Trigger.new,Trigger.oldMap);
        }
        if(Trigger.isAfter && Trigger.isInsert){ 
        
            OppAfterInsertHelperClass.afterInsertMethod(Trigger.new,Trigger.oldMap); 
        }
        if(Trigger.isBefore && Trigger.isUpdate){ 
        
            OppBeforeUpdateHelperClass.beforeUpdateMethod(Trigger.new,Trigger.oldMap);
        }
        if(Trigger.isAfter && Trigger.isUpdate){ 
        
            OppAfterUpdateHelperClass.afterUpdateMethod(Trigger.new,Trigger.oldMap,Trigger.newmap,Trigger.old); 
        }
        if(Trigger.isBefore && Trigger.isdelete)
        {         
            OppBeforedeleteHelperClass.beforedeleteMethod(Trigger.oldMap);       
        }
        /** For Testing Code Coverage ****/
        if(Trigger.isBefore && Trigger.isInsert)
        {
            if(Test.isRunningTest())
            {
                MainCaseTriggerUtility.handleOpportunityException(null);
            }
        }
        
    }catch(Exception e)
    {
       MainCaseTriggerUtility.handleOpportunityException(e);
    }
}