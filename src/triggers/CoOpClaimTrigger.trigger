trigger CoOpClaimTrigger on Claim__c (After update, before update) {
  if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
		 if(Trigger.isBefore) {
	if(Trigger.isInsert) {
	// CoOpClaimHandler.beforeInsertOperation(Trigger.new);
	}
	if(Trigger.isUpdate) {
	  list<User> submitteduser = [SELECT id FROM User WHERE username=:UserInfo.getUsername()];
	   
	  for(Claim__c ClaimInstance : trigger.new){
					for(user u:submitteduser){
	  if(ClaimInstance.Claim_Status__c=='Passed Audit')
	  {
	  ClaimInstance.Claim_Status__c ='Awaiting Reimbursement';
			   }  else if(ClaimInstance.Claim_Status__c== PRMGlobalConstants.CoopSubmitted){
				   ClaimInstance.Claim_Submitted_By__c = u.id;
				   ClaimInstance.Claim_Submitted_Date__c = system.today();
				   
				  
			   }
	  
	 
	 }

			   }  
	// CoOpClaimHandler.beforeUpdateOperation(Trigger.new, Trigger.oldMap);
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