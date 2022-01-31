@isTest
private class CH_PopulateCaseHandlingCasesTest {
	
	public static final string interfmpname='orange-irma';
	public static final string acctIn='TEST | TEST';
	public static final string verifyoutcome='recived wrong mapping list';
	public static final string verifyaccout='recived wrong mapping';
	
	
	@testSetup static void setup() {
		CH_ManageCreateQueueAsynchQueue.doChainJob= false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		CH_TestDataFactory.createCustomSettings();
		createWorkgroup();
		integer j = 5;
		List<CH_Case_PA_InterfaceMapping__c> interfaceMappings = new List<CH_Case_PA_InterfaceMapping__c>();
		interfaceMappings.add(CH_UTIL_TEST.createInterfaceMapping(interfmpname, '12345', '12346', '12348', '12350', '12352', '12354'));
		interfaceMappings.add(CH_UTIL_TEST.createInterfaceMapping(interfmpname, '123456', '12346', NULL, '12350', NULL, '12354'));
		insert interfaceMappings;
		
		Pricebook2 customPB1 = new Pricebook2();
		customPB1.Id = CH_EntitlementTestData.CreateCustomPriceBook();
		
		List <Account> AccountListNL = new List<Account>();
		AccountListNL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
		insert AccountListNL;
		
		Account acc = CH_UTIL_TEST.createS2SAccounts('testCustomer', 'testAccount', '12346');
		insert acc;
		
		List<Product2> productList = CH_UTIL_TEST.createS2SProducts('testSolution', '12348', 'testProduct', '12350', 'testVariant', '12352');
		insert productList;
		
		CH_ProductRelease__c releaseTest = CH_UTIL_TEST.createS2SRelease('testRelease', '12354', productList[1].Id);
		insert releaseTest;
		
		List<ServiceContract> ServiceContractlist =new List<ServiceContract>();
		ServiceContractlist = CH_EntitlementTestData.createServiceContractRecord(j,AccountListNL,null,customPB1.id);
		insert ServiceContractlist;
		
		createRule(ServiceContractlist[0].id, null, null, null, null, null, null, null, null, 'Any','true'); 
	}
	
	private static void createWorkgroup() {
		List<CH_Workgroup__c> workGroups = new List<CH_Workgroup__c>();
		CH_Workgroup__c workgroup = new CH_Workgroup__c();
		workgroup.name = 'Test';
		workgroup.CH_End_of_Business_Hours_Threshold__c = 120;
		workgroup.CH_Start_of_Business_Hours_Threshold__c = 120;
		workGroups.add(workgroup);
		CH_Workgroup__c workgroup2 = new CH_Workgroup__c();
		workgroup2.name = 'Test' + '2';
		workgroup2.CH_End_of_Business_Hours_Threshold__c = 120;
		workgroup2.CH_Start_of_Business_Hours_Threshold__c = 120;
		workGroups.add(workgroup2);	 
		insert workGroups;
	}
	
	private static void createRule(ID contractId, String severity, String region, String country, 
								   String levelOfSupport, String customer, String customerGroup, 
								   String product, String productGroup, String outage,String active) {
									   CH_Workgroup_Rule__c workgroupRule = new CH_Workgroup_Rule__c();
									   workgroupRule.Name = 'Test';
									   workgroupRule.CH_OrderNumber__c = 1;
									   workgroupRule.CH_ServiceContract__c = contractId; 
									   workgroupRule.CH_Severity__c = severity;
									   workgroupRule.CH_Region1__c = region;
									   workgroupRule.CH_Country1__c = country;
									   workgroupRule.CH_Account__c = customer;
									   workgroupRule.CH_Customer_Group__c = customerGroup;
									   workgroupRule.CH_Product__c = product;
									   workgroupRule.CH_Product_Group__c = productGroup;
									   workgroupRule.CH_Level_Of_Support__c = levelOfSupport;
									   workgroupRule.CH_Outage__c = outage;		
									   CH_Workgroup__c workgroup = [SELECT Id FROM CH_Workgroup__c WHERE Name = 'Test'];
									   workgroupRule.CH_Workgroup__c = workgroup.Id; 
									   //Changes w.r.t 17116  starts		
									   if (!String.isBlank(active) && active!= 'Any'){
										   if(active=='Yes'||active=='true'){
											   workgroupRule.CH_Active__c=true;
										   }
										   else{
											   workgroupRule.CH_Active__c=false;
										   }
									   } //Changes w.r.t 17116  ends
									   insert workgroupRule; 
								   }
	
