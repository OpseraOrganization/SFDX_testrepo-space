@isTest(SeeAllData=false)

private class BuildARHistorywithARDeletionTest {
	static testmethod void test() {
		// Create test accounts to be updated
		
		List<User> userList = [Select Id from User where Profile.Name = 'System Administrator'];
		List<Apttus_Approval__Approval_Request__c> arList = new List<Apttus_Approval__Approval_Request__c>();
		List<RecordType> recordTypeList = [SELECT DeveloperName,SobjectType FROM RecordType WHERE DeveloperName = 'Direct_Record_Type' AND SobjectType = 'Opportunity'];
		
		List<Account> accList = TestDataFactory.createAccount(1);
		insert accList;
		
		List<Opportunity> oppList = TestDataFactory.OpportunityCreation(1,accList[0]);
		oppList[0].RecordTypeId = recordTypeList[0].Id;
		oppList[0].phase_status__c = 'Planned';
		insert oppList[0];
		
		for(Integer i=0; i<=10; i++){
			Apttus_Approval__Approval_Request__c ar = new Apttus_Approval__Approval_Request__c ();
			
			Id userId;
			if(userList != null && userList.size() > 0){
	userId = userList[0].Id;
			}
			ar.Approver_User__c = userId;
			ar.Tech_Approval_Date__c  = System.Today()-15;
			ar.Apttus_Approval__Related_Opportunity__c = oppList[0].id;
			ar.Apttus_Approval__Active__c = true;
			ar.Apttus_Approval__ApprovalFromEmail__c = false;
			ar.Apttus_Approval__Approval_Process__c = '';
			ar.Apttus_Approval__Approval_Status__c = 'Notified';
			ar.Apttus_Approval__Assigned_To_Id__c = userId;
			ar.Apttus_Approval__Assigned_To_Name__c = 'Nokia CRM';
			ar.Apttus_Approval__Assigned_To_Type__c = 'User';
			ar.Apttus_Approval__AutoEscalate__c = false;
			ar.Apttus_Approval__AutoReapprove__c = false;
			ar.Apttus_Approval__Auto_Complete__c = false;
			ar.Apttus_Approval__CanEscalate__c = false;
			ar.Apttus_Approval__ContinuePolicyApprovalOnAReject__c = false;
			ar.Apttus_Approval__DateApproved__c = System.Today();
			ar.Apttus_Approval__DateAssigned__c = System.Today();
			ar.Apttus_Approval__Date__c = System.Today();
			ar.Apttus_Approval__EscalatedToHighestLevel__c = False;
			ar.Apttus_Approval__HasAttachments__c = False;
			ar.Apttus_Approval__Initial_Submitter__c = userId;
			ar.Apttus_Approval__Object_Type__c = 'Opportunity';
			ar.Apttus_Approval__Object_Name__c = 'Smoke_PRM Prospect 2';
			ar.Apttus_Approval__RequestType__c = 'Standard';
			ar.Apttus_Approval__Request_Comments__c = '(Sales Phase = Identify Opportunity)';
			ar.Apttus_Approval__Send_Email__c = False;
			ar.Apttus_Approval__StepLabel__c = 'Notify - CT Head';
			ar.Apttus_Approval__Step_Group_Seq_Number__c = 1001;
			ar.Apttus_Approval__Step_Name__c = 'Gate 2';
			ar.Apttus_Approval__SubprocessName__c = 'RE-0000007602';
			ar.Apttus_Approval__SubprocessSequence__c = 10;
			ar.Apttus_Approval__SubstepName__c = 'RA-0000018697';			
			ar.NF_Assignee_Type__c = 'Information';			
			ar.NF_Remaindercount__c = 10;
			arList.add(ar);
		}
		
			Insert arList;
			
			System.debug(arList);
			
			Test.startTest();
			BuildARHistorywithARDeletion obj = new BuildARHistorywithARDeletion();
			Database.executeBatch(obj,200);
			Test.stopTest();
	}
}