/****************************************
* Trigger Name : OpportunityTrigger
* Created Date: 7th November 2016
* Created By : Accenture
* Last Modified by: HCL Technologies
* Last Modified Date: 10 Jan 2021
* Description: All Opportunity events are handled here
*****************************************/
trigger OpportunityTrigger on Opportunity (before insert,after insert, before Update, after update, before Delete, after Delete)
{
	if(!Nokia_CPQ_Constants.isCloneRun)
	{
		OpportunityTriggerHandler OpptTrigHandler = new OpportunityTriggerHandler();
		if(Trigger.isBefore)
		{
			if(Trigger.isUpdate)
			{
	CLM_OpportunityTriggerHandler.beforeUpdate(Trigger.oldMap,Trigger.newMap);
	OpptTrigHandler.beforeUpdate(Trigger.new, Trigger.oldMap,Trigger.newMap);
	OpportunityTriggerHandlerPRM.recordTypeUpdate(Trigger.oldMap,Trigger.newMap);
			}
			if(Trigger.isInsert)
			{
	IndirectCPQ_OpportunityTriggerHandler.beforeInsert(Trigger.new);
	OpptTrigHandler.beforeInsert(Trigger.new,Trigger.newMap);
			}
			if(Trigger.isDelete)
			{
			}
		}
		if(Trigger.isAfter){
			if(Trigger.isInsert)
			{
	OpptTrigHandler.afterInsert(trigger.new);
	OpportunityTriggerHandlerPRM.afterInsert(trigger.new);
	OpportunityTriggerHandlerPRM.ShareOpptyWithApprover(Trigger.newMap);
	IndirectCPQ_OpportunityTriggerHandler.afterInsert(Trigger.new);
			}
			if(Trigger.isDelete)
			{
	OpptTrigHandler.afterDelete(Trigger.oldMap);
			}
		}
	
		if(Trigger.isAfter &&  Trigger.isUpdate)
		{
			OpportunityTriggerHandlerPRM.afterUpdate(Trigger.new[0],Trigger.Old[0]);
			OpptTrigHandler.afterUpdate(Trigger.newMap, Trigger.oldMap);
			OpportunityTriggerHandlerPRM.afterUpdateOppty(Trigger.oldMap,Trigger.newMap);  
			OpportunityTriggerHandlerPRM.afterOTMDelete(Trigger.old[0],Trigger.new[0]);
			OpportunityTriggerHandlerPRM.ShareOpptyWithApprover(Trigger.newMap);
		}
	}
}