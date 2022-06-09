/** 
* About 
* ----- 
* @Description	: Case Handling Entitlement Object Utility Test Class.
* @Project  : Case Handling.
* @Modification Log : 
*  Created  : 2020 02 17 – tiago.almeida@nokia.com
* ----- 
**/
@isTest
public class CH_EntitlementUtils_Test {
	public static List<ContractLineItem> newContractLineItems ;
	public static List<Servicecontract> newServiceContract;
	public static List<Account> newLegalEntity ;
	public static List<Contact> newContact;
	public static List<Asset> newAssets ;
	public static List<PriceBookEntry> newPricebookEntry ;
	public static List<Entitlement> newEntiltment ;
	  
	public static testMethod  void setupTestData() {
		Map<String, String> fieldsMap = new Map<String, String>();
		List<Entitlement> newEntiltment = new List<Entitlement>();
		List<user> userList = CH_TestFactoryDefaults.createInternalUsers( true, true, 2, null);
		system.assert(userList.size()==2);
		system.runAs(userList[0]){
			insert new Global_Control__c(ObjectTriggerByPass__c='Case,ACCT,CNTCT,ACC_CNTCT_REL,USER,SVCNTRT,ASSET,PRODUCT,CLI,ENT,CASE');
			
			newLegalEntity = CH_TestFactoryDefaults.createAccountData(true, 1, 'Legal_Entity', null, false);
			fieldsMap.put('AccountId', newLegalEntity[0].ParentId);	
			
			newContact = CH_TestFactoryDefaults.createContact(true, 1, null, fieldsMap, false);
			
			system.assertEquals(newContact[0].AccountID, newLegalEntity[0].ParentId);
			CH_TestFactoryDefaults.createAcccountContactRelation(true, newLegalEntity[0].Id, newContact[0].ID);
			
			fieldsMap.put('AccountId', newLegalEntity[0].Id);	  
			newServiceContract = CH_TestFactoryDefaults.createServiceContractData(true, 1, fieldsMap);
			
			fieldsMap.put('ServiceContractId', newServiceContract[0].Id);
			String productId = CH_TestFactoryDefaults.createProductDataSetUp( true,  1, null)[0].Id;
			String priceBookID = Test.getStandardPricebookId();
			fieldsMap.put('Product2Id',productId);
			fieldsMap.put('Pricebook2Id',priceBookID);
			
			newAssets = CH_TestFactoryDefaults.createAssetData(true, 1,'CH_CoveredProduct', fieldsMap);
			system.debug(newAssets[0].product2Id+'******newAssets '+productId);
			fieldsMap.Put('AssetId',newAssets[0].Id);   
			string pricebookEntryId = CH_TestFactoryDefaults.createPriceBookEntry(  true, fieldsMap)[0].Id;
			fieldsMap.put('pricebookEntryId',pricebookEntryId);
			
			newContractLineItems = CH_TestFactoryDefaults.createContractLineItemData(true, 1, fieldsMap);
			fieldsMap.Put('ContractLineItemId',newContractLineItems[0].Id);
			
			newEntiltment = CH_TestFactoryDefaults.createEntitlement(true, 1, fieldsMap);
			system.assert(newEntiltment[0].ID!=null);
			
			CH_TestFactoryDefaults.createEntitlementContact( true,  newContact[0].Id,  newEntiltment[0].Id);
			
			Entitlement oEntitlement = [select id,AccountId, Account.ParentId, AssetId, Asset.Product2Id
	from Entitlement where id = :newEntiltment[0].Id];
			
			System.debug(Limits.getCpuTime()+' CPU time & queries 1 ' + Limits.getQueries());
			test.startTest();
	 
			Case caseData =  CH_TestFactoryDefaults.createCaseNotSaved('Major','No', false,  newContact[0].Id, oEntitlement);
			insert caseData;
			System.debug(Limits.getCpuTime()+' CPU time & queries 2 ' + Limits.getQueries());//4212 CPU time & queries 2 24
			test.stopTest();
			
			CH_EntitlementUtils.getContactAuthorizedEntitlements(true, newEntiltment[0].AccountId, newEntiltment[0].AssetId, newContact[0].Id, newAssets[0], 'Customer Support', false);
			CH_EntitlementUtils.displayP20fields(newEntiltment[0].id);
			
		}
		
		
	}
	
	
	public static testMethod void test() {
	  /* setupTestData();
	system.debug('****'+newEntiltment[0]);
		 system.debug('****'+newContact[0]);
	system.debug('****'+newAssets[0]);
		/*CH_EntitlementUtils.getContactAuthorizedEntitlements(true, newEntiltment[0].AccountId, newEntiltment[0].AssetId, newContact[0].Id, newAssets[0], 'Customer Support', false);
		CH_EntitlementUtils.displayP20fields(newEntiltment[0].id);*/
	}
	
	
	
}