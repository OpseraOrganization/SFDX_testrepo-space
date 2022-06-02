/***********************************
Trigger Name: CompetitorTrigger
Author: Accenture
Reason: Sales Process : This is to lock relatedList of opportunity.
Created Date:Feb / 2017 
******************************************/
trigger QuestionnaireTrigger on Questionnaire__c (Before update,before delete,Before insert) {
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		if(Trigger.isBefore && Trigger.isInsert){
			QuestionnaireTriggerHandler.beforeInsertOperation(Trigger.new);
		}
		else if(Trigger.isBefore && Trigger.isUpdate){
			QuestionnaireTriggerHandler.beforeUpdateOperation(Trigger.new);
		}
		else if(Trigger.isBefore && Trigger.isDelete){
			QuestionnaireTriggerHandler.beforeDeleteOperation(Trigger.old);
		}
   }	 
}