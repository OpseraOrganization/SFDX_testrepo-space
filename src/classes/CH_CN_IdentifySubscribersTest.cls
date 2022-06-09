@isTest
public class CH_CN_IdentifySubscribersTest {
	public static testmethod void identifySubscribersWithEventsTest(){
		System.runAs(new User(Id=UserInfo.getUserId())) {
	
		 Group g = new Group(Name='TestGroup', type='Regular');
		insert g;
		
		GroupMember gm = new GroupMember(UserOrGroupId=userinfo.getUserId(), GroupId=g.Id);
		insert gm;
		}
		Test.startTest();
		Boolean hasEntitlementScript = true;
		List<ISO_Country_Codes__c> isoLst = new List<ISO_Country_Codes__c>();
		ISO_Country_Codes__c iso = new ISO_Country_Codes__c();
		iso.Name = 'IN';
		iso.Market__c = 'Market India';
		iso.Country_Name__c = 'India';
		isoLst.add(iso);
		
		ISO_Country_Codes__c iso1 = new ISO_Country_Codes__c();
		iso1.Name = 'IT';
		iso1.Market__c = 'Market Europe';
		iso1.Country_Name__c = 'Italy';
		isoLst.add(iso1);
		insert isoLst;
		Account accCustomerParentAccount = new Account();
		Id accountRecordType1 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accCustomerParentAccount.Name = 'Customer Parent Account';
		accCustomerParentAccount.RecordTypeId = accountRecordType1;
		accCustomerParentAccount.Customer_Compliance__c = 'US_Company';
		insert accCustomerParentAccount; 
		
		
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
		con.CH_contactType__c = 'Nokia Employee';
		insert con;
		
		List<Product2> productList = CH_UTIL_TEST.createS2SProducts('testSolution', '12348', 'testProduct', '12350', 'testVariant', '12352');
		productList[0].ProductCode = 'BLCCDN';
		productList[0].CH_Business_Group__c = 'FN Fixed Networks';
		productList[0].CH_Business_Unit__c = 'FN BBA';  
		productList[1].CH_Business_Group__c = 'GS Global Services';
		productList[1].CH_Business_Unit__c = 'GS SI';
		insert productList;
		
		
		
		Asset assetTest = CH_UTIL_TEST.createS2SAsset('12346|234|testSolution|testProduct|testVariant|testRelease', accCustomer.Id);
		
		insert assetTest;
		
		
		PriceBookEntry tempPriceBookEntry = new PriceBookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = productList[0].id,
			UnitPrice = 0,
			//  CurrencyIsoCode = 'EUR',
			IsActive = true
		);
		Insert tempPriceBookEntry;
		Account acc = new Account();
		Id accountCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		acc.Name = 'Legal Acc';
		acc.RecordTypeId = accountCustomerRecordType;
		acc.ParentId = accCustomerParentAccount.id;
		acc.Active__c = true;
		acc.CountryCode__c = 'WF';
		insert acc; 
		
		
		
		
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
		Entitlement entitlement = new Entitlement(
			AccountId = accCustomer.Id,
			AssetId = assetTest.Id,
			Startdate = Date.Today().addDays(-1), // To get an Active entitlement
			CH_CDB_EntitlementId__c = '12345',
			ContractLineItemId = contractLineItem.Id,
			ServiceContractId = serviceContract.Id,
			CH_EntitlementType__c = 'Entitled Asset',
			RecordtypeId =  Schema.SObjectType.Entitlement.getRecordTypeInfosByDeveloperName().get('CH_Entitlement').getRecordTypeId(),
			Name = 'TestEntitlement',
			CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7'
		);
		Insert entitlement;
		
		List<CH_Workgroup__c> WgrpRecds = new List<CH_Workgroup__c>();
		CH_Workgroup__c workGrp = new CH_Workgroup__c();
		workGrp.Name = 'Test';
		WgrpRecds.add(workGrp);
		
		CH_Workgroup__c workGrp1 = new CH_Workgroup__c();
		workGrp.Name = 'Test1';
		WgrpRecds.add(workGrp1);
		insert WgrpRecds;
		
	  
	  
		// Creation of Case
		Case newCase = new Case();
		newCase.AccountId = acc.Id;
		newCase.ContactId = con.Id;
		newCase.AssetId = assetTest.Id;
		newCase.CH_ReportedDate__c = DateTime.Now();
		newCase.Mobile_Phone__c = '123-456789';
		newCase.Country__c = 'India';
		newCase.reason = 'New problem';
		newCase.Subject = 'Survey Closed Case';
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
		newCase.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		newCase.EntitlementId = entitlement.Id;
		newCase.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		newCase.ownerId = userinfo.getUserId();
		newCase.CH_3rdPartySecurityGroup__c = 'TestGroup';
		newCase.CH_GWC_SecurityGroup__c = 'TestGroup';
		newCase.CH_SecurityGroup__c = 'TestGroup';
		newCase.CH_Workgroup__c  = WgrpRecds[0].Id;
		
