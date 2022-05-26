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
private class CH_DisplayEntitlementScriptTest {
	@isTest static void testCaseRecord() {
		// Load custom setting Data
		CH_EntitlementTestData.createCustomSettingData();
		
		List < Group > groupList = CH_EntitlementTestData.createGroups();		
		insert groupList;
		System.assertNotEquals(groupList[0].Id, null);
				
		Integer j = 2;
		List < Account > AccountListNL = new List<Account>();
		AccountListNL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
		insert AccountListNL;
		
		List < Account > AccountListLE = new List<Account>();
		AccountListLE = CH_EntitlementTestData.createAccountRecord(j, 'Legal_Entity', AccountListNL);
		insert AccountListLE;
		
		List < Contact > ConatctList = new List<Contact>();
		ConatctList = CH_EntitlementTestData.createContactRecord(j, AccountListNL);
		insert ConatctList;
		
		List<Product2> productlist =new List<Product2>();
		productlist = CH_EntitlementTestData.createProductRecord(j);
		insert productlist;
		
		List<PricebookEntry> pricebook =new List <PricebookEntry>();
		pricebook = CH_EntitlementTestData.createPricebookEntryRecord(j, productlist);
		insert pricebook;
		
		Pricebook2 customPB1 = new Pricebook2();
		customPB1.Id = CH_EntitlementTestData.CreateCustomPriceBook();
		
		List< PricebookEntry > Custompricebook = new List < PricebookEntry > ();
		Custompricebook = CH_EntitlementTestData.createCustomPricebookEntryRecord(j, productlist, customPB1.id);
		insert Custompricebook;
		
		List < ServiceContract > ServiceContractlist = new List < ServiceContract > ();
		ServiceContractlist = CH_EntitlementTestData.createServiceContractRecord(j, AccountListNL, null, customPB1.Id);
		insert ServiceContractlist;	 
		
		List<Asset> assetObjList = new List<Asset>();
		for(Integer i=0;i<j;i++){				  
			Asset assetObj = new Asset();
			assetObj.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_CoveredProduct').Id;
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
			contLine.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';
			contLine.CH_CDB_EntitlementId__c = '1test';
			contLine.AssetId = assetObjList[0].id;
		insert contLine;
		
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
			entiObj.CH_EntitlementType__c = 'Entitled Asset';
			entiObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
			entiobj.ServiceContractId = ServiceContractlist[i].id;
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
		
		Test.startTest();
			Case caseObj = new Case();
			caseObj.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_NokiaStandardCase').Id;
			caseObj.AccountId =  AccountListLE[0].Id;
			caseObj.ContactId = ConatctList[0].id;
			caseObj.AssetId = assetObjList[0].id;
			caseObj.EntitlementId = entitlementlist[0].id;
			caseObj.Subject = 'Test Case';
			caseObj.Description = 'Test Case';
			caseObj.Severity__c =  slaList[0].CH_Severity__c;
			caseObj.CH_Outage__c = slaList[0].CH_Outage__c;
			caseObj.CH_Defect__c = true;
			insert caseObj;
		
			Map<String,String> entitlementScriptMap = CH_DisplayEntitlementScript.getEntitlementScript(caseObj.Id);
			System.assertNotEquals(entitlementScriptMap, null);   
			
			CH_DisplayEntitlementScript.closeComponentMethod(caseObj.Id);		
		Test.stopTest();
	}
}