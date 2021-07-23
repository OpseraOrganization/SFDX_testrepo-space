/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* 
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/

@isTest
private class CH_CaseTriggerHelperTest { 
	
	
	//Test
	//test start for CompleteMilestoneonInsert
	 public static testMethod void testCompleteMilestoneOnInsert(){
		
		CH_EntitlementTestData.createCustomSettingData();
		integer j = 1;
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
		
		
		List<ServiceContract> ServiceContractlist =new List<ServiceContract>();
		ServiceContractlist = CH_EntitlementTestData.createServiceContractRecord(j, AccountListNL, null, customPB1.id );
		insert ServiceContractlist;  
		
		/*List<ContractLineItem> ContractLineItemList =new List<ContractLineItem>();
		ContractLineItemList = CH_EntitlementTestData.createContractLineItemRecord(j, Custompricebook,ServiceContractlist);
		insert ContractLineItemList;*/
		
		List<Asset> assetObjList = new List<Asset>();
		for(Integer i=0;i<j;i++){				 
			Asset assetObj = new Asset();
			assetObj.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_CoveredProduct').Id;
			assetObj.Name = 'Test Asset';
			assetObj.Product2Id = productlist[i].id;
			assetObj.AccountId = AccountListLE[i].id;
			//assetObj.CH_Solution__c = productlist[i].id;
			// assetObj.CH_ProductVariant__c = productlist[i].id;
			//assetObj.CH_ProductRelease__c = ProdRelObjList[i].id;
			assetObjList.add(assetObj);
		}
		insert assetObjList;
		
		ContractLineItem contLine = new ContractLineItem();
			//contLine.CH_BusinessHourName__c = stdBusinessHours.Id;
			//contLine.CH_CDB_EntitlementId__c = entObj.CH_CDB_EntitlementId__c;
			contLine.PricebookEntryId = Custompricebook[0].id;
			contLine.Quantity = 55;
			contLine.UnitPrice = 55;
			contLine.ServiceContractId = ServiceContractlist[0].id;
			ContLine.CH_ServiceOffering__c = 'Test';
			contLine.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';
			contLine.CH_CDB_EntitlementId__c = '1test';
			contLine.AssetId = assetObjList[0].id;
		insert contLine;  
	   
		SlaProcess slaProcess = [SELECT Id FROM SlaProcess WHERE Name = 'Legacy Customer Support Service - No Severity 24x7' LIMIT 1];
		List<Entitlement> entitlementlist =new List<Entitlement>();
		for(integer i=0;i<j;i++){
			Entitlement entiObj = new Entitlement();
			entiObj.Name ='test'+ i;
			entiObj.AccountId = AccountListLE[i].id;
			entiObj.CH_CDB_EntitlementId__c = '1test'+ i;
			entiObj.StartDate = System.today();
			entiObj.EndDate = System.today() + 10;
			entiObj.ContractLineItemId = contLine.id;
			entiObj.AssetId = assetObjList[i].id;
			//entiObj.BusinessHoursId = stdBusinessHours;
			entiObj.CH_EntitlementType__c = 'Entitled Asset';
			entiObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
			entiobj.ServiceContractId = ServiceContractlist[i].id;
			entiobj.SlaProcessId = slaProcess.id;
			entitlementlist.add(entiObj);
		}
		insert entitlementlist;
		
		
		EntitlementContact entcon = new EntitlementContact();
		entcon.EntitlementId = entitlementlist[0].id;
		entcon.ContactId = ConatctList[0].id;	
		insert entcon;
		 
		// Create CH_CustomerSpecificTargetSLA__c
		List < CH_CustomerSpecificTargetSLA__c > slaList = new List < CH_CustomerSpecificTargetSLA__c > ();
		for(Integer i=0; i<5; i++) {
			CH_CustomerSpecificTargetSLA__c slaObj = new CH_CustomerSpecificTargetSLA__c();
			slaObj.CH_Account__c = AccountListLE[0].id;
			slaObj.CH_Entitlement__c = entitlementlist[0].Id;
			slaObj.CH_ServiceContract__c = ServiceContractlist[0].Id;
			slaObj.CH_LineItemNumber__c = contLine.Id;
			slaObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
			slaObj.CH_SLARecordStatus__c = 'Active';
			slaObj.CH_IR_WorkMins__c = 10 * (i+1);
			slaObj.CH_SR_WorkMins__c = 20 * (i+1);
			slaObj.CH_TSP_WorkMins__c = 30 * (i+1);
			slaObj.CH_SDR_WorkMins__c = 40 * (i+1);
			slaObj.CH_SP_WorkMins__c = 50 * (i+1);
			slaObj.CH_SPD_WorkMins__c = 60 * (i+1);
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
		try{
			Case caseObj = new Case();
		caseObj.AccountId = AccountListLE[0].id;
		caseObj.ContactId = ConatctList[0].id;
		caseObj.AssetId = assetObjList[0].id;
		caseObj.CH_ReportedDate__c = DateTime.Now();
		caseObj.Mobile_Phone__c = '123-456789';
		caseObj.Country__c = 'India';
		caseObj.reason = 'New problem';
		caseObj.Subject = 'Survey Closed Case';
		caseObj.CH_Summary__c = 'TestSub';
		caseObj.Type = 'Incident';
		caseObj.Description = 'TEST';
		caseObj.Severity__c = slaList[0].CH_Severity__c;
		caseObj.CH_Outage__c = slaList[0].CH_Outage__c;
		caseObj.Status = 'Created';
		caseObj.CH_IssueOccurenceDate__c = system.today();
		caseObj.ProductId = productlist[0].Id;
		caseObj.CH_Initial_Assignment__c = true;
		caseObj.CH_SystemRestoredTargetDate__c = system.now();
		caseObj.CH_Reassignment__c = true;
		caseObj.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
		caseObj.EntitlementId = entitlementlist[0].id;
		caseObj.NCP_Service_Contract__c = ServiceContractlist[0].Id;
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
		caseObj.CH_CaseOriginSystem__c ='tmobile-tim';
		Test.startTest();			
		insert caseObj;		  
							   
			List < MilestoneType > mTypes = [SELECT Id, Name FROM MilestoneType] ;
			System.assertNotEquals(mTypes, null);
			System.assertEquals(mTypes.isEmpty(), false);
			
			CH_CaseMilestoneTimeCalculator timeCalculator = new CH_CaseMilestoneTimeCalculator();
			Integer slaTime = 1;
			for(MilestoneType mtObj: mTypes) {
				for(Integer i=0; i<j; i++){
					if(mtObj.Name == System.Label.CH_LegacyInitialResponse) {
						slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj.Id, mtObj.Id);
						//slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						//System.assertEquals(slaTime, 10);
					} else if(mtObj.Name == System.Label.CH_LegacySystemRestored) {
						slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj.Id, mtObj.Id);
						//slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						//System.assertEquals(slaTime, 20);
					} else if(mtObj.Name == System.Label.CH_LegacyTemporarySolutionProvided) {
						slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj.Id, mtObj.Id);
						// slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						//System.assertEquals(slaTime, 30);
					}  else if(mtObj.Name == System.Label.CH_LegacySolutionProvided) {
						slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj.Id, mtObj.Id);
						//slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						//System.assertEquals(slaTime, 60);
					}
				}
			}
	
			list<Case> aCases2 = new list<Case>([SELECT Id, CH_LegacyCaseNumber__c, CH_LegacyCaseStatus__c, CH_SolutionProvided__c, CH_TemporarySolutionProvided__c, CH_SystemRestored__c, CH_InitialResponse__c, (SELECT Id, CompletionDate, CaseId, MilestoneTypeId, MilestoneType.Name FROM CaseMilestones) FROM Case WHERE Id =:caseObj.Id]);
			system.assertEquals(aCases2.size(), 1);			
			 //system.debug('Suniti""""""Majumdar2@@@@case details@@@@@@@@@@@@@' +aCases2); 
			
			Set <Id> caseIds = new Set <Id> ();
			for (Case caseObje : aCases2){
				  caseIds.add(caseObje.Id);
			}
			
		   CH_CompleteMilestoneOnInsert.completeMilestonesOnInsert(caseIds);
			Test.stopTest();
			}Catch(Exception ex) {
			System.debug('### Exception has raised : ' + ex.getMessage());
		}
			
		} 
	
	//end
	
	//Test
	//test start 15275
	 public static testMethod void testCompleteIRonInsert(){
		
		CH_EntitlementTestData.createCustomSettingData();
		integer j = 1;
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
		
		
		List<ServiceContract> ServiceContractlist =new List<ServiceContract>();
		ServiceContractlist = CH_EntitlementTestData.createServiceContractRecord(j, AccountListNL, null, customPB1.id );
		insert ServiceContractlist;  
		
		/*List<ContractLineItem> ContractLineItemList =new List<ContractLineItem>();
		ContractLineItemList = CH_EntitlementTestData.createContractLineItemRecord(j, Custompricebook,ServiceContractlist);
		insert ContractLineItemList;*/
		
		List<Asset> assetObjList = new List<Asset>();
		for(Integer i=0;i<j;i++){				 
			Asset assetObj = new Asset();
			assetObj.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_CoveredProduct').Id;
			assetObj.Name = 'Test Asset';
			assetObj.Product2Id = productlist[i].id;
			assetObj.AccountId = AccountListLE[i].id;
			//assetObj.CH_Solution__c = productlist[i].id;
			// assetObj.CH_ProductVariant__c = productlist[i].id;
			//assetObj.CH_ProductRelease__c = ProdRelObjList[i].id;
			assetObjList.add(assetObj);
		}
		insert assetObjList;
		
		ContractLineItem contLine = new ContractLineItem();
			//contLine.CH_BusinessHourName__c = stdBusinessHours.Id;
			//contLine.CH_CDB_EntitlementId__c = entObj.CH_CDB_EntitlementId__c;
			contLine.PricebookEntryId = Custompricebook[0].id;
			contLine.Quantity = 55;
			contLine.UnitPrice = 55;
			contLine.ServiceContractId = ServiceContractlist[0].id;
			ContLine.CH_ServiceOffering__c = 'Test';
			contLine.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';
			contLine.CH_CDB_EntitlementId__c = '1test';
			contLine.AssetId = assetObjList[0].id;
		insert contLine;  
	   
		SlaProcess slaProcess = [SELECT Id FROM SlaProcess WHERE Name = 'Legacy Customer Support Service - No Severity 24x7' LIMIT 1];
		List<Entitlement> entitlementlist =new List<Entitlement>();
		for(integer i=0;i<j;i++){
			Entitlement entiObj = new Entitlement();
			entiObj.Name ='test'+ i;
			entiObj.AccountId = AccountListLE[i].id;
			entiObj.CH_CDB_EntitlementId__c = '1test'+ i;
			entiObj.StartDate = System.today();
			entiObj.EndDate = System.today() + 10;
			entiObj.ContractLineItemId = contLine.id;
			entiObj.AssetId = assetObjList[i].id;
			//entiObj.BusinessHoursId = stdBusinessHours;
			entiObj.CH_EntitlementType__c = 'Entitled Asset';
			entiObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
			entiobj.ServiceContractId = ServiceContractlist[i].id;
			entiobj.SlaProcessId = slaProcess.id;
			entitlementlist.add(entiObj);
		}
		insert entitlementlist;
		
		
		EntitlementContact entcon = new EntitlementContact();
		entcon.EntitlementId = entitlementlist[0].id;
		entcon.ContactId = ConatctList[0].id;	
		insert entcon;
		 
		// Create CH_CustomerSpecificTargetSLA__c
		List < CH_CustomerSpecificTargetSLA__c > slaList = new List < CH_CustomerSpecificTargetSLA__c > ();
		for(Integer i=0; i<5; i++) {
			CH_CustomerSpecificTargetSLA__c slaObj = new CH_CustomerSpecificTargetSLA__c();
			slaObj.CH_Account__c = AccountListLE[0].id;
			slaObj.CH_Entitlement__c = entitlementlist[0].Id;
			slaObj.CH_ServiceContract__c = ServiceContractlist[0].Id;
			slaObj.CH_LineItemNumber__c = contLine.Id;
			slaObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
			slaObj.CH_SLARecordStatus__c = 'Active';
			slaObj.CH_IR_WorkMins__c = 10 * (i+1);
			slaObj.CH_SR_WorkMins__c = 20 * (i+1);
			slaObj.CH_TSP_WorkMins__c = 30 * (i+1);
			slaObj.CH_SDR_WorkMins__c = 40 * (i+1);
			slaObj.CH_SP_WorkMins__c = 50 * (i+1);
			slaObj.CH_SPD_WorkMins__c = 60 * (i+1);
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
		try{
			Case caseObj = new Case();
			caseObj.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_NokiaStandardCase').Id;
			caseObj.AccountId =  AccountListLE[0].id;
			caseObj.Subject = 'Test Case';
			caseObj.Description = 'Test Case';
			caseObj.ContactId = ConatctList[0].id;
			caseObj.CH_ReportedDate__c = system.now();
			caseObj.CH_PendingbyEmail__c = true;
			caseObj.CH_Initial_Assignment__c = true;
			caseObj.CH_InitialAssignment__c = false;
			caseObj.Severity__c =  slaList[1].CH_Severity__c;
			caseObj.CH_Outage__c = slaList[1].CH_Outage__c;
			caseObj.AssetId = assetObjList[0].id;
			caseObj.EntitlementId = entitlementlist[0].id;
			caseObj.CH_Defect__c = false;
			//caseObj.CH_AssignedDate__c=system.now();
			Test.startTest();
			caseObj.Status = 'Assigned';
			caseObj.CH_AssignedDate__c=system.now();
			caseObj.CH_InitialDiagnosis__c= 'Test123';
			caseObj.CH_IsCompleteInitialResponseSetByFlow__c=true;
			insert caseObj;			 
						
			Case caseObj1 = [SELECT Id, CH_AssignedDate__c,CH_InitialResponse__c,CH_IsCompleteInitialResponse__c FROM Case where Id = :caseObj.Id];
			//caseObj1.CH_InitialResponse__c = caseObj.CH_AssignedDate__c;
			caseObj1.CH_IsCompleteInitialResponse__c=true;
			update caseObj1;	
			//system.debug('@Suniti@@@@@@@@Majumdar******"""""""""case details@@@@@@@@@@@@@'+caseObj1);
						
			List < MilestoneType > mTypes = [SELECT Id, Name FROM MilestoneType] ;
			System.assertNotEquals(mTypes, null);
			System.assertEquals(mTypes.isEmpty(), false);
			
			CH_CaseMilestoneTimeCalculator timeCalculator = new CH_CaseMilestoneTimeCalculator();
			Integer slaTime = 1;
			for(MilestoneType mtObj: mTypes) {
				for(Integer i=0; i<j; i++){
					if(mtObj.Name == System.Label.CH_InitialResponse) {
						slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						//slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						//System.assertEquals(slaTime, 10);
					} else if(mtObj.Name == System.Label.CH_SystemRestored) {
						slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						//slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						//System.assertEquals(slaTime, 20);
					} else if(mtObj.Name == System.Label.CH_TemporarySolutionProvided) {
						slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						// slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						//System.assertEquals(slaTime, 30);
					} else if(mtObj.Name == System.Label.CH_ServiceDisruptionReportProvided) {
						slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						//slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						//System.assertEquals(slaTime, 40);
					} else if(mtObj.Name == System.Label.CH_SolutionProvidedNonDefect) {
						slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						//slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						//System.assertEquals(slaTime, 50);
					} else if(mtObj.Name == System.Label.CH_SolutionProvidedDefect) {
						slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						//slaTime = timeCalculator.calculateMilestoneTriggerTime(caseObj1.Id, mtObj.Id);
						//System.assertEquals(slaTime, 60);
					}
				}
			}
	
			list<Case> aCases2 = new list<Case>([SELECT Id, CaseNumber,CH_InitialResponse__c,CH_IsCompleteInitialResponseSetByFlow__c,CH_IsCompleteInitialResponse__c FROM Case limit 1]);
			system.assertEquals(aCases2.size(), 1);			
			 //system.debug('Suniti""""""Majumdar2@@@@case details@@@@@@@@@@@@@' +aCases2); 
			
			Set <Id> caseIds = new Set <Id> ();
			for (Case caseObje : aCases2){
				  caseIds.add(caseObje.Id);
			}
			
		   CH_CompleteIROnInsert.completeIROnInsert(caseIds);
			Test.stopTest();
			}Catch(Exception ex) {
			System.debug('### Exception has raised : ' + ex.getMessage());
		}
			
		} 
	//test end 15275
	//
	
	
   
	}