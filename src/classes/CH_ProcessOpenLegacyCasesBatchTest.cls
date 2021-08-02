@isTest
private class CH_ProcessOpenLegacyCasesBatchTest {
	public static Profile profile = [Select Id from Profile where name = 'Data Loader Profile' LIMIT 1];
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
	@testSetup static void testDataSetup(){
		CH_EntitlementTestData.createCustomSettingData();
		integer j = 1;
		System.runAs(dataLoaderUser){
			List <Account> AccountListNL = new List<Account>();
			AccountListNL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
			insert AccountListNL;
			
			List <Account> AccountListLE = new List<Account>();
			AccountListLE = CH_EntitlementTestData.createAccountRecord(j, 'Legal_Entity', AccountListNL);
			insert AccountListLE;
			
			List <Contact> ConatctList = new List<Contact>();
			ConatctList = CH_EntitlementTestData.createContactRecord(j,AccountListNL);
			insert ConatctList;
			
			List<Product2> productlist =new List<Product2>();
			productlist = CH_EntitlementTestData.createProductRecord(j);
			insert productlist;
			
			List<PricebookEntry> pricebook =new List <PricebookEntry>();
			pricebook = CH_EntitlementTestData.createPricebookEntryRecord(j, productlist);
			insert pricebook;
			
			Pricebook2 customPB1 = new Pricebook2();
			customPB1.Id = CH_EntitlementTestData.CreateCustomPriceBook();
			
			List<PricebookEntry> Custompricebook =new List <PricebookEntry>();
			Custompricebook = CH_EntitlementTestData.createCustomPricebookEntryRecord(j, productlist, customPB1.id);
			insert Custompricebook;		
			
			
			id chId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
			Case caseObj = new Case();
			caseObj.AccountId =  AccountListLE[0].id;
			caseObj.Subject = 'Test Case';
			caseObj.Description = 'Test Case';
			caseObj.ContactId = ConatctList[0].id;
			caseObj.ProductId = productlist[0].Id;
			caseObj.Country__c = 'India';
			caseObj.Severity__c = 'Information Request';
			caseObj.CH_Outage__c = 'No';
			caseObj.CH_Defect__c = false;
			caseObj.CH_LegacyCaseNumber__c = '12345678';
			caseObj.CH_LegacyCaseStatus__c = 'Open';
			caseObj.RecordTypeId = chId;
			insert caseObj;
			
			
			CH_UTIL_TEST.createCustomSettings();
			CH_UTIL_TEST.createNokiaUsers();
			CH_UTIL_TEST.createAccounts();
			CH_UTIL_TEST.createProducts();
			CH_UTIL_TEST.createWorkgroups();
			
			
			//Suniti test code start
			
			List<ServiceContract> ServiceContractlist =new List<ServiceContract>();
			ServiceContractlist = CH_EntitlementTestData.createServiceContractRecord(j, AccountListNL, null, customPB1.id );
			insert ServiceContractlist;
			
			Id assetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Covered Product').getRecordTypeId();
			List<Asset> assetObjList = new List<Asset>();
			for(Integer i=0;i<j;i++){	 
			Asset assetObj = new Asset();
			assetObj.RecordTypeId = assetRecordTypeId;
			assetObj.Name = 'Test Asset';
			assetObj.Product2Id = productlist[i].id;
			assetObj.AccountId = AccountListLE[i].id;			
			assetObjList.add(assetObj);
			}
	insert assetObjList;
		
	  ContractLineItem contLine = new ContractLineItem();			
			contLine.PricebookEntryId = Custompricebook[0].id;
			contLine.Quantity = 55;
			contLine.UnitPrice = 55;
			contLine.ServiceContractId = ServiceContractlist[0].id;
			ContLine.CH_ServiceOffering__c = 'Test';
			//contLine.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';
			contLine.CH_CDB_EntitlementId__c = '1test123456';
			contLine.AssetId = assetObjList[0].id;
			insert contLine;
			
		SlaProcess slaProcess = [SELECT Id FROM SlaProcess WHERE Name = 'Legacy Customer Support Service - Critical 24x7' and IsVersionDefault=true LIMIT 1];
		List<Entitlement> entitlementlist =new List<Entitlement>();
		for(integer i=0;i<j;i++){
			Entitlement entiObj = new Entitlement();
			entiObj.Name ='test'+ i;
			entiObj.AccountId = AccountListLE[i].id;
			entiObj.CH_CDB_EntitlementId__c = '1test123456';
			entiObj.StartDate = System.today();
			entiObj.EndDate = System.today() + 10;
			entiObj.ContractLineItemId = contLine.id;
			entiObj.AssetId = assetObjList[i].id;
			//entiObj.BusinessHoursId = stdBusinessHours;
			entiObj.CH_EntitlementType__c = 'Entitled Asset';
			entiObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical 24x7';
			entiobj.ServiceContractId = ServiceContractlist[i].id;
			entiobj.SlaProcessId = slaProcess.id;
			entitlementlist.add(entiObj);
		}
		insert entitlementlist;
		
		EntitlementContact entcon = new EntitlementContact();
		entcon.EntitlementId = entitlementlist[0].id;
		entcon.ContactId = ConatctList[0].id;	
		insert entcon;
			
	//Create CH_CustomerSpecificTargetSLA__c
	List < CH_CustomerSpecificTargetSLA__c > slaList = new List < CH_CustomerSpecificTargetSLA__c > ();
	 for(Integer i=0; i<5; i++) {
			CH_CustomerSpecificTargetSLA__c slaObj = new CH_CustomerSpecificTargetSLA__c();
			slaObj.CH_Account__c = AccountListLE[0].id;
			slaObj.CH_Entitlement__c = entitlementlist[0].Id;
			slaObj.CH_ServiceContract__c = ServiceContractlist[0].Id;
			slaObj.CH_LineItemNumber__c = contLine.Id;
			//slaObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical 24x7';
			slaObj.CH_SLARecordStatus__c = 'Active';
			slaObj.CH_IR_WorkMins__c = 10 * (i+1);
			slaObj.CH_SR_WorkMins__c = 20 * (i+1);
			slaObj.CH_TSP_WorkMins__c = 30 * (i+1);
			slaObj.CH_SDR_WorkMins__c = 40 * (i+1);
			slaObj.CH_SP_WorkMins__c = 50 * (i+1);
			slaObj.CH_SPD_WorkMins__c = 60 * (i+1);
			slaObj.CH_Severity__c = 'Critical';
			slaObj.CH_Outage__c = 'Yes';
			slaList.add(slaObj);
		}
		slaList[0].CH_Severity__c = 'Critical';
		slaList[0].CH_Outage__c = 'Yes';
		system.debug('CH_IR_WorkMins__c' +  slaList[0].CH_IR_WorkMins__c );
		slaList[1].CH_Severity__c = 'Major';
		slaList[1].CH_Outage__c = 'Yes';
		
		slaList[2].CH_Severity__c = 'Major';
		slaList[2].CH_Outage__c = 'No';
		
		slaList[3].CH_Severity__c = 'Minor';
		slaList[3].CH_Outage__c = 'No';
		
		slaList[4].CH_Severity__c = 'Information Request';
		slaList[4].CH_Outage__c = 'No';
		insert slaList;
		
		System.assertNotEquals(slaList[0].Id, null);
		System.assertNotEquals(slaList[1].Id, null);
		System.assertNotEquals(slaList[2].Id, null);
		System.assertNotEquals(slaList[3].Id, null);
		System.assertNotEquals(slaList[4].Id, null);
			
			//case creation
			
					// Creation of Case
		Case caseObj1 = new Case();
		caseObj1.AccountId = AccountListLE[0].id;
		caseObj1.ContactId = ConatctList[0].id;
		caseObj1.AssetId = assetObjList[0].id;
		caseObj1.CH_ReportedDate__c = DateTime.Now();
		caseObj1.Mobile_Phone__c = '123-456789';
		caseObj1.Country__c = 'India';
		caseObj1.reason = 'New problem';
		caseObj1.Subject = 'Survey Closed Case';
		caseObj1.CH_Summary__c = 'TestSub';
		caseObj1.Type = 'Incident';
		caseObj1.Description = 'TEST';
		caseObj1.Severity__c = slaList[0].CH_Severity__c;
		caseObj1.CH_Outage__c = slaList[0].CH_Outage__c;
		caseObj1.Status = 'Created';
		caseObj1.CH_IssueOccurenceDate__c = system.today();
		caseObj1.ProductId = productlist[0].Id;
		caseObj1.CH_Initial_Assignment__c = true;
		caseObj1.CH_SystemRestoredTargetDate__c = system.now();
		caseObj1.CH_Reassignment__c = true;
		caseObj1.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
		caseObj1.EntitlementId = entitlementlist[0].id;
		caseObj1.NCP_Service_Contract__c = ServiceContractlist[0].Id;
		caseObj1.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		caseObj1.ownerId = userinfo.getUserId();
			
		caseObj1.CH_LegacyCaseNumber__c = '12345';
		caseObj1.CH_LegacyCaseStatus__c  = 'Open';
		caseObj1.CH_IsSolutionProvidedSLA__c = true;
		caseObj1.CH_SolutionProvided__c = Date.Today();
		caseObj1.CH_IsCompleteSolutionProvided__c = true;
		caseObj1.CH_LegacySolutionProvidedTargetDate__c  = System.today();
		caseObj1.CH_LegacyTemporarySolutionTargetDate__c   = System.today();
		caseObj1.CH_LegacySystemRestoredTargetDate__c	= System.today(); 
		caseObj1.CH_LegacyInitialResponseTargetDate__c =System.today();
		caseObj1.CH_TemporarySolutionNotApplicable__c = false;
		caseObj1.CH_IsTemporarySolutionProvidedSLA__c = true;
		caseObj1.CH_TemporarySolutionProvided__c =System.today();
		caseObj1.CH_IsCompleteTemporarySolution__c = true;
		caseObj1.CH_IsServiceDisruptionReportSLA__c  = true;
		caseObj1.CH_IsSystemRestoredSLA__c = true;
		caseObj1.CH_IsCompleteRestore__c = true;
		caseObj1.CH_SystemRestored__c = Date.Today();
		caseObj1.CH_IsInitialResponseSLA__c = true;
		caseObj1.CH_EntitlementException__c = 'No Exception';
		caseObj1.CH_ServiceType__c = 'Internal Support';		
		caseObj1.CH_ExternalSystemAccount__c='MVV40016|A3/E-W/03/3|Firma NSN';
		caseObj1.CH_CaseOriginSystem__c ='tmobile-tim';
		
		insert caseObj1;
	
			List < MilestoneType > mTypes = [SELECT Id, Name FROM MilestoneType] ;
			System.assertNotEquals(mTypes, null);
			System.assertEquals(mTypes.isEmpty(), false);
			
			CH_CaseMilestoneTimeCalculator timeCalculator = new CH_CaseMilestoneTimeCalculator();
			Integer slaTime = 1;
			for(MilestoneType mtObj: mTypes) {
	for(Integer i=0; i<j; i++){	
		if(mtObj.Name == System.Label.CH_LegacyInitialResponse) {
			slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
			//System.assertEquals(slaTime, 1440);
		  } else if(mtObj.Name == System.Label.CH_LegacySystemRestored) {
			slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
			}else if(mtObj.Name == System.Label.CH_LegacyTemporarySolutionProvided) {
			slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
			}   else if(mtObj.Name == System.Label.CH_LegacySolutionProvided) {
			slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
			}
		} }	
			
			list<Case> newCaseList = new list<Case>([SELECT Id, Status,CaseNumber,CH_InitialResponse__c,CH_SystemRestored__c,CH_TemporarySolutionProvided__c, CH_SolutionProvided__c FROM Case where Id = :caseObj1.Id]);
			system.assertEquals(newCaseList.size(), 1);			
			
			Map < Id, Case > newCaseMap = new Map < Id, Case > (newCaseList);		
			List < CaseMilestone > cmList = new list<CaseMilestone>([SELECT Id, CompletionDate, CaseId, MilestoneTypeId, MilestoneType.Name FROM CaseMilestone WHERE CaseId = :caseObj1.Id]);
			system.debug('CaseMls start date####'+cmList);
			
			if(cmList != null && !cmList.isEmpty()) {
	for(CaseMilestone cmObj: cmList) {
		Case caseObje = newCaseMap.get(cmObj.CaseId);
		if(caseObje != null && String.isNotBlank(cmObj.MilestoneTypeId)) {			
			if(caseObje.CH_InitialResponse__c !=null){
				if(cmObj.MilestoneType.Name == System.Label.CH_LegacyInitialResponse) {
		cmObj.CompletionDate = caseObje.CH_InitialResponse__c;
				}}
			 if(caseObje.CH_SystemRestored__c !=null){
				if(cmObj.MilestoneType.Name == System.Label.CH_LegacySystemRestored) {
		cmObj.CompletionDate = caseObje.CH_SystemRestored__c;
				}}
			 if(caseObje.CH_TemporarySolutionProvided__c !=null){
				if(cmObj.MilestoneType.Name == System.Label.CH_LegacyTemporarySolutionProvided) {
		cmObj.CompletionDate = caseObje.CH_TemporarySolutionProvided__c;
				}}
			 if(caseObje.CH_SolutionProvided__c !=null){
				if(cmObj.MilestoneType.Name == System.Label.CH_LegacySolutionProvided) {
		cmObj.CompletionDate = caseObje.CH_SolutionProvided__c;
				}}			
		} }	
	update cmList;			
			}
			
			// Suniti test code end */
			
			
		}
	}
	
	
	public static testmethod void testOpenBatchClass(){
		test.startTest();
		CH_ProcessOpenLegacyCasesBatch  batch = new CH_ProcessOpenLegacyCasesBatch();
		Database.executebatch(batch,10);  
		
		CH_ProcessOpenLegacyCasesBatch sh1 = new CH_ProcessOpenLegacyCasesBatch();
		String sch = '0 0 23 * * ?'; 
		system.schedule('Test Territory Check', sch, sh1);
		
		test.stopTest();
		
		
		
	}
}