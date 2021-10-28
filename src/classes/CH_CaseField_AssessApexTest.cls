@IsTest(seeAllData = false)
public class CH_CaseField_AssessApexTest {
public static User createUsr(String oUsr){
		Profile profile = [Select Id from Profile where name = 'System Administrator' LIMIT 1];
		// Create account owner
		User chUser = new User(
			Lastname='NONPORTAL1',
			Firstname='NONPORTAL1'+oUsr,
			Alias = 'NP1'+oUsr,
			ProfileId = profile.Id,
			Username = System.now().millisecond()  +oUsr+'NP1@test.com',
			Email= System.now().millisecond() + oUsr+'test2@test.com',
			EmailEncodingKey='UTF-8',
			LanguageLocaleKey='en_US',
			LocaleSidKey='en_US',
			TimeZoneSidKey='America/Chicago',
			Nokia_ID__c = oUsr
		);
		insert chUser;
		return chUser;
	}
	
	static testMethod void testCPATrigger() {
		User chUser = createUsr('User1');
		system.runAs(chUser){ 
			test();
		}
	}
	
	public static  void test() {
		
		
		CH_EntitlementTestData.createCustomSettingData();
		integer j = 2;
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
		
		/*Map<ID,ContractLineItem> ContractLineItemMap = New Map<ID,ContractLineItem>([Select ID from ContractLineItem where  id =:ContractLineItemList]);
		for(ContractLineItem cltTest1: ContractLineItemMap.values()){ 
			 for(Integer i=0;i<j;i++){
				cltTest1.AssetId = assetObjList[i].id;
			}
			ContractLineItemMap.put(cltTest1.id,cltTest1);
		}
		update ContractLineItemMap.values();
		system.assertNotEquals(assetObjList[0].id, Null);*/
		
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
			caseObj.Severity__c =  slaList[0].CH_Severity__c;
			caseObj.CH_Outage__c = slaList[0].CH_Outage__c;
			caseObj.AssetId = assetObjList[0].id;
			caseObj.EntitlementId = entitlementlist[0].id;
			caseObj.CH_Defect__c = true;
			caseObj.CH_LegacyCaseNumber__c ='LE2';
			Test.startTest();
			insert caseObj;
			SObject case1 = new Case();
			CH_CaseField_AssessApex.getPickVal(case1, 'Status');
			CH_ClearDontShowCSettingData.dontShowRecsDelete();
			test.stopTest();
		}Catch(Exception ex) {
			System.debug('### Exception has raised : ' + ex.getMessage());
		} 
	}
}