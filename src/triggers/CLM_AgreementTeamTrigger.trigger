trigger CLM_AgreementTeamTrigger on CLM_Agreement_Team__c (before insert, before update, before delete) {
	if(trigger.isBefore && trigger.isInsert){
		CLM_AgrmntCustomActionsCtrl.agrmntSharingWithTeamOnInsert(trigger.new);
	}
	if(trigger.isBefore && trigger.isUpdate){
		CLM_AgrmntCustomActionsCtrl.agrmntSharingWithTeamOnUpdate(trigger.oldMap,trigger.new);
	}
	if(trigger.isBefore && trigger.isDelete){
		CLM_AgrmntCustomActionsCtrl.removeAgrmntSharingWithTeamOnDelete(trigger.old);
	}
}