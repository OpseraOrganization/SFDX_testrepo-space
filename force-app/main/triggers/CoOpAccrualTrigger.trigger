trigger CoOpAccrualTrigger on Co_Op_Allocation__c (Before insert, Before update, After insert, After update) {
	If(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
		 if(Trigger.isBefore) {
	if(Trigger.isInsert) {
	 //CoOpAccrualHandler.beforeInsertOperation(Trigger.new);
	 //Database.executeBatch(new CoOpAccrualBatch(Trigger.new)); 
	 CoOpAccrualHandler.beforeInsertOperation(Trigger.New, Trigger.oldMap);
	} 
	if(Trigger.isUpdate) {
	 CoOpAccrualHandler.beforeUpdateOperation(Trigger.new, Trigger.oldMap);
	// CoopAllocationHandler.afterUpdateOperation(Trigger.New,Trigger.oldMap);
	}
		}
		if(Trigger.isAfter) {
			if(Trigger.isUpdate) {
	system.debug('>> in CoOpPaymentTrigger- After Update event >>>>>>');
	 system.debug('>> Trigger.oldMap >>>>>>' + Trigger.oldMap);
	CoOpAccrualHandler.afterUpdateOperation(Trigger.new, Trigger.oldMap);
	  // CoopAllocationHandler.afterUpdateOperation(Trigger.New,Trigger.oldMap);
			}
			if(Trigger.isInsert) {
	system.debug('>> in CoOpPaymentTrigger- After Insert event >>>>>>');
	CoOpAccrualHandler.afterInsertOperation(Trigger.new);
	// Database.executeBatch(new CoOpAccrualBatch(Trigger.new));
	//CoOpAccrualHandler.beforeInsertOperation(Trigger.new); 
	
			}
			system.debug('>> afterhandler call');
		}

	}

}