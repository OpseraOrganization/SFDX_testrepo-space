@isTest
public class CH_UTIL_TEST {
	
	private static final string PORTAL_PROFILE = 'Customers';
	private static final string CH_PROFILE = 'CH_Agent';
	public static final string GWC_QUEUE = 'GWC';
	public static final string TEST_QUEUE_LABEL = 'MN_GWC_R_All-Products';
	public static final string TEST_QUEUE_NAME = 'MN_GWC_R_All_Products';
	private static final string TEST_EMAIL = 'test@test.com';
	private static integer NokiaId = 100;   
	private static boolean ISCASE = false; 
	private static boolean ISPROBLEM = true; 
	public static final string WORKGROUPNAME = 'TEST';
	public static final string WORKGROUP_RULENAME = 'TEST';
	public static final string ACCOUNT_NAME = 'LEGAL-ACCOUNT';
	public static final string PRODUCT_NAME = 'TestProduct';
	public static User runAsUser = new User(Id = UserInfo.getUserId());
	// Fix SOQL problems
	private static Product2 tempProduct;
	private static PriceBookEntry tempPriceBookEntry;
	public static Account tempLegalAccount;
	public static Account tempParentAccount;
	public static final string assistantname1='Portal Contact';
	public static final string srvcMappngId ='Legacy Customer Support Service - Critical 24x7';
	public static final string datausage='test CARES';
	public static final string testemail = 'test2@test.com';
	public static final string lglenty='Legal Entity';
	
	// Setup all data so that a portal case can be created
	static public void setupCase(boolean hasEntitlementScript){
		System.debug('CH_CA:Limit: ' + Limits.getQueries());
		// Create custom settings for validating accounts 
		createCustomSettings();
		System.debug('CH_CA: createCustomSettings limit: ' + Limits.getQueries());
		// Create users
		createNokiaUsers();
		System.debug('CH_CA: createNokiaUsers limit: ' + Limits.getQueries());
		// Create accounts
		createAccounts();	
		System.debug('CH_CA: createAccounts limit: ' + Limits.getQueries());
		// Create contacts
		createContacts();
		System.debug('CH_CA: createContacts limit: ' + Limits.getQueries());
		// Create portal user
		CreatePortalUsers();		 
		System.debug('CH_CA: CreatePortalUsers limit: ' + Limits.getQueries());
		// Create products
		createProducts();
		System.debug('CH_CA: createProducts limit: ' + Limits.getQueries());
		// Create contracts
		createContracts(hasEntitlementScript);
		System.debug('CH_CA: hasEntitlementScript limit: ' + Limits.getQueries());
		// Creating workgroups
		createWorkgroups();
		System.debug('CH_CA: createWorkgroups limit: ' + Limits.getQueries());
		
		System.debug('CH_CA: LIM CH_UTIL_TEST.setupCase SOQL limit: ' + Limits.getQueries());
	}
	
	// Create a case based on the setup data
	public static Case createCaseNotSaved(string subject, string severity, string outage, string recordType, boolean isPortalCase){
		
		String userAlias = '';
		String assistantName = '';
		if (isPortalCase){
			userAlias = 'TSTP1';
			assistantName = assistantname1;
		}
		else {
			userAlias = 'TSTNP1';
			assistantName = 'Normal Contact';
		}
		User user = [SELECT Id FROM User WHERE Alias = :userAlias LIMIT 1];
		Contact contact = [SELECT Id, AssistantName FROM Contact WHERE AssistantName = :assistantName LIMIT 1];
		Account legalAccount = [SELECT Id FROM Account WHERE Name = 'LEGAL-ACCOUNT' LIMIT 1];
		Product2 product = [SELECT Id FROM Product2 WHERE Name = 'TestProduct' LIMIT 1];
		Entitlement entitlement = [SELECT Id FROM Entitlement WHERE CH_EntitlementType__c = 'Entitled Asset' LIMIT 1];
		Asset asset = [SELECT Id FROM Asset WHERE CH_CDB_ExternalAssetId__c = '12334' LIMIT 1];
		
		id recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId();
		DateTime now = DateTime.Now();
		
		// Create a case
		Case newCase = new Case(
			AccountId = legalAccount.Id,
			AssetId = asset.Id,
			CH_IssueOccurenceDate__c = now,
			CH_ReportedDate__c = now,
			CH_MilestoneSLA_Start__c = now,
			Mobile_Phone__c = '123-456789',
			Country__c = 'Sweden', //added to fix the test class w.r.t  - 15584
			reason = 'New problem',
			ContactId = contact.Id,
			Subject = subject,
			CH_Summary__c = subject,
			Type = 'Incident',
			Description = 'TEST',
			Severity__c = severity,
			CreatedById = user.Id,
			CH_Outage__c = outage,
			OwnerId = user.Id, 
			Status = 'Created',
			ProductId = product.id,
			EntitlementId = entitlement.Id,
			CH_SecurityGroup__c = '',
			CH_GWC_SecurityGroup__c = 'SEC_GWC|ALL',
			recordTypeId = recordTypeId);
		return newCase; 
	}
	
	public static Case createS2SCase(String originSystem, String externalAcc){
		Id standardCaseRecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		Case testCase = new Case();
		
		testCase.RecordTypeId = standardCaseRecordTypeId;
		testCase.CH_CaseOriginSystem__c = originSystem;
		testCase.CH_ExternalSystemAccount__c = externalAcc;
		testCase.Origin = 'S2S';
		testCase.CH_Outage__c = 'No';
		testCase.CH_Email2__c = 'test@email.com';
		testCase.SEC_Last_Name__c = 'testlastname';
		testCase.CH_Stage__c = 'Register';
		testCase.Type = 'Incident';
		testCase.Subject = 'test';
		testCase.Severity__c = 'Minor';
		testCase.CH_ServiceType__c = 'Customer Support';
		testCase.Status = 'Created';
		testCase.Description = 'test';
		testCase.CH_NetworkElementID__c = 'Net Element:DE-98134737';
		
		testCase.Country__c = 'Germany';
		
		return testCase;	
	}
	
