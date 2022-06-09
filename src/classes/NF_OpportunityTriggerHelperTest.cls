/****************************************
* Name : NF_OpportunityTriggerHelperTest
* Author : Accenture
* Description : Test class for NF_OpportunityTriggerHelper
*****************************************/
@istest
private with sharing class NF_OpportunityTriggerHelperTest{
	private static List<OpportunityTeamMember> opptyTeamMemberList = new List<OpportunityTeamMember>();
	private static List<Schema.Document> docList = new List<Schema.Document>();
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static Id oppIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_record_type).getRecordTypeId();
	private static List<user> userList = new List<user>();
	private static List<Account> accList = new List<Account>();
	private static List<Opportunity> optyList = new List<Opportunity>();
	private static User testUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User CurrentUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);

	private static User delegate1User = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User delegate2User = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
	private static User delegate3User = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);

	/******************************
	*Method Name: ClosedChatterPost
	*Description: Test Method to cover NF_OpportunityTriggerHelper class
	********************************/
	static testMethod void closedChatterPost1(){

		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		List<Apttus_Approval__Approval_Request__c> approvalrequests=new List<Apttus_Approval__Approval_Request__c>();

		user userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		userList.add(userCreation);
		user userCreation1 = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		userList.add(userCreation1);
		userList.add(delegate1User);
		userList.add(delegate2User);
		userList.add(delegate3User);
		insert userList;

		userList.get(0).DelegatedApproverId = userList.get(1).id;
		Sales_Role__c currentSalesOrg;
		Apttus_Approval__Backup_Approver__c BackupApprover;
		database.update(userList);

		system.runAs(userList.get(0)){
			Map<id,Opportunity> opptyMap = new Map<id,Opportunity>();
			List<Dated_Exchange_Rates__c> newExchange=new List<Dated_Exchange_Rates__c>();
			newExchange=TestDataFactory.datedExchnageRateCreation(4);
			database.insert(newExchange);

			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234';
			accountCreation.L7Name__c='Market India';
			database.insert(accountCreation,false);
			System.debug('-->'+accountCreation);
			List<Opportunity> optyCreation = new List<Opportunity>();
			Opportunity optyCreation1=TestDataFactory.OpportunityCreation(3,accountCreation)[0];

			optyCreation.add(optyCreation1);
			optyCreation.get(0).CurrencyIsoCode='USD';
			optyCreation.get(0).Amount=100;

			optyCreation.get(0).Lead_BG__c='MN';
			optyCreation.get(0).Country__c='India';
			optyCreation.get(0).LOA_Level__c='A';
			insert optyCreation;
			test.startTest();
			optyCreation.get(0).StageName='Create Offer (Bid)';
			optyCreation.get(0).Phase_Status__c=GlobalConstants.SUBMITTED_FOR_G4_APPROVAL;
			optyCreation.get(0).Apttus_Approval__Approval_Status__c='Pending Approval';
			optyCreation.get(0).ApprovalStatusTechField__c='Approved G2,Approved G3';
			optyCreation.get(0).NF_Facilitator_User__c=userList.get(1).id;
			optyCreation.get(0).Facilitator_Delegate_1__c=userList.get(1).id;
			optyCreation.get(0).Facilitator_Delegate_2__c=userList.get(1).id;
			optyCreation.get(0).Facilitator_Delegate_3__c=userList.get(1).id;
			database.update(optyCreation,false);

			currentSalesOrg = NF_TestDataFactory.createSalesRole(userList.get(1),Label.NF_NSNG_HCT,'Market India', '5 - RBC Presales Head AA G3 MU');
			insert currentSalesOrg;

			BackupApprover =new Apttus_Approval__Backup_Approver__c (
			Apttus_Approval__Current_User__c=currentSalesOrg.User__c,
			Apttus_Approval__DelegateUserIds__c=userList.get(0).Id+','+userList.get(2).Id+','+userList.get(3).Id,
			Apttus_Approval__IsDelegate__c=true,
			Apttus_Approval__IsActive__c=true,
			Apttus_Approval__InEffect__c=true
			);
			insert BackupApprover;

			for(Opportunity oppty:optyCreation){
	opptyMap.put(oppty.id, oppty);
			}
			opptyTeamMemberList = TestDataFactory.optyTeamMemberCreation(1,userList.get(0),optyCreation.get(0));
			database.insert(opptyTeamMemberList);
			Apttus_Approval__Approval_Request__c approvalrequest =
			NF_TestDataFactory.createApprovalRequest('Not Submitted', 'User', 'Test Object',string.valueOf(optyCreation.get(0).Id), True, True, userList.get(1).Name,string.valueOf(userList.get(1).Id), 'Sub step Name Test');
			approvalrequest.Apttus_Approval__DelegateApproverIds__c=userList.get(1).id;
			approvalrequest.Apttus_Approval__Step_Name__c='G2';
			approvalrequest.NF_Assignee_Type__c='Stakeholder for Information';
			approvalrequest.Apttus_Approval__Step_Name__c='Test';
			approvalrequest.Apttus_Approval__StepLabel__c='Test';
			approvalrequests.add(approvalrequest);

			Apttus_Approval__Approval_Request__c approvalrequest2 =
			NF_TestDataFactory.createApprovalRequest('Not Submitted', 'User', 'Test Object',string.valueOf(optyCreation.get(0).Id), True, True, userList.get(1).Name,string.valueOf(userList.get(1).Id), 'Sub step Name Test');
			approvalrequest2.Apttus_Approval__DelegateApproverIds__c='';
			approvalrequest2.Apttus_Approval__Step_Name__c='G4';
			approvalrequest2.NF_Assignee_Type__c='Approver';
			approvalrequest2.Apttus_Approval__Assigned_To_Id__c='';
			approvalrequests.add(approvalrequest2);
			database.insert(approvalrequests);

			NF_OpportunityTriggerHelper.WindeclarationNotification(opptyMap);
			NF_OpportunityTriggerHelper.RecallNotification(opptyMap);
			NF_OpportunityTriggerHelper.ChatterPostToStakeHolders(opptyMap,false);
			NF_OpportunityTriggerHelper.ChatterPostToStakeHolders(opptyMap,true);
			NF_OpportunityTriggerHelper.Recall_Presales_Notification(opptyMap);
			NF_OpportunityTriggerHelper.Common_method_calls(opptyMap,null);
			test.stoptest();
		}
	}

	/******************************
	*Method Name: ChatterPostNotification
	*Description: Test Method to cover NF_OpportunityTriggerHelper class
	********************************/
	static testMethod void chatterPostNotification(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userList.add(userCreation);
		user userCreation1 = TestDataFactory.userCreation(1,'System Administrator')[0];
		userList.add(userCreation1);
		userList.add(delegate1User);
		userList.add(delegate2User);
		userList.add(delegate3User);
		insert userList;
		system.runAs(userList.get(0)){
			test.startTest();
			NF_OpportunityTriggerHelper.NotifyOpportunityRelatedUsers(Null);
			NF_OpportunityTriggerHelper.NotifyOpportunityRelatedUsers(Null);
			NF_OpportunityTriggerHelper.ChatterPostToStakeHolders(Null,false);

			NF_OpportunityTriggerHelper.ChatterPostToStakeHolders(Null,true);
			NF_OpportunityTriggerHelper.Recall_Presales_Notification(Null);
			NF_OpportunityTriggerHelper.WindeclarationNotification(Null);
			NF_OpportunityTriggerHelper.RecallNotification(Null);
			NF_OpportunityTriggerHelper.NotifyOfferController(Null);
			NF_OpportunityTriggerHelper.getQueueMembers(Null);

			test.stoptest();
		}

	}
}