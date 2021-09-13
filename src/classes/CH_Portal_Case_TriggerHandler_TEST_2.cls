@isTest
public class CH_Portal_Case_TriggerHandler_TEST_2 { 

	@testSetup 
	static void setup(){
		CH_UTIL_TEST.setupCase(false);
	}
	
	/*
	@IsTest
	static void TestAssignOwnerNoEntitlementScript() {
		Test.startTest();
		Id workgroupId = [SELECT Id  FROM CH_Workgroup__c LIMIT 1].Id;
		Id workgroupQueueId = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName=:CH_UTIL_TEST.TEST_QUEUE_NAME LIMIT 1].Id;
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', 'Nokia Standard Case', true);
		newCase.OwnerId = UserInfo.getUserId();
		insert newCase;
		newCase = [SELECT Id, OwnerId, CH_Workgroup__c FROM Case WHERE Id = :newCase.Id LIMIT 1];
		Test.stopTest();
		
		System.assert(newCase.OwnerId == workgroupQueueId,'Workgroup queue should be assigned. Expected:' + workgroupQueueId + ' was:' + newCase.OwnerId);
		System.assert(newCase.CH_Workgroup__c == workgroupId,'Workgroup should be assigned. Expected:' + workgroupId + ' was:' + newCase.CH_Workgroup__c);		
	}*/
	
	// Test if the contract has no entitlment script
	@IsTest
	static void TestDoesContractHaveNoScript() {
		Test.startTest();
		Case newPortalCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', 'Nokia Standard Case', false); 
		boolean hasEntitlementScript = CH_Portal_Case_TriggerHandler.hasEntitlementScript(newPortalCase);
		Test.stopTest();
		
		System.assert(hasEntitlementScript == false, 'Case should have no entitlement script');		
	}
}