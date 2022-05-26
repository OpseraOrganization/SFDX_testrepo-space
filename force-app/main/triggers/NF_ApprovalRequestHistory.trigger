trigger NF_ApprovalRequestHistory on Apttus_Approval__Approval_Request_History__c (before insert, after insert) {
	if(Trigger.isInsert && Trigger.isAfter){
		NF_TL_UpdateHistoryRequestRCode.updateHistoryRequestRcodeM(Trigger.new);
	}
}