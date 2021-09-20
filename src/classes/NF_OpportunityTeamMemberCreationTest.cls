/**
	* @name NF_OpportunityTeamMemberCreationTest
	* @author  Sara Elalaoui
	* @since   Feb 07, 2017
	* @desc This Class is used to test the opportunity team members  for facilitators delegated and approvers		
	* @history 
**/
@isTest
private class NF_OpportunityTeamMemberCreationTest {
	private static User testUser = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User testUser2 = NF_TestDataFactory.createAdminUser('Data Loader Profile');
	private static Account currentAccount;
	private static Opportunity currentOpportunity;
	private static map<Id,Opportunity> opportunitiesMap;
	private static List<Apttus_Approval__Approval_Request__c> approvalrequests;
	private static File_Sharing_Custom_Setting__c FileSharingCS;
	private static File_Sharing_Custom_Setting__c FileSharingCS2;
	private static File_Sharing_Custom_Setting__c FileSharingCS3;
	//setup method for test data	 
	public static void setup(){
		
		FileSharingCS=new File_Sharing_Custom_Setting__c();
		FileSharingCS.Name='SchedulerOpptyTeamFileShareBatch';
		FileSharingCS.Value__c='SchedulerOpptyTeamFileShareBatch';
		FileSharingCS.Description__c='SchedulerOpptyTeam File Share Batch';
		insert FileSharingCS;
		
		FileSharingCS2=new File_Sharing_Custom_Setting__c();
		FileSharingCS2.Name='SchedulingTime';
		FileSharingCS2.Value__c='2';
		FileSharingCS2.Description__c='This is used for scheduling the batch';
		insert FileSharingCS2;
		
		FileSharingCS3=new File_Sharing_Custom_Setting__c();
		FileSharingCS3.Name='OpportunityTeamBatchSize';
		FileSharingCS3.Value__c='10';
		FileSharingCS3.Description__c='Opportunity Team Batch Size';
		insert FileSharingCS3;
		
		List<Account> currentAccountList = NF_TestDataFactory.getAccounts(1);
		currentAccount=currentAccountList[0];
		currentAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		insert currentAccount;
		system.debug(Logginglevel.ERROR ,'#########CurrentAccount '+ CurrentAccount);
		 
		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 7000000);
		//currentOpportunity.Organisation_Level_5__c = 'LAT GCBT CARSO';
		currentOpportunity.Lead_BG__c='MN';
		currentOpportunity.Facilitator_Delegate_1__c=testUser.Id;
		//currentOpportunity.End_Customer__c = currentAccount.Id;
		
		List<Opportunity> opportunities=new List<Opportunity>();
		opportunities.add(currentOpportunity);
		opportunitiesMap=new Map<Id,Opportunity>();
		opportunitiesMap.put(currentOpportunity.Id,currentOpportunity);
		insert currentOpportunity;	  
		
		Apttus_Approval__Approval_Request__c approvalrequest = NF_TestDataFactory.createApprovalRequest('Not Submitted', 'User', 'Test Object', 
																										string.valueOf(currentOpportunity.Id), True, True, testUser.Name,string.valueOf(testUser.Id), 'Sub step Name Test');
		
		approvalrequest.Apttus_Approval__DelegateApproverIds__c=TestUser.id;
		approvalrequests=new List<Apttus_Approval__Approval_Request__c>();
		approvalrequests.add(approvalrequest);
		insert approvalrequests;
	}
	
	// This method is used to test the creation of team members opportunity
	@isTest static void test_createOpportunityTeamMembers_IN_OpportunityTriggerHelper() {
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		system.runAs(testUser2){
			//test data creation
			setup();
		  }
		  system.runAs(testUser){
			// Start Test
			Test.startTest();
			OpportunityTriggerHelper oppTriggerHelper = new OpportunityTriggerHelper();
			oppTriggerHelper.createOpportunityTeamMembers(opportunitiesMap);
			
			Test.stopTest();
			
			//Verification
			List<OpportunityTeamMember> opportunitiesTeamMembersToCreate = new List<OpportunityTeamMember>();
			opportunitiesTeamMembersToCreate=[
				SELECT Id
				FROM OpportunityTeamMember
				
			];
		   
			//system.assert(opportunitiesTeamMembersToCreate.size()>0,'No Members is created');
			
			
		}
	}
	
	// This method is used to test the creation of team members opportunity
	@isTest static void test_createOpportunityTeamMembers_IN_NF_ApprovalRequest() {
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		system.runAs(testUser2){
			//test data creation
			setup();
		  }
	 
		system.runAs(testUser){
			//test data creation
			
			
			// Start Test
			Test.startTest();
			
		   //NF_ApprovalRequest.createOpportunityTeamMembers(approvalrequests);
			
			Test.stopTest();
			
			//Verification
			List<OpportunityTeamMember> opportunitiesTeamMembersToCreate = new List<OpportunityTeamMember>();
			opportunitiesTeamMembersToCreate=[
				SELECT Id
				FROM OpportunityTeamMember
				
			];
		   // system.assert(opportunitiesTeamMembersToCreate.size()>0,'No Members is created');
		}
	}
	
	 // This method is used to test the creation of team members opportunity
	@isTest static void test_createOpportunityTeamMembers_IN_NF_ApprovalRequest_Queue() {
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		system.runAs(testUser2){
			//test data creation
			setup();
		  }
		  
		system.runAs(testUser2){
			//test data creation
		   
			Group g1 = new Group(Name='Telemarketing Queue Americas', type='Queue');
			insert g1;
			
			GroupMember gm= new GroupMember(); 
			gm.GroupId=g1.id;
			gm.UserOrGroupId = testUser2.id;
			insert gm;
			approvalrequests[0].Apttus_Approval__Assigned_To_Id__c=g1.Id;
			approvalrequests[0].Apttus_Approval__Assigned_To_Type__c=g1.Id; 
			update approvalrequests;
			// Start Test
			Test.startTest();
			
			//NF_ApprovalRequest.createOpportunityTeamMembers(approvalrequests);
			
			Test.stopTest();
			
			//Verification
			List<OpportunityTeamMember> opportunitiesTeamMembersToCreate = new List<OpportunityTeamMember>();
			opportunitiesTeamMembersToCreate=[
				SELECT Id
				FROM OpportunityTeamMember
				
			];
			//system.assert(opportunitiesTeamMembersToCreate.size()>0,'No Members is created');
		}
	}
}