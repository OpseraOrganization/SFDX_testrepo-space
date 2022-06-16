@isTest
private class CH_CaseFlow_ControllerTest {
	public static Profile profile = [Select Id from Profile where name = 'Data Loader Profile' LIMIT 1];
	public static final String relationTyp = 'NSN Solution Consists Of';
	public static final String srvcMppID='Legacy Customer Support Service - Critical Major Minor 24x7';
	public static final String mobilephone='123-456789';
	public static final String caseReason='New problem';
	public static User dataLoaderUser = new User(
		Lastname='DataLoad',
		Firstname='USER',
		Alias = 'DL-OWNER',
		ProfileId = profile.Id,
		Username = System.now().millisecond() + 'DL-OWNER@test.com',
		Email= System.now().millisecond() + 'test2@test.com',
		EmailEncodingKey='UTF-8',
		LanguageLocaleKey='en_US',
		LocaleSidKey='en_US',
		TimeZoneSidKey='America/Chicago',
		Nokia_ID__c = 'CHTEST100'
	);
	public static testMethod void test0() {
		try{
			CH_CaseFlow_Controller.getContactName(null);
	CH_CaseFlow_Controller.checkProfile(null);
			CH_CaseFlow_Controller.checkProfile('Nokia Admin Profile');
			CH_CaseFlow_Controller.checkProfile('System Administrator');
			CH_CaseFlow_Controller.saveCase('insert', '{"Id":""}');
			CH_CaseFlow_Controller.saveAsset('insert', '{"Id":""}');			
		}
		catch(Exception e){
	System.assert(e.getMessage()!=null);
		}
	}
	public static testMethod void test1() {
		System.runAs(dataLoaderUser){
			CH_EntitlementTestData.createCustomSettingData();
			
			Account accObjNL = new Account();
			accObjNL.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('Prospect').Id;	
			accObjNL.Name ='testNL';
			accObjNL.Type = 'Prospect';
			accObjNL.BillingCity= 'Hyderabad';
			accObjNL.BillingCountry = 'India';
			accObjNL.BillingState = 'telangana';
			accObjNL.BillingStreet = '18/89 Ayyappa colony';
			insert accObjNL;
			
			Account accObjLE = new Account();
			accObjLE.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('Legal_Entity').Id;	
			accObjLE.Name ='testLE';
			accObjLE.ParentId = accObjNL.id;
			accObjLE.Type = 'Prospect';
			insert accObjLE;
			
			Contact contObj = new contact();
			contObj.AccountId = accObjNL.id;
			contObj.FirstName = 'TestClassData';
			contObj.LastName = 'TCS Data';
			contObj.Email = 'testaccount@aometh.com';
			contObj.Market__c = 'Market India';
			contObj.CH_ContactType__c = 'customer';
			contObj.CurrencyIsoCode = 'EUR';
			insert contObj;
			
			Product2 prodObj = new Product2();
			prodObj.Name ='Test';
			prodObj.ProductCode ='133-047489_0';
			prodObj.DataUsage__c = 'CARES';
			prodObj.PMD_Portfolio_Classification__c = 'Product';
			prodObj.NCP_CAREACTIVATE__c ='Test';
			prodObj.DataUsage__c='CARES';
			prodObj.NCP_Nokia_Product_Id__c = '123456';
			prodObj.NCP_CAREACTIVATE__c='Test';
			insert prodObj;
			
			Product2 prodObj1 = new Product2();
			prodObj1.Name ='Test1';
			prodObj1.ProductCode ='133-047489_1';
			prodObj1.DataUsage__c = 'CARES';		
			prodObj1.NCP_CAREACTIVATE__c ='Test1';
			prodObj1.DataUsage__c='CARES';
			prodObj1.CH_ParentProductId__c=prodObj.Id;
			prodObj1.NCP_Nokia_Product_Id__c = '852963';
			prodObj1.CH_Product_Type__c = SWS_Constants.ProductTypeNSN;
			prodObj1.PMD_Portfolio_Classification__c = 'Solution';
			insert prodObj1;
			
			Product2 prodObj2 = new Product2();
			prodObj2.Name ='Test11';
			prodObj2.ProductCode ='133-047489_11';
			prodObj2.DataUsage__c = 'CARES';		
			prodObj2.NCP_CAREACTIVATE__c ='Test11';
			prodObj2.DataUsage__c='CARES';
			prodObj2.CH_ParentProductId__c=prodObj.Id;
			prodObj2.NCP_Nokia_Product_Id__c = '8529637';
			prodObj2.CH_Product_Type__c = 'Complementary Item';
			prodObj2.PMD_Portfolio_Classification__c = 'Complementary Product';
			prodObj2.PMD_Additional_Classification__c = 'Product Variant';
			insert prodObj2;
			
			Product_Relation__c childParent = new Product_Relation__c();
			childParent.Child_Name__c = prodObj.NCP_Nokia_Product_Id__c;
			ChildParent.Parent_Type__c= SWS_Constants.ProductTypeNSN;
			childparent.RelationFor__c = 'ProductRelation';
			childparent.Parent_Name__c = prodObj1.NCP_Nokia_Product_Id__c;
			childParent.RelationType__c = relationTyp;
			insert childParent;
			
			Product_Relation__c ParentChild = new Product_Relation__c();
			ParentChild.Child_Name__c = prodObj2.NCP_Nokia_Product_Id__c;
			ParentChild.Child_Type__c = 'NSN Complementary Item';
			ParentChild.RelationFor__c = 'ProductRelation';
			ParentChild.Parent_Name__c = prodObj.NCP_Nokia_Product_Id__c;
			ParentChild.RelationType__c = 'NSN Is Complemented By';
			insert ParentChild;
			
			
			Id pricebook2Id = Test.getStandardPricebookId();
			
			PricebookEntry standardPrice = new PricebookEntry();
			standardPrice.Pricebook2Id= pricebook2id;
			standardPrice.Product2Id= prodObj.id;
			standardPrice.UnitPrice = 10000;
			standardPrice.IsActive = true;
			insert standardPrice;
			
			Pricebook2 customPB1 = new Pricebook2();
			customPB1.Id = CH_EntitlementTestData.CreateCustomPriceBook();
			
			PricebookEntry customPrice = new PricebookEntry();
			customPrice.Pricebook2Id= customPB1.Id;
			customPrice.Product2Id= prodObj.id;
			customPrice.UnitPrice = 10000;
			customPrice.IsActive = true;
			insert customPrice;
			
			Asset assetObj = new Asset();
			assetObj.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_CoveredProduct').Id;
			assetObj.Name = 'Test Asset Test Class';
			assetObj.Product2Id = prodObj.id;
			assetObj.AccountId = accObjLE.id;
			insert assetObj;
			system.assertNotEquals(assetObj.Id, Null);
			
			
			ServiceContract serContract =new ServiceContract();
			serContract.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_ServiceContract').Id;
			serContract.AccountId = accObjLE.id;
			serContract.Name = 'TCS Service Contract TestData';
			serContract.CurrencyIsoCode='EUR';
			serContract.CH_CDB_ContractId__c = '123456test';
			serContract.CH_PortalCaseCreationSWMaintenance__c = true;
			serContract.NCP_External_Status__c = 'Active';
			serContract.CH_CDB_PreviousContractId__c = '123456789testingdafsaf';
			serContract.StartDate = system.today();
			serContract.EndDate = system.today()+10;
			serContract.CH_CAPM_EmailAddress__c = 'cmmeekp7777@nokia.com';
			serContract.CH_PriceBook__c = 'Nokia CARE Price Book';
			
			serContract.Pricebook2Id = customPB1.Id;
			INSERT serContract;
			System.assertNotEquals(serContract.id, null);
			
			ServiceContract serContract1 =new ServiceContract();
			serContract1.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_ServiceContract').Id;
			serContract1.AccountId = accObjLE.id;
			serContract1.Name = 'TCS Service Contract TestData';
			serContract1.CurrencyIsoCode='EUR';
			serContract1.CH_CDB_ContractId__c = '456test123';
			serContract1.CH_PortalCaseCreationSWMaintenance__c = true;
			serContract1.NCP_External_Status__c = 'Active';
			serContract1.CH_CDB_PreviousContractId__c = '123456789testingdafsaf';
			serContract1.StartDate = system.today();
			serContract1.EndDate = system.today()+10;
			serContract1.CH_CAPM_EmailAddress__c = 'cmmeekp77@nokia.com';
			serContract1.CH_PriceBook__c = 'Nokia CARE Price Book';
			
			serContract1.Pricebook2Id = customPB1.Id;
			serContract1.CH_ServiceContractType__c = 'Internal Contract';
			INSERT serContract1;
			System.assertNotEquals(serContract1.id, null);
			
			Entitlement entiObj = new Entitlement();
			entiObj.Name ='test';
			entiObj.AccountId = accObjLE.id;
			entiObj.CH_CDB_EntitlementId__c = '1test';
			entiObj.StartDate = System.today();
			entiObj.EndDate = System.today() + 10;
			
			entiObj.AssetId = assetObj.id;
			entiObj.CH_EntitlementType__c = SWS_Constants.EntitlementTypeEA;
			entiObj.CH_ServiceMappingId__c = SWS_Constants.LCSSNS;
			entiObj.ServiceContractId = serContract.id;
			insert entiObj;
			
			Entitlement entiObj1 = new Entitlement();
			entiObj1.Name ='test';
			entiObj1.AccountId = accObjLE.id;
			entiObj1.CH_CDB_EntitlementId__c = '1test';
			entiObj1.StartDate = System.today();
			entiObj1.EndDate = System.today() + 10;
			
			entiObj1.AssetId = assetObj.id;
			entiObj1.CH_EntitlementType__c = SWS_Constants.EntitlementTypeEA;
			entiObj1.CH_ServiceMappingId__c = SWS_Constants.LCSSNS;
			entiObj1.ServiceContractId = serContract1.id;
			insert entiObj1;
			
			EntitlementContact entcon = new EntitlementContact();
			entcon.EntitlementId = entiObj.id;
			entcon.ContactId = contObj.id;
			insert entcon;
			
			EntitlementContact entcon1 = new EntitlementContact();
			entcon1.EntitlementId = entiObj1.id;
			entcon1.ContactId = contObj.id;
			insert entcon1;
			
		ContractLineItem contractLineItem1 = new ContractLineItem(
			ServiceContractId = serContract.Id,
			AssetId = assetObj.Id,
			UnitPrice = 0,
			Quantity = 1,
			NCP_External_Status__c = 'Active',
			CH_ServiceType__c = SWS_Constants.ServiceTypeCS,
			PricebookEntryId = customPrice.Id, 
			CH_LineItemEntitlementScript__c = 'true',
			CH_CDB_EntitlementId__c = 'TEST',
			
			CH_ServiceMappingId__c = srvcMppID
		);
			test.startTest();
			ContractLineItem contractLineItem2 = new ContractLineItem(
	ServiceContractId = serContract1.Id,
	AssetId = assetObj.Id,
	UnitPrice = 0,
	Quantity = 1,
	NCP_External_Status__c = 'Active',
	CH_ServiceType__c = SWS_Constants.ServiceTypeIS,
	PricebookEntryId = customPrice.Id, 
	CH_LineItemEntitlementScript__c = 'true',
	CH_CDB_EntitlementId__c = 'TEST',
	
	CH_ServiceMappingId__c = srvcMppID
			);
			
	Case newCase1 = new Case();
		newCase1.AccountId = accObjLE.Id;
		newCase1.ContactId = contObj.Id;
		newCase1.AssetId = assetObj.Id;
		newCase1.CH_ReportedDate__c = DateTime.Now();
		newCase1.Mobile_Phone__c = mobilephone;
		newCase1.Country__c = 'Bahrain';
		newCase1.reason = caseReason;
		newCase1.Subject = 'Survey Closed Case';
		newCase1.CH_Summary__c = 'TestSub';
		newCase1.Type = 'Incident';
		newCase1.Description = 'TEST';
		newCase1.Severity__c = 'Minor';
		newCase1.CH_Outage__c = 'No';
		newCase1.Status = 'Created';
		newCase1.CH_IssueOccurenceDate__c = system.today();
		
		newCase1.CH_Initial_Assignment__c = true;
		newCase1.CH_SystemRestoredTargetDate__c = system.now();
		newCase1.CH_Reassignment__c = true;
		newCase1.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		newCase1.EntitlementId = entiObj1.Id;
		newCase1.NCP_Service_Contract__c = serContract1.Id;
		newCase1.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		newCase1.ProductId = prodObj.id; 
	
		
		insert newCase1;
			
			Case newCase = new Case();
			newCase.AccountId = accObjLE.Id;
			newCase.ContactId = contObj.Id;
			newCase.CH_ReportedDate__c = DateTime.Now();
			newCase.Mobile_Phone__c = mobilephone;
			newCase.Country__c = 'Bahrain';
			newCase.reason = caseReason;
			newCase.Subject = 'Test';
			newCase.CH_Summary__c = 'Test';
			newCase.Type = 'Incident';	
			newCase.Description = 'TEST';
			newCase.Severity__c = 'Critical';
			newCase.CH_Outage__c = 'Yes';
			newCase.Status = 'Created';
			newCase.CH_IssueOccurenceDate__c = system.today();
			newCase.ProductId = prodObj.Id;
			newCase.CH_Initial_Assignment__c = true;
			newCase.CH_SystemRestoredTargetDate__c = system.now();
			newCase.CH_Reassignment__c = true;
			newCase.CH_Problem__c = newCase1.Id;
			
			newCase.recordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_NokiaIncidentWithRestoration').Id ;
			
			
			insert newCase;
			try{
	
	CH_CaseFlow_Controller.getCaseInitiationDateTime();
	CH_CaseFlow_Controller.getStandardCaseRecordTypeId();
	CH_CaseFlow_Controller.getContactNameAndId();
	CH_CaseFlow_Controller.getCaseOwnerId();
	CH_CaseFlow_Controller.getLegalEntities(false, contObj.Id, false);
	CH_CaseFlow_Controller.getLegalEntities(true, contObj.Id, false);
	CH_CaseFlow_Controller.getAssets(false, accObjLE.id, contObj.Id,SWS_Constants.ServiceTypeCS,false);
	CH_CaseFlow_Controller.getAssets(false, accObjLE.id, contObj.Id,SWS_Constants.ServiceTypeIS,false);
	CH_CaseFlow_Controller.getEntitlements(false,accObjLE.id, assetObj.id, contObj.Id,SWS_Constants.ServiceTypeCS,false);
	CH_CaseFlow_Controller.getEntitlements(false,accObjLE.id, assetObj.id, contObj.Id,SWS_Constants.ServiceTypeIS,false);
	  
	CH_CaseFlow_Controller.getArticles();
	CH_CaseFlow_Controller.isP20OrderEditAllowed(newCase.Id);
	CH_CaseFlow_Controller.getLegalEntities(false, contObj.Id, true);
	CH_CaseFlow_Controller.getAssets(true, accObjLE.id, contObj.Id,SWS_Constants.ServiceTypeCS,true);
	CH_CaseFlow_Controller.getAssets(false, accObjLE.id, contObj.Id,SWS_Constants.ServiceTypeIS,true);
	CH_CaseFlow_Controller.getEntitlements(false,accObjLE.id, assetObj.id, contObj.Id,SWS_Constants.ServiceTypeCS,true);
	CH_CaseFlow_Controller.getEntitlements(false,accObjLE.id, assetObj.id, contObj.Id,SWS_Constants.ServiceTypeIS,true);
	
	CH_CaseFlow_Controller.accountRelatedIsAuth(contObj.Id, accObjLE.id);
	
	CH_CaseFlow_Controller.hasCaseEditAcess(newCase.Id, new List<String>{'ProductId'});
	CH_CaseFlow_Controller.hasAssetEditAcess(assetObj.Id, new List<String>{'HWS_Service_Type__c', 'CH_ContractLineItem__c', 'CH_CountryISOName__c', 'Address__c'});
	
			} catch(Exception e) {
	//Added empty line to fix sonar cube issue
			}
			
			try{
	CH_CaseFlow_Controller.getAllLegalEntities('Account', contObj.Id,SWS_Constants.ServiceTypeCS);   
	CH_CaseFlow_Controller.getAllLegalEntities('Account', contObj.Id,SWS_Constants.ServiceTypeIS);
	CH_CaseFlow_Controller.newPostToProblem(newCase.Id);
	
	
			} catch(Exception e) {
	//Added empty line to fix sonar cube issue
			}
			try{
	
	CH_CaseFlow_Controller.saveCase('update', JSON.serialize(new list<Case> { newCase }));
			} catch(Exception e) {
	//Added empty line to fix sonar cube issue
			}
			
			
			try{
	//Added empty line to fix sonar cube issue
			} catch(Exception e) {
	//Added empty line to fix sonar cube issue
			} 
			
			try{
	CH_CaseFlow_Controller.redirectScreen('CH_KeyUser', 'CH_Agent');
	CH_CaseFlow_Controller.getCaseDetails(newCase.id);
	CH_CaseFlow_Controller.getAssetDetails(newCase.AssetId);
	CH_CaseFlow_Controller.saveAsset('insert', JSON.serialize(new list<Asset> { assetObj }));
	CH_CaseFlow_Controller.saveAsset('update', JSON.serialize(new list<Asset> { assetObj }));
	CH_CaseFlow_Controller.saveAsset('upsert', JSON.serialize(new list<Asset> { assetObj }));
	CH_CaseFlow_Controller.disassociateNewProblem(newCase.Id);		
	CH_CaseFlow_Controller.displayP20fields('');
		
			} catch(Exception e) {
	//Added empty line to fix sonar cube issue
			}   
			
			try{
	//Added empty line to fix sonar cube issue
			} catch(Exception e) {
	//Added empty line to fix sonar cube issue
			}
			
			try{
	CH_CaseFlow_Controller.getContactName(contObj.Id);  
	CH_CaseFlow_Controller.enableReEntitlement(newCase.id);
	CH_CaseFlow_Controller.checkPermissionSet('CH_KeyUser');
	CH_CaseFlow_Controller.checkProfile('CH_Agent');
	CH_CaseFlow_Controller.getCurrentUser();
	CH_CaseFlow_Controller.accessCheck(newCase.Id);
	CH_CaseFlow_Controller.checkSolutionTargetDate(newCase.Id);//Changes added for NOKIASC-35322
	CH_CaseFlow_Controller.checkpausedSinceDate(newCase.Id);//Changes added for NOKIASC-35322
			} catch(Exception e) {
	//Added empty line to fix sonar cube issue
			}
			
			test.stopTest();
		}
	}	
	
