/**
* @Name	NF_ApprovalRequestTrigger
* @Author  
* @Since   Dec , 2017
* @Desc	Trigger to control Approval Request before insert, after insert 
* @History 
*/
Trigger NF_ApprovalRequestTrigger on Apttus_Approval__Approval_Request__c (before insert, before update, after insert, after update) {

	if(Trigger.isbefore && Trigger.isUpdate){
		NF_TL_UpdateRequestRCode.updateAssignee_NSA(Trigger.New);
		NF_TL_UpdateRequestRCode.updateDateApporovedFieldOnValidator(trigger.New) ;  
	}
	
	if(Trigger.isBefore && Trigger.isInsert){
		NF_TL_UpdateRequestRCode.updateRequestRcodeM(Trigger.New);
	}
	
	if( Trigger.IsAfter && Trigger.IsUpdate ){
		NF_TL_UpdateRequestRCode.CopieApprovalStatus(trigger.New, Trigger.OldMap);
		NF_TL_UpdateRequestRCode.UpdateValidatorStatus(trigger.New) ;	
		NF_TL_UpdateRequestRCode.updateValidatorAndStakeholderStatus(Trigger.New, Trigger.OldMap);
	}
	
	new NF_ApprovalRequestHandler().run(); 
	// Caution: Please do not implement any logic inside triggers. 
	// Please use the trigger handlers.
	
}