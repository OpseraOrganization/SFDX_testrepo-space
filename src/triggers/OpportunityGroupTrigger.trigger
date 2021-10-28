/****************************************
 * Trigger Name : OpportunityGroupTrigger 
 * Created By : Accenture
 * Last Modified by: Accenture
 * Description: All Deal-Opportunity Grouping events are handled here
 *****************************************/
trigger OpportunityGroupTrigger on Opportunity_Group__c (before insert, before update, before delete) {
	if(Trigger.isBefore)
	{
		if(Trigger.isInsert)
		{
			//Req. 4943
			OpportunityGroupTriggerHandler.beforeInsert(Trigger.New);   
		}
		if(Trigger.isUpdate)
		{
			//Req. 4943
			OpportunityGroupTriggerHandler.beforeUpdate(Trigger.New ,Trigger.OldMap);   
		}
		if(Trigger.isDelete){
			// Req 4943
	  OpportunityGroupTriggerHandler.beforeDelete(Trigger.OldMap);
		}
	}
}