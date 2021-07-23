@isTest(seeallData = false)
public class CH_Portal_Case_TriggerHandler_TEST { 
	
	private static final string PORTAL_PROFILE = 'CH_Portal customer';
	private static final string CH_PROFILE = 'CH_Agent';
	
	@testSetup 
	static void setup(){
		Test.startTest();
		CH_UTIL_TEST.setupCase(true);
		Test.stopTest();
	}
	
	@IsTest
	static void TestProcessingCases() {
		Test.startTest();
		List<Case> cases = [SELECT Id, RecordTypeId, CreatedById, AssetId, EntitlementId, Origin, ContactId FROM Case];
		string recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Problem').getRecordTypeId();
		integer numberOfProblems = [SELECT Id FROM Case WHERE recordTypeId = :recordTypeId].size();
		DateTime casesCreatedDate = DateTime.Now();
		Case s2sCase = CH_UTIL_TEST.createS2SCase('orange-irma', '12345');
		Contact con = [Select Id, AccountId from Contact limit 1];
		Asset ast = [Select Id from Asset limit 1];
		Entitlement ent = [Select Id from Entitlement limit 1];
		String legalAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		Account acc = [select Id from Account where RecordTypeId =:legalAccRecordTypeId limit 1];
		s2sCase.ContactId = con.Id;
		s2sCase.AssetId = ast.Id;
		s2sCase.EntitlementId = ent.Id;
		s2sCase.AccountId = acc.Id;
		try{
			insert s2sCase;
		}
		catch(Exception e){}
		cases.add(s2sCase);
		CH_Portal_Case_TriggerHandler.assignOwner(cases);
		List<Case> processedCases = [SELECT Id FROM Case WHERE CH_Workgroup__c != null];
		Test.stopTest();
		
		//System.assert(processedCases.size() == (cases.size() - numberOfProblems), (cases.size() - numberOfProblems) + ' cases should be processed. Problem should not be processed ' + processedCases.size());
	}
	
	@IsTest
	static void TestAssignOwnerEntitlementScript() {
		Test.startTest();
		Id gwcQueueId = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName=:CH_UTIL_TEST.GWC_QUEUE LIMIT 1].Id;
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', 'Nokia Standard Case', true);
		newCase.OwnerId = UserInfo.getUserId();
		insert newCase;
		newCase = [SELECT OwnerId, AssetId, CH_Workgroup__c FROM Case WHERE Id = :newCase.Id LIMIT 1];
		
		
		Test.stopTest();
		
		//System.assert(newCase.OwnerId == gwcQueueId,'GWC queue should be assigned');
		System.assert(newCase.CH_Workgroup__c == null,'No Workgroup should be assigned');
	}
	
	
	// Test that if a user is a portal user
	@IsTest
	static void TestIsUserPortalUser() {
		Test.startTest();
		Case newPortalCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', 'Nokia Standard Case', true);
		newPortalCase.OwnerId = UserInfo.getUserId();
		insert newPortalCase;
		boolean validCase = CH_Portal_Case_TriggerHandler.isCaseCreatedByPortalUser(newPortalCase);
		Test.stopTest();
		
		//System.assert(validCase == true, 'Case should be created by a portal user');
	}
	
	// Test that if a user is a portal user
	@IsTest
	static void TestIsUserNonPortalUser() {
		Test.startTest();
		Case newPortalCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', 'Nokia Standard Case', false); 
		boolean validCase = CH_Portal_Case_TriggerHandler.isCaseCreatedByPortalUser(newPortalCase);
		Test.stopTest();
		
		System.assert(validCase == false, 'Case should be created by a non portal user');
	}
	
	// Test if the contract has an entitlment script
	@IsTest
	static void TestDoesContractHaveScript() {
		Test.startTest();
		Case newPortalCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', 'Nokia Standard Case', false); 
		boolean hasEntitlementScript = CH_Portal_Case_TriggerHandler.hasEntitlementScript(newPortalCase);
		Test.stopTest();
		
		System.assert(hasEntitlementScript == true, 'Case should have an entitlement script');	  
	}
	@IsTest
	static void TestCreatedByNaipUser() {
		Test.startTest();
		Case newPortalCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', 'Nokia Standard Case', false); 
		boolean isCaseCreatedByNAIPUser = CH_Portal_Case_TriggerHandler.isCaseCreatedByNAIPUser(newPortalCase);
		Test.stopTest();
		
		//  System.assert(isCaseCreatedByNAIPUser == true, 'Case should have an isCaseCreatedByNAIPUser');	  
	}
	@IsTest
	static void TestGetQueue() {
		try{
			Test.startTest();
			Case newPortalCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', 'Nokia Standard Case', false); 
			insert newPortalCase;
			Test.stopTest();
			CH_Workgroup_Member__c GetQueue = CH_Portal_Case_TriggerHandler.GetQueue(newPortalCase);
			
		}Catch(exception e){}	 
	}
	@IsTest
	static void TestAssignOwnerEntitlementScript1() {
		Test.startTest();
		Id gwcQueueId = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName=:CH_UTIL_TEST.GWC_QUEUE LIMIT 1].Id;
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', 'Nokia Standard Case', true);
		newCase.OwnerId = UserInfo.getUserId();
		newCAse.AssetId =  null;
		insert newCase;
		
		newCase = [SELECT OwnerId, AssetId, CH_Workgroup__c, EntitlementId FROM Case WHERE Id = :newCase.Id LIMIT 1];
		
		CH_Portal_Case_TriggerHandler.hasEntitlementScript(newCase);
		Test.stopTest();
	}
	@IsTest
	static void TestAssignOwnerEntitlementScript2() {
		Test.startTest();
		Id gwcQueueId = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName=:CH_UTIL_TEST.GWC_QUEUE LIMIT 1].Id;
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', 'Nokia Standard Case', true);
		newCase.OwnerId = UserInfo.getUserId();
		insert newCase;
		
		newCase = [SELECT OwnerId, AssetId, CH_Workgroup__c, EntitlementId FROM Case WHERE Id = :newCase.Id LIMIT 1];
		List<ContractLineitem> contractLineItems = [SELECT Id, CH_LineItemEntitlementScript__c, ServiceContractId 
													FROM ContractLineitem 
													WHERE AssetId = :newCase.AssetId LIMIT 1];
		contractLineItems[0].CH_LineItemEntitlementScript__c = null;
		update contractLineItems[0];
		CH_Portal_Case_TriggerHandler.hasEntitlementScript(newCase);
		Test.stopTest();
	}
}