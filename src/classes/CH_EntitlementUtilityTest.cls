/** 
 * About 
 * ----- 
 * @Description	  : Case Handling Entitlement Utility Test
 * @TestClass		: None.
 * @Project		  : Case Handling.
 * @Modification Log : 
 *  Update  : 2020 01 29 – tiago.almeida@nokia.com
 * ----- 
**/
@isTest
private class CH_EntitlementUtilityTest {
	
	private static List<Account> accountListLE;
	private static List<Contact> contactList;
	private static List<Asset> assetObjList;
	private static List<CH_CustomerSpecificTargetSLA__c> slaList;
	private static List<Entitlement> entitlementList;
	
	public static Case setupCaseData(String severity, String outage) {
		// Load custom setting Data
		CH_EntitlementTestData.createCustomSettingData();
		
		List < Group > groupList = CH_EntitlementTestData.createGroups();		
		insert groupList;
		System.assertNotEquals(groupList[0].Id, null);
				
		Integer j = 2;
		List < Account > accountListNL = new List<Account>();
		accountListNL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
		insert accountListNL;
		
		accountListLE = CH_EntitlementTestData.createAccountRecord(j, 'Legal_Entity', accountListNL);
		insert accountListLE;
		
		contactList = CH_EntitlementTestData.createContactRecord(j, accountListNL);
		insert contactList;
		
		List<Product2> productlist =new List<Product2>();
		productlist = CH_EntitlementTestData.createProductRecord(j);
		insert productlist;
		
		List<PricebookEntry> pricebook =new List <PricebookEntry>();
		pricebook = CH_EntitlementTestData.createPricebookEntryRecord(j, productlist);
		pricebook[0].CurrencyIsoCode = 'EUR';
		pricebook[1].CurrencyIsoCode = 'EUR';  
		insert pricebook;
		
		Pricebook2 customPB1 = new Pricebook2();
		customPB1.Id = CH_EntitlementTestData.CreatecustomPricebook();
		
		List< PricebookEntry > customPricebook = new List < PricebookEntry > ();
		customPricebook = CH_EntitlementTestData.createcustomPricebookEntryRecord(j, productlist, customPB1.id);
		customPricebook[0].CurrencyIsoCode = 'EUR';
		customPricebook[1].CurrencyIsoCode = 'EUR';
		insert customPricebook;
		
		List < ServiceContract > serviceContractlist = new List < ServiceContract > ();
		serviceContractlist = CH_EntitlementTestData.createServiceContractRecord(j, accountListNL, null, customPB1.Id);
		serviceContractlist[0].CurrencyIsoCode = customPricebook[0].CurrencyIsoCode;
		serviceContractlist[1].CurrencyIsoCode = customPricebook[1].CurrencyIsoCode;  
		insert serviceContractlist;	 
		
		assetObjList = new List<Asset>();
		for(Integer i=0;i<j;i++){				  
			Asset assetObj = new Asset();
			assetObj.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_CoveredProduct').Id;
			assetObj.Name = 'Test1 Asset';
			assetObj.Product2Id = productlist[i].id;
			assetObj.AccountId = accountListLE[i].id;
			assetObjList.add(assetObj);
		}
		insert assetObjList;
		
		ContractLineItem contLine = new ContractLineItem();
		contLine.PricebookEntryId = customPricebook[0].id;
		contLine.Quantity = 55;
		contLine.UnitPrice = 55;
		contLine.ServiceContractId = serviceContractlist[0].id;
		ContLine.CH_ServiceOffering__c = 'Test1';
		contLine.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';
		contLine.CH_CDB_EntitlementId__c = '1test1';
		contLine.AssetId = assetObjList[0].id;
		insert contLine;
		
		entitlementList = new List<Entitlement>();
		for(integer i=0;i<j;i++){
			Entitlement entiObj = new Entitlement();
			entiObj.Name ='test'+ i;
			entiObj.AccountId = accountListLE[i].id;
			entiObj.CH_CDB_EntitlementId__c = '1test1'+ i;
			entiObj.StartDate = System.today();
			entiObj.EndDate = System.today() + 10;
			entiObj.ContractLineItemId = contLine.id;
			entiObj.AssetId = assetObjList[i].id;
			entiObj.CH_EntitlementType__c = 'Entitled Asset';
			entiObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
			entiobj.ServiceContractId = serviceContractlist[i].id;
			entitlementList.add(entiObj);
		}
		insert entitlementList;
		
		EntitlementContact entcon = new EntitlementContact();
		entcon.EntitlementId = entitlementlist[0].id;
		entcon.ContactId = contactList[0].id;	 
		insert entcon;
		 
		// Create CH_CustomerSpecificTargetSLA__c
		CH_CustomerSpecificTargetSLA__c slaObj = new CH_CustomerSpecificTargetSLA__c();
		slaObj.CH_Account__c = accountListLE[0].id;
		slaObj.CH_Entitlement__c = entitlementlist[0].Id;
		slaObj.CH_ServiceContract__c = serviceContractlist[0].Id;
		slaObj.CH_LineItemNumber__c = contLine.Id;
		slaObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
		slaObj.CH_SLARecordStatus__c = 'Active';
		slaObj.CH_IR_WorkMins__c = -1;
		slaObj.CH_SR_WorkMins__c = 20;
		slaObj.CH_TSP_WorkMins__c = 30;
		slaObj.CH_SDR_WorkMins__c = 40;
		slaObj.CH_SP_WorkMins__c = 50;
		slaObj.CH_SPD_WorkMins__c = 60;
		slaObj.CH_Severity__c = severity;
		slaObj.CH_Outage__c = outage;
		insert slaObj;
		
		Case caseObj = new Case();
		caseObj.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_NokiaStandardCase').Id;
		caseObj.AccountId =  accountListLE[0].Id;
		caseObj.ContactId = contactList[0].id;
		caseObj.AssetId = assetObjList[0].id;
		caseObj.EntitlementId = entitlementlist[0].id;
		caseObj.Subject = 'Test Case';
		caseObj.Description = 'Test Case';
		caseObj.Severity__c =  slaObj.CH_Severity__c;
		caseObj.CH_Outage__c = slaObj.CH_Outage__c;
		return caseObj;
	}
	
