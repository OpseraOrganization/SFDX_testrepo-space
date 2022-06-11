trigger AllocationClaimJunctionTrigger on Accrual_junction__c (before insert, before delete) {
	If(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
		if(Trigger.isBefore) {
			if(Trigger.isInsert) {
				AllocationClaimJunctionHelper.beforeInsertOperation(Trigger.New);
			}
			
			if(Trigger.isDelete){
				AllocationClaimJunctionHelper.beforeDeleteOperation(Trigger.OldMap);
			}
		}
	}
}