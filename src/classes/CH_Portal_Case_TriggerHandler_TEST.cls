@isTest(seeallData = false)
public class CH_Portal_Case_TriggerHandler_TEST { 
	
	private static final string PORTAL_PROFILE = 'CH_Portal customer';
	private static final string CH_PROFILE = 'CH_Agent';
	public static final string nokiaRecrdTypeName='CH_NokiaStandardCase';
	
	@testSetup 
	static void setup(){
		Test.startTest();
		CH_UTIL_TEST.setupCase(true);
		Test.stopTest();
	}
	
	@IsTest
	static void testProcessingCases() {
		Test.startTest();
		List<Case> cases = [SELECT Id, RecordTypeId, CreatedById, AssetId, EntitlementId, Origin, ContactId FROM Case];
		string recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		Case s2sCase = CH_UTIL_TEST.createS2SCase('orange-irma', '12345');
		Contact con = [Select Id, AccountId from Contact limit 1];
		Asset ast = [Select Id from Asset limit 1];
		Entitlement ent = [Select Id from Entitlement limit 1];
		String legalAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		Account acc = [select Id from Account where RecordTypeId =:legalAccRecordTypeId limit 1];
		s2sCase.ContactId = con.Id;
		s2sCase.AssetId = ast.Id;
		s2sCase.EntitlementId = ent.Id;
		s2sCase.AccountId = acc.Id;
		s2sCase.Reference_Number__c = 'WBC21408';
		try{
			insert s2sCase;
		}
		catch(Exception e){ System.debug(' ERROR '+e); }
		cases.add(s2sCase);
		Set<Id> getCaseId=new Set<Id>();
		if(cases.size()>0){ 
			for(Case getIds:cases){
				getCaseId.add(getIds.Id);
			}
		}
		if(cases.size()>0){ 
			CH_Portal_Case_TriggerHandler.assignOwner(getCaseId);
		}
		Test.stopTest();
		
	}
	
	@IsTest
	static void testAssignOwnerEntitlementScript() {
		Test.startTest();
		Id gwcQueueId = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName=:CH_UTIL_TEST.GWC_QUEUE LIMIT 1].Id;
		System.assert(gwcQueueId != null,'  , Exception message - ' + gwcQueueId);
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', nokiaRecrdTypeName, true);
		newCase.OwnerId = UserInfo.getUserId();
		insert newCase;
		newCase = [SELECT OwnerId, AssetId, CH_Workgroup__c FROM Case WHERE Id = :newCase.Id LIMIT 1];
		Test.stopTest();
		System.assert(newCase.CH_Workgroup__c == null,'No Workgroup should be assigned');
	}
	
	
	// Test that if a user is a portal user
	@IsTest
	static void testIsUserPortalUser() {
		Test.startTest();
		Case newPortalCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', nokiaRecrdTypeName, true);
		newPortalCase.OwnerId = UserInfo.getUserId();
		insert newPortalCase;
		boolean validCase = CH_Portal_Case_TriggerHandler.isCaseCreatedByPortalUser(newPortalCase);
		System.assert(validCase == false, 'Expected false Actual '+validCase);
		Test.stopTest();
		
	}
	
	// Test that if a user is a portal user
	@IsTest
	static void testIsUserNonPortalUser() {
		Test.startTest();
		Case newPortalCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', nokiaRecrdTypeName, false); 
		boolean validCase = CH_Portal_Case_TriggerHandler.isCaseCreatedByPortalUser(newPortalCase);
		Test.stopTest();
		
		System.assert(validCase == false, 'Case should be created by a non portal user');
	}
	
	// Test if the contract has an entitlment script
	@IsTest
	static void testDoesContractHaveScript() {
		Test.startTest();
		Case newPortalCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', nokiaRecrdTypeName, false); 
		boolean hasEntitlementScript = CH_Portal_Case_TriggerHandler.hasEntitlementScript(newPortalCase);
		Test.stopTest();
		
		System.assert(hasEntitlementScript == true, 'Case should have an entitlement script');	
	}
	@IsTest
	static void testCreatedByNaipUser() {
		Test.startTest();
		Case newPortalCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', nokiaRecrdTypeName, false); 
		boolean isCaseCreatedByNAIPUser = CH_Portal_Case_TriggerHandler.isCaseCreatedByNAIPUser(newPortalCase);
		Test.stopTest();
		
	}
	@IsTest
	static void testGetQueue() {
		try{
			Test.startTest();
			Case newPortalCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', nokiaRecrdTypeName, false); 
			insert newPortalCase;
			Test.stopTest();
			CH_Workgroup_Member__c getQueue = CH_Portal_Case_TriggerHandler.GetQueue(newPortalCase);
			
		}Catch(exception e){ System.debug(' ERROR '+e); }	
	}
	@IsTest
	static void testAssignOwnerEntitlementScript1() {
		Test.startTest();
		Id gwcQueueId = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName=:CH_UTIL_TEST.GWC_QUEUE LIMIT 1].Id;
		System.assert(gwcQueueId != null,'  , Exception message - ' + gwcQueueId);
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', nokiaRecrdTypeName, true);
		newCase.OwnerId = UserInfo.getUserId();
		newCAse.AssetId =  null;
		insert newCase;
		
		newCase = [SELECT OwnerId, AssetId, CH_Workgroup__c, EntitlementId FROM Case WHERE Id = :newCase.Id LIMIT 1];
		
		CH_Portal_Case_TriggerHandler.hasEntitlementScript(newCase);
		Test.stopTest();
	}
	@IsTest
	static void testAssignOwnerEntitlementScript2() {
		Test.startTest();
		Id gwcQueueId = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName=:CH_UTIL_TEST.GWC_QUEUE LIMIT 1].Id;
		System.assert(gwcQueueId != null,'  , Exception message - ' + gwcQueueId);
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', nokiaRecrdTypeName, true);
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