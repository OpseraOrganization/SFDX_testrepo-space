trigger CoOpClaimTrigger on Claim__c (After update, before update) {
  if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
		 if(Trigger.isBefore) {
	if(Trigger.isInsert) {
	// CoOpClaimHandler.beforeInsertOperation(Trigger.new);
	}
	if(Trigger.isUpdate) {
			   
			   for(Claim__c ClaimInstance : trigger.new){
			   if(ClaimInstance.Claim_Status__c=='Passed Audit')
			   {
				  ClaimInstance.Claim_Status__c ='Awaiting Reimbursement';
			   }
			   
		   
		   }

			  
	 //CoOpClaimHandler.beforeUpdateOperation(Trigger.new, Trigger.oldMap);
	}
		}
		if(Trigger.isAfter) {
			if(Trigger.isUpdate) {
	system.debug('>> in CoOpClaimTrigger - After Update event >>>>>>');
				
				
	CoOpClaimHandler.afterUpdateOperation(Trigger.new, Trigger.oldMap);
			   

					
				
			}
		}

}
}