		newCase.CH_LegacyCaseNumber__c = '12345';
		newCase.CH_LegacyCaseStatus__c  = 'Open';
		newCase.CH_EntitlementException__c = 'Account Not Listed';
		newCase.CH_ServiceType__c = 'Internal Support';
		newCase.ownerid = userInfo.getUserId();
		
		// Creation of Case
		Case newCase1 = new Case();
		newCase1.AccountId = acc.Id;
		newCase1.ContactId = con.Id;
		newCase1.AssetId = assetTest.Id;
		newCase1.CH_ReportedDate__c = DateTime.Now();
		newCase1.Mobile_Phone__c = '123-456789';
		newCase1.Country__c = 'Italy';
		newCase1.reason = 'New problem';
		newCase1.Subject = 'Survey Closed Case';
		newCase1.CH_Summary__c = 'TestSub';
		newCase1.Type = 'Incident';
		newCase1.Description = 'TEST';
		newCase1.Severity__c = 'Major';
		newCase1.CH_Outage__c = 'No';
		newCase1.Status = 'Created';
		newCase1.CH_IssueOccurenceDate__c = system.today();
		newCase1.ProductId = productList[1].id;
		newCase1.CH_Initial_Assignment__c = true;
		newCase1.CH_SystemRestoredTargetDate__c = system.now();
		newCase1.CH_Reassignment__c = true;
		newCase1.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		newCase1.EntitlementId = entitlement.Id;
		newCase1.BusinessHoursId = newCase.BusinessHoursId;
		newCase1.ownerId = userinfo.getUserId();
		newCase1.CH_3rdPartySecurityGroup__c = 'TestGroup';
		newCase1.CH_GWC_SecurityGroup__c = 'TestGroup';
		newCase1.CH_SecurityGroup__c = 'TestGroup';
		newCase1.CH_LegacyCaseNumber__c = '12345';
		newCase1.CH_LegacyCaseStatus__c  = 'Open';
		newCase1.CH_EntitlementException__c = 'Account Not Listed';
		newCase1.CH_ServiceType__c = 'Internal Support';
		newCase1.ownerid = userInfo.getUserId();
		
		List<Case> caseLstToInsert = new List<Case>();
		caseLstToInsert.add(newCase);   
		
		caseLstToInsert.add(newCase1);  
		insert caseLstToInsert;
		Test.stopTest();
		caseLstToInsert[0].Country__c = 'India';
		caseLstToInsert[1].Country__c = 'Italy';
		caseLstToInsert[0].CH_NotificationSent__c='T1';
		update caseLstToInsert;
		Id excDomainRecordTypeId = Schema.SObjectType.CH_NotificationSubscription__c.getRecordTypeInfosByDeveloperName().get('CH_Executive_Domain').getRecordTypeId();
		Id wgDomainRecordTypeId = Schema.SObjectType.CH_NotificationSubscription__c.getRecordTypeInfosByDeveloperName().get('CH_Workgroup_Domain').getRecordTypeId();
		List<CH_NotificationSubscription__c> nsLst = new List<CH_NotificationSubscription__c>();
		CH_NotificationSubscription__c ns = new CH_NotificationSubscription__c(CH_BusinessGroup__c='ALL', CH_BusinessUnit__c='ALL',CH_Country__c='ALL',CH_LegalEntityAccount__c='ALL',CH_Product__c='ALL',CH_Region__c='ALL',CH_Workgroup__c='ALL',CH_EventType__c='ALL',CH_NotificationMode__c='Push Notification + Email',RecordTypeId=excDomainRecordTypeId,OwnerId = userinfo.getUserId());
		nsLst.add(ns);
		
		CH_NotificationSubscription__c ns1 = new CH_NotificationSubscription__c(CH_BusinessGroup__c='FN Fixed Networks', CH_BusinessUnit__c='FN BBA',CH_Country__c='',CH_LegalEntityAccount__c='',CH_Product__c='',CH_Region__c='ALL',CH_Workgroup__c='',CH_EventType__c='ALL',CH_NotificationMode__c='Push Notification + Email',RecordTypeId=wgDomainRecordTypeId,OwnerId = userinfo.getUserId());
		nsLst.add(ns1);
		insert nsLst;
		