	@isTest static void testCaseCriticalRecord() {
		Case caseObj = setupCaseData('Critical', 'Yes');
		Test.startTest();
		insert caseObj;
		
		Boolean testResult = testMilestonesCalculation(caseObj);
		System.assertNotEquals(testResult, false);
		
		Test.stopTest();
	}
	
	@isTest static void testCaseMajorWithOutageRecord() {
		Case caseObj = setupCaseData('Major', 'Yes');
		Test.startTest();
		insert caseObj;
		
		Boolean testResult = testMilestonesCalculation(caseObj);
		System.assertNotEquals(testResult, false);
		
		Test.stopTest();
	}
	
	@isTest static void testCaseMajorWithoutOutageRecord() {
		Case caseObj = setupCaseData('Major', 'No');
		Test.startTest();
		insert caseObj;
		
		Boolean testResult = testMilestonesCalculation(caseObj);
		System.assertNotEquals(testResult, false);
		
		Test.stopTest();
	}
	
	@isTest static void testCaseMinorRecord() {
		Case caseObj = setupCaseData('Minor', 'No');
		Test.startTest();
		insert caseObj;
		
		Boolean testResult = testMilestonesCalculation(caseObj);
		System.assertNotEquals(testResult, false);
		
		Test.stopTest();
	}
	
	@isTest static void testCaseInformationRequestRecord() {
		Case caseObj = setupCaseData('Information Request', 'No');
		Test.startTest();
		insert caseObj;
		
		Boolean testResult = testMilestonesCalculation(caseObj);
		System.assertNotEquals(testResult, false);
		
		Test.stopTest();
	}
	
	@isTest static void testLegacyCaseRecord() {
		Case caseObj = setupCaseData('Critical', 'Yes');
		Test.startTest();
		caseObj.CH_LegacyCaseNumber__c = '31313123213';
		insert caseObj;
		
		Boolean testResult = testMilestonesCalculation(caseObj);
		System.assertNotEquals(testResult, false);
		
		Test.stopTest();
	}
	
	private static Boolean testMilestonesCalculation(Case caseObj) {
		List < MilestoneType > mTypes = [SELECT Id, Name FROM MilestoneType] ;
		CH_CaseMilestoneTimeCalculator timeCalculator = new CH_CaseMilestoneTimeCalculator();
		Integer slaTime = 1;
		Boolean result = true;
		for(MilestoneType mtObj: mTypes) {
			slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj.Id, mtObj.Id);
			result = result && (slaTime != 0);
		}
		return result;
	}
}