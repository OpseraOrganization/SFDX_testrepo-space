@isTest

public class CH_TestDataFactory {
	private static final string PORTAL_PROFILE = 'Customers';
	private static final string PORTAL_ROLE = 'QA Compliance US ALTICE Customer Customer User';
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
	private static Product2 tempProduct;
	private static PriceBookEntry tempPriceBookEntry;
	public static Account tempLegalAccount;
	public static Account tempParentAccount;
	public static final string assistantName1 = 'Portal Contact';
	public static final string servcMapping='Legacy Customer Support Service - Critical Major Minor 24x7';
	public static final string testemal = 'test2@test.com';
	public static final string nokiadomainemail='@nokia.com';
	
	// Setup all data so that a portal case can be created
	static public void setupCase(boolean hasEntitlementScript){
		CH_ManageCreateQueueAsynchQueue.doChainJob= false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		// Create custom settings for validating accounts 
		createCustomSettings();
		// Create users
		createNokiaUsers(); 
		// Create accounts
		createAccounts();
		// Create contacts
		createContacts();
		// Create portal user
		CreatePortalUsers();
		// Create products
		createProducts();
		// Create contracts
		createContracts(hasEntitlementScript);
		// Create workgroups
		createWorkgroups();
		
		System.debug('CH_CA: CH_TestDataFactory.setupCase SOQL limit: ' + Limits.getQueries());
	}
	
	// Create a case based on the setup data
	public static Case createCaseNotSaved(string subject, string severity, string outage, string recordType, boolean isPortalCase){
		String userAlias = '';
		String assistantName = '';
		if (isPortalCase){
			userAlias = 'P1';
			assistantName = assistantName1;
		} else {
			userAlias = 'NP1';
			assistantName = 'Normal Contact';
		}
		User user = [SELECT Id FROM User WHERE Alias = :userAlias LIMIT 1];
		Contact contact = [SELECT Id FROM Contact WHERE AssistantName = :assistantName LIMIT 1];
		Account legalAccount = [SELECT Id FROM Account WHERE Name = 'LEGAL-ACCOUNT' LIMIT 1];
		Product2 product = [SELECT Id FROM Product2 WHERE Name = 'TestProduct' LIMIT 1];
		Entitlement entitlement = [SELECT Id FROM Entitlement WHERE Name = 'TestEntitlement' LIMIT 1];
		

		
		Asset asset = [SELECT Id FROM Asset LIMIT 1];
		Id rid = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId();
		// string rid = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('Problem').getRecordTypeId();
		// Create a case
		Case newCase = new Case(
			AccountId = legalAccount.Id,
			AssetId = asset.Id,
			CH_ReportedDate__c = DateTime.Now(),
			Mobile_Phone__c = '123-456789',
			Country__c = 'Bahrain',
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
			CH_IssueOccurenceDate__c = system.today(),
			ProductId = product.id,
			EntitlementId = entitlement.Id,
			CH_Initial_Assignment__c = true,
			CH_SystemRestoredTargetDate__c = system.now(),
			CH_Reassignment__c = true,
			NCP_Service_Contract__c=[SELECT Id FROM ServiceContract LIMIT 1].Id,
			BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id,
			recordTypeId = rid);
		
		return newCase;
	}
	
	// Create the custom settings that are needed to validate if the customer is authorized
	static public void createCustomSettings(){
		CH_AccountName__c  setting = new CH_AccountName__c();
		setting.CH_InvalidName__c = 'Nokia';
		setting.CH_ValidName__c = 'test';
		insert setting;
		
	}
	
	// Create the asset 
	static private Asset createAssets(Account portalAccount, Product2 product){
		
		// Create asset
		Id assetRecordTypeId =Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_CoveredProduct').getRecordTypeId();
		Asset asset = new Asset(AccountId = portalAccount.Id, Name = 'TestAsset', Product2Id = product.Id, recordTypeId = assetRecordTypeId);
		System.runAs(runAsUser) {
			Insert asset; 
		}
		System.debug('asset name n Id = '+ asset.Name +' '+asset.Id);
		return asset;
	}
	