	// Create the custom settings that are needed to validate if the customer is authorized 
	static public void createCustomSettings(){	  
		CH_AccountName__c  setting = new CH_AccountName__c  ();
		setting.CH_InvalidName__c = 'Nokia';
		//setting.CH_ValidName__c = 'test';
		setting.CH_ValidName__c = 'Nokia OYJ';
		upsert setting;
		//if ([SELECT Id FROM CH_AccountName__c WHERE CH_InvalidName__c = 'Nokia'].size() == 0){
		//  insert setting;
		//}
		
		CH_Settings__c settingForROTASchedule = new CH_Settings__c ();
		settingForROTASchedule.Name = 'Switch Between ROTA and Schedule';
		//settingForROTASchedule.Description__c = 'This setting determines whether we need to get workgroup members from ROTA or Schedule.';
		//settingForROTASchedule.SettingValue__c = 'CH_CA_WorkgroupMemberROTA';
		settingForROTASchedule.Description__c = 'This setting determines whether we need to get workgroup members from ROTA or Schedule.';
		settingForROTASchedule.SettingValue__c = 'CH_CA_WorkgroupMemberSchedule';
		upsert settingForROTASchedule;
		//if ([SELECT Id FROM CH_Settings__c WHERE Name = 'Switch Between ROTA and Schedule'].size() == 0){
		//  insert settingForROTASchedule;
		//}
		
		
	}
	
	// Create the asset
	static private Asset createAssets(Account legalAccount, Product2 product){
		Id assetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_CoveredProduct').getRecordTypeId();
		// Create asset
		Asset asset = new Asset(
			AccountId = legalAccount.Id,
			Name = 'TestAsset',
			Product2Id = product.Id,
			CH_CDB_ExternalAssetId__c = '12334',
			CH_NetworkElementID__c = '43321',
			recordTypeId = assetRecordTypeId
		);
		System.runAs(runAsUser){
			Insert asset;
		}
		return asset;
	}
	
	static public Asset createS2SAsset(String externalId, Id accId){
		
		Id standardAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_CoveredProduct').getRecordTypeId();
		Asset asset = new Asset();
		asset.CH_CDB_ExternalAssetId__c = externalId;
		asset.AccountId = accId;
		asset.RecordTypeId=standardAssetRecordTypeId;
		return asset;
	}
	
	// Create a contract
	static public void createContracts(boolean hasEntitlementScript){
		
		Date now = Date.today();
		// Create the assset
		Asset asset = createAssets(tempLegalAccount, tempProduct);
		System.debug('CH_CA: Asset limit: ' + Limits.getQueries());
		// Create contract. trigger will create the authorized account
		//Id chContractRecordTypeId = Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
		Id chContractRecordTypeId = Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_VendorContract').getRecordTypeId();
		ServiceContract serviceContract = new ServiceContract(
			RecordTypeId = chContractRecordTypeId,
			AccountId = tempLegalAccount.Id, 
			Name = 'TestServiceContract',
			CurrencyIsoCode = 'EUR',
			CH_CDB_ContractId__c = '12345',
			StartDate = now.AddDays(-5),
			EndDate = now.AddDays(5),
			OwnerId = [SELECT Id FROM User WHERE Alias = 'TSTNP3' LIMIT 1].Id,
			CH_EntitlementScript__c = (hasEntitlementScript)?'Header Script':'',
			Pricebook2Id = Test.getStandardPricebookId()
		);
		Insert serviceContract;
		serviceContract.RecordTypeId = chContractRecordTypeId;
		update serviceContract;
		System.debug('CH_CA: serviceContract limit: ' + Limits.getQueries());
		// Create Contract Line Item 
		ContractLineItem contractLineItem = new ContractLineItem(
			ServiceContractId = serviceContract.Id,
			AssetId = asset.Id,
			UnitPrice = 0,
			StartDate = now.AddDays(-5),
			EndDate = now.AddDays(5),
			Quantity = 1,
			PricebookEntryId = tempPriceBookEntry.Id, 
			CH_LineItemEntitlementScript__c = (hasEntitlementScript)?'Script':'',
			CH_CDB_EntitlementId__c = 'TEST',
			CH_ServiceOffering__c = 'Test Offering',
			CH_ServiceType__c = 'Customer Support', 
			CH_ServiceMappingId__c = srvcMappngId
		);
		Insert contractLineItem;
		System.debug('CH_CA: contractLineItem limit: ' + Limits.getQueries());
		// Create entitlement
		SlaProcess slaProcess = [SELECT Id FROM SlaProcess WHERE Name =: srvcMappngId LIMIT 1];
		Entitlement entitlement = new Entitlement(
			AccountId = tempLegalAccount.Id,
			AssetId = asset.Id,
			Startdate = Date.Today().addDays(-1), // To get an Active entitlement
			CH_CDB_EntitlementId__c = '12345',
			ContractLineItemId = contractLineItem.Id,
			ServiceContractId = serviceContract.Id,
			CH_EntitlementType__c = 'Entitled Asset',
			Name = 'Entitled Asset',
			SlaProcessId = slaProcess.id,
			CH_ServiceMappingId__c = srvcMappngId
		);
		Insert entitlement;
		System.debug('CH_CA: Entitlement limit: ' + Limits.getQueries());
		// authorized entitlement
		Entitlement authorizedEntitlement = new Entitlement(
			AccountId = tempLegalAccount.Id,
			Name = 'Authorized Contact Entitlement',
			//AssetId = asset.Id,
			Startdate = Date.Today().addDays(-1), // To get an Active entitlement
			CH_CDB_EntitlementId__c = '12345',
			ContractLineItemId = contractLineItem.Id,
			ServiceContractId = serviceContract.Id,
			CH_EntitlementType__c = 'Authorized Contact',
			CH_ServiceMappingId__c = srvcMappngId
		);
		Insert authorizedEntitlement;
		System.debug('CH_CA: authorizedEntitlement limit: ' + Limits.getQueries());
		serviceContract.CH_Entitlement__c = authorizedEntitlement.Id;
		update serviceContract; 
		
		contractLineItem.CH_Entitlement__c = entitlement.Id;
		update contractLineItem; 
		
		CH_CustomerSpecificTargetSLA__c customSla = new CH_CustomerSpecificTargetSLA__c(
			CH_Account__c = tempLegalAccount.Id,
			CH_ServiceContract__c = serviceContract.id,
			CH_LineItemNumber__c = contractLineItem.id,
			CH_ServiceMappingId__c = srvcMappngId,
			CH_Severity__c = 'Minor',
			CH_Outage__c = 'No',
			CH_Entitlement__c = entitlement.id,
			CH_IR_Duration__c = 5
		);
		insert customSla;	
		System.debug('CH_CA: CH_CustomerSpecificTargetSLA__c limit: ' + Limits.getQueries());
		List<Contact> contacts = [SELECT Id FROM Contact 
								  WHERE AssistantName = 'Normal Contact' OR AssistantName =: assistantname1];	 
		list<EntitlementContact> entitlementContactlist = new list<EntitlementContact>();
		list<AccountContactRelation> accountContactRelationList = new list<AccountContactRelation>();
		
		// Creat an authorized contact
		for (Contact contact : contacts){
			EntitlementContact entitlementContact = new EntitlementContact();
			entitlementContact.ContactId = contact.Id;
			entitlementContact.EntitlementId = authorizedEntitlement.id;
			entitlementContactlist.add(entitlementContact);
			
			AccountContactRelation accountContactRelation = new AccountContactRelation();
			accountContactRelation.AccountId = tempLegalAccount.Id;
			accountContactRelation.ContactId = contact.id;
			accountContactRelation.NCP_Entitlement_Relationship__c = false;
			accountContactRelation.Roles = 'Other';
			accountContactRelationList.add(accountContactRelation);
		}
		System.runAs(runAsUser){
			if(!entitlementContactlist.isEmpty()) insert entitlementContactlist;
			if(!accountContactRelationList.isEmpty()) insert accountContactRelationList;	
		}
		System.debug('CH_CA: entitlementContactlist limit: ' + Limits.getQueries());
		// Create the authroized account
		CH_AuthorizedAccount__c authorizedAccount = new CH_AuthorizedAccount__c();
		authorizedAccount.CH_Account__c = tempLegalAccount.id;
		authorizedAccount.CH_ServiceContract__c = serviceContract.Id;
		insert authorizedAccount;		
	}
	
