@isTest(seealldata=true)
private class ViewQueueMemberControllerTest2 {
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