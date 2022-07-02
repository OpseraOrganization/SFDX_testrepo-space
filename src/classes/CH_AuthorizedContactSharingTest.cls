@IsTest
public class CH_AuthorizedContactSharingTest {
	public static List<ContractLineItem> newContractLineItems ;
	public static List<Servicecontract> newServiceContract;
	public static List<Account> newLegalEntity ;
	public static List<Contact> newContact;
	public static List<Asset> newAssets ;
	public static List<Entitlement> newEntiltment ;
	public static Case newCase ;
	public static CH_AuthorizedAccount__c newAuthorizedAccount ;
	public static AccountContactRelation newAccountContactRelation;
	public static List<Case> newCaseId ;
	public static List<Schema.Address> newAddress ;
	public static List<PriceBookEntry> newPricebookEntry ;  
	public  static String newContactId =null;
	
	
	@testSetup
	static void testDataSetup(){
		Map<String, String> fieldsMap = new Map<String, String>();
		List<user> userList = CH_TestFactoryDefaults.createInternalUsers( true, true, 2, null);
		system.assert(userList.size()==2);  
		system.runAs(userList[0]){
			insert new Global_Control__c(ObjectTriggerByPass__c='Case,ACCT,CNTCT,ACC_CNTCT_REL,USER,SVCNTRT,ASSET,PRODUCT,CLI,ENT,CASE');
			
			newLegalEntity = CH_TestFactoryDefaults.createAccountData(true, 1, 'Legal_Entity', null, false);
			fieldsMap.put('AccountId', newLegalEntity[0].ParentId); 
			
			newContact = CH_TestFactoryDefaults.createContact(true, 2, null, fieldsMap, false);
			System.debug('newContact--'+newContact[0].ID);
			system.assertEquals(newContact[0].AccountID, newLegalEntity[0].ParentId);
			CH_TestFactoryDefaults.createAcccountContactRelation(true, newLegalEntity[0].Id, newContact[0].ID);
			newAccountContactRelation =  CH_TestFactoryDefaults.createAcccountContactRelation(false, newLegalEntity[0].Id, newContact[1].ID);
			newAccountContactRelation.NCP_Entitlement_Relationship__c = false;
			insert newAccountContactRelation;
			fieldsMap.put('AccountId', newLegalEntity[0].Id);  
			
			newServiceContract = CH_TestFactoryDefaults.createServiceContractData(true, 1, fieldsMap);
			system.debug('newServiceContract--->'+newServiceContract);
			
			Test.starttest();
			Entitlement entitlementAuthorized = CH_TestFactoryDefaults.createAuthorizedEntitlement(true, newServiceContract[0].AccountId, newServiceContract[0].Id);
			CH_TestFactoryDefaults.createEntitlementContact( true,  newContact[0].Id,  entitlementAuthorized.Id);
			
			fieldsMap.put('ServiceContractId', newServiceContract[0].Id);
			String productId = CH_TestFactoryDefaults.createProductDataSetUp( true,  1, null)[0].Id;
			String priceBookID = Test.getStandardPricebookId();
			fieldsMap.put('product2Id',productId);
			fieldsMap.put('Product2Id',productId);
			fieldsMap.put('Pricebook2Id',priceBookID);
			
			newAssets = CH_TestFactoryDefaults.createAssetData(true, 1,'CH_CoveredProduct', fieldsMap); 
			fieldsMap.Put('AssetId',newAssets[0].Id);//today3
			
			
			
			string pricebookEntryId = CH_TestFactoryDefaults.createPriceBookEntry(  true, fieldsMap)[0].Id;
			fieldsMap.put('pricebookEntryId',pricebookEntryId);
			
			newContractLineItems = CH_TestFactoryDefaults.createContractLineItemData(true, 1, fieldsMap);
			fieldsMap.Put('ContractLineItemId',newContractLineItems[0].Id);
			
			newEntiltment = CH_TestFactoryDefaults.createEntitlement(true, 1, fieldsMap);
			system.assert(newEntiltment[0].ID!=null);
			
			Entitlement oEntitlement = [select id,AccountId, Account.ParentId, AssetId, Asset.Product2Id,ContractLineItem.ServiceContract.CH_Entitlement__c
	from Entitlement where id = :newEntiltment[0].Id];
			Case caseData =  CH_TestFactoryDefaults.createCaseNotSaved('Major','No', false,  newContact[0].Id, oEntitlement);
			caseData.Type = 'Incident';
			caseData.recordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_NokiaIncidentWithRestoration').Id ;
			insert caseData;
			Test.stoptest();
			
			
		}
	}
	
	public static testMethod void TestHandleSharingInsert()
	{	 
		System.debug('inside test method 4');
		test.startTest();	   
		Map<ID, Case> oCaseMap = new Map<ID, Case>([select id ,AssetId,ownerID,Contactid,CH_ServiceType__c,EntitlementId,CH_RecordTypeDevName__c from Case  LIMIT 1 ]);	 
		CH_AuthorizedContactSharing.handleSharing(oCaseMap,oCaseMap,true,false);
		CH_AuthorizedContactSharing ac = new CH_AuthorizedContactSharing();
		ac.unshareAuthorizedContacts(oCaseMap);
		Map<ID, EntitlementContact> EntitlementContacts = new Map<ID, EntitlementContact>([select id ,name, entitlementId, ContactId from EntitlementContact  LIMIT 1 ]); 
		CH_AuthorizedContactSharing.unshareAuthorizedContacts(EntitlementContacts);
		CH_AuthorizedContactSharing.handleSharing(oCaseMap,oCaseMap,false,true);
		System.debug('End of test method 4');   
		test.stopTest(); 
	}
	public static testMethod void TestHandleSharingInsert2()
	{	 
		System.debug('inside test method 4');
		test.startTest();	   
		Map<ID, Case> oCaseMap = new Map<ID, Case>([select id ,AssetId,ownerID,Contactid,CH_ServiceType__c,EntitlementId,CH_RecordTypeDevName__c from Case  LIMIT 1 ]);	 
		CH_AuthorizedContactSharing.handleSharing(oCaseMap,oCaseMap,false,true);
		System.debug('End of test method 4');   
		test.stopTest(); 
	}
 
	
}