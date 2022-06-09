/***********************************
Trigger Name: ProgramFlagTrigger 
Author: Accenture
Reason: Sales Process : This is to lock relatedList of opportunity.
Created Date:Feb / 2017 
******************************************/
trigger ProgramFlagTrigger on OptyProgramFlagJunction__c (Before update,before delete,Before insert,after insert,after update) {
	 //if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		if(Trigger.isBefore && Trigger.isInsert){
			OptyProgramFlagJunctionTriggerHandler.beforeInsertOperation(Trigger.new);
		}
		else if(Trigger.isAfter && Trigger.isInsert){
			system.debug('After Insert Trigger1');
			OptyProgramFlagJunctionTriggerHandler.afterInsertOperation(Trigger.new);
			system.debug('After Insert Trigger2');
		}
		else if(Trigger.isBefore && Trigger.isUpdate){
			OptyProgramFlagJunctionTriggerHandler.beforeUpdateOperation(Trigger.new);
		}
		else if(Trigger.isBefore && Trigger.isDelete){
			OptyProgramFlagJunctionTriggerHandler.beforeDeleteOperation(Trigger.old);
		}
	else if (Trigger.isAfter && Trigger.isUpdate){
			system.debug('Trigger after update');
			OptyProgramFlagJunctionTriggerHandler.afterUpdateOperation(Trigger.newMap,Trigger.oldMap);
		}
		/*else if(Trigger.isAfter && Trigger.isDelete){
			//Sales Process: Req 1454
			system.debug('Inside After Delete');
			OptyProgramFlagJunctionTriggerHandler.afterDeleteOperation(Trigger.new);
		}*/
   //}	 
}