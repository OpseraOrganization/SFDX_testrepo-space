@isTest(seeAllData = false)
public class CH_BlacklistCaseReportTrigger_TEST {
	
	
	@testSetup
	public static void testDataFactory(){		
		
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		BusinessHours stdBusinessHours = [select id, name from BusinessHours where IsActive = true AND IsDefault = true];
		CH_AccountName__c accauth = new CH_AccountName__c();
		accauth.CH_InvalidName__c = 'Nokia';
		accauth.CH_ValidName__c = 'Nokia-OYJ';
		insert accauth;
		
		Map<String, Id> accRecordTypes = new Map<String, Id>(); 
		for (RecordType accrt : [SELECT Id, Name FROM RecordType WHERE SobjectType = :'Account']) { 
			accRecordTypes.put(accrt.Name, accrt.Id); 
		}
		Id RecTypeIdacc = accRecordTypes.get('Legal Entity');
		Id RecTypeIdCussacc = accRecordTypes.get('Customer'); 
		Id RecTypeIdProsacc = accRecordTypes.get('Prospect');	
		 
		Map<String, Id> CaseRecordTypes = new Map<String, Id>();
		for (RecordType rt : [SELECT Id, Name FROM RecordType WHERE SobjectType = :'Case']) { 
			CaseRecordTypes.put(rt.Name, rt.Id); 
		}
		Id RecTypeIdStandard = CaseRecordTypes.get('Nokia Standard Case');
		Id RecTypeIdProblem = CaseRecordTypes.get('Problem');
		Id RecTypeIdIncidentRest = CaseRecordTypes.get('Nokia Incident with Restoration');
		Id RecTypeIdInfoRequest = CaseRecordTypes.get('Nokia Information Request');
	
		 
		List<Account> testAccs = new List<Account>();
		List<Case> testCases = new List<Case>();
		List<Asset> testAsts = new List<Asset>();
		List<Contact> testCons = new List<Contact>();
		List<Entitlement> testEntls = new List<Entitlement>();
		List<Product2> prodRecds = new List<Product2>();  
		List<CH_Workgroup__c> WgrpRecds = new List<CH_Workgroup__c>();
		
		
		Account testacc = new Account(Name = 'AccTesting');
		testacc.Country__c = 'India';
		testacc.CountryCode__c = 'IN'; 
		testacc.recordtypeid = RecTypeIdacc;
		testAccs.add(testacc);
		insert testAccs;
		
		Product2 prodRc = new Product2();
		prodRc.Name = 'Par Prod';
		prodRc.DataUsage__c = 'CARES';
		prodRc.PMD_Portfolio_Classification__c = 'Solution';
		prodRc.ProductCode = '1234';
		insert prodRc;
		
		Product2 prodRec = new Product2();
		prodRec.Name = 'Test Prod';
		prodRec.DataUsage__c = 'CARES';
		prodRec.PMD_Portfolio_Classification__c = 'Product';
		prodRec.CH_ParentProductId__c = prodRc.id;
		prodRec.ProductCode = '12345';
		prodRecds.add(prodRec);
		insert prodRecds;
	
		Account testProcacc = new Account(Name = 'Testing');
		testProcacc.Country__c = 'India';
		testProcacc.CountryCode__c = 'IN'; 
		testProcacc.ShippingCountry = 'India';
		testProcacc.ShippingCity = 'HYD';
		testProcacc.ShippingCountryCode = 'IN';
		testProcacc.ShippingState = 'Telangana';
		testProcacc.ShippingPostalCode = '5000032';
		testProcacc.ShippingStreet = 'DLF';
		testProcacc.BillingCity = 'Hyderabad';
		testProcacc.BillingStreet = 'DLF';
		testProcacc.BillingCountry = 'India';
		testProcacc.RecordTypeId = RecTypeIdProsacc;
		insert testProcacc;
		
		Contact testcon = new Contact();
		testcon.LastName = 'Mickey';
		testcon.FirstName = 'Mouse';
		testcon.Phone = '955';
		testcon.Email = 'Testing@tcs.com';
		testcon.CH_ContactTimeZone__c = '(GMT+14:00) Line Islands Time (Pacific/Kiritimati)';
		testcon.CH_PreferredMtdOfServiceCommunication__c = 'Email';
		testcon.accountId = testProcacc.Id;
		testcon.CH_Legal_Entity_Name__c = 'test';
		testCons.add(testcon);
		insert testCons; 
		
		List<Product2> productlist =new List<Product2>();
			Product2 prodObj = new Product2();
			prodObj.Name ='Test';
			prodObj.ProductCode ='133-047489_0';
			prodObj.DataUsage__c = 'CARES';
			prodObj.PMD_Portfolio_Classification__c = 'Product';
			prodObj.NCP_CAREACTIVATE__c ='Test';
			prodObj.DataUsage__c='CARES';
			prodObj.NCP_CAREACTIVATE__c='Test';
			prodObj.CH_ParentProductId__c=prodObj.Id;
			//prodObj.CH_Valid__c =True;
			productlist.add(prodObj);
		insert productlist;
		
		Id pricebook2Id = Test.getStandardPricebookId();
		List<PricebookEntry> pricebook =new List <PricebookEntry>();
			PricebookEntry standardPrice = new PricebookEntry();
			standardPrice.Pricebook2Id= pricebook2id;
			standardPrice.Product2Id= productlist[0].id;
			standardPrice.UnitPrice = 10000;
			standardPrice.IsActive = true;
			pricebook.add(standardPrice);
		insert pricebook;
		
		Pricebook2 customPB = new Pricebook2();
		customPB.Name = 'Nokia CARE Price Book';  
		customPB.IsActive = true;
		insert customPB;
		
		List<PricebookEntry> Custompricebook =new List <PricebookEntry>();

			PricebookEntry customPrice = new PricebookEntry();
			customPrice.Pricebook2Id= customPB.id;
			customPrice.Product2Id= productlist[0].id;
			customPrice.UnitPrice = 10000;
			customPrice.IsActive = true;
			Custompricebook.add(customPrice);
		insert Custompricebook;
		
		List<ServiceContract> ServiceContractlist =new List<ServiceContract>();
		
			ServiceContract serContract =new ServiceContract();
	  //	  serContract.RecordTypeId = RecTypeIdser;
			serContract.AccountId = testacc.id;
			serContract.Name = 'TCS Service Contract TestData';
			serContract.CurrencyIsoCode='EUR';
			serContract.CH_CDB_ContractId__c = '123456test';
			serContract.CH_CDB_PreviousContractId__c = '123456test';
			serContract.StartDate = system.today();
			serContract.EndDate = system.today()+10;
			serContract.Pricebook2Id = customPB.id;
			ServiceContractlist.add(serContract);
		insert ServiceContractlist;
		
		List<ContractLineItem> ContractLineItemList =new List<ContractLineItem>();
	
			ContractLineItem contLine = new ContractLineItem();
	 // contLine.CH_BusinessHourName__c = stdBusinessHours.Id;
			contLine.PricebookEntryId = Custompricebook[0].id;
			contLine.Quantity = 55;
			contLine.UnitPrice = 55;
			contLine.ServiceContractId = ServiceContractlist[0].id;
			ContLine.CH_ServiceOffering__c = 'Test';
			contLine.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';
			contLine.CH_CDB_EntitlementId__c = '1test';
			ContractLineItemList.add(contLine);   
	
		insert ContractLineItemList;
		
		Id assetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Covered Product').getRecordTypeId();
		Asset testAst = new Asset();
		testAst.Name = 'Test Asset' ;
		testAst.ContactId = testcon.Id;
		testAst.AccountId = testacc.Id;
		testAst.RecordTypeId = assetRecordTypeId;
		testAst.CH_CDB_ExternalAssetId__c = 'ExtId Test';
		testAsts.add(testAst);
		insert testAsts;
		
		Entitlement tstEntle = new Entitlement();
		tstEntle.Name= 'Test Entitlement';
		tstEntle.AssetId = testAst.id;
		tstEntle.accountId = testProcacc.Id;
		tstEntle.CH_CDB_EntitlementId__c = 'Test';
		tstEntle.ContractLineItemId = ContractLineItemList[0].id;
		tstEntle.ServiceContractId = ServiceContractlist[0].id;
		tstEntle.StartDate = System.today();
		tstEntle.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';
		testEntls.add(tstEntle);
		insert testEntls;		
		
		EntitlementContact entcon = new EntitlementContact();
		entcon.EntitlementId = tstEntle.id;
		entcon.ContactId = testcon.id;
		insert entcon;
		
		CH_Workgroup__c workGrp = new CH_Workgroup__c();
		workGrp.Name = 'Test';
		WgrpRecds.add(workGrp);
		insert WgrpRecds;
		test.startTest();
		Case tstCase = new Case();
		tstCase.recordtypeid = RecTypeIdProblem;
		tstCase.AccountId = testacc.id;
		tstCase.AssetId = testAst.id;
		tstCase.Subject = 'Case Testing';
		tstCase.Description = 'Case Testing';
		tstCase.Severity__c = 'Major';
		tstCase.CH_InitialDiagnosis__c = 'testt';
		tstCase.CH_Solution__c = prodRc.id;
		tstCase.Country__c = 'India';
		tstCase.CH_CurrentWorkGroup__c = workGrp.id;
		tstCase.CH_Outage__c = 'No';
		tstCase.CH_ServiceType__c = 'Customer Support';
		tstCase.Status = 'Draft';
	  // tstCase.CH_Stage__c = 'Register';
		tstCase.EntitlementId = tstEntle.id;
		tstCase.ProductId = prodRec.id;
		tstCase.ContactId = testcon.Id;
		tstCase.CH_IssueOccurenceDate__c = system.today(); 
		testCases.add(tstCase);
		insert testCases;
		List<CH_BlacklistRecords__c> listRecds = New List<CH_BlacklistRecords__c>();

		CH_BlacklistRecords__c blkRecord = new CH_BlacklistRecords__c();
		blkRecord.name = 'Sales_Targets_Schedule_Trigger_1';
		blkRecord.CH_AccountNames__c = 'Nokia GDC Chennai';
		blkRecord.CH_ProductCodes__c = '833-002636';
		listRecds.add(blkRecord);
		insert listRecds;

		test.stopTest();
	}
	
