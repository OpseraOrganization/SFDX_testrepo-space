/***********************************************
*	Trigger Name : AccountMemberTrigger 
*	Created By : Accenture IDC
*	Created Date :28/August/2017
*	Description : This will handle the Account Team Actions
*	Requirement : Lead & certification Sharing
*********************************************/


trigger AccountMemberTrigger on Account_Member__c (before insert , before update, After insert , before delete,  after update, after delete) {

 if(Trigger.isDelete){  
	AccountMemberHelperPRM.unshareCertificationOnDelete(Trigger.old);
   // AccountMemberHelperPRM.unshareLeadOnDelete(Trigger.old);
		 if(Trigger.isAfter){
				
		 }
	}
	
	if(Trigger.isInsert){
   // AccountMemberHanlderPRM.sharePRM(Trigger.new);
	//AccountMemberHanlderPRM.sharePRM.shareCertificationOnInsertPRM(Trigger.new);
	AccountMemberHanlderPRM.sharePSM(Trigger.new);
	
		 if(Trigger.isBefore){
				
			}
		  if(Trigger.isAfter){
				
			}
	}
	if(Trigger.isUpdate){
		//AccountMemberHanlderPRM.shareUpdatePRM(Trigger.new,Trigger.new[0],Trigger.Old[0]);
		//AccountMemberHanlderPRM.shareUpdatePRM.shareCertificationOnUpdatePRM(Trigger.new,Trigger.new[0],Trigger.Old[0]);
		AccountMemberHanlderPRM.shareUpdatePSM(Trigger.new,Trigger.new[0],Trigger.Old[0]);
		//AccountMemberHanlderPRM.shareUpdatePRM.shareLeadOnUpdateAccountRole(Trigger.new,Trigger.new[0],Trigger.Old[0]);
		//AccountMemberHanlderPRM.shareUpdatePRM.shareCertificationOnUpdateAccountRolePRM(Trigger.new,Trigger.new[0],Trigger.Old[0]);
		//AccountMemberHanlderPRM.shareUpdatePSM.shareCertificationOnUpdateAccountRolePSM(Trigger.new,Trigger.new[0],Trigger.Old[0]);
	}

}