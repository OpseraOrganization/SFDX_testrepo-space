/****************************************
* Trigger Name : CH_CustomerTargetSLATrigger
* Created Date: 26 October 2018
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 26 October 2018
* Description : All Customer SLA Related Actions will be tracked here
*****************************************/
trigger CH_CustomerTargetSLATrigger on CH_CustomerSpecificTargetSLA__c (before insert) {
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
		if(Trigger.isBefore) {
			if(Trigger.isInsert) {
				CH_CustomerTargetSLATriggerHandler.beforeInsertOperation(Trigger.NEW);						 
			}   
		}
	} 
}