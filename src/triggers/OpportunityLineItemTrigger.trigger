trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert,before update, before delete,after insert ,after update,after delete) {
    
        TriggerDispatcher.Run(new OpportunityLineItemTriggerHandler());
        /*if(AvoidRecursion1.isFirstRun_OpportunityLineItemTrigger ()){
    }*/

    
}