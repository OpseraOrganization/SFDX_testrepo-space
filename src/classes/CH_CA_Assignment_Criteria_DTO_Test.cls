@isTest
public class CH_CA_Assignment_Criteria_DTO_Test {
	public static final string ACCOUNT_NAME = 'LEGAL-ACCOUNT';
	public static final string LCSSC='Legacy Customer Support Service - Critical 24x7';
	public static final string NSC='CH_NokiaStandardCase';
	public static User runAsUser = new User(Id = UserInfo.getUserId());
	private static integer NokiaId = 100;  
	
	@testSetup
	static void setuptestdata(){  
		Id accountLegalEntityRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		Account tempLegalAccount = new Account(
	  Type = 'Vendor', //Y.
			Name = ACCOUNT_NAME,
			RecordTypeId = accountLegalEntityRecordType
		);
		Insert tempLegalAccount;
		
		Id accountCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		Account tempParentAccount = new Account(
			Name = 'PARENT-ACOOUNT',
			RecordTypeId = accountCustomerRecordType
		);
		Insert tempParentAccount; 
		
		CH_CustomerGrouping__c customerGroup =new CH_CustomerGrouping__c();
		customerGroup.Name = 'Test CustomerGroup';
		Insert customerGroup;
		
		CH_CustomerGroup_Account__c customerGroupAccounts =new CH_CustomerGroup_Account__c();
		customerGroupAccounts.CH_Account__c=tempLegalAccount.Id;
		customerGroupAccounts.CH_Customer_Grouping__c=customerGroup.Id;
		insert customerGroupAccounts;
		
		Product2 tempProduct = new Product2(Name = 'TestProduct',NokiaCPQ_State__c = 'Implement',
											NCP_CAREACTIVATE__c = 'test',
											PMD_Portfolio_Classification__c = 'Product');
		insert tempProduct;
		
		PriceBookEntry tempPriceBookEntry = new PriceBookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = tempProduct.id,
			UnitPrice = 0,
			CurrencyIsoCode = 'EUR',
			IsActive = true
		);
		Insert tempPriceBookEntry;
		
		Id recordTypeId = Schema.SobjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_VendorContract').getRecordTypeId(); //Y.
		
		// Create contract
		Test.starttest();
		ServiceContract serviceContract = new ServiceContract(
	  RecordTypeId = recordTypeId, //Y.
			StartDate = Date.today(), //Y.
			AccountId = tempLegalAccount.Id,
			Name = 'TestServiceContract',
			CH_CDB_ContractId__c = 'Test',
			CH_EntitlementScript__c = 'Header Script',
			Pricebook2Id = Test.getStandardPricebookId(),
			CurrencyIsoCode = tempPriceBookEntry.CurrencyIsoCode
		);
		Insert serviceContract;
		test.stopTest();
		
		CH_ProductGrouping__c productGroup = new CH_ProductGrouping__c();   
		productGroup.OwnerId = runAsUser.Id;
		productGroup.Name = 'Test ProductGroup';
		Insert productGroup;
		
		CH_ProductGroup_Product__c productGroupProduct = new CH_ProductGroup_Product__c();
		productGroupProduct.CH_Product__c= tempProduct.Id;
		productGroupProduct.CH_Product_Grouping__c =productGroup.Id;
		Insert productGroupProduct;
		
		Account tempParentAccount1 = [Select Id from Account where name = 'PARENT-ACOOUNT' LIMIT 1];
		
		Contact normalContact = new Contact(
			FirstName = 'McTesty',
			Lastname = String.valueOf(System.now().millisecond()),
			Email = 'test@email.com',
			AssistantName = 'Normal Contact',
			AccountId = tempParentAccount1.Id
		);
		Insert normalContact;
		Profile profile = [Select Id from Profile where name = 'System Administrator' LIMIT 1];
		
