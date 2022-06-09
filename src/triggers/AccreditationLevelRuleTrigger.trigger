/****************************************
* Trigger Name : AccreditationTrigger 
* Created Date: July 2018
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description : All AccreditationTrigger Related Actions will be tracked here
*****************************************/
trigger AccreditationLevelRuleTrigger on Accreditation_Level_Rule__c (before insert,after insert, before update,after update) {
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
	   if(Trigger.isAfter)
		{
			if(Trigger.isInsert)
			{
			   
				AccreditationLevelChangeHandler.afterInsertOperation(Trigger.new);
				system.debug('dxgvdrfth'); 
			}
			else if(Trigger.isUpdate)
			{
				
				AccreditationLevelChangeHandler.afterUpdateOperation(Trigger.new,Trigger.oldMap);
				
			}
		}
	}
}