/**
About
-----
Description: This Trigger is excuted Whenever
AccountContactRelation is inserted or updated we have to update field User.CompanyName with the Account Name.

Created for: Nokia Customer Portal
Created: 04 16 2018

Update History
--------------
Created: 07-12-2018 – manoj.gahlot.ext@nokia.com
-------------
**/
trigger AccountContactRelationTrigger on AccountContactRelation (Before Insert, Before Update, After Insert, After Update, after delete) {

	//if (!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
	{
		if (Trigger.isBefore) {
			if (Trigger.isInsert) {
	AccountContactRelationTriggerHandler.AccountContactRelationBeforeInsertOperation(Trigger.new);
			}
			if (Trigger.isUpdate) {
	AccountContactRelationTriggerHandler.AccountContactRelationBeforeUpdateOperation(Trigger.newMap, Trigger.old);
			}
		} else if (Trigger.isAfter) {
			if (Trigger.isInsert) {
	CH_AccountContactRelationTriggerHandler.afterInsertOperation(Trigger.new);
	AccountContactRelationTriggerHandler.AccountContactRelationAfterOperation(Trigger.newMap);
	AccountContactRelationTriggerHandler.createAccountContactShare(Trigger.newMap);
	DS_AccountContactRelationTriggerHandler.checkRecordExist(Trigger.new,Trigger.newMap);
			}
			if (Trigger.isUpdate) {
	CH_AccountContactRelationTriggerHandler.afterUpdateOperation(Trigger.oldMap, Trigger.newMap);
	AccountContactRelationTriggerHandler.AccountContactRelationAfterOperation(Trigger.newMap);
	AccountContactRelationTriggerHandler.updateAccountContactShare(Trigger.newMap, Trigger.oldMap);
			}
			if (Trigger.isDelete) {
	CH_AccountContactRelationTriggerHandler.afterDeleteOperation(Trigger.old);
	AccountContactRelationTriggerHandler.deleteAccountContactShare(Trigger.old);
			}
		}
	}
}