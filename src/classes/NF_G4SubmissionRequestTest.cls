/****************************************
* Name : NF_G4SubmissionRequestTest
* Author : Accenture
* Description : Test class for NF_OpportunityTriggerHelper
*****************************************/
@istest
private with sharing class NF_G4SubmissionRequestTest{

 private static List<OpportunityTeamMember> opptyTeamMemberList = new List<OpportunityTeamMember>(); 
	 private static List<Schema.Document> docList = new List<Schema.Document>();
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_DIRECT_SALES_OPPORTUNITY).getRecordTypeId();
	private static Id oppIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_INDIRECT_SALES_OPPORTUNITY).getRecordTypeId();
	private static List<user> userList = new List<user>();
	private static List<Account> accList = new List<Account>();
	private static List<Opportunity> optyList = new List<Opportunity>();
	 private static User testUser = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User CurrentUser = NF_TestDataFactory.createAdminUser('System Administrator');
		private static User CurrentUser1= NF_TestDataFactory.createAdminUser('Data Loader Profile');

	private static User delegate1User = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User delegate2User = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User delegate3User = NF_TestDataFactory.createAdminUser('System Administrator');
	
   private static List<Offer__c> Offerinfo = new List<Offer__c>();
	
	  /******************************
*Method Name: ClosedChatterPost
*Description: Test Method to cover NF_OpportunityTriggerHelper class
********************************/
	
	static testMethod void ClosedChatterPost(){
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		Apttus_Approval__Approval_Request__c currentApprovalRequest;
		List<Apttus_Approval__Approval_Request__c> approvalrequests=new List<Apttus_Approval__Approval_Request__c>();
		
		
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		user userCreation1 = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation1;
		userCreation.DelegatedApproverId = userCreation1.id;
	 Sales_Role__c currentSalesOrg;
		 Apttus_Approval__Backup_Approver__c BackupApprover;
		database.update(userCreation);
		
		system.runAs(userCreation){
	 
	 
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
			
			optyCreation.get(0).Lead_BG__c='ION';
	optyCreation.get(0).Lead_BU__c='ION IPR';
	optyCreation.get(0).Supporting_BG_AA__c='NSW';
	optyCreation.get(0).Country__c='India';
	optyCreation.get(0).Supporting_BG_FN__c='FN';
	optyCreation.get(0).Supporting_BG_ION__c='ION';
	optyCreation.get(0).Supporting_BG_MN__c='MN';
	optyCreation.get(0).Supporting_BG_GS__c='GS';
	optyCreation.get(0).Supporting_BU_ION__c='ION Optics';
	optyCreation.get(0).LOA_Level__c='A';
	insert optyCreation;
			test.startTest();
			//offer creation
	Offer__c optyOffer=TestDataFactory.OfferCreation(2,optyCreation.get(0))[0];
	 optyOffer.Offer_Description__c='Test';
	 optyOffer.LoA_Approval_Level__c='A';
	 optyOffer.Customer_Offer_Due_Date__c=System.today()-3;
			
			optyOffer.LoA_Level_Before_Trigger_Approval__c='A'; 
			insert optyOffer;
			Offerinfo.add(optyOffer);
	
	
	NF_G4SubmissionRequest Submission=new NF_G4SubmissionRequest();
	SchedulableContext SC;
	Database.BatchableContext BC;
	
	Submission.start(BC);
	Submission.execute(BC,Offerinfo);
	Submission.finish(BC);
	Submission.execute(SC);
	test.stopTest();
	
		 }	

	}

}