	// Create workgroups, workgroup members, product groups, account groups, rules
	static public void createWorkgroups(){
		User chUser;
		User chUser2;
		for (User tempUser : [SELECT Id, Alias FROM User WHERE Alias in ('TSTNP1','TSTNP2')]){
			if (tempUser.Alias == 'TSTNP1'){
				chUser = tempUser;
			}
			if (tempUser.Alias == 'TSTNP2'){
				chUser2 = tempUser;
			}	 
		}
		
		// Create the queues needed for workgroups
		createQueues(); 
		
		CH_CustomerGrouping__c customerGroup =new CH_CustomerGrouping__c();
		customerGroup.Name = 'Test CustomerGroup';
		customerGroup.OwnerId = runAsUser.Id;
		Insert customerGroup;
		
		CH_CustomerGroup_Account__c customerGroupAccounts =new CH_CustomerGroup_Account__c();
		customerGroupAccounts.CH_Account__c=tempLegalAccount.Id;
		customerGroupAccounts.CH_Customer_Grouping__c=customerGroup.Id;
		insert customerGroupAccounts;
		
		CH_ProductGrouping__c productGroup = new CH_ProductGrouping__c();   
		productGroup.OwnerId = runAsUser.Id;
		productGroup.Name = 'Test ProductGroup';
		Insert productGroup;
		
		CH_ProductGroup_Product__c productGroupProduct = new CH_ProductGroup_Product__c();
		productGroupProduct.CH_Product__c= tempProduct.Id;
		productGroupProduct.CH_Product_Grouping__c =productGroup.Id;
		Insert productGroupProduct;
		
		// Create workgroup
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		Id workgroupRecordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByDeveloperName().get('CH_CA_Workgroup').getRecordTypeId();
		CH_Workgroup__c workgroup = new CH_Workgroup__c();
		workgroup.name = WORKGROUPNAME;
		workgroup.RecordTypeId = workgroupRecordTypeId;
		workgroup.CH_Workgroup_Instructions__c = 'This is a workgroup instruction';
		workgroup.CH_Type__c = 'Engineer;Smart Tier 1';
		insert workgroup;
		
		id CH_CA_Workgroup = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByDeveloperName().get('CH_CA_WorkgroupMember').getRecordTypeId();
		List<CH_Workgroup_Member__c> newWorkgroupMembers = new List<CH_Workgroup_Member__c>();
		// Create queue workgroup member
		CH_Workgroup_Member__c member = new CH_Workgroup_Member__c ();
		
		member.Name = TEST_QUEUE_LABEL;
		member.CH_User__c = chUser.id;
		member.CH_Role__c = 'Queue';
		member.CH_Workgroup_Member_Type__c = 'Queue';
		member.CH_Workgroup__c = workgroup.Id;
		member.RecordTypeId = CH_CA_Workgroup;
		newWorkgroupMembers.add(member);
		// Create an engineer with ROTA
		CH_Workgroup_Member__c member1 = new CH_Workgroup_Member__c ();
		member1.CH_User__c = chUser.id;
		member1.CH_Role__c = 'Engineer'; 
		member1.CH_Workgroup__c = workgroup.Id;
		member1.CH_Workgroup_Member_Type__c = 'User';
		member1.RecordTypeId = CH_CA_Workgroup;
		newWorkgroupMembers.add(member1);
		// Create an engineer without ROTA
		CH_Workgroup_Member__c member2 = new CH_Workgroup_Member__c ();
		member2.CH_User__c = chUser2.id;
		member2.CH_Role__c = 'Engineer'; 
		member2.CH_Workgroup__c = workgroup.Id;
		member2.CH_Workgroup_Member_Type__c = 'User';
		member2.RecordTypeId = CH_CA_Workgroup;
		newWorkgroupMembers.add(member2);
		// Create a hotline
		CH_Workgroup_Member__c member3 = new CH_Workgroup_Member__c ();
		member3.CH_Hotline_Name__c = 'HotlineName';
		member3.CH_HotlinePhone__c = '134646832648348973';
		member3.CH_Role__c = 'Hotline'; 
		member3.CH_Workgroup__c = workgroup.Id;
		member3.CH_Workgroup_Member_Type__c = 'Hotline';
		member3.RecordTypeId = CH_CA_Workgroup;
		newWorkgroupMembers.add(member3);
		// Create a incident manager 
		CH_Workgroup_Member__c member4 = new CH_Workgroup_Member__c ();
		member4.CH_User__c  = chUser2.Id;
		member4.CH_Role__c = 'Incident Manager';
		member4.CH_Workgroup__c = workgroup.Id;
		member4.CH_Workgroup_Member_Type__c = 'User';
		member4.RecordTypeId = CH_CA_Workgroup;
		newWorkgroupMembers.add(member4);
		// Create a case manager 
		CH_Workgroup_Member__c member5 = new CH_Workgroup_Member__c ();
		member5.CH_User__c  = chUser.id;
		member5.CH_Role__c = 'Case Manager';
		member5.CH_Workgroup__c = workgroup.Id;
		member5.CH_Workgroup_Member_Type__c = 'User';
		member5.RecordTypeId = CH_CA_Workgroup;
		newWorkgroupMembers.add(member5);
		// Create a manager 2
		CH_Workgroup_Member__c member6 = new CH_Workgroup_Member__c ();
		member6.CH_User__c  = chUser.id;
		member6.CH_Role__c = 'Manager 1';
		member6.CH_Workgroup__c = workgroup.Id;
		member6.CH_Workgroup_Member_Type__c = 'User';
		member6.RecordTypeId = CH_CA_Workgroup;
		newWorkgroupMembers.add(member6);
		
		insert newWorkgroupMembers;
		
		id rtId = Schema.SObjectType.CH_Workgroup_Rule__c.getRecordTypeInfosByDeveloperName().get('CH_CA_WorkgroupRule').getRecordTypeId();
		List<CH_Workgroup_Rule__c> newWorkgroupRules = new List<CH_Workgroup_Rule__c>();
		// Create an active rule
		CH_Workgroup_Rule__c rule = new CH_Workgroup_Rule__c ();
		rule.name = 'ACTIVE';
		rule.CH_Workgroup__c = workgroup.Id;
		rule.CH_Severity__c = 'Major';
		rule.CH_Outage__c = 'Yes';
		rule.CH_OrderNumber__c = 10;
		rule.RecordTypeId = rtId;
		newWorkgroupRules.add(rule);
		// Catch passive rule
		rule = new CH_Workgroup_Rule__c ();
		rule.name = 'PASSIVE';
		rule.CH_Workgroup__c = workgroup.Id;
		rule.CH_Severity__c = 'Minor';
		rule.CH_Outage__c = 'No';
		rule.CH_OrderNumber__c = 100; 
		rule.RecordTypeId = rtId;
		newWorkgroupRules.add(rule);
		// Catch all rule
		rule = new CH_Workgroup_Rule__c ();
		rule.name = 'CATCH ALL';
		rule.CH_Workgroup__c = workgroup.Id;
		rule.CH_Outage__c = 'Any';
		rule.CH_OrderNumber__c = 9;
		rule.RecordTypeId = rtId;
		newWorkgroupRules.add(rule);
		insert newWorkgroupRules;
		
		CH_Workgroup_Event__c workgroupMemberRota  =new CH_Workgroup_Event__c();
		workgroupMemberRota.CH_Workgroup__c = workgroup.Id;
		
		workgroupMemberRota.CH_WorkgroupMember__c = member1.Id;
		workgroupMemberRota.CH_StartDate__c= DateTime.now().addDays(-1);	
		workgroupMemberRota.CH_EndDate__c= DateTime.now().addDays(2);
		workgroupMemberRota.CH_SupportType__c='On Call Primary';
		workgroupMemberRota.CH_Timezone__c='GMT';
		workgroupMemberRota.CH_Days__c='Sunday';
		workgroupMemberRota.CH_EndOccurence__c = DateTime.now().addDays(50);
		workgroupMemberRota.CH_Recoccurence__c=true;
		insert workgroupMemberRota; 
	}   
	