	@isTest
	public static void testmethod1(){
		
		test.startTest();
	
		Map<String, Id> CaseRecordTypes = new Map<String, Id>();
		Map<Id, Product2> proRecordMap = new Map<Id, Product2>();
		for (RecordType rt : [SELECT Id, Name FROM RecordType WHERE SobjectType = :'Case']) { 
			CaseRecordTypes.put(rt.Name, rt.Id); 
		}
		Id RecTypeIdProblem = CaseRecordTypes.get('Problem');
		List<Case> caseRecs = new List<Case>();
	
		 Case caseRec = [select id, subject from case where Subject = 'Case Testing'];
		 caseRec.recordtypeid = RecTypeIdProblem;
		 caseRecs.add(caseRec);
		 system.debug('CH_Stage__c'+caseRec.CH_Stage__c);
		 update caseRecs;
		
		List < CH_BlacklistRecords__c > lBlockRecords = CH_BlacklistRecords__c.getAll().values();
		system.debug('$$$$'+lBlockRecords);
		test.stopTest();
	}
	
	@isTest
	public static void testmethod2(){
		
		test.startTest(); 
		List<Account> testAccs = new List<Account>();
		List<Case> caseRecs = new List<Case>();
		Case caseRec = [select id, subject from case where Subject = 'Case Testing'];
		 caseRec.Status = 'Created';
		 caseRecs.add(caseRec);
		 system.debug('CH_Stage__c'+caseRec.CH_Stage__c);
		 update caseRecs;
		Map < Id, Account > accountMap = new Map < Id, Account> ();
		Account acc= [SELECT Id, Name, CountryCode__c FROM Account WHERE Name = 'AccTesting'];
		acc.CountryCode__c = 'WF'; 
		testAccs.add(acc);
		update testAccs;		
		accountMap.put(acc.Id, acc);
		
		Map<Id, Product2> proRecordMap = new Map<Id, Product2>();
		Product2 proRec = [select id, ProductCode from Product2 where ProductCode  = '12345'];
		proRec.ProductCode = '833-002636';
		update proRec;
		proRecordMap.put(proRec.id, proRec);
		test.stopTest();
		
	}
}