	@isTest
	private static void populateCaseHandlingCasesTest() {
		Account testAccount = [SELECT Id FROM Account WHERE Name = 'testAccount'];
		Product2 testProduct = [SELECT Id FROM Product2 WHERE Name = 'testProduct'];
		Asset testAsset = CH_UTIL_TEST.createS2SAsset('12346|234|12348|12350|12352|12354', testAccount.Id);
		insert testAsset;
		system.debug('-88---testAsset-----'+testAsset);
		CH_EntitlementTestData.createS2SEntitlement('testEntitlement', testAsset.Id, testAccount.Id, testProduct.Id, '56478', 'Legacy Customer Support Service - Critical Major Minor 24x7', false);
		Case testCase = CH_UTIL_TEST.createS2SCase(interfmpname, '12345');
		
		Test.startTest();
		List<Case> newCaseS2SList = new List<Case>();
		newCaseS2SList.add(testCase);
		CH_ExternalInterfaceUTIL.populateCaseHandlingCases(newCaseS2SList, new Map<Id, Account>(), new Map<Id, Product2>(), new Map<Id, CH_ProductRelease__c>(), new Map<Id, Asset>(), new Map<Id, Entitlement>());
		Test.stopTest();
		
		System.assertEquals([SELECT Acc_No__c FROM Account WHERE Id =: testCase.AccountId].Acc_No__c, '12346');
		System.assertEquals([SELECT NCP_Nokia_Product_Id__c FROM Product2 WHERE Id =: testCase.CH_Solution__c].NCP_Nokia_Product_Id__c, '12348');
		System.assertEquals([SELECT NCP_Nokia_Product_Id__c FROM Product2 WHERE Id =: testCase.ProductId].NCP_Nokia_Product_Id__c, '12350');
	   
		System.assertEquals([SELECT CH_NSNLegacyCode__c FROM CH_ProductRelease__c WHERE Id =: testCase.CH_Product_Release__c].CH_NSNLegacyCode__c, '12354');

	}
	
	@isTest
	private static void populateCaseHandlingCasesWithoutVariantSolutionTest() {
		Account testAccount = [SELECT Id FROM Account WHERE Name = 'testAccount'];
		Product2 testProduct = [SELECT Id FROM Product2 WHERE Name = 'testProduct'];
		Asset testAsset = CH_UTIL_TEST.createS2SAsset('12346|234||12350||12354', testAccount.Id);
		insert testAsset;
		CH_EntitlementTestData.createS2SEntitlement('testEntitlement', testAsset.Id, testAccount.Id, testProduct.Id, '56478', 'Legacy Customer Support Service - Critical Major Minor 24x7', false);
		Case testCase = CH_UTIL_TEST.createS2SCase(interfmpname, '123456');
		
		Test.startTest();
		List<Case> newCaseS2SList = new List<Case>();
		newCaseS2SList.add(testCase);
		CH_ExternalInterfaceUTIL.populateCaseHandlingCases(newCaseS2SList, new Map<Id, Account>(), new Map<Id, Product2>(), new Map<Id, CH_ProductRelease__c>(), new Map<Id, Asset>(), new Map<Id, Entitlement>());
		Test.stopTest();
		
		System.assertEquals([SELECT Acc_No__c FROM Account WHERE Id =: testCase.AccountId].Acc_No__c, '12346');
		System.assertEquals(testCase.CH_Solution__c, NULL);
		System.assertEquals([SELECT NCP_Nokia_Product_Id__c FROM Product2 WHERE Id =: testCase.ProductId].NCP_Nokia_Product_Id__c, '12350');
		System.assertEquals(testCase.CH_ProductVariant__c, NULL);
		System.assertEquals([SELECT CH_NSNLegacyCode__c FROM CH_ProductRelease__c WHERE Id =: testCase.CH_Product_Release__c].CH_NSNLegacyCode__c, '12354');
		
		
	}
	
	@isTest
	private static void uniqueReferenceNumberTest() {
		Test.startTest();
		Case testCase = CH_UTIL_TEST.createS2SCase(interfmpname, '12345');
		testCase.Reference_Number__c = 'WBC21408';
		Case testCase2 = CH_UTIL_TEST.createS2SCase(interfmpname, '12345');
		testCase2.Reference_Number__c = 'WBC21408';
		List<Case> newCaseS2SList = new List<Case>();
		newCaseS2SList.add(testCase2);
		try {
			List<Case> uniqueRefNumberCases = CH_ExternalInterfaceUTIL.isolateUniqueRefNumCases(newCaseS2SList);
			CH_ExternalInterfaceUTIL.populateCaseHandlingCases(uniqueRefNumberCases, new Map<Id, Account>(), new Map<Id, Product2>(), new Map<Id, CH_ProductRelease__c>(), new Map<Id, Asset>(), new Map<Id, Entitlement>());
		} catch(Exception e) {
			System.assert(!e.getMessage().contains('Case cannot be created with this Reference Number'));
		}
		Test.stopTest();
	}
	
