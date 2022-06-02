/****************************************
* Class Name : PSR_Approval_ApprovalNotificationTest
* Created Date: 5th June 2017
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description : Test class for PSR_Approval_ApprovalNotification_Comp Class
*****************************************/
@isTest
Private class PSR_Approval_ApprovalNotificationTest{
	
	private static User testUser = NF_TestDataFactory.createAdminUser('System Administrator');
	
	static testMethod void testController(){
		insert testUser;
		System.runAs(testUser){
			Account account = TestDataFactory.createAccount(1)[0];
			insert account;
			Opportunity refOppty = TestDataFactory.OpportunityCreation(1, account)[0];
			refOppty.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			refOppty.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			insert refOppty;
			Offer__c offer = TestDataFactory.OfferCreation(1, refOppty)[0];
			offer.ActiveOffer__c = true;
			insert offer;
			Test.startTest();
			Opportunity psro = TestDataFactory.preSalesOpportunityCreation(1, account, refOppty)[0];
			psro.PSR_Pre_Sales_Risk_Opportunity_Type__c = GlobalConstants.RISK_ORDER;
			psro.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = GlobalConstants.RISK_ORDER_ONLY;
			insert psro;
			PSR_Approval_ApprovalNotification_Comp cmp = new PSR_Approval_ApprovalNotification_Comp();
			cmp.getOpp();
			cmp.getOff();
			cmp.OppId = psro.Id;
			cmp.getOpp();
			cmp.getOff();
			List<Apttus_Approval__Approval_Request__c> oppApprovalRequests = cmp.oppApprovalRequests;
			Test.stopTest();
		}
	}
}