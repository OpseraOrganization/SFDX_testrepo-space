@isTest
private class CH_ProcessOpenLegacyCasesBatchTest {
	public static Profile getProfile = [Select Id from Profile where name = 'Data Loader Profile' LIMIT 1];
	public static User getdataLoaderUser = new User(
		Lastname='DataLoad',
		Firstname='USER',
		Alias = 'DL-OWNER',
		ProfileId = getProfile.Id,
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
		System.runAs(getdataLoaderUser){
			List <Account> acctListNL = new List<Account>();
			acctListNL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
			insert acctListNL;
			
			List <Account> accountLstLE = new List<Account>();
			accountLstLE = CH_EntitlementTestData.createAccountRecord(j, 'Legal_Entity', acctListNL);
			insert accountLstLE;
			
			List <Contact> contactLst = new List<Contact>();
			contactLst = CH_EntitlementTestData.createContactRecord(j,acctListNL);
			insert contactLst;
			
			List<Product2> prdctList =new List<Product2>();
			prdctList = CH_EntitlementTestData.createProductRecord(j);
			insert prdctList;
			
			List<PricebookEntry> pricebookLst =new List <PricebookEntry>();
			pricebookLst = CH_EntitlementTestData.createPricebookEntryRecord(j, prdctList);
			insert pricebookLst;
			
			Pricebook2 createCustmPriceBook = new Pricebook2();
			createCustmPriceBook.Id = CH_EntitlementTestData.CreateCustomPriceBook();
			
			List<PricebookEntry> Custompricebook =new List <PricebookEntry>();
			Custompricebook = CH_EntitlementTestData.createCustomPricebookEntryRecord(j, prdctList, createCustmPriceBook.id);
			insert Custompricebook;		
			
			
			id chId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
			Case caseObj = new Case();
			caseObj.AccountId =  accountLstLE[0].id;
			caseObj.Subject = 'Test Case';
			caseObj.Description = 'Test Case';
			caseObj.ContactId = contactLst[0].id;
			caseObj.ProductId = prdctList[0].Id;
			caseObj.Country__c = 'India';
			caseObj.Severity__c = 'Information Request';
			caseObj.CH_Outage__c = 'No';
			caseObj.CH_Defect__c = false;
			caseObj.CH_LegacyCaseNumber__c = '12345678';
			caseObj.CH_LegacyCaseStatus__c = 'Open';
			caseObj.RecordTypeId = chId;
			caseObj.CH_CaseOriginSystem__c = 'orange-irma';
			caseObj.Origin = 'S2S';
			insert caseObj;
			CH_UTIL_TEST.createCustomSettings();
			CH_UTIL_TEST.createNokiaUsers();
			CH_UTIL_TEST.createAccounts();
			CH_UTIL_TEST.createProducts();
			CH_UTIL_TEST.createWorkgroups();
			
			List<ServiceContract> ServiceContractlist =new List<ServiceContract>();
			ServiceContractlist = CH_EntitlementTestData.createServiceContractRecord(j, acctListNL, null, createCustmPriceBook.id );
			insert ServiceContractlist;
			
			Id assetRecrdTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_CoveredProduct').getRecordTypeId();
			List<Asset> assetObjLst = new List<Asset>();
			for(Integer i=0;i<j;i++){	 
				Asset createAssetRec = new Asset();
				createAssetRec.RecordTypeId = assetRecrdTypeId;
				createAssetRec.Name = 'Test Asset';
				createAssetRec.Product2Id = prdctList[i].id;
				createAssetRec.AccountId = accountLstLE[i].id;			
				assetObjLst.add(createAssetRec);
			}
			insert assetObjLst;
			
			ContractLineItem createcontLineItem = new ContractLineItem();			
			createcontLineItem.PricebookEntryId = Custompricebook[0].id;
			createcontLineItem.Quantity = 55;
			createcontLineItem.UnitPrice = 55;
			createcontLineItem.ServiceContractId = ServiceContractlist[0].id;
			createcontLineItem.CH_ServiceOffering__c = 'Test';
			createcontLineItem.CH_CDB_EntitlementId__c = '1test123456';
			createcontLineItem.AssetId = assetObjLst[0].id;
			insert createcontLineItem;
			
			SlaProcess slaProcess = [SELECT Id FROM SlaProcess WHERE Name = 'Legacy Customer Support Service - Critical 24x7' and IsVersionDefault=true LIMIT 1];
			List<Entitlement> entitlemntLst =new List<Entitlement>();
			for(integer i=0;i<j;i++){
				Entitlement entitlemntObj = new Entitlement();
				entitlemntObj.Name ='test'+ i;
				entitlemntObj.AccountId = accountLstLE[i].id;
				entitlemntObj.CH_CDB_EntitlementId__c = '1test123456';
				entitlemntObj.StartDate = System.today();
				entitlemntObj.EndDate = System.today() + 10;
				entitlemntObj.ContractLineItemId = createcontLineItem.id;
				entitlemntObj.AssetId = assetObjLst[i].id;
				entitlemntObj.CH_EntitlementType__c = 'Entitled Asset';
				entitlemntObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical 24x7';
				entitlemntObj.ServiceContractId = ServiceContractlist[i].id;
				entitlemntObj.SlaProcessId = slaProcess.id;
				entitlemntLst.add(entitlemntObj);
			}
			insert entitlemntLst;
			
			EntitlementContact entcon = new EntitlementContact();
			entcon.EntitlementId = entitlemntLst[0].id;
			entcon.ContactId = contactLst[0].id;	
			insert entcon;
			
			//Create CH_CustomerSpecificTargetSLA__c
			List < CH_CustomerSpecificTargetSLA__c > slaList = new List < CH_CustomerSpecificTargetSLA__c > ();
			for(Integer i=0; i<5; i++) {
				CH_CustomerSpecificTargetSLA__c slaObj = new CH_CustomerSpecificTargetSLA__c();
				slaObj.CH_Account__c = accountLstLE[0].id;
				slaObj.CH_Entitlement__c = entitlemntLst[0].Id;
				slaObj.CH_ServiceContract__c = ServiceContractlist[0].Id;
				slaObj.CH_LineItemNumber__c = createcontLineItem.Id;
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
			// Creation of Case
			Case caseObj1 = new Case();
			caseObj1.AccountId = accountLstLE[0].id;
			caseObj1.ContactId = contactLst[0].id;
			caseObj1.AssetId = assetObjLst[0].id;
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
			caseObj1.ProductId = prdctList[0].Id;
			caseObj1.CH_Initial_Assignment__c = true;
			caseObj1.CH_SystemRestoredTargetDate__c = system.now();
			caseObj1.CH_Reassignment__c = true;
			caseObj1.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
			caseObj1.EntitlementId = entitlemntLst[0].id;
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
			caseObj1.Origin = 'S2S';

			
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
		}
	}
	
	
	public static testmethod void testOpenBatchClass(){
		Test.startTest();
		CH_ProcessOpenLegacyCasesBatch  batch = new CH_ProcessOpenLegacyCasesBatch();
		Database.executebatch(batch,10);  
		Test.stopTest();
	}
	
	
}