	@isTest
	private static void getTMobileMappingsTest() {
		CH_Case_PA_InterfaceMapping__c testMapping1 = new CH_Case_PA_InterfaceMapping__c(
			Name = 'test',
			AccountIn__c = acctIn,
			RangePrefix__c = 'TEST',
			RangeStart__c = 0,
			RangeEnd__c = 10,
			AccountOut__c = 'success',
			CaseOriginSystem__c = CH_ExternalInterfaceUTIL.TMOBILE_ORIGIN_CODE
		);
		insert testMapping1;
		
		CH_Case_PA_InterfaceMapping__c testMapping2 = new CH_Case_PA_InterfaceMapping__c(
			Name = 'test',
			AccountIn__c = acctIn,
			RangePrefix__c = 'ABC',
			RangeStart__c = 100,
			RangeEnd__c = 200,
			AccountOut__c = 'success',
			CaseOriginSystem__c = CH_ExternalInterfaceUTIL.TMOBILE_ORIGIN_CODE
		);
		insert testMapping2;
		
		Case testCase1 = new Case(
			CH_CaseOriginSystem__c = CH_ExternalInterfaceUTIL.TMOBILE_ORIGIN_CODE,
			CH_ExternalSystemAccount__c = 'TEST5 | TEST | TEST'
		);
		Case testCase2 = new Case(
			CH_CaseOriginSystem__c = CH_ExternalInterfaceUTIL.TMOBILE_ORIGIN_CODE,
			CH_ExternalSystemAccount__c = 'ABC150 | TEST | TEST'
		);
		
		Test.startTest();
		List<CH_Case_PA_InterfaceMapping__c>  testResult = CH_ExternalInterfaceUTIL.getTMobileMappings(new List<Case>{testCase1,testCase2});
		Test.stopTest();
		
		System.assert(testResult.size() == 2, verifyoutcome);
		System.assert(testResult[0].AccountOut__c == testMapping1.AccountOut__c || testResult[0].AccountOut__c == testMapping2.AccountOut__c, verifyaccout);
		if (testResult[0].AccountOut__c == testMapping1.AccountOut__c ) {
			System.assert(testResult[1].AccountOut__c == testMapping2.AccountOut__c, verifyaccout);
		} else {
			System.assert(testResult[0].AccountOut__c == testMapping2.AccountOut__c, verifyaccout);
		}
	}
	
	@isTest
	private static void getTMobileMappingsFailTest() {
		CH_Case_PA_InterfaceMapping__c testMapping = new CH_Case_PA_InterfaceMapping__c(
			Name = 'test',
			AccountIn__c = acctIn,
			RangePrefix__c = 'TEST',
			RangeStart__c = 0,
			RangeEnd__c = 10,
			AccountOut__c = 'success',
			CaseOriginSystem__c = CH_ExternalInterfaceUTIL.TMOBILE_ORIGIN_CODE
		);
		insert testMapping;
		
		Case testCase = new Case(
			CH_CaseOriginSystem__c = CH_ExternalInterfaceUTIL.TMOBILE_ORIGIN_CODE,
			CH_ExternalSystemAccount__c = 'ABC9999 | TEST | TEST'
		);
		
		Test.startTest();
		List<CH_Case_PA_InterfaceMapping__c>  testResult = CH_ExternalInterfaceUTIL.getTMobileMappings(new List<Case>{testCase});
		Test.stopTest();
		
		System.assert(testResult.size() == 0, verifyoutcome);
	}
	
	@isTest
	private static void getTMobileMappingsFailWrongInputTest() {
		Case testCase = new Case(
			CH_CaseOriginSystem__c = CH_ExternalInterfaceUTIL.TMOBILE_ORIGIN_CODE,
			CH_ExternalSystemAccount__c = 'TEST'
		);
		
		Test.startTest();
		List<CH_Case_PA_InterfaceMapping__c>  testResult = CH_ExternalInterfaceUTIL.getTMobileMappings(new List<Case>{testCase});
		Test.stopTest();
		
		System.assert(testResult.size() == 0, verifyoutcome);
		System.assert(CH_ExternalInterfaceUTIL.casesWithErrors.contains(testCase), 'case had no error assigned');
	}
}