/***************************************************
*Class Name: OpportunityStrategyController_TEST
*Description: Test class for OpportunityStrategyController 
****************************************************/
@isTest
public class OpportunityStrategyController_TEST
{
	static List<user>		users		 = TestDataFactory.userCreation(1,'System Administrator');
	static List<Account>	 accounts	  = TestDataFactory.createAccount(1);
	static List<Opportunity> opportunities = new List<Opportunity>();

	@isTest static void userAllowedToEdit_OK()
	{
		insert users;
		System.runAs(users[0])
		{
			insert accounts;
			opportunities = TestDataFactory.OpportunityCreation(1,accounts[0]);
			insert opportunities;
			Test.startTest();
			boolean result = OpportunityStrategyController.allowedUserToEdit(opportunities[0].id);
			Test.stopTest();
			System.assertEquals(true,result);
		}
	}

	@isTest static void userAllowedToEdit_NOK_PROFILE()
	{

		users = TestDataFactory.userCreation(1,'CH_Agent');
		insert users;
		System.runAs(users[0])
		{
			insert accounts;
			opportunities = TestDataFactory.OpportunityCreation(1,accounts[0]);
			opportunities[0].recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Sales_Opportunity_For_Partner').getRecordTypeId();
			insert opportunities;
			Test.startTest();
			boolean result = OpportunityStrategyController.allowedUserToEdit(opportunities[0].id);
			Test.stopTest();
			System.assertEquals(false,result);
		}

	}

	@isTest static void userAllowedToEdit_NOK_PHASE()
	{
		insert users;
		System.runAs(users[0])
		{
			insert accounts;
			opportunities = TestDataFactory.OpportunityCreation(1,accounts[0]);
			opportunities[0].Phase_Status__c = 'Submitted for G2 Approval';
			insert opportunities;
			Test.startTest();
			boolean result = OpportunityStrategyController.allowedUserToEdit(opportunities[0].id);
			Test.stopTest();
			System.assertEquals(false,result);
		}

	}

	@isTest static void testGetOpportunityInfo()
	{
		insert users;
		System.runAs(users[0])
		{
			insert accounts;
			opportunities = TestDataFactory.OpportunityCreation(1,accounts[0]);
			insert opportunities;
			Competitor__c competitor = new Competitor__c();
			competitor.Competitor_New__c = 'Accenture';
			competitor.Primary_Competitor__c = true;
			competitor.Opportunity__c = opportunities[0].Id;
			insert competitor;

			List<Contact> contactList = TestDataFactory.createContact(1, accounts[0]);
			contactList[0].LastName = 'last name';
			insert contactList;

			OpportunityContactRole contactRole = new OpportunityContactRole();
			contactRole.ContactId = contactList[0].Id;
			contactRole.OpportunityId = opportunities[0].Id;
			insert contactRole;

			Task taskObj = new Task(WhoId=contactList[0].Id,Subject=Label.CRM_WinPlanPrefix +'Test', Status='Open', whatId = opportunities[0].Id);
			insert taskObj;

			ApexPages.currentPage().getParameters().put('recordId', opportunities[0].Id);
			OpportunityStrategyController ctrl = new OpportunityStrategyController();
			Test.startTest();
			ctrl.getOpportunityInfo();
			Test.stopTest();
			System.assertEquals(true,ctrl.opportunity!=null);
		}
	}
}