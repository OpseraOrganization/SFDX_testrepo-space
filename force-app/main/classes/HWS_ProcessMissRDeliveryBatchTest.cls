/********************************************************************************
* Name : HWS_ProcessMissingAttachmentBatchTest
* Description : Test class for HWS_ProcessMissingAttachmentBatch
********************************************************************************/
@isTest
public class HWS_ProcessMissRDeliveryBatchTest {
	public static List<Account> newLegalEntity ;
	public static List<Contact> newContact; 
	public static CH_AuthorizedAccount__c newAuthorizedAccount ;
	public static AccountContactRelation newAccountContactRelation;
	public static List<ContractLineItem> newContractLineItems ;
	public static List<ServiceContract> newServiceContract;
	public static List<Asset> newAssets ;
	public static List<Entitlement> newEntiltment ;
	public static Case newCase ;
	public static List<user> userList;
	@testSetup
	public static void createTestData(){
		Map<String, String> fieldsMap = new Map<String, String>();
		userList = CH_TestFactoryDefaults.createInternalUsers( true, true, 2, null);
		system.runAs(userList[0]){
			insert new Global_Control__c(ObjectTriggerByPass__c='Case,ACCT,CNTCT,ACC_CNTCT_REL,USER,SVCNTRT,ASSET,PRODUCT,CLI,ENT,CASE');
			newLegalEntity = CH_TestFactoryDefaults.createAccountData(true, 1, 'Legal_Entity', null, false);
			fieldsMap.put('AccountId', newLegalEntity[0].ParentId); 
			newContact = CH_TestFactoryDefaults.createContact(true, 2, null, fieldsMap, false);
			
			CH_TestFactoryDefaults.createAcccountContactRelation(true, newLegalEntity[0].Id, newContact[0].ID);
			newAccountContactRelation =  CH_TestFactoryDefaults.createAcccountContactRelation(false, newLegalEntity[0].Id, newContact[1].ID);
			newAccountContactRelation.NCP_Entitlement_Relationship__c = false;
			insert newAccountContactRelation;
			fieldsMap.put('AccountId', newLegalEntity[0].Id);  
			newServiceContract = CH_TestFactoryDefaults.createServiceContractData(true, 1, fieldsMap);
			Entitlement entitlementAuthorized = CH_TestFactoryDefaults.createAuthorizedEntitlement(true, newServiceContract[0].AccountId, newServiceContract[0].Id);
			EntitlementContact ect = CH_TestFactoryDefaults.createEntitlementContact( true,  newContact[0].Id,  entitlementAuthorized.Id);
			
			fieldsMap.put('ServiceContractId', newServiceContract[0].Id);
			String productId = CH_TestFactoryDefaults.createProductDataSetUp( true,  1, null)[0].Id;
			String priceBookID = Test.getStandardPricebookId();
			fieldsMap.put('product2Id',productId);
			fieldsMap.put('Product2Id',productId);
			fieldsMap.put('Pricebook2Id',priceBookID);
			newAssets = CH_TestFactoryDefaults.createAssetData(true, 1,'CH_CoveredProduct', fieldsMap); 
			fieldsMap.Put('AssetId',newAssets[0].Id);
			string pricebookEntryId = CH_TestFactoryDefaults.createPriceBookEntry(  true, fieldsMap)[0].Id;
			fieldsMap.put('pricebookEntryId',pricebookEntryId);
			newContractLineItems = CH_TestFactoryDefaults.createContractLineItemData(true, 1, fieldsMap);
			fieldsMap.Put('ContractLineItemId',newContractLineItems[0].Id);
			newEntiltment = CH_TestFactoryDefaults.createEntitlement(true, 1, fieldsMap);
			system.assert(newEntiltment[0].ID!=null);
			Entitlement oEntitlement = [select id,AccountId, Account.ParentId, AssetId, Asset.Product2Id,ContractLineItem.ServiceContract.CH_Entitlement__c
										from Entitlement where id = :newEntiltment[0].Id];
			ID entId = oEntitlement.ContractLineItem.ServiceContract.CH_Entitlement__c;
			
			Case caseData =  CH_TestFactoryDefaults.createCaseNotSaved('Major','No', false,  newContact[0].Id, oEntitlement);
			caseData.Type = 'Incident';
		  //  caseData.HWS_RecordTypeCheck__c = true;
			caseData.HWS_ReturnAddressReceivedFromSOO__c = true;
			caseData.HWS_OrderConfirmationSent__c=true;
			caseData.recordTypeId = CH_EntitlementTestData.recordTypeMap.get('HWS_Return_For_Repair').Id ;
			insert caseData;
			Case caseData2 =  CH_TestFactoryDefaults.createCaseNotSaved('Major','No', false,  newContact[0].Id, oEntitlement);
			caseData2.Type = 'Incident';
			//caseData2.HWS_RecordTypeCheck__c = true;
			caseData2.ParentId= caseData.id;
			
		   caseData2.recordTypeId = CH_EntitlementTestData.recordTypeMap.get('HWS_Return_For_Repair').Id ;
		   insert caseData2;
				 Case caseData3 =  CH_TestFactoryDefaults.createCaseNotSaved('Major','No', false,  newContact[0].Id, oEntitlement);
			caseData3.Type = 'Incident';
			//caseData2.HWS_RecordTypeCheck__c = true;
			caseData3.ParentId= caseData.id;
			
		   caseData3.recordTypeId = CH_EntitlementTestData.recordTypeMap.get('HWS_Return_For_Repair').Id ;
		   insert caseData3;
		}
	}
	public static testMethod void testBatchProcess(){ 
		//Datetime newInstance(Integer year, Integer month, Integer day, Integer hour, Integer minute, Integer second)
	  //  DateTime dateTimeIns = DateTime.newInstance(2021, 9, 20, 7, 8, 16);
	   // HWS_GenericSettings__c cs = new HWS_GenericSettings__c(Name='BulkOrderLastsync',ReturnAddressSyncTime__c=dateTimeIns);
	   // insert cs;
		Test.startTest();
		 DateTime dateTimeIns = DateTime.newInstance(2021, 9, 20, 7, 8, 16);
		HWS_GenericSettings__c cs = new HWS_GenericSettings__c(Name='BulkOrderLastsync',ReturnAddressSyncTime__c=dateTimeIns);
		insert cs;
		String hour = String.valueOf(Datetime.now().hour());
String min = '30';
String ss = '30';
String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
		HWS_ProcessMissingReturnDeliveryBatch batchCls = new HWS_ProcessMissingReturnDeliveryBatch('test'); 
		System.schedule('Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, batchCls);
		HWS_ProcessMissingReturnDeliveryBatch mbatchCls = new HWS_ProcessMissingReturnDeliveryBatch('test'); 
		database.executeBatch(mbatchCls);
		Test.stopTest();
	   // HWS_GenericSettings__c updatedCustSettings = [SELECT ReturnAddressSyncTime__c FROM HWS_GenericSettings__c WHERE Name = 'BulkOrderLastsync'];
	   // System.assert(updatedCustSettings.ReturnAddressSyncTime__c != dateTimeIns);
	}

}