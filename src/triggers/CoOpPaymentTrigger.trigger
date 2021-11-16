trigger CoOpPaymentTrigger on CoOp_Claim_Payment__c(After update) {
  if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
		 if(Trigger.isBefore) {
			 if(Trigger.isInsert) {
				 //CoOpPaymentHandler.beforeInsertOperation(Trigger.new);
			 }
			 if(Trigger.isUpdate) {
				 //CoOpPaymentHandler.beforeUpdateOperation(Trigger.new, Trigger.oldMap);
			 }
		}
		if(Trigger.isAfter) {
			if(Trigger.isUpdate) {
				system.debug('>> in CoOpPaymentTrigger- After Update event >>>>>>');
				CoOpPaymentHandler.afterUpdateOperation(Trigger.new, Trigger.oldMap);
			}
		}

}
}