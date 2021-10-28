/****************************************
* Class Name : CH_CaseCommentTrigger
* Created Date: 20 Dec 2018
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 20 Dec 2018
* Description : Scrambling the text fields in the Case Comments Object
* Test Class: 
*****************************************/
trigger CH_CaseCommentTrigger on CaseComment (before insert, after insert, before update, after delete) {
	if (Trigger.IsInsert) {
		if (Trigger.isBefore) {
			CH_CaseCommentTriggerHandler.beforeInsertOperation(Trigger.New);   
		} else {
			if (Trigger.isAfter) {
				CH_CaseCommentTriggerHandler.afterInsertOperation(Trigger.New);
			}
		}
	}
	if (Trigger.isUpdate) {   
		CH_CaseCommentTriggerHandler.beforeupdateOperation(Trigger.New);   
	}
	if (Trigger.isDelete) {
		if (Trigger.isAfter) {
			CH_CaseCommentTriggerHandler.afterDeleteOperation(Trigger.Old);
		}
	}
}