		List<CH_NotificationSubscriptionDetail__c> nsDetilsLst = new List<CH_NotificationSubscriptionDetail__c>();
		CH_NotificationSubscriptionDetail__c nsDetils0 = new CH_NotificationSubscriptionDetail__c(CH_AttributeCode__c='', CH_AttributeName__c='', CH_AttributeRecordID__c=nsLst[0].Id, CH_AttributeType__c='Default',CH_NotificationSubscription__c=nsLst[0].Id );
		nsDetilsLst.add(nsDetils0);
		CH_NotificationSubscriptionDetail__c nsDetils = new CH_NotificationSubscriptionDetail__c(CH_AttributeCode__c='IN', CH_AttributeName__c='India', CH_AttributeRecordID__c='IN', CH_AttributeType__c='Country',CH_NotificationSubscription__c=nsLst[1].Id );
		nsDetilsLst.add(nsDetils);
		
		CH_NotificationSubscriptionDetail__c nsDetils1 = new CH_NotificationSubscriptionDetail__c(CH_AttributeCode__c='', CH_AttributeName__c=acc.Name, CH_AttributeRecordID__c=caseLstToInsert[0].AccountId, CH_AttributeType__c='Legal Entity Account',CH_NotificationSubscription__c=nsLst[1].Id );
		nsDetilsLst.add(nsDetils1);
		
		CH_NotificationSubscriptionDetail__c nsDetils2 = new CH_NotificationSubscriptionDetail__c(CH_AttributeCode__c=productList[0].ProductCode, CH_AttributeName__c=productList[0].Name, CH_AttributeRecordID__c=caseLstToInsert[0].ProductId, CH_AttributeType__c='Product',CH_NotificationSubscription__c=nsLst[1].Id );
		nsDetilsLst.add(nsDetils2);
		
		insert nsDetilsLst;
		
		CH_CNNotificationLimits__c setting = new CH_CNNotificationLimits__c();
			setting.CH_NotificationLimitName__c = 'Subscription Record Count';
			setting.CH_NotificationLimitValue__c = '1';
			setting.Name = 'Subscription Record Count';
			insert setting;
		
		Map<Id, Case> oldCaseMap = new Map<Id,Case>();
		Case c = new Case(Id =caseLstToInsert[0].Id, CH_Outage__c='Yes', Severity__c ='Critical', Status='Assigned',CH_Workgroup__c=WgrpRecds[1].Id);
		oldCaseMap.put(c.Id, c);
		
		Id jobId = System.enqueueJob(new CH_CN_IdentifySubscribersQueueable(new Set<id>{caseLstToInsert[0].Id, caseLstToInsert[1].Id}, oldCaseMap, false, false, false, null));
		CH_CN_IdentifySubscribers.identifySubscribersfromDistributCommentUpdate(new List<id>{caseLstToInsert[0].Id});
		List<Case> caseLst = [SELECT Id, Subject, AccountId, Account.Market__c,Country__c, ProductId, Status,CH_Rep_Product_Business_group__c,CH_BusinessUnit__c,Severity__c,CH_Outage__c,CaseNumber, Account.ParentId, CH_Workgroup__c, CH_Workgroup__r.Name,CH_ExternalBridge__c,CH_InternalBridge__c,Comment__c,Account.Name, CH_Product_Name__c,CH_GWC_SecurityGroup__c, CH_SecurityGroup__c,CH_3rdPartySecurityGroup__c,CH_ReportedDate__c, CH_CurrentQueue__c, RecordTypeId, RecordType.Name FROM Case limit 10];
		Map<Case, Map<String, List<CH_NotificationSubscription__c>>> casEvtNSMap = CH_CN_IdentifySubscribers.identifySubscribersWithEvents(caseLst, oldCaseMap, true ,false, false, null, '12345');
		Id jobId1 = System.enqueueJob(new CH_CN_NotificationSubContentQueueable(casEvtNSMap,new Set<id>{caseLstToInsert[0].Id},'1122'));

		CH_CN_IdentifySubscribers.identifySubscribersWithEvents(caseLst, oldCaseMap, false ,true, false, null, '0011');		
		 
		Map<case,Map<string,List<CH_NotificationSubscription__c>>> caseEventMap =  new Map<case,Map<string,List<CH_NotificationSubscription__c>>>();
		Map<string,List<CH_NotificationSubscription__c>> caseEventMap1= new Map<string,List<CH_NotificationSubscription__c>>();
		 
		 caseEventMap1.put('All',nsLst);
		 caseEventMap.put(newCase1,caseEventMap1);
		 
		Map<Id,Integer> T1Map= new Map<Id,Integer>();
		T1Map.put(caseLstToInsert[1].Id,15);
		
		CH_CN_IdentifySubscribers.identifySubscribersWithEvents(caseLstToInsert, null, false ,true, false,T1Map, 'abc123');
		CH_CN_EventTypeNotifications eveT1 = new CH_CN_EventTypeNotifications(T1Map);
		DataBase.executeBatch(eveT1);
	
	}
}