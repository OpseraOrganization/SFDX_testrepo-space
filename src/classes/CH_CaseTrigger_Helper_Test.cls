@isTest
Public Class CH_CaseTrigger_Helper_Test{ 
	public static final String assetName = '12346|234|testSolution|testProduct|testVariant|testRelease';
	public static final String americaLA = 'America/Los_Angeles';
	public static final String queueUsrName ='CH Queue DO NOT USE';
	public static final String mobilePhoneNo ='123-456789';
	public static final String caseReason = 'New problem';
	public static final String caseSubjct = 'Survey Closed Case';
	public static final String entitlementException= 'Account Not Listed';
	public static final String caseSubjct1 = 'Test call';
	public static final String CaseDesc ='test description';
	public static user uu = new User();

	@testSetUp
	public static void setupData() {	
		Boolean hasEntitlementScript = true;
		Account accCustomerParentAccount = new Account();
		Id accountRecordType1 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accCustomerParentAccount.Name = 'Customer Parent Account';
		accCustomerParentAccount.RecordTypeId = accountRecordType1;
		accCustomerParentAccount.Customer_Compliance__c = 'US_Company';
		insert accCustomerParentAccount; 
		
		//Creation of Account
		Account acc = new Account();
		Id accountCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		acc.Name = 'Legal Acc';
		acc.RecordTypeId = accountCustomerRecordType;
		acc.ParentId = accCustomerParentAccount.id;
		acc.Active__c = true;
		acc.CountryCode__c = 'WF';
		insert acc; 	
		
		Account acc1 = new Account();
		
		acc1.Name = 'Legal Acc1';
		acc1.RecordTypeId = accountCustomerRecordType;
		acc1.ParentId = accCustomerParentAccount.id;
		acc1.Active__c = true;
		insert acc1;
		
		Account accCustomer = new Account();
		Id accountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accCustomer.Name = 'Customer Account';
		accCustomer.RecordTypeId = accountRecordType;
		
		insert accCustomer; 
		
		// Creation of Contact
		Contact con = new Contact();
		con.FirstName = 'TestFirstName';
		con.Lastname = 'YesNokia';
		con.Email = 'Test@test.com';
		con.AssistantName ='TestAssistanceName';
		con.Email1__c = 'TestCaseEmail@test.com';
		con.CH_Email3__c = 'TestCaseEmail3@test.com';
		con.AccountId = accCustomer.Id;
		con.CH_contactType__c = SWS_Constants.CONTTypeNokiaEmp;
		insert con;
		
		Contact con1 = new Contact();
		con1.FirstName = 'TestFirstName1';
		con1.Lastname = 'NoNokia';
		con1.Email = 'Test121@test.com';
		con1.AssistantName ='TestAssistanceName';
		con1.Email1__c = 'TestCaseEmail@test.com';
		con1.CH_Email3__c = 'TestCaseEmail3@test.com';
		con1.AccountId = accCustomer.Id;
		insert con1;
		
		
		List<Product2> productList = CH_UTIL_TEST.createS2SProducts('testSolution', '12348', 'testProduct', '12350', 'testVariant', '12352');
		productList[0].ProductCode = 'BLCCDN';
		insert productList;
		
		Asset assetTest = CH_UTIL_TEST.createS2SAsset(assetName, acc.Id);
		
		insert assetTest;
		
		PriceBookEntry tempPriceBookEntry = new PriceBookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = productList[0].id,
			UnitPrice = 0,
			IsActive = true
		);
		Insert tempPriceBookEntry;
		
		// Create contract
		ServiceContract serviceContract = new ServiceContract(
			AccountId = acc.Id, 
			Name = 'TestServiceContract',
			CH_CDB_ContractId__c = 'Test',
			CH_EntitlementScript__c = (hasEntitlementScript)?'Header Script':'',
			NCP_External_Status__c = 'Active',
			EndDate = Date.Today(),
			startdate= Date.today().addDays(-180),
			Pricebook2Id = Test.getStandardPricebookId(),
			CH_CDB_ContractNumber__c = '12345',
			CH_CARES_ServiceAgreement__c = ''
		);
		Insert serviceContract;
		
		// Create Contract Line Item 
		ContractLineItem contractLineItem = new ContractLineItem(
			ServiceContractId = serviceContract.Id,
			AssetId = assetTest.Id,
			UnitPrice = 0,
			Quantity = 1,
			PricebookEntryId = tempPriceBookEntry.Id, 
			CH_LineItemEntitlementScript__c = (hasEntitlementScript)?'Script':'',
			CH_CDB_EntitlementId__c = 'TEST', 
			CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7',
			NCP_External_Status__c = 'Active'
		);
		Insert contractLineItem;
		
		// Create entitlement
		Entitlement entitlement = new Entitlement(
			AccountId = acc.Id,
			AssetId = assetTest.Id,
			Startdate = Date.Today().addDays(-1), // To get an Active entitlement
			CH_CDB_EntitlementId__c = '12345',
			ContractLineItemId = contractLineItem.Id,
			ServiceContractId = serviceContract.Id,
			CH_EntitlementType__c = 'Entitled Asset',
			RecordtypeId =  Schema.SObjectType.Entitlement.getRecordTypeInfosByDeveloperName().get('HWS_Entitlement').getRecordTypeId(),
			Name = 'TestEntitlement',
			CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7'
		);
		Insert entitlement;
		
		EntitlementContact oEntitlementContact = new EntitlementContact(
			EntitlementId = entitlement.Id,
			ContactId = con.Id
		);
		insert oEntitlementContact;
		
		Product2 oProduct = new Product2();
		oProduct.Name = 'test';
		oProduct.ProductCode ='A123';
		insert oProduct;
		assetTest.Product2Id = oProduct.id;
		
		List<CH_Settings__c> chSetList = new List<CH_Settings__c>();
		CH_Settings__c chSet = new CH_Settings__c();
		chSet.Name = 'Switch Between ROTA and Schedule';
		chSet.SettingValue__c = 'CH_CA_WorkgroupMemberSchedule';
		chSetList.add(chSet);
		insert chSetList;
		createProblemRecord();
		
		
		Profile pf= [Select Id from profile where Name='System Administrator']; 
		String orgId=UserInfo.getOrganizationId(); 
		String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomId=Integer.valueOf(Math.rint(Math.random()*1000000));
		String uniqueName=orgId+dateString+randomId; 
		
		uu=new User(firstname = 'ABC', 
		lastName = 'XYZ', 
		email = uniqueName + '@test' + orgId + '.org', 
		Username = uniqueName + 'CI@test' + orgId + '.org', 
		EmailEncodingKey = 'ISO-8859-1', 
		Alias = uniqueName.substring(18, 23), 
		TimeZoneSidKey = americaLA, 
		LocaleSidKey = 'en_US', 
		LanguageLocaleKey = 'en_US', 
		ProfileId = pf.Id,
		Nokia_ID__c = '12345'
	); 
		insert uu;
		
		system.runAs(uu){
			List<case> prbCAseList = [select id from case where recordType.Name ='Problem'];
			Case incidentCase = createCaseRecord();
			incidentCase.CH_Problem__c = prbCAseList[0].Id;
			insert incidentCase;
		}
		
		
		
	}
	
	public static Case createCaseRecord(){
		User queueUser = new User();
		queueUser.alias = 'CHQueueU';
		queueUser.email = 'testgmail1@mail.com';
		queueUser.emailencodingkey = 'UTF-8';
		queueUser.lastname = queueUsrName;
		queueUser.languagelocalekey = 'en_US';
		queueUser.localesidkey = 'en_US';
		queueUser.profileid = UserInfo.getProfileId();
		queueUser.Country__c = 'Canada';
		queueUser.timezonesidkey = americaLA;
		queueUser.Username = 'testgmail2@mail.com';
		insert queueUser;
		
		List<Account> acc = [select id from Account where name = 'Legal Acc'];
		
		List<Contact> con = [select id from Contact];		
		Asset assetTest = [select id , name from Asset where accountId = :acc[0].Id];
		
		
		List<Entitlement> Entitlement = [select id from Entitlement];
		List<ServiceContract> ServiceContract = [select id from ServiceContract];
		List<Product2> ProductList = [select id from Product2];
		
		
		Case newCase = new Case();
		newCase.AccountId = acc[0].Id;
		newCase.ContactId = con[0].Id;
		newCase.AssetId = assetTest.Id;
		newCase.CH_ReportedDate__c = DateTime.Now();
		newCase.Mobile_Phone__c = mobilePhoneNo;
		newCase.Country__c = 'Bahrain';
		newCase.reason = caseReason;
		newCase.Subject = caseSubjct;
		newCase.CH_Summary__c = 'TestSub';
		newCase.Type = 'Incident';
		newCase.Description = 'TEST';
		newCase.Severity__c = 'Major';
		newCase.CH_Outage__c = 'No';
		newCase.Status = 'Created';
		newCase.CH_IssueOccurenceDate__c = system.today();
		newCase.ProductId = productList[0].id;
		newCase.CH_Initial_Assignment__c = true;
		newCase.CH_SystemRestoredTargetDate__c = system.now();
		newCase.CH_Reassignment__c = true;
		newCase.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		newCase.EntitlementId = entitlement[0].Id;
		newCase.NCP_Service_Contract__c = serviceContract[0].Id;
		newCase.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		newCase.ownerId = userinfo.getUserId();
		
		newCase.CH_LegacyCaseNumber__c = '12345';
		newCase.CH_LegacyCaseStatus__c  = 'Open';
		newCase.CH_EntitlementException__c = entitlementException;
		newCase.CH_ServiceType__c = SWS_Constants.ServiceTypeIS;
		newCase.ownerid = userInfo.getUserId();
		
		return newCase;
		
		
	}
	
	public static  void createProblemRecord(){
		List<Product2> ProductList = [select id from Product2];
		test.startTest(); 
		List<case>caselist = new List<case>(); 
		Case newProblemCase = new Case();
		newProblemCase.CH_ReportedDate__c = DateTime.Now();
		newProblemCase.Mobile_Phone__c = mobilePhoneNo;
		newProblemCase.Country__c = 'Bahrain';
		newProblemCase.reason = caseReason;
		newProblemCase.Subject = caseSubjct;
		newProblemCase.CH_Summary__c = 'TestSub';
		newProblemCase.Description = 'TEST';
		newProblemCase.Severity__c = 'Major';
		newProblemCase.CH_Outage__c = 'No';
		newProblemCase.Status = 'Created';
		newProblemCase.CH_IssueOccurenceDate__c = system.today();
		newProblemCase.ProductId = productList[0].id;
		newProblemCase.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		newProblemCase.CH_RouteCase__c = true;
		newProblemCase.CH_Initial_Assignment__c = false;
		newProblemCase.ownerId = userinfo.getUserId();
		
		caselist.add(newProblemCase);
		
		Case newProblemCase1 = new Case();
		newProblemCase1.CH_ReportedDate__c = DateTime.Now();
		newProblemCase1.Mobile_Phone__c = mobilePhoneNo;
		newProblemCase1.Country__c = 'Bahrain';
		newProblemCase1.reason = caseReason;
		newProblemCase1.Subject = caseSubjct;
		newProblemCase1.CH_Summary__c = 'TestSub';
		newProblemCase1.Description = 'TEST';
		newProblemCase1.Severity__c = 'Major';
		newProblemCase1.CH_Outage__c = 'No';
		newProblemCase1.Status = 'Created';
		newProblemCase1.CH_IssueOccurenceDate__c = system.today();
		newProblemCase1.ProductId = productList[0].id;
		newProblemCase1.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		newProblemCase1.CH_RouteCase__c = true;
		newProblemCase1.CH_Initial_Assignment__c = false;
		newProblemCase1.ownerId = userinfo.getUserId();
		caselist.add(newProblemCase1);
		insert caselist;
	}
	
	public static testmethod void addoRemoveProblemOwnerForCasesTestMethod(){ 
		test.startTest(); 
	User userRec = [Select Id,Name,Nokia_ID__c from User where id=:userinfo.getuserId()];
	String userval = userInfo.getUserId();
	Group grp =  [SELECT Id, Name , type FROM Group where type='Regular' and name = 'SEC_GWC|ALL'];
	GroupMember grpMem1 = new GroupMember();
	grpMem1.UserOrGroupId = userval;
	grpMem1.GroupId = grp.Id;
	Insert grpMem1;
	system.runAs(userRec){
	  List<case> prbCAseList = [select id from case where recordType.Name ='Problem'];
	  case incCase = [select id, CH_Problem__c from case where recordType.Name !='Problem'];
	  case updateCaseProblem = new case();
	  updateCaseProblem.id = incCase.id;
	  updateCaseProblem.OwnerId = userval;
	  updateCaseProblem.CH_Problem__c = prbCAseList[1].Id;
	  update updateCaseProblem;
	}
	test.stopTest();  
	}
	
	
	@isTest
	
	public static void completeMilestoneTest(){
		test.starttest();
		
		User queueUser = new User();
		queueUser.alias = 'CHQueueU';
		queueUser.email = 'testgmail2@mail.com';
		queueUser.emailencodingkey = 'UTF-8';
		queueUser.lastname = queueUsrName;
		queueUser.languagelocalekey = 'en_US';
		queueUser.localesidkey = 'en_US';
		queueUser.profileid = UserInfo.getProfileId();
		queueUser.Country__c = 'Canada';
		queueUser.timezonesidkey = americaLA;
		queueUser.Username = 'testgmail3@mail.com';
		insert queueUser;
		
		List<Account> acc = [select id from Account where name = 'Legal Acc'];
		List<Account> acc1 = [select id from Account where name = 'Customer Account'];
		List<Account> acc2 = [select id from Account where name = 'Legal Acc1'];
		List<Contact> con = [select id from Contact];
		Asset assetTest = CH_UTIL_TEST.createS2SAsset(assetName, acc[0].Id);
		
		insert assetTest;
		Asset assetTest1 = CH_UTIL_TEST.createS2SAsset(assetName, acc1[0].Id);
		
		insert assetTest1;
		
		Asset assetTest2 = CH_UTIL_TEST.createS2SAsset(assetName, acc2[0].Id);
		
		insert assetTest2;
		List<Entitlement> Entitlement = [select id from Entitlement];
		List<ServiceContract> ServiceContract = [select id from ServiceContract];
		List<Product2> ProductList = [select id from Product2];
		
		
		
		List<case>caselist = new List<case>(); 
		// Creation of Case
		Case newCase = new Case();
		newCase.AccountId = acc[0].Id;
		newCase.ContactId = con[0].Id;
		newCase.AssetId = assetTest.Id;
		newCase.CH_ReportedDate__c = DateTime.Now();
		newCase.Mobile_Phone__c = mobilePhoneNo;
		newCase.Country__c = 'Bahrain';
		newCase.reason = caseReason;
		newCase.Subject = caseSubjct;
		newCase.CH_Summary__c = 'TestSub';
		newCase.Type = 'Incident';
		newCase.Description = 'TEST';
		newCase.Severity__c = 'Major';
		newCase.CH_Outage__c = 'No';
		newCase.Status = 'Created';
		newCase.CH_IssueOccurenceDate__c = system.today();
		newCase.ProductId = productList[0].id;
		newCase.CH_Initial_Assignment__c = true;
		newCase.CH_SystemRestoredTargetDate__c = system.now();
		newCase.CH_Reassignment__c = true;
		newCase.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		newCase.EntitlementId = entitlement[0].Id;
		newCase.NCP_Service_Contract__c = serviceContract[0].Id;
		newCase.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		newCase.ownerId = userinfo.getUserId();
		
		
		newCase.CH_LegacyCaseNumber__c = '12345';
		newCase.CH_LegacyCaseStatus__c  = 'Open';
		newCase.CH_EntitlementException__c = entitlementException;
		newCase.CH_ServiceType__c = SWS_Constants.ServiceTypeIS;
		newCase.ownerid = userInfo.getUserId();
		
		insert newCase;
		
		caselist.add(newCase); 
		newCase.Status = 'Cancelled';
		newCase.CH_ReasonForCancellation__c = 'testing';
		update newcase;
		list<case> cancelledcaselist = new List<case>();
		cancelledcaselist.add(newCase);
		
		CH_CaseTriggerHelper.completeMilestoneOnCancellation(cancelledcaselist);
		CH_CaseTriggerHelper.checkEntitlementExceptionCases(caselist);
		CH_CaseTriggerHelper.setEntitlementReport(caselist);
		
		Case newCase2 = new Case();
		newCase2.AccountId = acc2[0].Id;
		newCase2.ContactId = con[1].Id;
		newCase2.AssetId = assetTest2.Id;
		newCase2.CH_ReportedDate__c = DateTime.Now();
		newCase2.Mobile_Phone__c = mobilePhoneNo;
		
		newCase2.reason = caseReason;
		newCase2.Subject = caseSubjct;
		newCase2.CH_Summary__c = 'TestSub';
		newCase2.Type = 'Incident';
		newCase2.Description = 'TEST';
		newCase2.Severity__c = 'Minor';
		newCase2.CH_Outage__c = 'No';
		newCase2.Status = 'Created';
		newCase2.CH_IssueOccurenceDate__c = system.today();
		newCase2.ProductId = productList[0].id;
		newCase2.CH_Initial_Assignment__c = true;
		newCase2.CH_SystemRestoredTargetDate__c = system.now();
		newCase2.CH_Reassignment__c = true;
		newCase2.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		newCase2.EntitlementId = entitlement[0].Id;
		newCase2.NCP_Service_Contract__c = serviceContract[0].Id;
		newCase2.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		
		
		newCase2.Country__c = 'India';
		newCase2.CH_LegacyCaseNumber__c = '12345';
		newCase2.CH_IsCompleteServiceDisruptionReport__c = true;
		newCase2.CH_SystemRestored__c = Date.Today();
		newCase2.CH_ServiceDisruptionReportProvided__c = Date.Today();
		newCase2.CH_TemporarySolutionProvided__c = Date.Today();
		newCase2.CH_SolutionProvided__c = Date.Today();
		newCase2.CH_IsInitialResponseSLA__c = true;
		newCase2.CH_IsCompleteInitialResponse__c = true;
		newCase2.CH_IsSystemRestoredSLA__c = true;
		newCase2.CH_IsCompleteRestore__c = true;
		newCase2.CH_IsServiceDisruptionReportSLA__c = true;
		
		newCase2.CH_IsTemporarySolutionProvidedSLA__c = true;
		
		newCase2.CH_IsSolutionProvidedSLA__c = true;
		
		
		newCase2.CH_IsCompleteServiceDisruptionReport__c = true;
		newCase2.CH_IsCompleteSolutionProvided__c = true;
		newCase2.CH_IsCompleteTemporarySolution__c = true;
		
		
		newCase2.CH_ReportedDate__c = Date.Today();
		newCase2.CH_InitialResponse__c = date.today();
		
		
		
		newCase2.CH_Defect__c = false;
		insert newCase2;
		
		Map<id,case> oldCaseMap = new Map<id,Case>();
		Case oldCase = new Case(id=newCase.id, Country__c = 'India',ownerID=queueUser.id);
		oldCaseMap.put(oldCase.id,oldCase);
		
		Map<id,case> oldmap = new Map<id,Case>();
		
		CH_Hierarchical_Setting__c chs = new CH_Hierarchical_Setting__c();
		chs.P20OrderDetails__c = true;
		insert chs;
		
		CH_CaseTriggerHelper.updateCurrentQueue(oldCaseMap,caselist);
		CH_CaseTriggerHelper.handleP20orderDetails(oldmap,caselist);
		
		
		
		
		CH_Attachment__c attach = new CH_Attachment__c();
		attach.Case__c = newCase2.id;
		attach.CH_Status__c = 'uploading';
		
		CH_Attachment__c attach1 = new CH_Attachment__c();
		attach1.Case__c = newCase2.id;
		attach1.CH_Status__c = 'uploading';
		list<CH_Attachment__c> attlist = new list<CH_Attachment__c>();
		attlist.add(attach);
		attlist.add(attach1);
		insert attlist;
		CH_CaseTriggerHelper.checkEntitlementExceptionCases(oldCaseMap,caselist);
		CH_CaseTriggerHelper.updateFlagForCaseMilestone(oldCaseMap,caselist);
		CH_CaseTriggerHelper.setFlagForCaseMilestone(caselist, true);
		CH_CaseTriggerHelper.setFlagForCaseMilestone(caselist, false);
		CH_CaseTriggerHelper.updateMilestoneCompletionDate(oldCaseMap,caselist);
		CH_CaseTriggerHelper.queueSecurityGroupsCheck(caselist,oldCaseMap);
		CH_CaseTriggerHelper.queueSecurityGroupsCheckOwnerChange(caselist, oldCaseMap);
		
		test.stoptest();		
	}
	
	@isTest
	public static void entitlementTest(){
		
		test.starttest();
		List<Account> acc = [select id from Account where name = 'Customer Account'];
		Contact con = new Contact();
		con.FirstName = 'TestFirstName';
		con.Lastname = 'TestLastName';
		con.Email = 'Test21@test.com';
		con.AssistantName ='TestAssistanceName';
		con.Email1__c = 'TestCaseEmail214@test.com';
		con.CH_Email3__c = 'TestCaseEmail213@test.com';
		con.AccountId = acc[0].Id;
		con.CH_contactType__c = SWS_Constants.CONTTypeNokiaEmp;
		insert con;
		Asset assetTest = CH_UTIL_TEST.createS2SAsset(assetName, acc[0].Id);
		
		insert assetTest;
		
		List<Entitlement> Entitlement = [select id from Entitlement];
		List<ServiceContract> ServiceContract = [select id from ServiceContract];
		List<Product2> ProductList = [select id from Product2];
		
		List<case>caselist = new List<case>(); 
		// Creation of Case
		Case newCase = new Case();
		newCase.AccountId = acc[0].Id;
		newCase.ContactId = con.Id;
		newCase.AssetId = assetTest.Id;
		newCase.CH_ReportedDate__c = DateTime.Now();
		newCase.Mobile_Phone__c = mobilePhoneNo;
		newCase.Country__c = 'Bahrain';
		newCase.reason = caseReason;
		newCase.Subject = caseSubjct;
		newCase.CH_Summary__c = 'TestSub';
		newCase.Type = 'Incident';
		newCase.Description = 'TEST';
		newCase.Severity__c = 'Minor';
		newCase.CH_Outage__c = 'No';
		newCase.Status = 'Created';
		newCase.CH_IssueOccurenceDate__c = system.today();
		newCase.ProductId = productList[0].id;
		newCase.CH_Initial_Assignment__c = true;
		newCase.CH_SystemRestoredTargetDate__c = system.now();
		newCase.CH_Reassignment__c = true;
		newCase.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		newCase.EntitlementId = entitlement[0].Id;
		newCase.NCP_Service_Contract__c = serviceContract[0].Id;
		newCase.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		newCase.CH_ServiceType__c = SWS_Constants.ServiceTypeIS;
		newCase.Country__c = 'India';
		newCase.CH_LegacyCaseNumber__c = '12345';
		
		newCase.CH_SystemRestored__c = Date.Today();
		newCase.CH_ServiceDisruptionReportProvided__c = Date.Today();
		newCase.CH_TemporarySolutionProvided__c = Date.Today();
		newCase.CH_SolutionProvided__c = Date.Today();
		newCase.CH_IsInitialResponseSLA__c = true;
		newCase.CH_IsCompleteInitialResponse__c = true;
		newCase.CH_IsSystemRestoredSLA__c = true;
		newCase.CH_IsCompleteRestore__c = true;
		newCase.CH_IsServiceDisruptionReportSLA__c = true;
		
		newCase.CH_IsTemporarySolutionProvidedSLA__c = true;
		
		newCase.CH_IsSolutionProvidedSLA__c = true;
		
		
		newCase.CH_IsCompleteServiceDisruptionReport__c = true;
		newCase.CH_IsCompleteSolutionProvided__c = true;
		newCase.CH_IsCompleteTemporarySolution__c = true;
		
		
		newCase.CH_ReportedDate__c = Date.Today();
		newCase.CH_InitialResponse__c = date.today();
		insert newCase;
		
		caselist.add(newCase);
		
		
		Case newCase2 = new Case();
		newCase2.AccountId = acc[0].Id;
		newCase2.ContactId = con.Id;
		newCase2.AssetId = assetTest.Id;
		newCase2.CH_ReportedDate__c = DateTime.Now();
		newCase2.Mobile_Phone__c = mobilePhoneNo;
		newCase2.Country__c = 'Bahrain';
		newCase2.reason = caseReason;
		newCase2.Subject = caseSubjct;
		newCase2.CH_Summary__c = 'TestSub';
		newCase2.Type = 'Incident';
		newCase2.Description = 'TEST';
		newCase2.Severity__c = 'Minor';
		newCase2.CH_Outage__c = 'No';
		newCase2.Status = 'Created';
		newCase2.CH_IssueOccurenceDate__c = system.today();
		newCase2.ProductId = productList[0].id;
		newCase2.CH_Initial_Assignment__c = true;
		newCase2.CH_SystemRestoredTargetDate__c = system.now();
		newCase2.CH_Reassignment__c = true;
		newCase2.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		newCase2.EntitlementId = entitlement[0].Id;
		newCase2.NCP_Service_Contract__c = serviceContract[0].Id;
		newCase2.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		
		newCase2.Country__c = 'India';
		newCase2.CH_LegacyCaseNumber__c = '12345';
		newCase2.CH_IsCompleteServiceDisruptionReport__c = true;
		newCase2.CH_SystemRestored__c = Date.Today();
		newCase2.CH_ServiceDisruptionReportProvided__c = Date.Today();
		newCase2.CH_TemporarySolutionProvided__c = Date.Today();
		newCase2.CH_SolutionProvided__c = Date.Today();
		newCase2.CH_IsInitialResponseSLA__c = true;
		newCase2.CH_IsCompleteInitialResponse__c = true;
		newCase2.CH_IsSystemRestoredSLA__c = true;
		newCase2.CH_IsCompleteRestore__c = true;
		newCase2.CH_IsServiceDisruptionReportSLA__c = true;
		
		newCase2.CH_IsTemporarySolutionProvidedSLA__c = true;
		
		newCase2.CH_IsSolutionProvidedSLA__c = true;
		
		
		newCase2.CH_IsCompleteServiceDisruptionReport__c = true;
		newCase2.CH_IsCompleteSolutionProvided__c = true;
		newCase2.CH_IsCompleteTemporarySolution__c = true;
		
		
		newCase2.CH_ReportedDate__c = Date.Today();
		newCase2.CH_InitialResponse__c = date.today();
		
		
		
		newCase2.CH_Defect__c = false;
		

		
		insert newCase2;
		
		CH_CaseTriggerHelper.getEntitlementReportA(newCase,con,1);
		CH_CaseTriggerHelper.getEntitlementReportB(newCase,con,1);
		CH_CaseTriggerHelper.getEntitlementReportC(newCase,con);
		
		
		
		CH_CaseTriggerHelper.getEntitlementReportA(newCase2,con,1);
		CH_CaseTriggerHelper.getEntitlementReportB(newCase2,con,1);
		CH_CaseTriggerHelper.getEntitlementReportC(newCase2,con);
		
		
		
		
		test.stoptest();
		
	}
	@isTest
	public static void checkAuthorisedContactTest(){
		
		test.starttest();
		List<Account> acc = [select id from Account where name = 'Legal Acc'];
		
		List<Contact> con = [select id from Contact where lastname='YesNokia'];
		
		
		
		List<Entitlement> Entitlement = [select id from Entitlement];
		List<ServiceContract> ServiceContract = [select id from ServiceContract];
		List<Product2> ProductList = [select id from Product2];
		Asset assetTest = CH_UTIL_TEST.createS2SAsset(assetName, acc[0].Id);
		Entitlement[0].assetId = assetTest.id;
		insert assetTest;
		
		List<case>caselist = new List<case>(); 
	
		Case caseObj = new Case();
		caseObj.AccountId =acc[0].Id ;
		caseObj.ProductId = productlist[0].Id;
	
		caseObj.CreatedDate=Date.today();
		caseObj.OwnerId = UserInfo.getUserId();
		caseObj.Status = 'Created';
		caseObj.Country__c = 'India';
		caseObj.CH_Outage__c = 'No';
		caseObj.CH_InitialDiagnosis__c = 'testt';
		caseObj.Severity__c = 'Minor';		
		caseObj.of_Employees_to_represent_Nokia_CP__c = '0-10%';
		caseObj.Subject = caseSubjct1;
		caseObj.Description = CaseDesc;
		caseObj.CH_ProblemDisassociationReason__c='test';
		caseObj.RecordTypeId =Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		caseObj.CH_Reassignment__c=true;
		caseObj.ContactId=con[0].Id;
		caseObj.CH_ServiceType__c = SWS_Constants.ServiceTypeIS;
		caseObj.EntitlementId = Entitlement[0].id;
		caseObj.CH_ReportedDate__c = System.now()-1;
		caseObj.CH_IssueOccurenceDate__c = System.now()-1;
		
		
		insert caseObj;
		
		
		caselist.add(caseObj); 
		CH_CaseTriggerHelper.checkAuthorisedContact(caselist);
		CH_CaseTriggerHelper.caseIsEligibleForP20Details(caseObj);
		
		
		Case newCase1 = new Case();
		newCase1.AccountId = acc[0].Id;
		newCase1.ContactId = con[0].Id;
		newCase1.AssetId = assetTest.Id;
		newCase1.CH_ReportedDate__c = DateTime.Now();
		newCase1.Mobile_Phone__c = mobilePhoneNo;
		newCase1.reason = caseReason;
		newCase1.Subject = caseSubjct;
		newCase1.CH_Summary__c = 'TestSub';
		newCase1.Type = 'Incident';
		newCase1.Description = 'TEST';
		newCase1.Severity__c = 'Major';
		newCase1.CH_Outage__c = 'No';
		newCase1.Status = 'Draft';
		newCase1.CH_IssueOccurenceDate__c = system.today();
		newCase1.ProductId = productList[0].id;
		newCase1.CH_Initial_Assignment__c = true;
		newCase1.CH_SystemRestoredTargetDate__c = system.now();
		newCase1.CH_Reassignment__c = true;
		newCase1.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		newCase1.EntitlementId = entitlement[0].Id;
		newCase1.NCP_Service_Contract__c = serviceContract[0].Id;
		newCase1.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		
	
		
		insert newCase1;
		list<case> caselist1 =  new List<case>();
		caselist1.add(newCase1);
		CH_CaseTriggerHelper.CH_BlacklistCaseReportTrigger(caselist1); 
		Group testGroup = new Group();
		testGroup.Name = 'GWC';
		testGroup.DeveloperName = 'testGroupdeveloper';
		testGroup.type= 'queue';
		insert testgroup;
		
		Group grp = new Group();
		grp.Name = 'GWCRole';
		grp.DeveloperName = 'testGroupdeveloper1';
		grp.type= 'Regular';
		insert grp;
		
		User userRec = [Select Id,Name,Nokia_ID__c from User where id=:userinfo.getuserId()];
		system.runAs(userRec){   
			GroupMember testGroupMember = new GroupMember();
			testGroupMember.UserOrGroupId = userinfo.getuserid();
			testGroupMember.GroupId = testgroup.ID;
			insert testGroupMember;
			
			GroupMember gm = new GroupMember();
			gm.UserOrGroupId = userinfo.getuserid();
			gm.GroupId = grp.ID;
			insert gm;
			
			list<GroupMember> gmList = new List<GroupMember>();
			gmlist.add(testGroupMember);
			gmlist.add(gm);
		}   
		newCase1.ownerId = testgroup.id; 
		List<case> caseList3 = new List<case>();
		caseList3.add(newCase1);
		
		Map<id,case> oldCaseMap = new Map<id,Case>();
		Case oldCase = new Case(id=newCase1.id, Country__c = 'India',ownerID=testgroup.id,CH_InitialResponse__c =system.today()+1);
		oldCaseMap.put(oldCase.id,oldCase);
		
		
		CH_CaseTriggerHelper.queueSecurityGroupsCheck(caseList3,oldCaseMap);
		
		newCase1.ownerId = userinfo.getuserID(); 
		List<case> caseList4 = new List<case>();
		caseList4.add(newCase1);
		Map<id,case> oldCaseMap1 = new Map<id,Case>();
		Case oldcase1 = new Case(id=newCase1.id, Country__c = 'India',ownerID=userinfo.getuserid(),CH_InitialResponse__c =system.today()+1);
		oldCaseMap1.put(oldCase1.id,oldCase1);
		
		CH_CaseTriggerHelper.queueSecurityGroupsCheck(caseList4,oldCaseMap1);
		
		newCase1.ownerId = grp.id; 
		List<case> caseList5 = new List<case>();
		caseList5.add(newCase1);
		Map<id,case> oldCaseMap2 = new Map<id,Case>();
		Case oldCase2 = new Case(id=newCase1.id, Country__c = 'India',ownerID=grp.id,CH_InitialResponse__c =system.today()+1);
		oldCaseMap2.put(oldCase2.id,oldCase2);
		
		CH_CaseTriggerHelper.queueSecurityGroupsCheck(caseList5,oldCaseMap2);
		
		newCase1.ownerId = userinfo.getuserid(); 
		List<case> caseList6 = new List<case>();
		caseList6.add(newCase1);
		Map<id,case> oldCaseMap3 = new Map<id,Case>();
		Case oldCase3 = new Case(id=newCase1.id, Country__c = 'India',ownerID=grp.id,CH_InitialResponse__c =system.today()+1);
		oldCaseMap3.put(oldCase3.id,oldCase3);
		
		
		CH_CaseTriggerHelper.queueSecurityGroupsCheckOwnerChange(caseList6,oldCaseMap3);
		
		
		test.stoptest();
		
	}
	@isTest
	public static void routeNewProblemsTest(){
		
		test.starttest();
		List<Account> acc = [select id from Account where name = 'Legal Acc'];
		List<Account> acc1 = [select id from Account where name = 'Customer Account'];
		List<Account> acc2 = [select id from Account where name = 'Legal Acc1'];
		List<Contact> con = [select id from Contact];
		Asset assetTest = CH_UTIL_TEST.createS2SAsset(assetName, acc[0].Id);
		
		insert assetTest;
		Asset assetTest1 = CH_UTIL_TEST.createS2SAsset(assetName, acc1[0].Id);
		
		insert assetTest1;
		
		Asset assetTest2 = CH_UTIL_TEST.createS2SAsset(assetName, acc2[0].Id);
		
		insert assetTest2;
		List<Entitlement> Entitlement = [select id from Entitlement];
		List<ServiceContract> ServiceContract = [select id from ServiceContract];
		List<Product2> ProductList = [select id from Product2];
		
		
		Case caseObj2 = new Case();
		caseObj2.AccountId =acc[0].Id ;
		caseObj2.ProductId = productList[0].Id;
		caseObj2.CreatedDate=Date.today();
		caseObj2.OwnerId = UserInfo.getUserId();
		caseObj2.Status = 'Created';
		caseObj2.Country__c = 'India';
		caseObj2.CH_Outage__c = 'No';
		caseObj2.CH_InitialDiagnosis__c = 'testt';
		caseObj2.Severity__c = 'Minor';
		
		caseObj2.of_Employees_to_represent_Nokia_CP__c = '0-10%';
		caseObj2.Subject = caseSubjct1;
		caseObj2.Description = CaseDesc;
		caseObj2.CH_ProblemDisassociationReason__c='test';
		caseObj2.RecordTypeId =Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		caseObj2.CH_Reassignment__c=true;
		caseObj2.ContactId=con[0].Id;
		caseObj2.CH_ReportedDate__c = DateTime.Now()-1;
		caseObj2.CH_IssueOccurenceDate__c = DateTime.Now()-1;
		
		insert caseObj2;
		List<case> caselist = new list<case>();
		caselist.add(caseObj2);
		
		set<id> caseIds = new set<id>();
		caseIds.add(caseObj2.id);
		
		CH_CaseTriggerHelper.populateS2SCases(caselist);
		//changing Referencing from case trigger helper to CH_ExternalInterfaceUTIL class method as both are duplicate
	 
		CH_CaseTriggerHelper.populateCaseEntitlement(caselist);

		
		User userRec = [Select Id,Name,Nokia_ID__c from User where id=:userinfo.getuserId()];
		
		system.runAs(userRec){
			List<CaseTeamRole> caseRoles = new List<CaseTeamRole>();
			CaseTeamRole ctr = new CaseTeamRole();
			ctr.Name = 'Test role';
			ctr.AccessLevel='Read';
			
			caseRoles.add(ctr);
			CaseTeamRole ctr1 = new CaseTeamRole();
			ctr1.Name = 'case owner';
			ctr1.AccessLevel='Read';
			
			caseRoles.add(ctr1);
			insert caseRoles;
			
			CaseTeamMember caseTeamMember1;
			caseTeamMember1 = new CaseTeamMember();
			caseTeamMember1.ParentId = caseObj2.Id;
			caseTeamMember1.MemberId = userinfo.getuserid();
			caseTeamMember1.TeamRoleId = caseRoles[0].Id;
			
			List<CaseTeamMember> membersForCaseTeam = new List<CaseTeamMember>(); 
			membersForCaseTeam.add(caseTeamMember1);
			insert membersForCaseTeam;
		}
		
		test.stoptest();
	}
	
	@isTest
	public static void handleUpdatesS2SCasesTest(){
		
		Test.startTest();
		List<Account> acc = [select id from Account where name = 'Legal Acc'];
		List<Account> acc1 = [select id from Account where name = 'Customer Account'];
		List<Account> acc2 = [select id from Account where name = 'Legal Acc1'];
		List<Contact> con = [select id from Contact];
		Asset assetTest = CH_UTIL_TEST.createS2SAsset(assetName, acc[0].Id);
		
		insert assetTest;
		Asset assetTest1 = CH_UTIL_TEST.createS2SAsset(assetName, acc1[0].Id);
		
		insert assetTest1;
		
		Asset assetTest2 = CH_UTIL_TEST.createS2SAsset(assetName, acc2[0].Id);
		
		insert assetTest2;
		List<Entitlement> Entitlement = [select id from Entitlement];
		List<ServiceContract> ServiceContract = [select id from ServiceContract];
		List<Product2> ProductList = [select id from Product2];
		
		
		
		List<case>caselist = new List<case>(); 
		// Creation of Case
		Case newCase = new Case();
		newCase.AccountId = acc[0].Id;
		newCase.ContactId = con[0].Id;
		newCase.AssetId = assetTest.Id;
		newCase.CH_ReportedDate__c = DateTime.Now();
		newCase.Mobile_Phone__c = mobilePhoneNo;
		newCase.Country__c = 'Bahrain';
		newCase.reason = caseReason;
		newCase.Subject = caseSubjct;
		newCase.CH_Summary__c = 'TestSub';
		newCase.Type = 'Incident';
		newCase.Description = 'TEST';
		newCase.Severity__c = 'Major';
		newCase.CH_Outage__c = 'No';
		newCase.Status = 'Created';
		newCase.CH_IssueOccurenceDate__c = system.today();
		newCase.ProductId = productList[0].id;
		newCase.CH_Initial_Assignment__c = true;
		newCase.CH_SystemRestoredTargetDate__c = system.now();
		newCase.CH_Reassignment__c = true;
		newCase.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		newCase.EntitlementId = entitlement[0].Id;
		newCase.NCP_Service_Contract__c = serviceContract[0].Id;
		newCase.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
	
		newCase.CH_ServiceType__c = SWS_Constants.ServiceTypeIS;
		
		newCase.CH_LegacyCaseNumber__c = '12345';
		newCase.CH_IsCompleteServiceDisruptionReport__c = true;
		newCase.CH_IsCompleteSolutionProvided__c = true;
		newCase.CH_IsCompleteTemporarySolution__c = true;
	
		newCase.CH_IsInitialResponseSLA__c = true;
		newCase.CH_IsCompleteInitialResponse__c = false;
		newCase.CH_IsSystemRestoredSLA__c = true;
		newCase.CH_IsCompleteRestore__c = true;
		newCase.CH_IsServiceDisruptionReportSLA__c = true;
		
		newCase.CH_IsTemporarySolutionProvidedSLA__c = true;
		
		newCase.CH_IsSolutionProvidedSLA__c = true;
		
		newCase.CH_ReportedDate__c = Date.Today();
		newCase.CH_EntitlementException__c = entitlementException;
		newCase.CH_ServiceType__c = SWS_Constants.ServiceTypeIS;
		
		
		newCase.CH_IsCompleteServiceDisruptionReport__c = true;
		
		newCase.CH_IsCompleteTemporarySolution__c = true;
		
		
		newCase.CH_SystemRestored__c = Date.Today();
		newCase.CH_ServiceDisruptionReportProvided__c = Date.Today();
		newCase.CH_TemporarySolutionProvided__c = Date.Today();
		newCase.CH_SolutionProvided__c = Date.Today();
		newCase.ownerid = userInfo.getUserId();
		insert newCase;
		
		caselist.add(newCase); 
		
		Case newCase2 = new Case();
		newCase2.AccountId = acc2[0].Id;
		newCase2.ContactId = con[1].Id;
		newCase2.AssetId = assetTest2.Id;
		newCase2.CH_ReportedDate__c = DateTime.Now();
		newCase2.Mobile_Phone__c = mobilePhoneNo;
		newCase2.Country__c = 'Bahrain';
		newCase2.reason = caseReason;
		newCase2.Subject = caseSubjct;
		newCase2.CH_Summary__c = 'TestSub';
		newCase2.Type = 'Incident';
		newCase2.Description = 'TEST';
		newCase2.Severity__c = 'Minor';
		newCase2.CH_Outage__c = 'No';
		newCase2.Status = 'Created';
		newCase2.CH_IssueOccurenceDate__c = system.today();
		newCase2.ProductId = productList[0].id;
		newCase2.CH_Initial_Assignment__c = true;
		newCase2.CH_SystemRestoredTargetDate__c = system.now();
		newCase2.CH_Reassignment__c = true;
		newCase2.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		newCase2.EntitlementId = entitlement[0].Id;
		newCase2.NCP_Service_Contract__c = serviceContract[0].Id;
		newCase2.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		
		
		newCase2.Country__c = 'India';
		newCase2.CH_LegacyCaseNumber__c = '12345';
		
		insert newCase2;
		Map<id,case> oldCase = new Map<id,Case>(); 
		oldCase.put(newCase2.id,newCase2);
		
		CH_CaseTriggerHelper.handleUpdatesS2SCases(oldCase,caselist);
		test.stoptest();	 
	}
	
	@istest
	public static void setEmailTypesTest(){
		
		Test.startTest();
		List<Account> acc = [select id from Account where name = 'Legal Acc'];
		
		List<Contact> con = [select id from Contact];
		Asset assetTest = CH_UTIL_TEST.createS2SAsset(assetName, acc[0].Id);
		
		insert assetTest;
		
		List<Entitlement> Entitlement = [select id from Entitlement];
		List<ServiceContract> ServiceContract = [select id from ServiceContract];
		List<Product2> ProductList = [select id from Product2];
		
		Case newCase = new Case();
		newCase.AccountId = acc[0].Id;
		newCase.ContactId = con[0].Id;
		newCase.AssetId = assetTest.Id;
		newCase.CH_ReportedDate__c = DateTime.Now();
		newCase.Mobile_Phone__c = mobilePhoneNo;
		newCase.Country__c = 'Bahrain';
		newCase.reason = caseReason;
		newCase.Subject = caseSubjct;
		newCase.CH_Summary__c = 'TestSub';
		newCase.Type = 'Incident';
		newCase.Description = 'TEST';
		newCase.Severity__c = 'Major';
		newCase.CH_Outage__c = 'No';
		newCase.Status = 'Pending Customer';
		newCase.CH_IssueOccurenceDate__c = system.today();
		newCase.ProductId = productList[0].id;
		newCase.CH_Initial_Assignment__c = true;
		newCase.CH_SystemRestoredTargetDate__c = system.now();
		newCase.CH_Reassignment__c = true;
		newCase.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaInformationRequest').getRecordTypeId();
		newCase.EntitlementId = entitlement[0].Id;
		newCase.NCP_Service_Contract__c = serviceContract[0].Id;
		newCase.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		
		newCase.CH_ServiceType__c = SWS_Constants.ServiceTypeIS;
		
		newCase.CH_LegacyCaseNumber__c = '12345';
		newCase.CH_IsCompleteServiceDisruptionReport__c = true;
		newCase.CH_IsCompleteSolutionProvided__c = false;
		newCase.CH_IsCompleteTemporarySolution__c = true;
		
		newCase.CH_IsInitialResponseSLA__c = true;
		newCase.CH_IsCompleteInitialResponse__c = true;
		newCase.CH_IsSystemRestoredSLA__c = true;
		newCase.CH_IsCompleteRestore__c = true;
		newCase.CH_IsServiceDisruptionReportSLA__c = true;
		
		newCase.CH_IsTemporarySolutionProvidedSLA__c = true;
		
		newCase.CH_IsSolutionProvidedSLA__c = true;
		
		newCase.CH_ReportedDate__c = Date.Today();
		newCase.CH_EntitlementException__c = entitlementException;
		newCase.CH_ServiceType__c = SWS_Constants.ServiceTypeIS;
		newCase.CH_IsCompleteServiceDisruptionReport__c = true;
		newCase.CH_IsCompleteTemporarySolution__c = true;
		newCase.CH_EmailTypeController__c = 'All';
		
		newCase.CH_SystemRestored__c = Date.Today();
		newCase.CH_ServiceDisruptionReportProvided__c = Date.Today();
		newCase.CH_TemporarySolutionProvided__c = Date.Today();
		
		newCase.ownerid = userInfo.getUserId();
		newCase.CH_Status_PriorValue__c = 'test';
	
		List<Case> caselist = new List<Case>();
		caselist.add(newCase);
		CH_CaseTriggerHelper.setEmailTypes(caselist);
		
		List<Case> caselist0 = new List<Case>();
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId(); 
		caselist0.add(newCase);
		CH_CaseTriggerHelper.setEmailTypes(caselist0);
		
		List<Case> caselist00 = new List<Case>();
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaInformationRequest').getRecordTypeId(); 
		caselist00.add(newCase);
		CH_CaseTriggerHelper.setEmailTypes(caselist00);
		
		List<Case> caselist1 = new List<Case>();
		caselist[0].status = 'Created';
		caselist1.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist1);
		List<Case> caselist2 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].CH_InitialResponse__c = Date.today();
		caselist[0].CH_SolutionProvided__c = null;
		caselist2.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist2);
		
		List<Case> caselist3 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = Date.today();
		caselist3.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist3);
		
		List<Case> caselist4 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].CH_InitialResponse__c = Date.today();
		caselist[0].CH_SolutionProvided__c = Date.today();
		caselist4.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist4);
		
		List<Case> caselist5 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = Date.today();
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = null;
		caselist5.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist5);
		
		List<Case> caselist6 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = Date.today();
		caselist[0].CH_SolutionProvided__c = Date.today();
		caselist[0].CH_TemporarySolutionProvided__c = null;
		caselist6.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist6);
		
		List<Case> caselist11 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = date.today();
		caselist[0].CH_TemporarySolutionProvided__c = date.today();
		caselist11.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist11);
		
		List<Case> caselist7 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = Date.today();
		caselist[0].CH_TemporarySolutionProvided__c = null;
		caselist7.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist7);
		
		List<Case> caselist8 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = Date.today();
		caselist[0].CH_TemporarySolutionProvided__c = Date.today();
		caselist8.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist8);
		
		List<Case> caselist9 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = Date.today();
		caselist9.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist9);
		
		List<Case> caselist10 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = Date.today();
		caselist10.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist10);
		
		List<Case> caselist12 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist12.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist12);
		
		List<Case> caselist13 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c =  Date.today();
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c =null;
		caselist13.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist13);
		
		List<Case> caselist14 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = Date.today();
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist14.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist14);
		
		List<Case> caselist15 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = Date.today();
		caselist[0].CH_TemporarySolutionProvided__c = Date.today();
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist15.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist15);
		
		List<Case> caselist16 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist16.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist16);
		
		List<Case> caselist17 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = Date.today();
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist17.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist17);
		
		List<Case> caselist18 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = Date.today();
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist18.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist18);
		
		List<Case> caselist19 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = Date.today();
		caselist[0].CH_TemporarySolutionProvided__c = Date.today();
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist19.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist19);
		
		List<Case> caselist20 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = Date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist20.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist20);
		
		List<Case> caselist21 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = Date.today();
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = Date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist21.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist21);
		
		List<Case> caselist22 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = Date.today();
		CaseList[0].CH_SystemRestored__c = Date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist22.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist22);
		
		List<Case> caselist23 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = Date.today();
		caselist[0].CH_TemporarySolutionProvided__c = Date.today();
		CaseList[0].CH_SystemRestored__c = Date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist23.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist23);
		
		List<Case> caselist24 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = Date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist24.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist24);
		
		List<Case> caselist25 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = Date.today();
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = Date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist25.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist25);
		
		List<Case> caselist26 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = Date.today();
		CaseList[0].CH_SystemRestored__c = Date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist26.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist26);
		
		List<Case> caselist27 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = Date.today();
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = Date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist27.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist27);
		
		List<Case> caselist28 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = Date.today();
		CaseList[0].CH_SystemRestored__c = Date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist28.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist28);
		
		List<Case> caselist29 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = null;
		caselist[0].CH_SolutionProvided__c = Date.today();
		caselist[0].CH_TemporarySolutionProvided__c = Date.today();
		CaseList[0].CH_SystemRestored__c = Date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist29.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist29);
		
		List<Case> caselist30 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist30.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist30);
		
		List<Case> caselist31 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = date.today();
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist31.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist31);
		
		List<Case> caselist32 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = Date.today();
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist32.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist32);
		
		List<Case> caselist33 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = date.today();
		caselist[0].CH_TemporarySolutionProvided__c = Date.today();
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist33.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist33);
		
		List<Case> caselist34 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = date.today();
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist34.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist34);
		
		List<Case> caselist35 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist35.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist35);
		
		List<Case> caselist36 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = date.today();
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist36.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist36);
		
		List<Case> caselist37 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = date.today();
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist37.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist37);
		
		List<Case> caselist38 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = date.today();
		caselist[0].CH_TemporarySolutionProvided__c = date.today();
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist38.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist38);
		
		List<Case> caselist39 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = date.today();
		caselist[0].CH_TemporarySolutionProvided__c = date.today();
		CaseList[0].CH_SystemRestored__c = null;
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist39.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist39);
		
		List<Case> caselist40 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist40.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist40);
		
		List<Case> caselist41 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = date.today();
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist41.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist41);
		
		List<Case> caselist42 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = date.today();
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist42.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist42);
		
		List<Case> caselist43 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = date.today();
		CaseList[0].CH_SystemRestored__c = date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist43.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist43);
		
		List<Case> caselist44 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = date.today();
		caselist[0].CH_TemporarySolutionProvided__c = date.today();
		CaseList[0].CH_SystemRestored__c = date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = null;
		caselist44.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist44);
		
		List<Case> caselist45 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist45.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist45);
		
		List<Case> caselist46 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = date.today();
		caselist[0].CH_TemporarySolutionProvided__c = null;
		CaseList[0].CH_SystemRestored__c = Date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist46.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist46);
		
		List<Case> caselist47 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = null;
		caselist[0].CH_TemporarySolutionProvided__c = date.today();
		CaseList[0].CH_SystemRestored__c = date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist47.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist47);
		
		List<Case> caselist48 = new List<Case>();
		caselist[0].status = 'Created';
		caselist[0].recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
		caselist[0].CH_InitialResponse__c = date.today();
		caselist[0].CH_SolutionProvided__c = date.today();
		caselist[0].CH_TemporarySolutionProvided__c = date.today();
		CaseList[0].CH_SystemRestored__c = date.today();
		CaseList[0].CH_ServiceDisruptionReportProvided__c = Date.today();
		caselist48.addall(caselist);
		CH_CaseTriggerHelper.setEmailTypes(caselist48);
		test.stoptest();
	}
	@isTest
	public static void updateCurrentQueueTest(){
		
		test.starttest();
		List<Account> acc = [select id from Account where name = 'Customer Account'];
		Contact con = new Contact();
		con.FirstName = 'TestFirstName';
		con.Lastname = 'TestLastName';
		con.Email = 'Test21@test.com';
		con.AssistantName ='TestAssistanceName';
		con.Email1__c = 'TestCaseEmail214@test.com';
		con.CH_Email3__c = 'TestCaseEmail213@test.com';
		con.AccountId = acc[0].Id;
		con.CH_contactType__c = SWS_Constants.CONTTypeNokiaEmp;
		insert con;
		Asset assetTest = CH_UTIL_TEST.createS2SAsset(assetName, acc[0].Id);
		
		insert assetTest;
		
		List<Entitlement> Entitlement = [select id from Entitlement];
		List<ServiceContract> ServiceContract = [select id from ServiceContract];
		List<Product2> ProductList = [select id from Product2];
		
		
		// Creation of Case
		Case newCase = new Case();
		newCase.AccountId = acc[0].Id;
		newCase.ContactId = con.Id;
		newCase.AssetId = assetTest.Id;
		newCase.CH_ReportedDate__c = DateTime.Now();
		newCase.Mobile_Phone__c = mobilePhoneNo;
		newCase.Country__c = 'Bahrain';
		newCase.reason = caseReason;
		newCase.Subject = caseSubjct;
		newCase.CH_Summary__c = 'TestSub';
		newCase.Type = 'Incident';
		newCase.Description = 'TEST';
		newCase.Severity__c = 'Minor';
		newCase.CH_Outage__c = 'No';
		newCase.Status = 'Created';
		newCase.CH_IssueOccurenceDate__c = system.today();
		newCase.ProductId = productList[0].id;
		newCase.CH_Initial_Assignment__c = true;
		newCase.CH_SystemRestoredTargetDate__c = system.now();
		newCase.CH_Reassignment__c = true;
		newCase.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		newCase.EntitlementId = entitlement[0].Id;
		newCase.NCP_Service_Contract__c = serviceContract[0].Id;
		newCase.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		newCase.CH_ServiceType__c = SWS_Constants.ServiceTypeIS;
		newCase.Country__c = 'India';
		newCase.CH_LegacyCaseNumber__c = '12345';
		
		newCase.CH_SystemRestored__c = Date.Today();
		newCase.CH_ServiceDisruptionReportProvided__c = Date.Today();
		newCase.CH_TemporarySolutionProvided__c = Date.Today();
		newCase.CH_SolutionProvided__c = Date.Today();
		newCase.CH_IsInitialResponseSLA__c = true;
		newCase.CH_IsCompleteInitialResponse__c = true;
		newCase.CH_IsSystemRestoredSLA__c = true;
		newCase.CH_IsCompleteRestore__c = true;
		newCase.CH_IsServiceDisruptionReportSLA__c = true;
		
		newCase.CH_IsTemporarySolutionProvidedSLA__c = true;
		
		newCase.CH_IsSolutionProvidedSLA__c = true;
		
		
		newCase.CH_IsCompleteServiceDisruptionReport__c = true;
		newCase.CH_IsCompleteSolutionProvided__c = true;
		newCase.CH_IsCompleteTemporarySolution__c = true;
		
		
		newCase.CH_ReportedDate__c = Date.Today();
		newCase.CH_InitialResponse__c = date.today();
		insert newCase;
		Map<Id, Case> caseMapOld = new Map<Id, Case>();
		Case oldCase = new Case(Id =newCase.Id, OwnerId = '00541000007ghazAAA');		
		update oldCase;
		caseMapOld.put(oldCase.Id, oldCase);
		CH_CaseTriggerHelper.updateCurrentQueue(caseMapOld, new List<Case>{newCase});
	}
	@isTest
	public static void addProblemOwnerForNewCasesTest(){
		
		Test.startTest();
		CH_Settings__c settingForROTASchedule = new CH_Settings__c ();
		settingForROTASchedule.Name = 'Switch Between ROTA and Schedule';
		settingForROTASchedule.Description__c = 'This setting determines whether we need to get workgroup members from ROTA or Schedule.';
		settingForROTASchedule.SettingValue__c = 'CH_CA_WorkgroupMemberSchedule';
		
		if ([SELECT Id FROM CH_Settings__c WHERE Name = 'Switch Between ROTA and Schedule'].size() == 0){
			insert settingForROTASchedule;
		}
		List<Account> acc = [select id from Account where name = 'Legal Acc'];
		
		List<Contact> con = [select id from Contact];
		Asset assetTest = CH_UTIL_TEST.createS2SAsset(assetName, acc[0].Id);
		
		insert assetTest;
		
		List<Entitlement> Entitlement = [select id from Entitlement];
		List<ServiceContract> ServiceContract = [select id from ServiceContract];
		
		
		
		
		Case caseObj2 = new Case();
		caseObj2.AccountId = acc[0].Id;
		caseObj2.ContactId = con[0].Id;
		caseObj2.CreatedDate=Date.today();
		caseObj2.OwnerId = UserInfo.getUserId();
		caseObj2.Status = 'Created';
		caseObj2.Country__c = 'India';
		caseObj2.CH_Outage__c = 'No';
		caseObj2.CH_InitialDiagnosis__c = 'testt';
		caseObj2.Severity__c = 'Minor';	  
		caseObj2.of_Employees_to_represent_Nokia_CP__c = '0-10%';
		caseObj2.Subject = caseSubjct1;
		caseObj2.Description = CaseDesc;
		caseObj2.CH_ProblemDisassociationReason__c='test';
		caseObj2.RecordTypeId =Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		caseObj2.CH_Reassignment__c=true;
		caseObj2.CH_RouteCase__c = true;
		caseObj2.CH_ReportedDate__c = System.now()-1;
		caseObj2.CH_IssueOccurenceDate__c = Date.today()-1;
		
		insert caseObj2;
		caseObj2.CH_Problem__c = caseObj2.id;
		List<Case> caselist = new List<Case>();
		caselist.add(caseObj2);
		test.stoptest();
	}
	
	
	@isTest 
	public static void completeMilestoneElseTest(){
		test.starttest();
		CH_BlacklistRecords__c newBlackListRecord1 = new CH_BlacklistRecords__c(
			Name='BlackListRecord1', CH_AccountNames__c='Legal Acc1');
		CH_BlacklistRecords__c newBlackListRecord2 = new CH_BlacklistRecords__c(
			Name='BlackListRecord2', CH_ProductCodes__c='BLCCDN');
		
		List<CH_BlacklistRecords__c> custSettingList = new List<CH_BlacklistRecords__c>();
		custSettingList.add(newBlackListRecord1);
		custSettingList.add(newBlackListRecord2);
		insert custSettingList;
		
		User queueUser = new User();
		queueUser.alias = 'CHQueueU';
		queueUser.email = 'testgmail3@mail.com';
		queueUser.emailencodingkey = 'UTF-8';
		queueUser.lastname = queueUsrName;
		queueUser.languagelocalekey = 'en_US';
		queueUser.localesidkey = 'en_US';
		queueUser.profileid = UserInfo.getProfileId();
		queueUser.Country__c = 'Canada';
		queueUser.timezonesidkey = americaLA;
		queueUser.Username = 'testgmail3@mail.com';
		insert queueUser;
		
		List<Account> acc = [select id from Account where name = 'Legal Acc'];
		List<Account> acc1 = [select id from Account where name = 'Customer Account'];
		List<Account> acc2 = [select id from Account where name = 'Legal Acc1'];
		List<Contact> con = [select id from Contact];
		Asset assetTest = CH_UTIL_TEST.createS2SAsset(assetName, acc[0].Id);
		
		insert assetTest;
		Asset assetTest1 = CH_UTIL_TEST.createS2SAsset(assetName, acc1[0].Id);
		
		insert assetTest1;
		
		Asset assetTest2 = CH_UTIL_TEST.createS2SAsset(assetName, acc2[0].Id);
		
		insert assetTest2;
		List<Entitlement> Entitlement = [select id from Entitlement];
		List<ServiceContract> ServiceContract = [select id from ServiceContract];
		List<Product2> ProductList = [select id from Product2];
		
		
		
		List<case>caselist = new List<case>(); 
		// Creation of Case
		Case newCase = new Case();
		newCase.AccountId = acc[0].Id;
		newCase.ContactId = con[0].Id;
		newCase.AssetId = assetTest.Id;
		newCase.CH_ReportedDate__c = DateTime.Now();
		newCase.Mobile_Phone__c = mobilePhoneNo;
		newCase.Country__c = 'Bahrain';
		newCase.reason = caseReason;
		newCase.Subject = caseSubjct;
		newCase.CH_Summary__c = 'TestSub';
		newCase.Type = 'Incident';
		newCase.Description = 'TEST';
		newCase.Severity__c = 'Major';
		newCase.CH_Outage__c = 'No';
		newCase.Status = 'Created';
		newCase.CH_IssueOccurenceDate__c = system.today();
		newCase.ProductId = productList[0].id;
		newCase.CH_Initial_Assignment__c = true;
		newCase.CH_SystemRestoredTargetDate__c = system.now();
		newCase.CH_Reassignment__c = true;
		newCase.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		newCase.EntitlementId = entitlement[0].Id;
		newCase.NCP_Service_Contract__c = serviceContract[0].Id;
		newCase.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		newCase.ownerId = userinfo.getUserId();
		
		newCase.CH_LegacyCaseNumber__c = '12345';
		newCase.CH_IsSolutionProvidedSLA__c = true;
		newCase.CH_SolutionProvided__c = Date.Today();
		newCase.CH_IsCompleteSolutionProvided__c = true;
		newCase.CH_LegacySolutionProvidedTargetDate__c  = System.today();
		newCase.CH_LegacyTemporarySolutionTargetDate__c   = System.today();
		newCase.CH_LegacySystemRestoredTargetDate__c	= System.today(); 
		newCase.CH_LegacyInitialResponseTargetDate__c =System.today();
		newCase.CH_TemporarySolutionNotApplicable__c = false;
		newCase.CH_IsTemporarySolutionProvidedSLA__c = true;
		newCase.CH_TemporarySolutionProvided__c =System.today();
		newCase.CH_IsCompleteTemporarySolution__c = true;
		newCase.CH_IsServiceDisruptionReportSLA__c  = true;
		newCase.CH_IsSystemRestoredSLA__c = true;
		newCase.CH_IsCompleteRestore__c = true;
		newCase.CH_SystemRestored__c = Date.Today();
		newCase.CH_IsInitialResponseSLA__c = true;
		newCase.CH_EntitlementException__c = entitlementException;
		newCase.CH_ServiceType__c = SWS_Constants.ServiceTypeIS;
		newCase.ownerid = userInfo.getUserId();
		newCase.CH_ExternalSystemAccount__c='MVV40016|A3/E-W/03/3|Firma NSN';
		newCase.CH_Defect__c = false;//Defect Field added NOKIASC-38501
		insert newCase;
		
		caselist.add(newCase); 
		newCase.Status = 'Cancelled';
		newCase.CH_ReasonForCancellation__c = 'testing';
		 //Linked Problem For NOKIASC-38501
		List<case> problemCaselist = new List<case>(); 
		Case newProblemCase = new Case();
		newProblemCase.CH_Originating_Incident_Number__c = newCase.Id;
		newProblemCase.CH_Defect__c = true;
		newProblemCase.CH_ReportedDate__c = DateTime.Now();
		newProblemCase.Mobile_Phone__c = mobilePhoneNo;
		newProblemCase.Country__c = 'Bahrain';
		newProblemCase.Subject = caseSubjct;
		newProblemCase.CH_Summary__c = 'TestSub';
		newProblemCase.Description = 'TEST';
		newProblemCase.Severity__c = 'Major';
		newProblemCase.CH_Outage__c = 'No';
		newProblemCase.Status = 'Created';
		newProblemCase.CH_IssueOccurenceDate__c = system.today();
		newProblemCase.ProductId = productList[0].id;
		newProblemCase.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		newProblemCase.CH_RouteCase__c = false;
		newProblemCase.CH_Initial_Assignment__c = false;
		newProblemCase.ownerId = userinfo.getUserId();
		
		problemCaselist.add(newProblemCase);
		insert problemCaselist;
		
		list<case> cancelledcaselist = new List<case>();
		cancelledcaselist.add(newCase);
		
		CH_CaseTriggerHelper.completeMilestoneOnCancellation(cancelledcaselist);
		CH_CaseTriggerHelper.checkEntitlementExceptionCases(caselist);
		CH_CaseTriggerHelper.setEntitlementReport(caselist);
		
		Case newCase2 = new Case();
		newCase2.AccountId = acc2[0].Id;
		newCase2.ContactId = con[1].Id;
		newCase2.AssetId = assetTest2.Id;
		newCase2.CH_ReportedDate__c = DateTime.Now();
		newCase2.Mobile_Phone__c = mobilePhoneNo;
	
		newCase2.reason = caseReason;
		newCase2.Subject = caseSubjct;
		newCase2.CH_Summary__c = 'TestSub';
		newCase2.Type = 'Incident';
		newCase2.Description = 'TEST';
		newCase2.Severity__c = 'Minor';
		newCase2.CH_Outage__c = 'No';
		newCase2.Status = 'Created';
		newCase2.CH_IssueOccurenceDate__c = system.today();
		newCase2.ProductId = productList[0].id;
		newCase2.CH_Initial_Assignment__c = true;
		newCase2.CH_SystemRestoredTargetDate__c = system.now();
		newCase2.CH_Reassignment__c = true;
		newCase2.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		newCase2.EntitlementId = entitlement[0].Id;
		newCase2.NCP_Service_Contract__c = serviceContract[0].Id;
		newCase2.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
	  
		
		newCase2.Country__c = 'India';
		newCase2.CH_LegacyCaseNumber__c = '12345';
		newCase2.CH_LegacyCaseStatus__c ='Open';
		newCase2.CH_IsCompleteServiceDisruptionReport__c = true;
		newCase2.CH_SystemRestored__c = Date.Today();
		newCase2.CH_ServiceDisruptionReportProvided__c = Date.Today();
		newCase2.CH_TemporarySolutionProvided__c = Date.Today();
		newCase2.CH_SolutionProvided__c = Date.Today();
		newCase2.CH_IsInitialResponseSLA__c = true;
		newCase2.CH_IsCompleteInitialResponse__c = true;
		newCase2.CH_IsSystemRestoredSLA__c = true;
		
		newCase2.CH_IsCompleteRestore__c = true;
		newCase2.CH_IsServiceDisruptionReportSLA__c = true;
		
		newCase2.CH_IsTemporarySolutionProvidedSLA__c = true;
		
		newCase2.CH_IsSolutionProvidedSLA__c = true;
		newCase2.CH_TemporarySolution__c = 'test';
		
		newCase2.CH_IsCompleteServiceDisruptionReport__c = true;
		newCase2.CH_IsCompleteSolutionProvided__c = true;
		newCase2.CH_IsCompleteTemporarySolution__c = true;
		
		
		newCase2.CH_ReportedDate__c = Date.Today();
		
		
		
		
		newCase2.CH_Defect__c = false;
		
		Map<id,case> oldCaseMap = new Map<id,Case>();
		Case oldCase = new Case(id=newCase.id, Country__c = 'India',ownerID=queueUser.id, CH_InitialResponse__c =system.today()+1,CH_TemporarySolution__c= 'test12'
	);
		oldCaseMap.put(oldCase.id,oldCase);
		
		
		
		CH_Hierarchical_Setting__c chs = new CH_Hierarchical_Setting__c();
		chs.P20OrderDetails__c = true;
		insert chs;
		
		CH_CaseTriggerHelper.updateCurrentQueue(oldCaseMap,caselist);
		
		CH_CaseTriggerHelper.queueSecurityGroupsCheckOwnerChange(caselist, oldCaseMap);  
		CH_CaseTriggerHelper.queueSecurityGroupsCheckOwnerChange(caselist, oldCaseMap);
		
		CH_Settings__c cstObj = new CH_Settings__c();
		cstObj.Description__c = 'test custom settings';
		cstObj.SettingValue__c = '3';
		cstObj.Name = 'SpecificTimeForOnhold';
		insert cstObj;
		
		CH_Attachment__c attach = new CH_Attachment__c();
		attach.Case__c = caselist[0].id;
		attach.CH_Status__c = 'uploading';
		CH_Attachment__c attach1 = new CH_Attachment__c();
		attach1.Case__c = oldCase.id;
		attach1.CH_Status__c = 'uploading';
	
		list<CH_Attachment__c> attlist = new list<CH_Attachment__c>();
		attlist.add(attach);
		attlist.add(attach1);
		insert attlist;
		
		CH_CaseTriggerHelper.updateMilestoneCompletionDate(oldCaseMap,caselist);
		
		CH_CaseTriggerHelper.updateAttchmentinCAPS(oldCaseMap,caselist);
		CH_CaseTriggerHelper.setStatusAfterQueueAssignment(oldCaseMap,caselist);
		CH_CaseTriggerHelper.updateIncidentsDefect(oldCaseMap,caselist);
		CH_CaseTriggerHelper.insertIncidentsDefect(problemCaselist);//NOKIASC-38501
		
		CH_CaseTriggerHelper.addProblemChatterPost(oldCaseMap,caselist);
		CH_CaseTriggerHelper.addMembersToCaseTeam(caselist);
		CH_CaseTriggerHelper.caseRecordtypeChanged(oldCaseMap,caselist);
		CH_CaseTriggerHelper.validateServiceCaseCreation(caselist,oldCaseMap);
		CH_CaseTriggerHelper.fetchCaseFields(caselist,oldCaseMap);
		CH_CaseTriggerHelper.scramblingLogic(caselist[0],oldCase, new List<String>{'CH_LegacyCaseNumber__c'});
		CH_CaseTriggerHelper.updateProductDetails(caselist);
		CH_CaseTriggerHelper.addMembersToCaseTeamWrapper(caselist);
		
		CH_CaseTriggerHelper.addMembersToCaseTeamAssync(new Set<Id>{caselist[0].Id});	  
		
		
		test.stoptest(); 
	}
	
	 //Changes added as a part of NOKIASC-35311
	@isTest
	public static void checkDefectSolutionTargetAndPausedDateTest(){
		
		Test.StartTest();
		List<Account> acc = [select id from Account where name = 'Legal Acc'];
		
		List<Contact> con = [select id from Contact];
		Asset assetTest = CH_UTIL_TEST.createS2SAsset(assetName, acc[0].Id);
		
		insert assetTest;
		
		List<Entitlement> Entitlement = [select id from Entitlement];
		List<ServiceContract> ServiceContract = [select id from ServiceContract];
		List<Product2> ProductList = [select id from Product2];
		
		Case newCase = new Case();
		newCase.AccountId = acc[0].Id;
		newCase.ContactId = con[0].Id;
		newCase.AssetId = assetTest.Id;
		newCase.CH_ReportedDate__c = DateTime.Now();
		newCase.Mobile_Phone__c = mobilePhoneNo;
		newCase.Country__c = 'Bahrain';
		newCase.reason = caseReason;
		newCase.Subject = caseSubjct;
		newCase.CH_Summary__c = 'TestSub';
		newCase.Type = 'Incident';
		newCase.Description = 'TEST';
		newCase.Severity__c = 'Major';
		newCase.CH_Outage__c = 'No';
		newCase.Status = 'Pending Customer';
		newCase.IsStopped=True;
		newCase.CH_IssueOccurenceDate__c = system.today();
		newCase.ProductId = productList[0].id;
		newCase.CH_Initial_Assignment__c = true;
		newCase.CH_SystemRestoredTargetDate__c = system.now();
		newCase.CH_Reassignment__c = true;
		newCase.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		newCase.CH_InitialResponse__c = Date.today();
		newCase.CH_SolutionProvided__c = null;
		newCase.CH_TemporarySolutionProvided__c = null;
		newCase.EntitlementId = entitlement[0].Id;
		newCase.NCP_Service_Contract__c = serviceContract[0].Id;
		newCase.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		
		newCase.CH_ServiceType__c = SWS_Constants.ServiceTypeIS;
		
		newCase.CH_LegacyCaseNumber__c = '12345';
		newCase.CH_IsCompleteServiceDisruptionReport__c = true;
		newCase.CH_IsCompleteSolutionProvided__c = false;
		newCase.CH_IsCompleteTemporarySolution__c = true;
		
		newCase.CH_IsInitialResponseSLA__c = true;
		newCase.CH_IsCompleteInitialResponse__c = true;
		newCase.CH_IsSystemRestoredSLA__c = true;
		newCase.CH_IsCompleteRestore__c = true;
		newCase.CH_IsServiceDisruptionReportSLA__c = true;
		
		newCase.CH_IsTemporarySolutionProvidedSLA__c = true;
		
		newCase.CH_IsSolutionProvidedSLA__c = true;
		
		newCase.CH_ReportedDate__c = Date.Today();
		newCase.CH_EntitlementException__c = entitlementException;
		newCase.CH_ServiceType__c = SWS_Constants.ServiceTypeIS;
		newCase.CH_IsCompleteServiceDisruptionReport__c = true;
		newCase.CH_IsCompleteTemporarySolution__c = true;
		newCase.CH_EmailTypeController__c = 'All';
		
		newCase.CH_SystemRestored__c = Date.Today();
		newCase.CH_ServiceDisruptionReportProvided__c = Date.Today();
		newCase.CH_TemporarySolutionProvided__c = Date.Today();
		
		newCase.ownerid = userInfo.getUserId();
		newCase.CH_Status_PriorValue__c = 'test';
		newCase.CH_Defect__c = False;
		insert newCase;
		
		Case caseObj2 = new Case();
		caseObj2.AccountId = acc[0].Id;
		caseObj2.ContactId = con[0].Id;
		caseObj2.CreatedDate=Date.today();
		caseObj2.OwnerId = UserInfo.getUserId();
		caseObj2.Status = 'Created';
		caseObj2.Country__c = 'India';
		caseObj2.CH_Outage__c = 'No';
		caseObj2.CH_InitialDiagnosis__c = 'testt';
		caseObj2.Severity__c = 'Minor';	  
		caseObj2.of_Employees_to_represent_Nokia_CP__c = '0-10%';
		caseObj2.Subject = caseSubjct1;
		caseObj2.Description = CaseDesc;
		caseObj2.CH_ProblemDisassociationReason__c='test';
		caseObj2.RecordTypeId =Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		caseObj2.CH_Reassignment__c=true;
		caseObj2.CH_RouteCase__c = true;
		caseObj2.CH_ReportedDate__c = System.now()-1;
		caseObj2.CH_IssueOccurenceDate__c = Date.today()-1;
		insert caseObj2;
		Map<Id, Case> caseMapOld = new Map<Id, Case>();
		Case oldCase = new Case(Id=newCase.Id, OwnerId = '00541000007ghazAAA');
		update oldCase;
		caseMapOld.put(oldCase.Id, oldCase);
		newCase.CH_Problem__c = caseObj2.id;
		newCase.CH_Defect__c = True;
		update newCase;
		List<Case> caselist = new List<Case>();
		caselist.add(newCase);
		CH_CaseTriggerHelper.checkDefectSolutionTargetAndPausedDate(caseMapOld,caselist);
		Test.StopTest(); 
		
	}
	
	
	
	
}