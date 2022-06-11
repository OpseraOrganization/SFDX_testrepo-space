trigger CoOpTransferTrigger on Co_op_Allocation_Transfer__c (before insert, after insert) {
	If(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		if(Trigger.isBefore){
			if(Trigger.isInsert){
	CoOpTransferHandler.beforeInsertOperation(Trigger.New);
			}
		}
		if(Trigger.isAfter){
			if(Trigger.isInsert){
	CoOpTransferHandler.afterInsertOperation(Trigger.New);
			}
		}
	}
}