	// Create a contract
	static public void createContracts(boolean hasEntitlementScript){
		// Create the assset
		Asset asset = createAssets(tempLegalAccount, tempProduct);
		// Create contract
		ServiceContract serviceContract = new ServiceContract(
			AccountId = tempLegalAccount.Id,
			Name = 'TestServiceContract',
			CH_CDB_ContractId__c = 'Test',
			//OwnerId = [SELECT Id FROM User WHERE Alias = 'NP3' LIMIT 1].Id,
			CH_EntitlementScript__c = (hasEntitlementScript)?'Header Script':'',
			Pricebook2Id = Test.getStandardPricebookId()
		);
		Insert serviceContract;
		
		// Create Contract Line Item 
		ContractLineItem contractLineItem = new ContractLineItem(
			ServiceContractId = serviceContract.Id,
			AssetId = asset.Id,
			UnitPrice = 0,
			Quantity = 1,
			PricebookEntryId = tempPriceBookEntry.Id, 
			CH_LineItemEntitlementScript__c = (hasEntitlementScript)?'Script':'',
			CH_CDB_EntitlementId__c = 'TEST',
			// CH_ServiceClassification__c='teste',
			CH_ServiceMappingId__c = servcMapping
		);
		Insert contractLineItem;
		
		// Create entitlement
		Entitlement entitlement = new Entitlement(
			AccountId = tempLegalAccount.Id,
			AssetId = asset.Id,
			Startdate = Date.Today().addDays(-1), // To get an Active entitlement
			CH_CDB_EntitlementId__c = '12345',
			ContractLineItemId = contractLineItem.Id,
			ServiceContractId = serviceContract.Id,
			CH_EntitlementType__c = 'Entitled Asset',
			Name = 'TestEntitlement',
			CH_ServiceMappingId__c = servcMapping
		);
		Insert entitlement;
		
		// authorized entitlement
		Entitlement authorizedEntitlement = new Entitlement(
			AccountId = tempLegalAccount.Id,
			AssetId = asset.Id,
			Startdate = Date.Today().addDays(-1), // To get an Active entitlement
			CH_CDB_EntitlementId__c = '12345',
			ContractLineItemId = contractLineItem.Id,
			ServiceContractId = serviceContract.Id,
			CH_EntitlementType__c = 'Authorized Contact',
			Name = 'Authorized Contact Entitlement',
			CH_ServiceMappingId__c = servcMapping
		);
		Insert authorizedEntitlement;
		
		serviceContract.CH_Entitlement__c = authorizedEntitlement.Id;
		update serviceContract;
		
		contractLineItem.CH_Entitlement__c = entitlement.Id;
		update contractLineItem;
		
		List<Contact> contacts = [SELECT Id FROM Contact WHERE AssistantName = 'Normal Contact' OR AssistantName =: assistantName1];
		list<EntitlementContact> entitlementContactlist = new list<EntitlementContact>();
		list<AccountContactRelation> accountContactRelationList = new list<AccountContactRelation>();
		
		// Creat an authorized contact
		for (Contact contact : contacts){
			EntitlementContact entitlementContact = new EntitlementContact();
			entitlementContact.ContactId = contact.Id;
			entitlementContact.EntitlementId = entitlement.id;
			entitlementContactlist.add(entitlementContact);
			
			System.runAs(runAsUser) {
	AccountContactRelation accountContactRelation = new AccountContactRelation();
	accountContactRelation.AccountId = tempLegalAccount.Id;
	accountContactRelation.ContactId = contact.id;
	accountContactRelation.NCP_Entitlement_Relationship__c = true;
	accountContactRelationList.add(accountContactRelation);
	
			}
		}
		System.runAs(runAsUser){
			if(!entitlementContactlist.isEmpty()) insert entitlementContactlist;
			if(!accountContactRelationList.isEmpty()) insert accountContactRelationList;
		}
		
		System.debug('tempLegalAccount = '+ tempLegalAccount);
		// Create the authroized account
		CH_AuthorizedAccount__c authorizedAccount = new CH_AuthorizedAccount__c();
		authorizedAccount.CH_Account__c = tempLegalAccount.id;
		authorizedAccount.CH_ServiceContract__c = serviceContract.Id;
		insert authorizedAccount;
	}
	