	// Create a "GWC Queue"
	static public void createQueues(){
		System.runAs(runAsUser) {
			try {
				Group gwcQueue = new Group(Type='Queue', Name = GWC_QUEUE, Email = TEST_EMAIL, DeveloperName = GWC_QUEUE);
				insert gwcQueue;
				QueueSObject queue = new QueueSObject(SobjectType='Case', QueueId=gwcQueue.Id);
				insert queue;
			}
			catch (Exception e){
				// An error occured because the queue already exists
			}
		}	
	}
	
	// Create products and the pricebook entries related to the product
	static public void createProducts(){
		CH_Import_UTIL_TEST.CreateCustomPriceBook();
		
		tempProduct = new Product2(
			Name = PRODUCT_NAME,
			NokiaCPQ_State__c = 'Implement',
			NCP_CAREACTIVATE__c = 'test',
			PMD_Portfolio_Classification__c = 'Product'
		);
		
		System.runAs(runAsUser) {	 
			Insert tempProduct;
			
			tempPriceBookEntry = new PriceBookEntry(
				Pricebook2Id = Test.getStandardPricebookId(),
				Product2Id = tempProduct.id,
				UnitPrice = 0,
				CurrencyIsoCode = 'EUR',
				IsActive = true
			);
			Insert tempPriceBookEntry;
		}
	}
	
