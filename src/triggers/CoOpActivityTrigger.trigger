/****************************************
 * Trigger Name : CoOpActivityTrigger 
 * Created Date: May 2018
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : All Co_Op_Activity__c Related Actions will be tracked here
 *****************************************/
trigger CoOpActivityTrigger on Co_Op_Activity__c (before update) {
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
		 if(Trigger.isBefore) {
			 if(Trigger.isInsert) {
				 //CoOpActivitHandler.beforeInsertOperation(Trigger.new);
			 }
			 if(Trigger.isUpdate) {
				 CoOpActivitHandler.beforeUpdateOperation(Trigger.new, Trigger.oldMap);
			 }
		}
		if(Trigger.isAfter) {
			if(Trigger.isUpdate) {
			   // CoOpActivitHandler.afterUpdateOperation(Trigger.new, Trigger.oldMap);
			}
		}
   }
}