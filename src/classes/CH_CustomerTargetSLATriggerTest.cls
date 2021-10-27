@isTest
public class CH_CustomerTargetSLATriggerTest {
	public static testMethod void test() {
		integer j =5;
		
		CH_EntitlementTestData.createCustomSettingData();
		
		List <Account> AccountListNL = new List<Account>();
		AccountListNL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
		insert AccountListNL;
		
		// Create Entitlement
		List < SLAProcess > slaProcessList = [SELECT Id, IsVersionDefault FROM SlaProcess WHERE SobjectType = 'Case' AND IsActive = true];
		System.assertNotEquals(slaProcessList, null);
		System.assertEquals(slaProcessList.isEmpty(), false);
		
		SLAProcess slaProcessObj = null;
		for(SLAProcess sla: slaProcessList) {
			if(sla.IsVersionDefault) {
				slaProcessObj = sla;
				break;
			}
			slaProcessObj = sla;			
		}
		System.assertNotEquals(slaProcessObj, null);
		System.assertNotEquals(slaProcessObj.Id, null);
		
		List<Product2> productlist1 =new List<Product2>();
		productlist1 = CH_EntitlementTestData.createProductRecord(j);
		insert productlist1;
		
		List<PricebookEntry> pricebook =new List <PricebookEntry>();
		pricebook = CH_EntitlementTestData.createPricebookEntryRecord(j, productlist1);
		insert pricebook;
		
		
		Pricebook2 customPB1 = new Pricebook2();
		customPB1.Id = CH_EntitlementTestData.CreateCustomPriceBook();
		
		List<PricebookEntry> Custompricebook =new List <PricebookEntry>();
		Custompricebook = CH_EntitlementTestData.createCustomPricebookEntryRecord(j, productlist1, customPB1.id);
		insert Custompricebook;
		
		
		List<ServiceContract> ServiceContractlist =new List<ServiceContract>();
		ServiceContractlist = CH_EntitlementTestData.createServiceContractRecord(j, AccountListNL, null, customPB1.id );
		insert ServiceContractlist;		
		
		List<ContractLineItem> ContractLineItemList =new List<ContractLineItem>();
		ContractLineItemList = CH_EntitlementTestData.createContractLineItemRecord(j, Custompricebook,ServiceContractlist);
		insert ContractLineItemList;
		
		List<Entitlement> entitlementlist =new List<Entitlement>();
		entitlementlist = CH_EntitlementTestData.createEntitlementRecord(j, AccountListNL, ContractLineItemList, null,ServiceContractlist);
		insert entitlementlist;
		
		List<Asset> assetObjList = new List<Asset>();
		for(Integer i=0;i<j;i++){				  
			Asset assetObj = new Asset();
			assetObj.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_CoveredProduct').Id;
			assetObj.Name = 'Test Asset';
			assetObj.Product2Id = productlist1[i].id;
			assetObj.AccountId = AccountListNL[i].id;
			assetObj.CH_Solution__c = productlist1[i].id;
			assetObj.CH_ProductVariant__c = productlist1[i].id;
			//assetObj.CH_ProductRelease__c = ProdRelObjList[i].id;
			assetObjList.add(assetObj);
		}
		insert assetObjList;
		
		
		// Create CH_CustomerSpecificTargetSLA__c
		List < CH_CustomerSpecificTargetSLA__c > slaList = new List < CH_CustomerSpecificTargetSLA__c > ();
		for(Integer i=0; i<j; i++) {
			CH_CustomerSpecificTargetSLA__c slaObj = new CH_CustomerSpecificTargetSLA__c();
			slaObj.CH_Account__c = AccountListNL[i].id;
			slaObj.CH_Entitlement__c = entitlementlist[i].Id;
			slaObj.CH_ServiceContract__c = ServiceContractlist[i].Id;
			slaObj.CH_LineItemNumber__c = ContractLineItemList[i].Id;
			slaObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
			slaObj.CH_SLARecordStatus__c = 'Active';
			slaObj.CH_IR_WorkMins__c = 10 * i;
			slaObj.CH_SR_WorkMins__c = 20 * i;
			slaObj.CH_TSP_WorkMins__c = 30 * i;
			slaObj.CH_SDR_WorkMins__c = 40 * i;
			slaObj.CH_SP_WorkMins__c = 50 * i;
			slaObj.CH_SPD_WorkMins__c = 60 * i;
			slaList.add(slaObj);
		}
		slaList[0].CH_Severity__c = 'Critical';
		slaList[0].CH_Outage__c = 'Yes';
		
		slaList[1].CH_Severity__c = 'Major';
		slaList[1].CH_Outage__c = 'No';
		
		slaList[2].CH_Severity__c = 'Major';
		slaList[2].CH_Outage__c = 'Yes';
		
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
		
		try {	  
			List < CH_CustomerSpecificTargetSLA__c > slaList1 = new List < CH_CustomerSpecificTargetSLA__c > ();
			for(Integer i=0; i<j; i++) {
				CH_CustomerSpecificTargetSLA__c slaObj1 = new CH_CustomerSpecificTargetSLA__c();
				slaObj1.CH_Account__c = AccountListNL[i].id;
				slaObj1.CH_Entitlement__c = entitlementlist[i].Id;
				slaObj1.CH_ServiceContract__c = ServiceContractlist[i].Id;
				slaObj1.CH_LineItemNumber__c = ContractLineItemList[i].Id;
				slaObj1.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
				slaObj1.CH_SLARecordStatus__c = 'Active';
				slaObj1.CH_IR_WorkMins__c = 10 * i;
				slaObj1.CH_SR_WorkMins__c = 20 * i;
				slaObj1.CH_TSP_WorkMins__c = 30 * i;
				slaObj1.CH_SDR_WorkMins__c = 40 * i;
				slaObj1.CH_SP_WorkMins__c = 50 * i;
				slaObj1.CH_SPD_WorkMins__c = 60 * i;
				slaList1.add(slaObj1);
			}
			slaList1[0].CH_Severity__c = 'Critical';
			slaList1[0].CH_Outage__c = 'Yes';
			insert slaList1;
			
		} catch(DmlException e) {
			System.debug('The following exception has occurred: ' + e.getMessage());
		}
	}
	
}