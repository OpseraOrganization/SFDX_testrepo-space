/****************************************
* Trigger Name : CH_AuthorizedAccountTrigger 
* Created Date: 13 September 2018
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 13 September 2018
* Description : All CH_AuthorizedAccount__c Related Actions will be tracked here
*****************************************/
trigger CH_AuthorizedAccountTrigger on CH_AuthorizedAccount__c (before insert, before update, after insert, after update, after delete) {
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
		if(Trigger.isBefore) {
			CH_AuthorizedAccountTriggerHandler.beforeTriggerOperation(Trigger.new);
		}
		if(Trigger.isAfter) {
			if(Trigger.isInsert) {
				CH_AuthorizedAccountTriggerHandler.afterInsertOperation(Trigger.new);
			}
			if(Trigger.isUpdate) {
				CH_AuthorizedAccountTriggerHandler.afterUpdateOperation(Trigger.oldMap, Trigger.newMap);
			}
			if(Trigger.isDelete) {
				CH_AuthorizedAccountTriggerHandler.afterDeleteOperation(Trigger.old);
			}		
		}
	}
}