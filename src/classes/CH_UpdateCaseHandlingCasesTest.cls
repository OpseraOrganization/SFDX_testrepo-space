@isTest
public with sharing class CH_UpdateCaseHandlingCasesTest {
	@testSetup
	public static void setup() 
	{
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		CH_Workgroup__c wg = new CH_Workgroup__c(CH_End_of_Business_Hours_Threshold__c = 60,
			 CH_Level_Of_Support__c = 'Initial Support',
			 CH_Start_of_Business_Hours_Threshold__c = 60,
			 CH_Type__c = 'Engineer',
			 Name='TestWorkgroup');
		insert wg;
		
		CH_Workgroup_Rule__c rule = new CH_Workgroup_Rule__c ();
		rule.name = 'TestRule';
		rule.CH_Workgroup__c = wg.Id;
		rule.CH_Severity__c = 'Minor';
		rule.CH_Outage__c = 'No';
		rule.CH_OrderNumber__c = 1;   
		insert rule;
	}

	@isTest
	public static void feedOnUpdateCaseTest() {
		CH_EntitlementTestData.createCustomSettingData();

		CH_Case_PA_InterfaceMapping__c im = CH_UTIL_TEST.createInterfaceMapping('orange-irma', '12345', '12346', '12348', '12350', '12352', '12354');
		insert im;

		Account acc = CH_UTIL_TEST.createS2SAccounts('testCustomer', 'testAcc', '12346');
		insert acc;

		List<Product2> productList = CH_UTIL_TEST.createS2SProducts('testSolution', '12348', 'testProduct', '12350', 'testVariant', '12352');
		insert productList;

		CH_ProductRelease__c releaseTest = CH_UTIL_TEST.createS2SRelease('testRelease', '12354', productList[1].Id);
		insert releaseTest;

		Asset assetTest = CH_UTIL_TEST.createS2SAsset('12346|234|12348|12350|12352|12354', acc.Id);
		insert assetTest;

		Entitlement entTest = CH_EntitlementTestData.createS2SEntitlement('testEnt', assetTest.Id, acc.Id, productList[1].Id, '56478', 'Legacy Customer Support Service - Critical Major Minor 24x7', false);

		String standardCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
		Case testCase = CH_UTIL_TEST.createS2SCase('orange-irma', '12345');

		CH_ExternalInterfaceUTIL.populateCaseHandlingCases(new List<Case> {testCase}, new Map<Id, Account>(), new Map<Id, Product2>(), new Map<Id, CH_ProductRelease__c>(), new Map<Id, Asset>(), new Map<Id, Entitlement>());

		Contact cont = new Contact(LastName = 'test', Email = 'feedOnUpdateCaseTest@email.com');
		insert cont;

		testCase.ContactId = cont.Id;

		Test.startTest();
		CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
		CH_ExternalInterfaceUTIL.runUpdateFromExternalInterface = true;
		insert testCase;
		try {
			CH_ExternalInterfaceUTIL.updatedFromExternalInterface(null, new List<Case> {testCase});
		} catch (Exception ex) {
			system.assert(ex.getMessage().contains('ConnectApi'));
		}
		Test.stopTest();
	}
}