		User chUser = new User(
			Lastname='NONPORTAL1',
			Firstname='NONPORTAL1',
			Alias = 'TSTNP1',
			ProfileId = profile.Id,
			Username = System.now().millisecond() + 'TSTNP1@test.com',
			Email= System.now().millisecond() + 'test2@test.com',
			EmailEncodingKey='UTF-8',
			LanguageLocaleKey='en_US',
			LocaleSidKey='en_US',
			TimeZoneSidKey='America/Chicago',
			Nokia_ID__c = 'CHTEST' + String.valueOf(NokiaId++)
		);
		insert chUser;
		Date now = Date.today();
		// Create the assset
		Id assetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_CoveredProduct').getRecordTypeId();
		Asset asset = new Asset(
			AccountId = tempLegalAccount.Id,
			Name = 'TestAsset',
			Product2Id = tempProduct.Id,
			CH_CDB_ExternalAssetId__c = '12334',
			CH_NetworkElementID__c = '43321',
			recordTypeId = assetRecordTypeId
		);
		Insert asset;
		
		// Create Contract Line Item 
		ContractLineItem createContractLineItem = new ContractLineItem(
			ServiceContractId = serviceContract.Id,
			AssetId = asset.Id,
			UnitPrice = 0,
			StartDate = now.AddDays(-5),
			EndDate = now.AddDays(5),
			Quantity = 1,
			PricebookEntryId = tempPriceBookEntry.Id, 
			CH_LineItemEntitlementScript__c = 'TestLineItemScript',
			CH_CDB_EntitlementId__c = 'TESTEntitlement',
			CH_ServiceOffering__c = 'Test Service Offering',
			CH_ServiceType__c = 'Customer Support', 
			CH_ServiceMappingId__c = CH_CA_Assignment_Criteria_DTO_Test.LCSSC
		);
		Insert createContractLineItem;
		
		// Create entitlement
		SlaProcess slaProcess = [SELECT Id FROM SlaProcess WHERE Name = 'Legacy Customer Support Service - Critical 24x7' LIMIT 1];
		Entitlement createEntitlement = new Entitlement(
			AccountId = tempLegalAccount.Id,
			AssetId = asset.Id,
			Startdate = Date.Today().addDays(-1), // To get an Active entitlement
			CH_CDB_EntitlementId__c = '23451',
			ContractLineItemId = CreateContractLineItem.Id,
			ServiceContractId = serviceContract.Id,
			CH_EntitlementType__c = 'Entitled Asset',
			Name = 'Entitled Asset',
			SlaProcessId = slaProcess.id,
			CH_ServiceMappingId__c = CH_CA_Assignment_Criteria_DTO_Test.LCSSC
		);
		Insert createEntitlement;
		
		// authorized entitlement
		Entitlement createAuthorizedEntitlement = new Entitlement(
			AccountId = tempLegalAccount.Id,
			Name = 'Test Authorized Contact Entitlement',
			Startdate = Date.Today().addDays(-1), // To get an Active entitlement
			CH_CDB_EntitlementId__c = '22345',
			ContractLineItemId = CreateContractLineItem.Id,
			CH_EntitlementType__c = 'Authorized Contact',
			CH_ServiceMappingId__c = CH_CA_Assignment_Criteria_DTO_Test.LCSSC
		);
		Insert createAuthorizedEntitlement;
	   
		EntitlementContact entitlementContact = new EntitlementContact();
		entitlementContact.ContactId = normalContact.Id;
		entitlementContact.EntitlementId = createEntitlement.id;
		insert entitlementContact;
		
