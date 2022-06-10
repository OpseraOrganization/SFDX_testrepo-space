/****************************************
* Class Name : WorkgroupInstructionsTrigger
* Created Date: 12 Dec 2019
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 
* Description : Contains common business logic
*****************************************/
trigger WorkgroupInstructionsTrigger on CH_WorkgroupInstructions__c (before insert, before update, after update, after insert) {
	if(Trigger.isBefore) {
		if(Trigger.isInsert) {
			CH_CA_WorkgroupInstructionsHandler.beforeInsertOperation(Trigger.New);
		}
		if(Trigger.isUpdate) {
			CH_CA_WorkgroupInstructionsHandler.beforeUpdateOperation(Trigger.new,Trigger.oldMap);
		}
	}
}