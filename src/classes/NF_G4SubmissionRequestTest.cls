/****************************************
* Name : NF_G4SubmissionRequestTest
* Author : Accenture
* Description : Test class for NF_OpportunityTriggerHelper
*****************************************/
@istest
private with sharing class NF_G4SubmissionRequestTest{
	
	private static List<OpportunityTeamMember> opptyTeamMemberList = new List<OpportunityTeamMember>(); 
	private static List<Schema.Document> docList = new List<Schema.Document>();
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
	
	static testMethod void closedChatterPost(){
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		user userCreation1 = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation1;
		userCreation.DelegatedApproverId = userCreation1.id;
		database.update(userCreation);
		
		system.runAs(userCreation){
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
			optyCreation.get(0).Lead_BU__c='MN';
			optyCreation.get(0).Country__c='India';
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