	static public List<Product2> createS2SProducts(String solutionName, String solutionNokiaProductId, String productName, String productNokiaProductId, String variantName, String variantNokiaProductId){
		List<Product2> productList = new List<Product2>();
		Product2 solutionTest = new Product2();
		solutionTest.Name = solutionName;
		solutionTest.PMD_Portfolio_Classification__c = 'Solution';
		solutionTest.DataUsage__c = datausage;
		solutionTest.NCP_Nokia_Product_Id__c = solutionNokiaProductId;
		Product2 productTest = new Product2();
		productTest.Name = productName;
		productTest.PMD_Portfolio_Classification__c = 'Product';
		productTest.DataUsage__c = datausage;
		productTest.NCP_Nokia_Product_Id__c = productNokiaProductId;
		Product2 variantTest = new Product2();
		variantTest.Name = variantName;
		variantTest.PMD_Additional_Classification__c = 'Product Variant';
		variantTest.DataUsage__c = datausage;
		variantTest.NCP_Nokia_Product_Id__c = variantNokiaProductId;
		productList.add(solutionTest);
		productList.add(productTest);
		productList.add(variantTest);
		
		return productList;
	}
	
	static public CH_ProductRelease__c createS2SRelease(String releaseName, String code, Id prodId){
		CH_ProductRelease__c releaseTest = new CH_ProductRelease__c();
		releaseTest.Name = releaseName;
		releaseTest.CH_NSNLegacyCode__c = code;
		releaseTest.CH_ProductId__c = prodId;
		
		return releaseTest;
	}
	
	// Create new users
	static private void createPortalUsers(){		
		// Create the portal user
		Contact portalContact = [SELECT Id FROM Contact WHERE AssistantName =: assistantname1];
		Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE :PORTAL_PROFILE+'%' LIMIT 1];
		
