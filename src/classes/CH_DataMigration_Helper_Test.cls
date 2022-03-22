@isTest
public class CH_DataMigration_Helper_Test {
	
	//test start for CompleteMilestoneonInsert
	public static testMethod void testCompleteMilestoneOnInsert(){
		
		CH_EntitlementTestData.createCustomSettingData();
		integer j = 1;
		List <Account> createAccountListNL = new List<Account>();
		createAccountListNL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
		insert createAccountListNL;
		
		List <Account> createAccountListLE = new List<Account>();
		createAccountListLE = CH_EntitlementTestData.createAccountRecord(j, 'Legal_Entity', createAccountListNL);
		insert createAccountListLE;
		
		List <Contact> createConatctList = new List<Contact>();
		createConatctList = CH_EntitlementTestData.createContactRecord(j,createAccountListNL);
		insert createConatctList;
		
		List<Product2> createProductList =new List<Product2>();
		createProductList = CH_EntitlementTestData.createProductRecord(j);
		insert createProductList;
		
		List<PricebookEntry> createPricebook =new List <PricebookEntry>();
		createPricebook = CH_EntitlementTestData.createPricebookEntryRecord(j, createProductList);
		insert createPricebook;
		
		Pricebook2 createCustomPB1 = new Pricebook2();
		createCustomPB1.Id = CH_EntitlementTestData.CreateCustomPriceBook();
		
		List<PricebookEntry> createCustomPriceBook =new List <PricebookEntry>();
		createCustomPriceBook = CH_EntitlementTestData.createCustomPricebookEntryRecord(j, createProductList, createCustomPB1.id);
		insert createCustomPriceBook;
		
		
		List<ServiceContract> createServiceContractList =new List<ServiceContract>();
		createServiceContractList = CH_EntitlementTestData.createServiceContractRecord(j, createAccountListNL, null, createCustomPB1.id );
		insert createServiceContractList;  
		
		
		List<Asset> assetObjList = new List<Asset>();
		for(Integer i=0;i<j;i++){				
			Asset assetObj = new Asset();
			assetObj.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_CoveredProduct').Id;
			assetObj.Name = 'Test Asset';
			assetObj.Product2Id = createProductlist[i].id;
			assetObj.AccountId = createAccountListLE[i].id;
			assetObjList.add(assetObj);
		}
		insert assetObjList;
		
		ContractLineItem contLine = new ContractLineItem();
		contLine.PricebookEntryId = createCustomPriceBook[0].id;
		contLine.Quantity = 55;
		contLine.UnitPrice = 55;
		contLine.ServiceContractId = createServiceContractList[0].id;
		ContLine.CH_ServiceOffering__c = 'Test';
		contLine.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';
		contLine.CH_CDB_EntitlementId__c = '1test';
		contLine.AssetId = assetObjList[0].id;
		insert contLine;  
		
		SlaProcess slaProcess = [SELECT Id FROM SlaProcess WHERE Name = 'Legacy Customer Support Service - No Severity 24x7' LIMIT 1];
		List<Entitlement> entitlementlist =new List<Entitlement>();
		for(integer i=0;i<j;i++){
			Entitlement createEntitlementRec = new Entitlement();
			createEntitlementRec.Name ='test'+ i;
			createEntitlementRec.AccountId = createAccountListLE[i].id;
			createEntitlementRec.CH_CDB_EntitlementId__c = '1test'+ i;
			createEntitlementRec.StartDate = System.today();
			createEntitlementRec.EndDate = System.today() + 10;
			createEntitlementRec.ContractLineItemId = contLine.id;
			createEntitlementRec.AssetId = assetObjList[i].id;
			createEntitlementRec.CH_EntitlementType__c = 'Entitled Asset';
			createEntitlementRec.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
			createEntitlementRec.ServiceContractId = createServiceContractList[i].id;
			createEntitlementRec.SlaProcessId = slaProcess.id;
			entitlementlist.add(createEntitlementRec);
		}
		insert entitlementlist;
		
		
		EntitlementContact entContact = new EntitlementContact();
		entContact.EntitlementId = entitlementlist[0].id;
		entContact.ContactId = createConatctList[0].id; 
		insert entContact;
		
		// Create CH_CustomerSpecificTargetSLA__c
		List < CH_CustomerSpecificTargetSLA__c > slaLst = new List < CH_CustomerSpecificTargetSLA__c > ();
		for(Integer i=0; i<5; i++) {
			CH_CustomerSpecificTargetSLA__c slaRec = new CH_CustomerSpecificTargetSLA__c();
			slaRec.CH_Account__c = createAccountListLE[0].id;
			slaRec.CH_Entitlement__c = entitlementlist[0].Id;
			slaRec.CH_ServiceContract__c = createServiceContractList[0].Id;
			slaRec.CH_LineItemNumber__c = contLine.Id;
			slaRec.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
			slaRec.CH_SLARecordStatus__c = 'Active';
			slaRec.CH_IR_WorkMins__c = 10 * (i+1);
			slaRec.CH_SR_WorkMins__c = 20 * (i+1);
			slaRec.CH_TSP_WorkMins__c = 30 * (i+1);
			slaRec.CH_SDR_WorkMins__c = 40 * (i+1);
			slaRec.CH_SP_WorkMins__c = 50 * (i+1);
			slaRec.CH_SPD_WorkMins__c = 60 * (i+1);
			slaLst.add(slaRec);
		}
		slaLst[0].CH_Severity__c = 'Critical';
		slaLst[0].CH_Outage__c = 'Yes';
		system.debug('CH_IR_WorkMins__c' +  slaLst[0].CH_IR_WorkMins__c );
		slaLst[1].CH_Severity__c = 'Major';
		slaLst[1].CH_Outage__c = 'Yes';
		
		slaLst[2].CH_Severity__c = 'Major';
		slaLst[2].CH_Outage__c = 'No';
		
		slaLst[3].CH_Severity__c = 'Minor';
		slaLst[3].CH_Outage__c = 'No';
		
		slaLst[4].CH_Severity__c = 'Information Request';
		slaLst[4].CH_Outage__c = 'No';
		insert slaLst;
		
		System.assertNotEquals(slaLst[0].Id, null);
		System.assertNotEquals(slaLst[1].Id, null);
		System.assertNotEquals(slaLst[2].Id, null);
		System.assertNotEquals(slaLst[3].Id, null);
		System.assertNotEquals(slaLst[4].Id, null);
		try{
			Case caseObj = new Case();
			caseObj.AccountId = createAccountListLE[0].id;
			caseObj.ContactId = createConatctList[0].id;
			caseObj.AssetId = assetObjList[0].id;
			caseObj.CH_ReportedDate__c = DateTime.Now();
			caseObj.Mobile_Phone__c = '123-456789';
			caseObj.Country__c = 'India';
			caseObj.reason = 'New problem';
			caseObj.Subject = 'Survey Closed Case';
			caseObj.CH_Summary__c = 'TestSub';
			caseObj.Type = 'Incident';
			caseObj.Description = 'TEST';
			caseObj.Severity__c = slaLst[2].CH_Severity__c;
			caseObj.CH_Outage__c = slaLst[2].CH_Outage__c;
			caseObj.Status = 'Created';
			caseObj.CH_IssueOccurenceDate__c = system.today();
			caseObj.ProductId = createProductList[0].Id;
			caseObj.CH_Initial_Assignment__c = true;
			caseObj.CH_SystemRestoredTargetDate__c = system.now();
			caseObj.CH_Reassignment__c = true;
			caseObj.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
			caseObj.EntitlementId = entitlementlist[0].id;
			caseObj.NCP_Service_Contract__c = createServiceContractList[0].Id;
			caseObj.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
			caseObj.ownerId = userinfo.getUserId();
			
			caseObj.CH_LegacyCaseNumber__c = '12345';
			caseObj.CH_LegacyCaseStatus__c  = 'Open';
			caseObj.CH_IsSolutionProvidedSLA__c = true;
			caseObj.CH_SolutionProvided__c = Date.Today();
			caseObj.CH_IsCompleteSolutionProvided__c = true;
			caseObj.CH_LegacySolutionProvidedTargetDate__c  = System.today();
			caseObj.CH_LegacyTemporarySolutionTargetDate__c   = System.today();
			caseObj.CH_LegacySystemRestoredTargetDate__c	= System.today(); 
			caseObj.CH_LegacyInitialResponseTargetDate__c =System.today();
			caseObj.CH_TemporarySolutionNotApplicable__c = false;
			caseObj.CH_IsTemporarySolutionProvidedSLA__c = true;
			caseObj.CH_TemporarySolutionProvided__c =System.today();
			caseObj.CH_IsCompleteTemporarySolution__c = true;
			caseObj.CH_IsServiceDisruptionReportSLA__c  = true;
			caseObj.CH_IsSystemRestoredSLA__c = true;
			caseObj.CH_IsCompleteRestore__c = true;
			caseObj.CH_SystemRestored__c = Date.Today();
			caseObj.CH_IsInitialResponseSLA__c = true;
			caseObj.CH_EntitlementException__c = 'No Exception';
			caseObj.CH_ServiceType__c = 'Customer Support';	 
			caseObj.CH_ExternalSystemAccount__c='MVV40016|A3/E-W/03/3|Firma NSN';
			Test.startTest();		   
			insert caseObj;	 
			List < MilestoneType > mTypes = [SELECT Id, Name FROM MilestoneType] ;
			System.assertNotEquals(mTypes, null);
			System.assertEquals(mTypes.isEmpty(), false);
			
			CH_CaseMilestoneTimeCalculator timeCalculator = new CH_CaseMilestoneTimeCalculator();
			Integer slaTime = 1;
			for(MilestoneType mtObj: mTypes) {
				if((mtObj.Name == System.Label.CH_LegacyInitialResponse) || (mtObj.Name == System.Label.CH_LegacySystemRestored) || (mtObj.Name == System.Label.CH_LegacyTemporarySolutionProvided) || (mtObj.Name == System.Label.CH_LegacySolutionProvided ) ) {
					slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj.Id, mtObj.Id);
				}				 
			}
			
			
			caseObj.Status = 'Cancelled';
			caseObj.CH_ReasonForCancellation__c = 'testing';
			update caseObj;				
			
			list<Case> aCases2 = new list<Case>([SELECT Id,CH_LegacyCaseNumber__c, Status,CaseNumber,CH_InitialResponse__c,RecordTypeId,CH_SystemRestored__c,CH_TemporarySolutionProvided__c, CH_SolutionProvided__c,CH_RecordTypeCheck__c,EntitlementId,CH_IsCompleteInitialResponse__c,CH_IsCompleteRestore__c,CH_IsCompleteTemporarySolution__c,CH_IsCompleteSolutionProvided__c,  (SELECT Id, CompletionDate, CaseId, MilestoneTypeId, MilestoneType.Name FROM CaseMilestones) FROM Case WHERE Id =:caseObj.Id]);   
			system.assertEquals(aCases2.size(), 1); 
			system.debug('caseslist'+aCases2);
			
			Set <Id> caseIds = new Set <Id> ();
			for (Case caseObje : aCases2){
				caseIds.add(caseObje.Id);
			}
			List < CaseMilestone > cmList = new list<CaseMilestone>([SELECT Id, CompletionDate, CaseId, MilestoneTypeId, MilestoneType.Name FROM CaseMilestone WHERE CaseId = :caseIds]);
			
			
			system.debug('CaseMls start date####'+cmList[0].MilestoneType.Name);
			update cmList;
			system.debug('CaseMls start date#### update'+cmList[0].MilestoneType.Name);
			
			
			CH_DataMigration_Helper.completeMilestoneOnCancellationforLegacy(aCases2);
			Test.stopTest();
		}Catch(Exception ex) {
			System.debug('### Exception has raised : ' + ex.getMessage());
		}
		
	} 
	
	
	
	
}