@isTest
private class NF_ApprovalRequestTriggerTest {
	
	@isTest static void TestNF_ApprovalRequestTrigger() {	
		List<Apttus_Approval__Approval_Request__c> appRequests = new List<Apttus_Approval__Approval_Request__c>();
		List<Apttus_Approval__Approval_Request__c> appRequests1 = [select id, name from Apttus_Approval__Approval_Request__c limit1];  
		Apttus_Approval__Approval_Request__c APR = new Apttus_Approval__Approval_Request__c
			(ApprovalDateTechField__c = System.today().addMonths(1), Apttus_Approval__Request_Comments__c ='Test',
			 Apttus_Approval__Assigned_To_Name__c= 'Test approval');
		appRequests.add(APR);
		
		test.startTest();
		insert appRequests;
		
		NF_TL_UpdateRequestRCode.updateRequestRcodeM(appRequests);
		NF_TL_UpdateRequestRCode.updateAssignee_NSA(appRequests);
		NF_TL_UpdateRequestRCode.updateDateApporovedFieldOnValidator(appRequests);
		//NF_TL_UpdateRequestRCode.CopieApprovalStatus(appRequests,appRequests1);
		NF_TL_UpdateRequestRCode.UpdateValidatorStatus(appRequests) ;	
		ITA_IFM_PAD.deactivateTrigger('test');
		//NF_TL_UpdateRequestRCode.updateValidatorAndStakeholderStatus(appRequests,appRequests1);
		 test.stopTest();
	}
}