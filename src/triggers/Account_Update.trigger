trigger Account_Update on Account_Focal__c (before insert, before update,after insert, after update) 
{
    if(Trigger.isBefore)
    {             
        //Populate Customer & Business focal escalation values : In AccFocal Object, precedeSoldToValues, Declare AccountFocaldefault value
        AccountUpdateTriggerHandler.beforeActions(Trigger.new);   
    }
    if(Trigger.isAfter)
    {   
        //AccountFocaldefault section, Populate Focal & Escalation field values in Account Object, AddAccountTeamMember 
        if(!bundle_checkRecursive.isStopRecursion)
        {
            AccountUpdateTriggerHandler.makeAccountFocaldefault(Trigger.new);
        }
        AccountUpdateTriggerHandler.AccountEscalation(Trigger.new);    
        if(!bundle_checkRecursive.isStopRecursion)
        {  
            AccountUpdateTriggerHandler.AddAccountTeamMember(Trigger.new);    
        }  
    }    
}