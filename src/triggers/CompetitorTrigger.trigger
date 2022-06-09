/***********************************
Trigger Name: CompetitorTrigger
Author: Accenture
Reason: Sales Process : To handle all competitor events.
Created Date:Feb / 2017 
******************************************/
trigger CompetitorTrigger on Competitor__c (Before update,before delete,Before insert, after insert, after update) {
	if(Trigger.isBefore){
		if(Trigger.isInsert){
			CompetitorTriggerHandler.beforeInsertOperation(Trigger.new);
		}
		if(Trigger.isUpdate){
			 CompetitorTriggerHandler.beforeUpdateOperation(Trigger.new,Trigger.oldMap);
		}
		if(Trigger.isDelete){
			CompetitorTriggerHandler.beforeDeleteOperation(Trigger.oldMap);
		}
	}	
   if(Trigger.isAfter){
	   if(Trigger.isInsert){
		   CompetitorTriggerHandler.afterInsertOperation(Trigger.new);
	   }
	   if(Trigger.isUpdate){
		   CompetitorTriggerHandler.afterUpdateOperation(Trigger.newMap,Trigger.oldMap);				  
	   }
   }
}