		User newUser = new User(
			LastName = 'PORTAL2',
			FirstName='PORTAL2',
			Alias = 'TSTP1',
			Email = System.now().millisecond() + testemail,
			Username = math.random() + 'P1@test.com',
			ProfileId = portalProfile.id,
			//UserRoleId = userRole.id,
			TimeZoneSidKey = 'GMT',
			LanguageLocaleKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LocaleSidKey = 'en_US',
			ContactId = portalContact.id,
			IsActive = true,
			Nokia_ID__c = 'CHTEST' + String.valueOf(NokiaId++)
		);
		insert newUser; 
	}
	
	// Create new users
	public static void createNokiaUsers(){
		User chUser;
		System.runAs(runAsUser) {
			List<User> newUsers = new List<User>();
			Profile profile = [Select Id from Profile where name = 'System Administrator' LIMIT 1];
			
			// Create account owner
			UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
			User portalAccountOwner = new User(
				Lastname='ACCOUNTOWNER',
				Firstname='ACCOUNTOWNER',
				Alias = 'AC-OWNER',
				UserRoleId = portalRole.Id,
				ProfileId = profile.Id,
				Username = System.now().millisecond() + 'AC-OWNER@test.com',
				Email= System.now().millisecond() + testemail,
				EmailEncodingKey='UTF-8',
				LanguageLocaleKey='en_US',
				LocaleSidKey='en_US',
				TimeZoneSidKey='America/Chicago',
				Nokia_ID__c = 'CHTEST' + String.valueOf(NokiaId++)
			);
			newUsers.add(portalAccountOwner);
			
			chUser = new User(
				Lastname='NONPORTAL1',
				Firstname='NONPORTAL1',
				Alias = 'TSTNP1',
				ProfileId = profile.Id,
				Username = System.now().millisecond() + 'TSTNP1@test.com',
				Email= System.now().millisecond() + testemail,
				EmailEncodingKey='UTF-8',
				LanguageLocaleKey='en_US',
				LocaleSidKey='en_US',
				TimeZoneSidKey='America/Chicago',
				Nokia_ID__c = 'CHTEST' + String.valueOf(NokiaId++)
			);
			newUsers.add(chUser);
			
			profile = [SELECT Id FROM Profile WHERE Name = :CH_PROFILE LIMIT 1];
			User newUser = new User(
				LastName = 'NONPORTAL2',
				FirstName='NONPORTAL2',
				Alias = 'TSTNP2',
				Email = System.now().millisecond() + testemail,
				Username = System.now().millisecond() + 'TSTNP2@test.com',
				ProfileId = profile.id,
				TimeZoneSidKey = 'GMT',
				LanguageLocaleKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				LocaleSidKey = 'en_US',
				IsActive = true,
				Nokia_ID__c = 'CHTEST' + String.valueOf(NokiaId++)
			);
			newUsers.add(newUser);
			
			newUser = new User(
				LastName = 'NONPORTAL3',
				FirstName='NONPORTAL3',
				Alias = 'TSTNP3',
				Email = System.now().millisecond() + testemail,
				Username = System.now().millisecond() + 'TSTNP3@test.com',
				ProfileId = profile.id,
				TimeZoneSidKey = 'GMT',
				LanguageLocaleKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				LocaleSidKey = 'en_US',
				IsActive = true,
				Nokia_ID__c = 'CHTEST' + String.valueOf(NokiaId++)
			);
			newUsers.add(newUser);
			
			newUser = new User(
				LastName = 'NONPORTAL4',
				FirstName='NONPORTAL4',
				Alias = 'TSTNP4',
				Email = System.now().millisecond() + testemail,
				Username = System.now().millisecond() + 'TSTNP4@test.com',
				ProfileId = profile.id,
				TimeZoneSidKey = 'GMT',
				LanguageLocaleKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				LocaleSidKey = 'en_US',
				IsActive = true,
				Nokia_ID__c = 'CHTEST' + String.valueOf(NokiaId++)
			);  
			newUsers.add(newUser);   
			
			// Create the iPaaS user if it does not exist
			List<User> iPaaSUsers = [SELECT Id FROM User WHERE Alias = 'iPAAS'];
			if (iPaaSUsers.size() == 0){
				newUser = new User(
					LastName = 'iPAAS',
					FirstName='iPAAS',
					Alias = 'iPAAS',
					Email = System.now().millisecond() + testemail,
					Username = System.now().millisecond() + 'iPAAS@test.com',
					ProfileId = profile.id,
					TimeZoneSidKey = 'GMT',
					LanguageLocaleKey = 'en_US',
					EmailEncodingKey = 'UTF-8',
					LocaleSidKey = 'en_US',
					IsActive = true,
					Nokia_ID__c = 'CHTEST' + String.valueOf(NokiaId++)
				);
				newUsers.add(newUser);
			}
			
			insert newUsers;
			
			PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CARE_DVT_Admin'];
			Id assigneeId = [SELECT Id FROM User WHERE Alias = 'TSTNP3' LIMIT 1].Id;
			List<PermissionSetAssignment> pst=[Select id from PermissionSetAssignment where AssigneeId=:assigneeId and PermissionSetId= :ps.Id];
			if(pst.size()<1)
			{
		insert new PermissionSetAssignment(AssigneeId = assigneeId, PermissionSetId = ps.Id);
			}
			
			// Sec group
			Group secgroup = [SELECT Id FROM Group WHERE Name = 'SEC_GWC|ALL' LIMIT 1];
			List<GroupMember> groupMembersList = new List<GroupMember>();
			for (User tempUser : newUsers){
				GroupMember secGroupMember = new GroupMember();
				secGroupMember.GroupId = secgroup.id;
				secGroupMember.UserOrGroupId = tempUser.Id;
				groupMembersList.add(secGroupMember); 
			}
			if(!groupMembersList.isEmpty())
			{
				insert groupMembersList;	///////////Bulkified as part of US# 27621
			}
		}
		
	}
	
	static public void createAccounts(){
		List<Account> newAccounts = new List<Account>();
		User portalAccountOwner = [SELECT Id FROM User WHERE Alias = 'AC-OWNER' LIMIT 1];
		
		// Create parent account
		Id accountCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		tempParentAccount = new Account(
			Name = 'PARENT-ACOOUNT',
			OwnerId = portalAccountOwner.Id,
			RecordTypeId = accountCustomerRecordType
		);
		newAccounts.add(tempParentAccount);	 
		
		// Create legal entity
		Id accountLegalEntityRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		tempLegalAccount = new Account(
			Type = 'Vendor',
			Name = ACCOUNT_NAME,
			OwnerId = portalAccountOwner.Id,
			Country__c = 'Sweden',
			RecordTypeId = accountLegalEntityRecordType
		);
		newAccounts.add(tempLegalAccount);	
		
		System.runAs(runAsUser) {	 
			Insert newAccounts;
			
			if (newAccounts[1].Name == ACCOUNT_NAME){
				newAccounts[1].ParentId = newAccounts[0].id;
				Update newAccounts[1];	  
			}
		}
		
	}
	
	static public Account createS2SAccounts(String customerName, String legalName, String accNo){
		String legalAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		String customerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		
		Account accCustomer = new Account();
		accCustomer.Name = customerName;
		accCustomer.RecordTypeId = customerAccRecordTypeId;
		insert accCustomer;
		
		Account acc = new Account();
		acc.ParentId = accCustomer.Id;
		acc.RecordTypeId = legalAccRecordTypeId;
		acc.AccountNumber = accNo;
		acc.CountryCode__c = '234';
		acc.Name = legalName;
		acc.BillingCity = 'test';
		acc.BillingCountry = 'Germany';
		acc.BillingStreet = 'test';
		acc.Acc_No__c = accNo;
		
		return acc;
	}
	
	static public void createContacts(){
		List<Contact> newContacts = new List<Contact>();
		string email = System.now().millisecond() + 'test@test.com';
		
		// Create the contact that is needed for portal users
		Contact normalContact = new Contact(
			FirstName = 'McTesty',
			Lastname = String.valueOf(System.now().millisecond()),
			Email = email,
			AssistantName = 'Normal Contact',
			AccountId = tempParentAccount.Id
		);
		newContacts.add(normalContact);
		
		// Create the contact that is needed for portal users
		Contact portalContact = new Contact(
			FirstName = assistantname1,
			Lastname = String.valueOf(System.now().millisecond()),
			Email = System.now().millisecond() + testemail,
			AssistantName = assistantname1,
			AccountId = tempParentAccount.Id
		);
		newContacts.add(portalContact);
		
		System.runAs(runAsUser) {	 
			Insert newContacts;
		}
	}  
	
	static public CH_Case_PA_InterfaceMapping__c createInterfaceMapping(String origin, String accIn, String accOut, String solOut, String prodOut, String varOut, String relOut){
		CH_Case_PA_InterfaceMapping__c im = new CH_Case_PA_InterfaceMapping__c();
		im.CaseOriginSystem__c = origin;
		im.AccountIn__c = accIn;
		im.AccountOut__c = accOut;
		im.SolutionOut__c = solOut;
		im.ProductOut__c = prodOut;
		im.VariantOut__c = varOut;
		im.ProductReleaseOut__c = relOut;
		return im;
	}
	
	//setting association records
	static public void createWorkgroupSchedules(){
		CH_workgroup__c workgroup = [SELECT Id, CH_Type__c, Name  
									 FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];
		
		//Creating Workgroup Schedule
		DateTime now = DateTime.now();
		CH_Workgroup_Schedule__c wgSchedule = new CH_Workgroup_Schedule__c();
		wgSchedule.Name = 'Schedule_test';
		wgSchedule.CH_Start_DateTime__c = now.addDays(-10);
		wgSchedule.CH_End_DateTime__c = now.addDays(10);
		wgSchedule.CH_Workgroup__c  = workgroup.Id;
		wgSchedule.CH_Time_Zone__c = 'UTC';
		insert wgSchedule; 
		
		// Create a schedule filter
		CH_Workgroup_Filter__c schedulefilter = new CH_Workgroup_Filter__c();
		schedulefilter.CH_Country__c = 'Sweden';
		schedulefilter.CH_Outage__c = 'No';
		schedulefilter.CH_Region__c = '';
		schedulefilter.CH_Severity__c = 'Minor';
		schedulefilter.CH_Workgroup_Schedule__c = wgSchedule.Id;
		schedulefilter.CH_Workgroup_Type__c = workgroup.CH_Type__c;
		insert schedulefilter;
		
		//Creating schedule timeslot
		CH_Workgroup_Schedule_Timeslot__c timeSlot = new CH_Workgroup_Schedule_Timeslot__c();
		timeSlot.CH_Day__c='Monday;Tuesday;Wednesday;Thursday;Friday;Saturday;Sunday';
		timeSlot.CH_Start_Time__c = now.addHours(-3).Time();
		timeSlot.CH_End_Time__c = (now.addHours(3).Time() < now.addHours(-3).Time())?Time.newInstance(0, 0, 0, 0):now.addHours(3).Time();
		timeSlot.CH_Workgroup_Id__c = workgroup.Id;
		timeSlot.CH_Workgroup_Schedule__c = wgSchedule.Id;
		insert timeSlot;
		
		// Timeslot association 
		CH_Workgroup_Member__c member = [SELECT Id FROM CH_Workgroup_Member__c Where CH_Role__c = 'Engineer' LIMIT 1];
		CH_Workgroup_Member_Timeslot_Association__c timeslotAssociationEngineer =  new CH_Workgroup_Member_Timeslot_Association__c();
		timeslotAssociationEngineer.CH_Schedule_Type__c = 'Primary';
		timeslotAssociationEngineer.CH_Workgroup_Member__c = member.Id;
		timeslotAssociationEngineer.CH_Workgroup_Schedule_Timeslot__c = timeSlot.Id;
		insert timeslotAssociationEngineer;
		
		// Activate the schedule
		wgSchedule.CH_Active__c = true;
		update wgSchedule;
	}
	
	static public void createWGSTimeslotAlone(Id workgroupId, Id workgroupScheduleId){
		//Create workgroup Schedule timeslot
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot1 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot1.CH_Workgroup_Id__c = workgroupId;
		workGroupScheduleTimeslot1.CH_Workgroup_Schedule__c = workgroupScheduleId;
		workGroupScheduleTimeslot1.CH_Day__c='Monday';
		workGroupScheduleTimeslot1.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot1.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		Insert workGroupScheduleTimeslot1;
	}
	
	static public void createWGSTimeslotTwoOverlapping(Id workgroupId, Id workgroupScheduleId){
		//Create workgroup Schedule timeslot
		List<CH_Workgroup_Schedule_Timeslot__c> workGroupScheduleTimeslotList = new List<CH_Workgroup_Schedule_Timeslot__c>();
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot1 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot1.CH_Workgroup_Id__c = workgroupId;
		workGroupScheduleTimeslot1.CH_Workgroup_Schedule__c = workgroupScheduleId;
		workGroupScheduleTimeslot1.CH_Day__c='Monday';
		workGroupScheduleTimeslot1.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot1.CH_End_Time__c=Time.newInstance(11, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot1);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot2 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot2.CH_Workgroup_Id__c = workgroupId;
		workGroupScheduleTimeslot2.CH_Workgroup_Schedule__c = workgroupScheduleId;
		workGroupScheduleTimeslot2.CH_Day__c='Monday';
		workGroupScheduleTimeslot2.CH_Start_Time__c=Time.newInstance(11, 0, 0, 0);
		workGroupScheduleTimeslot2.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot2);
		Insert workGroupScheduleTimeslotList;
	}
	
	public static User getUser(String userEmail, String userName, String userAlias, Profile userProfile) {
		User testUser = new User(Alias = userAlias, 
								 Email = userEmail, 
								 ProfileId = userProfile.Id, 
								 UserName = userName, 
								 EmailEncodingKey = 'UTF-8', 
								 LastName = 'Test User', 
								 LanguageLocaleKey = 'en_US', 
								 LocaleSidKey = 'en_US', 
								 TimeZoneSidKey = 'America/Los_Angeles');
		return testUser;
	}
	
	public static CollaborationGroup createInterfaceKeyGroup(String groupName, String externalSystem) {
		CollaborationGroup interfaceKeyUserGroup = new CollaborationGroup(Name = groupName, CollaborationType = 'Public');
		insert interfaceKeyUserGroup;
		CH_InterfaceKeyGroup__c interfaceKeyUserGroupSettings = new CH_InterfaceKeyGroup__c(Name = externalSystem, ExternalSystem__c = externalSystem, CollaborationGroupName__c = interfaceKeyUserGroup.Name);
		insert interfaceKeyUserGroupSettings;
		
		return interfaceKeyUserGroup;
	}
	
	public static CH_Problem_RnD_Reference__c getRndInteraction(String status, String errorMessage, String rndType, String subject, String direction, String rndInterface, String referenceId, Id relatedRecordId) {
		CH_Problem_RnD_Reference__c rndInteraction = new CH_Problem_RnD_Reference__c(CH_RnD_Status__c = status,
																					 CH_RnD_Error_Message__c = errorMessage,
																					 CH_RnD_Type__c = rndType,
																					 CH_RnD_Direction__c = direction,
																					 CH_RnD_Subject__c = subject,
																					 CH_RnD_Interface__c = rndInterface,
																					 CH_RnD_Reference__c = referenceId,
																					 CH_Related_Record__c = relatedRecordId);
		return rndInteraction;
	}
	
	public static void setupCase() {
		createCustomSettings();
		
		CH_Case_PA_InterfaceMapping__c testInterfaceMapping = createInterfaceMapping('orange-irma', '12345', '12346', '12348', '12350', '12352', '12354');
		insert testInterfaceMapping;
		
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		CH_Workgroup__c testWorkGroup = new CH_Workgroup__c(CH_End_of_Business_Hours_Threshold__c = 60,
															CH_Level_Of_Support__c = 'Initial Support',
															CH_Start_of_Business_Hours_Threshold__c = 60,
															CH_Type__c = 'Engineer',
															Name = 'TestWorkgroup');
		insert testWorkGroup;
		
		CH_Workgroup_Rule__c testWorkGroupRule = new CH_Workgroup_Rule__c(Name = 'TestRule',
																		  CH_Workgroup__c = testWorkGroup.Id,
																		  CH_Severity__c = 'Minor',
																		  CH_Outage__c = 'No',
																		  CH_OrderNumber__c = 1);
		insert testWorkGroupRule;
		
		Account testAccount = createS2SAccounts('testCustomer', 'testAcc', '12346');
		insert testAccount;
		
		List<Product2> testProducts = createS2SProducts('testSolution', '12348', 'testProduct', '12350', 'testVariant', '12352');
		testProducts[1].NokiaCPQ_Alias__c = 'testProduct CPQ Alias';
		testProducts[2].NokiaCPQ_Alias__c = 'testVariant CPQ Alias';
		insert testProducts;
		
		CH_ProductRelease__c testProductRelease = createS2SRelease('testRelease', '12354', testProducts[1].Id);
		insert testProductRelease;
		
		Asset testAsset = createS2SAsset('12346|234|12348|12350|12352|12354', testAccount.Id);
		testAsset.CH_NetworkElementID__c = 'test';
		insert testAsset;
		
		CH_EntitlementTestData.createS2SEntitlement('testEnt', testAsset.Id, testAccount.Id, testProducts[1].Id, '56478', 'Legacy Customer Support Service - Critical Major Minor 24x7', false);
		
		Contact testContact = new Contact(
			LastName = 'test',
			FirstName = 'test',
			Email = 'test@email.com',
			AccountId = testAccount.ParentId,
			CH_ContactType__c = 'Customer'
		);
		insert testContact;   
	}
	
	public static Case getProblem() {
		Contact testContact = [SELECT Id FROM Contact WHERE Email = 'test@email.com'];
		Account testAccount = [SELECT Id FROM Account WHERE Name = 'testAcc' LIMIT 1];
		Product2 testProduct = [SELECT Id FROM Product2 LIMIT 1];
		Entitlement testEntitlement = [SELECT Id FROM Entitlement LIMIT 1];
		Asset testAsset = [SELECT Id FROM Asset LIMIT 1];
		Id problemRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		DateTime testDateTime = DateTime.Now();
		
		Case testCase = new Case(
			AccountId = testAccount.Id,
			AssetId = testAsset.Id,
			CH_IssueOccurenceDate__c = testDateTime,
			CH_ReportedDate__c = testDateTime,
			CH_MilestoneSLA_Start__c = testDateTime,
			Mobile_Phone__c = '123-456789',
			Country__c = 'Sweden',
			Reason = 'New problem',
			ContactId = testContact.Id,
			Subject = 'test subject',
			CH_Summary__c = 'test summary',
			Type = 'Incident',
			Description = 'test description',
			Severity__c = 'Minor',
			CH_Outage__c = 'No',
			Status = 'New',
			ProductId = testProduct.id,
			EntitlementId = testEntitlement.Id,
			CH_SecurityGroup__c = '',
			CH_GWC_SecurityGroup__c = 'SEC_GWC|ALL',
			RecordTypeId = problemRecordTypeId);
		
		return testCase;
	}
	
	public static Case getS2SCase() {
		Case testCase = CH_UTIL_TEST.createS2SCase('orange-irma', '12345');
		CH_ExternalInterfaceUTIL.populateCaseHandlingCases(new List<Case> {testCase}, new Map<Id, Account>(), new Map<Id, Product2>(), new Map<Id, CH_ProductRelease__c>(), new Map<Id, Asset>(), new Map<Id, Entitlement>());
		Contact testContact = [SELECT Id FROM Contact WHERE Email = 'test@email.com'];
		testCase.ContactId = testContact.Id;
		testCase.CH_CustomerDescription__c = '<p>test customer description</p>';
		testCase.Reference_Number__c = 'test ref1';
		
		return testCase;		
	}
	static public void createLegalAccount(){
		List<Account> newAccounts = new List<Account>();
		// Create parent account
		Id accountCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		tempParentAccount = new Account(
			Name = 'PARENT-CustomerACOOUNT',
			RecordTypeId = accountCustomerRecordType
		);
		newAccounts.add(tempParentAccount);	 
		
		// Create legal entity
		Id accountLegalEntityRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		tempLegalAccount = new Account(
			Type = 'Vendor', 
			Name = ACCOUNT_NAME,
			Country__c = 'Sweden',
			RecordTypeId = accountLegalEntityRecordType
		);
		newAccounts.add(tempLegalAccount);	
		
		System.runAs(runAsUser) {	 
			Insert newAccounts;
			
			if (newAccounts[1].Name == ACCOUNT_NAME){
				newAccounts[1].ParentId = newAccounts[0].id;
				Update newAccounts[1];	  
			}
		}
	} 
}