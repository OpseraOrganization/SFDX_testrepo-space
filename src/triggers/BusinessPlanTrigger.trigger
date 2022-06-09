/****************************************
 * Trigger Name : BusinessPlanTrigger 
 * Created Date: 1 Sep 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : All Business_Plan__c Related Actions will be tracked here
 *****************************************/
trigger BusinessPlanTrigger on Business_Plan__c (Before update, after update) {
	 if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
		if(Trigger.isBefore) {
			if(Trigger.isUpdate) {
			System.debug(':::::Trigger.new::::::: ' +Trigger.old);
				BusinessPlanTriggerHandler.beforeUpdateOperation(Trigger.new, Trigger.NewMap, Trigger.oldMap);
				
			}
			 
	   }
		if(Trigger.isAfter) {
			if(Trigger.isUpdate) {
			System.debug(':::::Trigger.new::::::: ' +Trigger.old);
				BusinessPlanTriggerHandler.afterUpdateOperation(Trigger.new, Trigger.oldMap);
				
			}
			 
	   }
   }
	   
}