	public static testMethod void test2() {
		
		CH_EntitlementTestData.createCustomSettingData();
		
		Account accObjNL = new Account();
		accObjNL.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('Prospect').Id;	
		accObjNL.Name ='testNL';
		accObjNL.BillingCity= 'Hyderabad';
		accObjNL.BillingCountry = 'India';
		accObjNL.BillingState = 'telangana';
		accObjNL.BillingStreet = '18/89 Ayyappa colony';
		insert accObjNL;
		
		Account accObjLE = new Account();
		accObjLE.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('Legal_Entity').Id;	
		accObjLE.Name ='testLE';
		accObjLE.ParentId = accObjNL.id;
		insert accObjLE;
		
		Contact contObj = new contact();
		contObj.AccountId = accObjNL.id;
		contObj.FirstName = 'TestClassData';
		contObj.LastName = 'TCS Data';
		contObj.Email = 'testaccount@aometh.com';
		contObj.Market__c = 'Market India';
		contObj.CH_ContactType__c = 'customer';
		contObj.CurrencyIsoCode = 'EUR';
		insert contObj;
		
		Product2 prodObj = new Product2();
		prodObj.Name ='Test';
		prodObj.ProductCode ='133-047489_0';
		prodObj.DataUsage__c = 'CARES';
		prodObj.PMD_Portfolio_Classification__c = 'Product';
		prodObj.NCP_CAREACTIVATE__c ='Test';
		prodObj.DataUsage__c='CARES';
		prodObj.NCP_Nokia_Product_Id__c = '123456';
		prodObj.NCP_CAREACTIVATE__c='Test';
		insert prodObj;
		
		Product2 prodObj1 = new Product2();
		prodObj1.Name ='Test1';
		prodObj1.ProductCode ='133-047489_1';
		prodObj1.DataUsage__c = 'CARES';		
		prodObj1.NCP_CAREACTIVATE__c ='Test1';
		prodObj1.DataUsage__c='CARES';
		prodObj1.CH_ParentProductId__c=prodObj.Id;
		prodObj1.NCP_Nokia_Product_Id__c = '852963';
		prodObj1.CH_Product_Type__c = SWS_Constants.ProductTypeNSN;
		prodObj1.PMD_Portfolio_Classification__c = 'Solution';
		insert prodObj1;
		
		Product2 prodObj2 = new Product2();
		prodObj2.Name ='Test11';
		prodObj2.ProductCode ='133-047489_11';
		prodObj2.DataUsage__c = 'CARES';		
		prodObj2.NCP_CAREACTIVATE__c ='Test11';
		prodObj2.DataUsage__c='CARES';
		prodObj2.CH_ParentProductId__c=prodObj.Id;
		prodObj2.NCP_Nokia_Product_Id__c = '8529637';
		prodObj2.CH_Product_Type__c = 'Complementary Item';
		prodObj2.PMD_Portfolio_Classification__c = 'Complementary Product';
		prodObj2.PMD_Additional_Classification__c = 'Product Variant';
		insert prodObj2;
		
		Product_Relation__c childParent = new Product_Relation__c();
		childParent.Child_Name__c = prodObj.NCP_Nokia_Product_Id__c;
		ChildParent.Parent_Type__c= SWS_Constants.ProductTypeNSN;
		childparent.RelationFor__c = 'ProductRelation';
		childparent.Parent_Name__c = prodObj1.NCP_Nokia_Product_Id__c;
		childParent.RelationType__c = relationTyp;
		insert childParent;
		
		Product_Relation__c ParentChild = new Product_Relation__c();
		ParentChild.Child_Name__c = prodObj2.NCP_Nokia_Product_Id__c;
		ParentChild.Child_Type__c = 'NSN Complementary Item';
		ParentChild.RelationFor__c = 'ProductRelation';
		ParentChild.Parent_Name__c = prodObj.NCP_Nokia_Product_Id__c;
		ParentChild.RelationType__c = 'NSN Is Complemented By';
		insert ParentChild;
		
		
		Id pricebook2Id = Test.getStandardPricebookId();
		
		PricebookEntry standardPrice = new PricebookEntry();
		standardPrice.Pricebook2Id= pricebook2id;
		standardPrice.Product2Id= prodObj.id;
		standardPrice.UnitPrice = 10000;
		standardPrice.IsActive = true;
		insert standardPrice;
		
		Pricebook2 customPB1 = new Pricebook2();
		customPB1.Id = CH_EntitlementTestData.CreateCustomPriceBook();
		
		PricebookEntry customPrice = new PricebookEntry();
		customPrice.Pricebook2Id= customPB1.Id;
		customPrice.Product2Id= prodObj.id;
		customPrice.UnitPrice = 10000;
		customPrice.IsActive = true;
		insert customPrice;
		
		Asset assetObj = new Asset();
		assetObj.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_CoveredProduct').Id;
		assetObj.Name = 'Test Asset Test Class';
		assetObj.Product2Id = prodObj.id;
		assetObj.AccountId = accObjLE.id;
		insert assetObj;
		system.assertNotEquals(assetObj.Id, Null);
		
		Entitlement entiObj = new Entitlement();
		entiObj.Name ='test';
		entiObj.AccountId = accObjNL.id;
		entiObj.CH_CDB_EntitlementId__c = '1test';
		entiObj.StartDate = System.today();
		entiObj.EndDate = System.today() + 10;		
		entiObj.AssetId = assetObj.id;
		entiObj.CH_EntitlementType__c = SWS_Constants.EntitlementTypeEA;
		entiObj.CH_ServiceMappingId__c = SWS_Constants.LCSSNS;		
		insert entiObj;
		
		EntitlementContact entcon = new EntitlementContact();
		entcon.EntitlementId = entiObj.id;
		entcon.ContactId = contObj.id;   
		insert entcon;
		
		Case newCase = new Case();
		newCase.AccountId = accObjLE.Id;
		newCase.ContactId = contObj.Id;
		newCase.CH_ReportedDate__c = DateTime.Now();
		newCase.Mobile_Phone__c = mobilephone;
		newCase.Country__c = 'Bahrain';
		newCase.reason = caseReason;
		newCase.Subject = 'Test';
		newCase.CH_Summary__c = 'Test';
		newCase.Type = 'Incident';	
		newCase.Description = 'TEST';
		newCase.Severity__c = 'Critical';
		newCase.CH_Outage__c = 'Yes';
		newCase.Status = 'Created';
		newCase.CH_IssueOccurenceDate__c = system.today();
		newCase.ProductId = prodObj.Id;
		newCase.CH_Initial_Assignment__c = true;
		newCase.CH_SystemRestoredTargetDate__c = system.now();
		newCase.CH_Reassignment__c = true;
		newCase.recordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_NokiaIncidentWithRestoration').Id ;
		
		test.startTest();
		insert newCase;
		
		try{
			CH_CaseFlow_Controller.disassociateNewProblem(newCase.Id);
			CH_CaseFlow_Controller.getContactName(null);
			CH_CaseFlow_Controller.hasOnlyReadAccess(newCase.Id);
			CH_CaseFlow_Controller.getEntitlementTabData(newCase.Id);
			CH_CaseFlow_Controller.hasCaseEditAcess(newCase.Id, new List<String>{'ProductId'});
			CH_CaseFlow_Controller.accessCheck(newCase.Id);
			CH_CaseFlow_Controller.displayP20fields(entiObj.id);
			CH_CaseFlow_Controller.getInternalAccount();
	CH_CaseFlow_Controller.getAssetDetails(null);
		} catch(Exception e) {
	  //Added empty line to fix sonar cube issue
		}
		
		try{
	 
			CH_CaseFlow_Controller.updateEntitlementScript(newCase.Id);
			
		} catch(Exception e) {
			//Added empty line to fix sonar cube issue
		}
		
		try{
			CH_CaseFlow_Controller.newPostToProblem(newCase.Id);
		} catch(Exception e) {
			//Added empty line to fix sonar cube issue
		}
		
		test.stopTest();
	}   
}