	// Create workgroups, workgroup members, product groups, account groups, rules
	static public void createWorkgroups(){
		CH_ManageCreateQueueAsynchQueue.doChainJob= false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		User chUser;
		User chUser2;
		List<User> users = [SELECT Id, Alias FROM User WHERE Alias in ('TSTNP1','TSTNP2')];
		for (User tempUser : users){
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
		
		Insert customerGroup;
		
		CH_CustomerGroup_Account__c customerGroupAccounts =new CH_CustomerGroup_Account__c();
		customerGroupAccounts.CH_Account__c=tempLegalAccount.Id;
		customerGroupAccounts.CH_Customer_Grouping__c=customerGroup.Id;
		insert customerGroupAccounts;
		
		CH_ProductGrouping__c productGroup = new CH_ProductGrouping__c();
		
		productGroup.Name = 'Test ProductGroup';
		Insert productGroup;
		
		CH_ProductGroup_Product__c productGroupProduct = new CH_ProductGroup_Product__c();
		productGroupProduct.CH_Product__c= tempProduct.Id;
		productGroupProduct.CH_Product_Grouping__c =productGroup.Id;
		Insert productGroupProduct;
		
		// Create workgroup
		CH_ManageCreateQueueAsynchQueue.doChainJob= false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		List<CH_Workgroup__c> workGroups = new List<CH_Workgroup__c>();
		CH_Workgroup__c workgroup = new CH_Workgroup__c();
		workgroup.name = WORKGROUPNAME;
		workgroup.CH_End_of_Business_Hours_Threshold__c = 120;
		workgroup.CH_Start_of_Business_Hours_Threshold__c = 120;
		workGroups.add(workgroup);
		CH_Workgroup__c workgroup2 = new CH_Workgroup__c();
		workgroup2.name = WORKGROUPNAME + '2';
		workgroup2.CH_End_of_Business_Hours_Threshold__c = 120;
		workgroup2.CH_Start_of_Business_Hours_Threshold__c = 120;
		workGroups.add(workgroup2);
		insert workGroups;
		
		List<CH_Workgroup_Member__c> newWorkgroupMembers = new List<CH_Workgroup_Member__c>();
		// Create queue workgroup member
		CH_Workgroup_Member__c member = new CH_Workgroup_Member__c ();
		member.CH_Queue__c = TEST_QUEUE_LABEL;
		member.CH_Role__c = 'Queue';
		member.CH_Workgroup__c = workgroup.Id;
		newWorkgroupMembers.add(member);
		// Create an engineer
		CH_Workgroup_Member__c member1 = new CH_Workgroup_Member__c ();
		member1.CH_User__c = chUser.id;
		member1.CH_Role__c = 'Engineer';
		member1.CH_Workgroup__c = workgroup.Id;
		newWorkgroupMembers.add(member1);
		// Create a incident manager 
		member = new CH_Workgroup_Member__c ();
		member.CH_User__c  = chUser2.Id;
		member.CH_Role__c = 'Incident Manager';
		member.CH_Workgroup__c = workgroup.Id;
		newWorkgroupMembers.add(member);
		// Create a case manager 
		member = new CH_Workgroup_Member__c ();
		member.CH_User__c  = chUser.id;
		member.CH_Role__c = 'Case Manager';
		member.CH_Workgroup__c = workgroup.Id;
		newWorkgroupMembers.add(member);
		// Create a manager 2
		member = new CH_Workgroup_Member__c ();
		member.CH_User__c  = chUser.id;
		member.CH_Role__c = 'Manager 1';
		member.CH_Workgroup__c = workgroup.Id;
		newWorkgroupMembers.add(member);
		insert newWorkgroupMembers;
		
		List<CH_Workgroup_Rule__c> newWorkgroupRules = new List<CH_Workgroup_Rule__c>();
		// Create an active rule
		CH_Workgroup_Rule__c rule = new CH_Workgroup_Rule__c ();
		rule.name = 'ACTIVE';
		rule.CH_Workgroup__c = workgroup.Id;
		rule.CH_Severity__c = 'Major';
		rule.CH_Outage__c = 'Yes';
		rule.CH_OrderNumber__c = 10;
		newWorkgroupRules.add(rule);
		// Catch passive rule
		rule = new CH_Workgroup_Rule__c ();
		rule.name = 'PASSIVE';
		rule.CH_Workgroup__c = workgroup.Id;
		rule.CH_Severity__c = 'Minor';
		rule.CH_Outage__c = 'No';
		rule.CH_OrderNumber__c = 100;
		newWorkgroupRules.add(rule);
		// Catch all rule
		rule = new CH_Workgroup_Rule__c ();
		rule.name = 'CATCH ALL';
		rule.CH_Workgroup__c = workgroup.Id;
		rule.CH_Outage__c = 'Yes';
		rule.CH_OrderNumber__c = 100;
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
		
		List<CH_Workgroup_Schedule__c> newWorkgroupSchedules = new List<CH_Workgroup_Schedule__c>();
		// Create a schedule for WG1
		CH_Workgroup_Schedule__c schedule = new CH_Workgroup_Schedule__c();
		schedule.Name = 'test';
		schedule.CH_Start_DateTime__c = DateTime.now();
		schedule.CH_End_DateTime__c = DateTime.now().addDays(1);
		schedule.CH_Time_Zone__c = 'UTC +1';
		schedule.CH_Workgroup__c = workgroup.Id;
		newWorkgroupSchedules.add(schedule);
		CH_Workgroup_Schedule__c schedule1 = new CH_Workgroup_Schedule__c();
		schedule1.Name = 'test2';
		schedule1.CH_Start_DateTime__c = DateTime.now();
		schedule1.CH_End_DateTime__c = DateTime.now().addDays(1);
		schedule1.CH_Time_Zone__c = 'UTC +12';
		schedule1.CH_Start_Time__c = Time.newInstance(12, 0, 0, 0);
		schedule1.CH_End_Time__c  = Time.newInstance(12, 15, 0, 0);
		schedule1.CH_Start_Date__c = Date.newInstance(2020, 12, 1);
		schedule1.CH_End_Date__c  = Date.newInstance(2024, 1, 1);
		schedule1.CH_Workgroup__c = workgroup.Id;
		newWorkgroupSchedules.add(schedule1);
		// Create a schedule for WG2
		schedule = new CH_Workgroup_Schedule__c();
		schedule.Name = 'test3';
		schedule.CH_Start_DateTime__c = DateTime.now();
		schedule.CH_End_DateTime__c = DateTime.now().addDays(1);
		schedule.CH_Time_Zone__c = 'UTC +1';
		schedule.CH_Workgroup__c = workgroup2.Id;
		newWorkgroupSchedules.add(schedule);
		insert newWorkgroupSchedules;
		
		// Create a workgroup schedule filter
		CH_Workgroup_Filter__c scheduleFilter = new CH_Workgroup_Filter__c();
		scheduleFilter.Name = 'test';
		scheduleFilter.CH_Severity__c = 'Critical';
		scheduleFilter.CH_Workgroup_Schedule__c = schedule1.Id;
		insert scheduleFilter;
		
		// Create a workgroup schedule filter customer
		CH_Workgroup_Filter_Customer_Association__c scheduleFilterCustomer = new CH_Workgroup_Filter_Customer_Association__c();
		scheduleFilterCustomer.CH_Workgroup_Filter__c = scheduleFilter.id;
		scheduleFilterCustomer.CH_Account__c = null;
		insert scheduleFilterCustomer;
		
		// Create a workgroup schedule filter product
		CH_Workgroup_Filter_Product_Association__c scheduleFilterProduct = new CH_Workgroup_Filter_Product_Association__c();
		scheduleFilterProduct.CH_Workgroup_Filter__c = scheduleFilter.id;
		scheduleFilterProduct.CH_Product__c = null;
		insert scheduleFilterProduct;
		
		List<CH_Workgroup_Schedule_Timeslot__c> newScheduleTimeslots = new List<CH_Workgroup_Schedule_Timeslot__c>();		
		// Create a workgroup schedule timeslots
		CH_Workgroup_Schedule_Timeslot__c scheduleTimeSlot = new CH_Workgroup_Schedule_Timeslot__c();
		scheduleTimeSlot.CH_Day__c = 'Monday';
		scheduleTimeSlot.CH_Start_Time__c = Time.newInstance(12, 0, 0, 0);
		scheduleTimeSlot.CH_End_Time__c  = Time.newInstance(12, 15, 0, 0);
		scheduleTimeSlot.CH_Workgroup_Schedule__c = schedule1.Id;
		newScheduleTimeslots.add(scheduleTimeSlot);
		scheduleTimeSlot = new CH_Workgroup_Schedule_Timeslot__c();
		scheduleTimeSlot.CH_Day__c = 'Tuesday';
		scheduleTimeSlot.CH_Start_Time__c = Time.newInstance(12, 0, 0, 0);
		scheduleTimeSlot.CH_End_Time__c  = Time.newInstance(12, 15, 0, 0);
		scheduleTimeSlot.CH_Workgroup_Schedule__c = schedule1.Id;
		newScheduleTimeslots.add(scheduleTimeSlot);
		insert newScheduleTimeslots;
	}	
	
	// Create a "GWC Queue" and a "Test Queue"
	static public void createQueues(){
		System.runAs(runAsUser) {
			boolean existGWCQueue = false;
			boolean existTestQueue = false;
			List<Group> queues = [SELECT Id, developername FROM Group WHERE Type='Queue' AND DeveloperName in (:GWC_QUEUE, :TEST_QUEUE_NAME)];
			for (Group queue : queues){
	if (queue.developername == GWC_QUEUE){
		existGWCQueue = true;
	}
	if (queue.developername == TEST_QUEUE_NAME){
		existTestQueue = true;
	}
			} 
			// Create GWC queue
			If (!existGWCQueue){
	Group gwcQueue = new Group(Type='Queue', Name = GWC_QUEUE, Email = TEST_EMAIL, DeveloperName = GWC_QUEUE);
	insert gwcQueue;
	QueueSObject queue = new QueueSObject(SobjectType='Case', QueueId=gwcQueue.Id);
	insert queue;
			}
			// Create Test queue
			If (!existTestQueue){
	Group groupQueue = new Group(Type='Queue', Name= TEST_QUEUE_LABEL, Email = TEST_EMAIL, DeveloperName = TEST_QUEUE_NAME);
	insert groupQueue;
	QueueSObject queue = new QueueSObject(SobjectType='Case', QueueId=groupQueue.Id);
	insert queue;
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
	// CurrencyIsoCode = 'EUR',
	IsActive = true
			);
			Insert tempPriceBookEntry;
		}
	}
	
	// Create new users
	static private void createPortalUsers(){
		// Create the portal user
		Contact portalContact = [SELECT Id FROM Contact WHERE AssistantName =: assistantName1];
		Profile portalProfile = [SELECT Id FROM Profile WHERE Name = :PORTAL_PROFILE LIMIT 1];
		
		User newUser = new User(
			LastName = 'PORTAL1',
			FirstName='PORTAL1',
			Alias = 'P1',
			Email = System.now().millisecond() + testemal,
			Username = System.now().millisecond() + 'P1@test.com',
			ProfileId = portalProfile.id,
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
			//  UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
			User portalAccountOwner = new User(
	Lastname='ACCOUNTOWNER',
	Firstname='ACCOUNTOWNER',
	Alias = 'AC-OWNER',
	ProfileId = profile.Id,
	Username = System.now().millisecond() + 'AC-OWNER@test.com',
	Email= System.now().millisecond() + testemal,
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
	Username = System.now().millisecond() + 'NP1@test.com',
	Email= System.now().millisecond() + testemal,
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
	Email = System.now().millisecond() + testemal,
	Username = System.now().millisecond() + 'NP2@test.com',
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
	Alias = 'NP3',
	Email = System.now().millisecond() + testemal,
	Username = System.now().millisecond() + 'NP3@test.com',
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
	Alias = 'NP4',
	Email = System.now().millisecond() + testemal,
	Username = System.now().millisecond() + 'NP4@test.com',
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
		Email = System.now().millisecond() + testemal,
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
		}
	}
	static public void createAccounts(){
		List<Account> newAccounts = new List<Account>();
		User portalAccountOwner = [SELECT Id FROM User WHERE Alias = 'AC-OWNER' LIMIT 1];
		// Create parent account
		Id accountCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		tempParentAccount = new Account(
			Name = 'PARENT-ACOOUNT',
			//OwnerId = portalAccountOwner.Id,
			RecordTypeId = accountCustomerRecordType
		);
		newAccounts.add(tempParentAccount);
		
		// Create legal entity
		Id accountLegalEntityRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		tempLegalAccount = new Account(
			Name = ACCOUNT_NAME,
			//OwnerId = portalAccountOwner.Id,
			RecordTypeId = accountLegalEntityRecordType
			//Country__c = 'Bahrain'
			//Country__c = 'France'
		);
		newAccounts.add(tempLegalAccount);
		
		System.runAs(runAsUser) {
			Insert newAccounts;
			if (newAccounts[1].Name == ACCOUNT_NAME){
	newAccounts[1].ParentId = newAccounts[0].id;
	Update newAccounts[1];
			}
			// Add a account team member
			AccountTeamMember member = new AccountTeamMember();
			member.AccountId  = tempLegalAccount.Id;
			member.UserId  = runAsUser.Id;
			member.TeamMemberRole  = 'Customer Care Manager';
			insert member;
		}
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
			FirstName = assistantName1,
			Lastname = String.valueOf(System.now().millisecond()),
			Email = System.now().millisecond() + testemal,
			AssistantName = assistantName1,
			AccountId = tempParentAccount.Id
		);
		newContacts.add(portalContact);
		System.runAs(runAsUser) {
			Insert newContacts;
		}
	}
	
	// create only workgroups
	public static List<CH_Workgroup__c> create_CH_Workgroups(Integer size, String developerName){
		CH_ManageCreateQueueAsynchQueue.doChainJob= false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		Id recordTypeId;
		List<RecordType> recordtypeIdsList = [SELECT id FROM RecordType where DeveloperName =: developerName limit 1];
		if(!recordtypeIdsList.isEmpty()){
			recordTypeId = recordtypeIdsList[0].Id;
		} else {
			return null;
		}
		List<CH_Workgroup__c> workGroupList = new List<CH_Workgroup__c>();
		for (integer i = 0; i < size; i++) {
			// construct a workgroup
			CH_Workgroup__c newWorkGroup = new CH_Workgroup__c();
			newWorkGroup.name = WORKGROUPNAME + ' ' + (i+1);
			newWorkGroup.RecordTypeId = recordTypeId;
			newWorkGroup.CH_Description__c = '<p>test ' + (i+1) + '</p>';
			// add a workgroup to the list
			workGroupList.add(newWorkGroup);
		}
		return workGroupList;
	}
	
	
	// create only workgroup members
	public static List<CH_Workgroup_Member__c> create_CH_WorkgroupMembers(Integer size, List<CH_Workgroup__c> wgList, String role){
		CH_ManageCreateQueueAsynchQueue.doChainJob= false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		List<CH_Workgroup_Member__c> wgMemberList = new List<CH_Workgroup_Member__c>();
		List<RecordType> recordTypeList = [SELECT Id FROM RecordType WHERE developername='CH_KB_Workgroup_Members' limit 1];
		if ( recordTypeList.isEmpty() ) {
			return null;
		}
		
		String lastname = null;
		List<User> insertUserList = new List<User>();
		for (CH_Workgroup__c wg : wgList) {
			for (Integer i = 0 ; i < size; i++) {
	if (i == 0) {
		lastname = 'Test_user' + i;
		user adUser = createUser('System Administrator', lastname);
		insertUserList.add(adUser);
	}else if (i > 0) {
		user stdUser = userCreation(1, 'Nokia Sales Profile')[0];
		insertUserList.add(stdUser);
	}
			}
		}
		insert insertUserList;
		List<User> adminUser = [select id , name, lastname from user where lastname =:lastname and profile.name ='System Administrator' ];
		List<User> standardUser =  [select id , name, lastname from user where  profile.name ='Nokia Sales Profile'];
		for (CH_Workgroup__c wg : wgList) {
			for (Integer i = 0 ; i < size; i++) {
	CH_Workgroup_Member__c wgMember = new CH_Workgroup_Member__c();
	wgMember.CH_Workgroup__c = wg.id;
	wgMember.CH_Role__c = role;
	
	wgMember.RecordTypeId = recordTypeList[0].id;
	if (i == 0) {
		wgMember.CH_User__c = adminUser[0].Id;
		wgMember.CH_Owner__c = true;
		
	} else if (i > 0) {
		wgMember.CH_User__c = standardUser[0].Id;
	}
	wgMemberList.add(wgMember);
			}
		}
		return wgMemberList;
	}
	
	//create users by profile
	// return a list of users
	public static List<User> userCreation(Integer size, String profileName) {
		List<User> userList = new List<User>();
		Id sp = [SELECT Id FROM profile WHERE name =: profileName limit 1].id;
		for (integer i = 0; i < size; i++){
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName = dateString + randomInt;
			User user = new User(alias = 'abc', email = uniqueName + nokiadomainemail , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sp,  Country__c= 'Canada', Market__c='MARKET NORTH AMERICA', NSA_Compliant__c=False,
		 timezonesidkey = 'America/Los_Angeles',  Username = uniqueName + nokiadomainemail + orgId + '.org', Nokia_ID__c = randomInt + '0');
			userList.add(user);
		}
		return userList;
	}
	
	// create user by profilename and lastname
	// return a user
	public static User createUser(String profileName, String lastName) {
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		String uniqueName = dateString + randomInt;
		String orgId = UserInfo.getOrganizationId();
		Profile p;
		User u;
		if('Admin'.equalsIgnoreCase(profileName)){
			p =[SELECT Id, Name FROM Profile Where UserType = 'Standard' AND PermissionsCustomizeApplication = true AND PermissionsModifyAllData = true AND PermissionsApiUserOnly= false Limit 1];
		}else{
			p = [SELECT Id FROM Profile WHERE Name = :profileName];
		}
		
		u = new User();
		u.alias = 'abc';
		u.email = uniqueName + nokiadomainemail;
		u.emailencodingkey = 'UTF-8';
		u.firstName = 'test';
		u.lastname = lastName;
		u.languagelocalekey = 'en_US';
		u.localesidkey = 'en_US';
		u.profileid = p.Id;
		u.Country__c = 'Canada';
		u.Market__c ='MARKET NORTH AMERICA';
		u.NSA_Compliant__c = False;
		u.timezonesidkey = 'America/Los_Angeles';
		u.Username = uniqueName + nokiadomainemail + orgId + '.org';
		u.Nokia_ID__c = randomInt + '0';
		return u;
	}
	
	public static List<Knowledge__kav> createKnowledgeRecord(List<CH_Workgroup__c> workgroupList, string RecordTypeId, string status){
		List<Knowledge__kav> KnowledgeList = new List<Knowledge__kav>();
		for(integer i =0;i<workgroupList.size() ;i++){
			Knowledge__kav oknowledge =new Knowledge__kav();
			oknowledge.Title=workgroupList[i].Name;
			oKnowledge.CH_InApproval__c = false;
			oknowledge.summary=workgroupList[i].Name;
			oknowledge.urlname=workgroupList[i].Name+workgroupList[i].id; 
			oKnowledge.RecordTypeId = RecordTypeId;
			oKnowledge.CH_Workgroup__c = workgroupList[0].id;
			oKnowledge.CH_ProcedureRequired__c =workgroupList[i].Name;
			oKnowledge.CH_PurposeRequired__c =workgroupList[i].Name;
			oknowledge.CH_ProblemDescriptionRequired__c= workgroupList[i].Name;
			oknowledge.ValidationStatus =status;
			oKnowledge.CH_Minor_changes__c = false;
			oknowledge.CH_ComingFromApprovalProcess__c = true;
			oKnowledge.CH_Candidate_for_External__c = true;
			KnowledgeList.add(oknowledge);
		}
		return KnowledgeList; 
	} 
}