		CH_CustomerSpecificTargetSLA__c customSla = new CH_CustomerSpecificTargetSLA__c(
			CH_Account__c = tempLegalAccount.Id,
			CH_ServiceContract__c = serviceContract.id,
			CH_LineItemNumber__c = CreateContractLineItem.id,
			CH_ServiceMappingId__c = CH_CA_Assignment_Criteria_DTO_Test.LCSSC,
			CH_Severity__c = 'Major',
			CH_Outage__c = 'No',
			CH_Entitlement__c = createEntitlement.id,
			CH_IR_Duration__c = 5
		);
		insert customSla;	   
	   
	}
	
	@istest
	static void getCustomerGroupsForCustomer(){
		Test.startTest();
		CH_CA_Assignment_Criteria_DTO dto = new CH_CA_Assignment_Criteria_DTO();
		System.assert(dto.customerGroupIds.size() == 0);
		
		id accountId = [SELECT Id FROM Account WHERE Name = 'LEGAL-ACCOUNT' LIMIT 1].Id;
		dto.customerId = accountId;
		dto.GetCustomerGroupsForCustomer();
		System.assert(dto.customerGroupIds.size() == 1);
		Test.stopTest();
	}
	
	@istest
	static void getProductGroupsForProduct(){
		Test.startTest();
		CH_CA_Assignment_Criteria_DTO dto = new CH_CA_Assignment_Criteria_DTO();
		 
		Id productId = [SELECT Id FROM Product2 WHERE Name = 'TestProduct' LIMIT 1].Id;
		dto.productId = productId;
		dto.GetProductGroupsForProduct();
		CH_CA_Assignment_Criteria_DTO.getRegionByCountry('Sweden');
		System.assert(dto.productGroupIds.size() == 1);
		Test.stopTest();
	}
	
	@istest
	static void createIncidentSearchCriteria(){
		test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_Assignment_Criteria_DTO_Test.NSC, false);
		Insert newCase; 
		Case newCase1 = CH_UTIL_TEST.createCaseNotSaved('TEST2', 'Critical', 'No', CH_CA_Assignment_Criteria_DTO_Test.NSC, false);
		Insert newCase1;
		test.stoptest();
		CH_CA_Assignment_Criteria_DTO dto = new CH_CA_Assignment_Criteria_DTO();
		CH_CA_Assignment_Criteria_DTO newDTO = dto.createIncidentSearchCriteria(newCase);
		CH_CA_Assignment_Criteria_DTO newDTO1 = dto.createProblemSearchCriteria(newCase1);
		System.assert(newDTO1.severity == 'Critical', 'Expected Critical');
		System.assert(newDTO.severity == 'Minor', 'Expected Minor');
		System.assert(newDTO.levelOfSupport[0] == 'Initial Support', 'Expected Initial Support');
		System.assert(newDTO.workgroupType[0] == 'Smart Tier 1', 'Expected Smart Tier 1');
		System.assert(newDTO.workgroupType[1] == 'Engineer', 'Expected Engineer');
	}
	
	@istest
	static void createProblemSearchCriteria(){
		test.starttest();
		CH_Workgroup__c workgroup = new CH_Workgroup__c();
		workgroup.name = 'TEST';
		workgroup.CH_Type__c = 'Engineer;Smart Tier 1';
		insert workgroup;
		
		CH_workgroup__c workgroup1 = [SELECT Id,CH_Severity_Outage__c FROM CH_workgroup__c WHERE Name = 'TEST' LIMIT 1];
		// Create severity Outage Field
		
		CH_Workgroup_Rule__c rule = new CH_Workgroup_Rule__c ();
		rule.name = 'PASSIVE';
		rule.CH_Workgroup__c = workgroup.Id;
		rule.CH_Severity__c = 'Major';
		rule.CH_Outage__c = 'No';
		rule.CH_OrderNumber__c = 100;
		insert rule;
		
		workgroup1.CH_Severity_Outage__c='Severity Minor and Outage No';
		update workgroup1;
		
		List<string> levelOfSupports = new List<string>();
		levelOfSupports.add('Initial Support');
		List<string> workgroupTypes = new List<string>();   
		workgroupTypes.add('Expert');
		
		SlaProcess slaProcess = [SELECT Id FROM SlaProcess WHERE Name = 'Legacy Customer Support Service - Critical 24x7' LIMIT 1];
		Entitlement entitlement = [SELECT Id FROM Entitlement LIMIT 1];
		
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Major', 'No', CH_CA_Assignment_Criteria_DTO_Test.NSC, false);
		Insert newCase; 
		DateTime now = DateTime.now();
		newCase.SlaStartDate = now.AddDays(-1);
		newCase.EntitlementId = entitlement.Id;
		newCase.IsStopped = false;
		newCase.CH_IsInitialResponseSLA__c = true;
		update newCase;
		
		CH_CA_Assignment_Criteria_DTO caseAssignmentDetails = new CH_CA_Assignment_Criteria_DTO();
		caseAssignmentDetails.supportCase = newCase;
		// Create search criteria
		caseAssignmentDetails.contractType='';
		caseAssignmentDetails.contract = '';
		caseAssignmentDetails.severity = 'Major';
		caseAssignmentDetails.region = '';
		caseAssignmentDetails.country = '';
		caseAssignmentDetails.levelOfSupport = levelOfSupports;
		caseAssignmentDetails.customerId = null;
		caseAssignmentDetails.customerGroupId = null; // only used for search screens
		caseAssignmentDetails.productId = newCase.ProductId;
		caseAssignmentDetails.productGroupId = null; // only used for search screens
		caseAssignmentDetails.outage = 'No';
		caseAssignmentDetails.workgroupType= workgroupTypes;
		CH_Workgroup_Rule__c rule1 = [SELECT Id, CH_Workgroup__c FROM CH_Workgroup_Rule__c WHERE name = 'PASSIVE' LIMIT 1];
		caseAssignmentDetails.validWorkgroupRules = new List<CH_Workgroup_Rule__c>{rule1};
			
			CH_Workgroup_Business_Hours_Association__c bH = new CH_Workgroup_Business_Hours_Association__c();
		bH.CH_Business_Hours__c = [select id from BusinessHours where name = 'BE | Mon-Fri 0800-1800 | Europe/Brussels | H' LIMIT 1].Id;
		bH.CH_Workgroup__c = [SELECT Id FROM CH_workgroup__c WHERE Name ='TEST' LIMIT 1].id;
		insert bH;
		system.debug('BH BUSINNESS date####'+BH.CH_Business_Hours__c);
		CH_CA_Assignment_Criteria_DTO newDTO = new CH_CA_Assignment_Criteria_DTO();
		newDTO.getAssignmentType(caseAssignmentDetails);
		test.stoptest();
		
	}  
	
	@istest
	static void calculateNextStartBH(){
		CH_Workgroup__c workgroup = new CH_Workgroup__c();
		workgroup.name = 'TEST';
		workgroup.CH_Type__c = 'Engineer;Smart Tier 1';
		insert workgroup;
		
		CH_Workgroup_Business_Hours_Association__c bH = new CH_Workgroup_Business_Hours_Association__c();
		bH.CH_Business_Hours__c = [select id from BusinessHours where name = 'BE | Mon-Fri 0800-1800 | Europe/Brussels | H' LIMIT 1].Id;
		bH.CH_Workgroup__c = [SELECT Id FROM CH_workgroup__c WHERE Name ='TEST' LIMIT 1].id;
		insert bH;
		
		List<CH_Workgroup_Business_Hours_Association__c> workgroupBHs = new List<CH_Workgroup_Business_Hours_Association__c>{bH};
			
			CH_CA_Assignment_Criteria_DTO dto1 = new CH_CA_Assignment_Criteria_DTO();
		DateTime nextStartBH = dto1.calculateNextStartBH(workgroupBHs, DateTime.now());
		
		System.assert(nextStartBH > DateTime.now());
		
		CH_CA_Assignment_Criteria_DTO dto = new CH_CA_Assignment_Criteria_DTO();
		Boolean validFirstMilestone = dto.validateNextStartBH(DateTime.now(), DateTime.now().addminutes(5), 0);
		System.assert(validFirstMilestone, 'Dates should be valid');
		
		validFirstMilestone = dto.validateNextStartBH(DateTime.now(), DateTime.now().addminutes(5), 10);
		System.assert(validFirstMilestone, 'Dates should be valid');
		
		validFirstMilestone = dto.validateNextStartBH(DateTime.now(), DateTime.now().addminutes(-5), 0);
		System.assert(!validFirstMilestone, 'Dates should not be valid');
		
		validFirstMilestone = dto.validateNextStartBH(DateTime.now(), DateTime.now().addminutes(-10), 5);
		System.assert(!validFirstMilestone, 'Dates should not be valid');
	}
	
}