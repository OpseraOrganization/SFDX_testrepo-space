@isTest
private class ViewQueueMemberControllerTest {
	@testSetup static void setup() {
		// Create common test opportunity
		Group testGroup = new Group(Name='test group', Type='Queue');
		insert testGroup;

		List<Account> acc = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert acc;
		
		List<Opportunity> opp = NOKIA_CPQ_TestDataFactory.getOpportunities(2, acc);
		opp[0].Queue_Id__c = testGroup.Id;
		insert opp;
	}
	static testMethod void testMethod1() {
		Opportunity oppty = [SELECT Id FROM Opportunity WHERE Queue_Id__c!=null limit 1][0];
		ApexPages.currentPage().getParameters().put('id', oppty.Id);
		ViewQueueMemberController view = new ViewQueueMemberController(null);
	}
	 static testMethod void testMethod2() {
		Opportunity oppty = [SELECT Id FROM Opportunity WHERE Queue_Id__c=null limit 1][0];
		ApexPages.currentPage().getParameters().put('id', oppty.Id);
		ViewQueueMemberController view = new ViewQueueMemberController(null);
	}
	static testMethod void testMethod3() {
		Opportunity oppty = [SELECT Id FROM Opportunity WHERE Queue_Id__c=null limit 1][0];
		ApexPages.currentPage().getParameters().put('id', oppty.Id);
		ViewQueueMemberController.cancel();
	}
}