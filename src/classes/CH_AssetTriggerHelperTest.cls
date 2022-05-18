/**
* 
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@isTest
public class CH_AssetTriggerHelperTest {
	public static final string LOCATION_NAME = 'My location';
	public static final string LEGAL_ENTITY = 'Legal Entity';
	public static final string BUSINESS_LINE = 'Business Line';
	public static final string MARKETING_TEXT = 'Creating it for test';
	public static final string NETWORK_ELEMENT_ASSET = 'Network Element Asset';
	public static Id assetRecordTypeId =Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_NetworkElementAsset').getRecordTypeId();
	public static Id addRecordTypeId=Schema.SObjectType.Address.getRecordTypeInfosByDeveloperName().get('CH_Address').getRecordTypeId();
	@testSetup static void testDataSetup(){
		Schema.Location loc = new Schema.Location();
		loc.Name=LOCATION_NAME;
		loc.LocationType='Site';
		insert loc;
		
		Schema.Address addr = new Schema.Address();
		addr.LocationType='Site';
		addr.ParentId= loc.id;
		addr.RecordTypeId = addRecordTypeId;
		insert addr;
		Id accRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		Account acc=new Account();
		acc.Name='test';
		acc.RecordTypeId=accRecordTypeId;
		acc.BillingCountry='India';
		acc.BillingCity='Hyd';
		acc.BillingStreet='Hyd';
		acc.Customer_Compliance__c='US_Sprint';
		insert acc;
		
		Id prodRecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		Product2 product=new Product2();
		product.Name='test1';
		product.RecordTypeId=prodRecordTypeId;
		product.Apttus_Config2__Uom__c='Each';
		product.Apttus_Config2__ConfigurationType__c='Standalone';
		product.Apttus_Config2__Version__c=1.00;
		product.Is_Dummy_Bundle_CPQ__c='No';
		product.NCP_Marketing_Text__c=MARKETING_TEXT;
		insert product;
		
		Asset neAsset=new Asset();
		neAsset.CH_NetworkElementID__c='Test99';
		neAsset.Name='Test99';
		neAsset.Status='Active';
		neAsset.Product2Id=product.id;
		neAsset.CH_ProductVariant__c=product.id;
		neAsset.CH_Solution__c=product.id;
		neAsset.AccountId=acc.Id;
		neAsset.CH_CountryISOName__c='USA';
		neAsset.Address__c=addr.id;
		neAsset.RecordTypeId=assetRecordTypeId;
		insert neAsset;
		
		Asset neAsset1=new Asset();
		neAsset1.CH_NetworkElementID__c='Test91';
		neAsset1.Name='Test91';
		neAsset1.Status='Active';
		neAsset1.Product2Id=product.id;
		neAsset1.CH_ProductVariant__c=product.id;
		neAsset1.CH_Solution__c=product.id;
		neAsset1.AccountId=acc.id;
		neAsset1.CH_CountryISOName__c='USA';
		neAsset1.Address__c=addr.id;
		neAsset1.RecordTypeId=assetRecordTypeId;
		insert neAsset1;
		insert new Global_Control__c(ObjectTriggerByPass__c='Case,ACCT,CNTCT,ACC_CNTCT_REL');	
	}
	public static testMethod void test() {
	
	
		integer j = 5;
		
		Map < String, RecordType > recordTypeMap = CH_EntitlementTestData.recordTypeMap;
		CH_EntitlementTestData.createCustomSettingData();
		List <Account> AccountListNL = new List<Account>();
		AccountListNL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
		insert AccountListNL;
		
		ISO_Country_Codes__c code = new ISO_Country_Codes__c();
		code.country_name__c = 'United States of America';
		code.name='US';
		insert code;
		
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
		
		List <CH_ProductRelease__c> ProdRelObjList = new List<CH_ProductRelease__c>();
		for(Integer i=0;i<j;i++){
			CH_ProductRelease__c prodRelObj = new CH_ProductRelease__c();
			prodRelObj.Name = 'testing prodRelObj';
			ProdRelObjList.add(prodRelObj);
		}
		insert ProdRelObjList;
		
		Test.startTest();
	try{ 
			List<Asset> assetObjList = new List<Asset>();
			for(Integer i=0;i<j;i++){	  
	Asset assetObj = new Asset();
	assetObj.RecordTypeId = recordTypeMap.get('CH_CoveredProduct').Id;
	assetObj.Name = 'Test Asset';
	assetObj.Product2Id = productlist1[i].id;
	assetObj.AccountId = AccountListNL[i].id;
	assetObj.CH_Solution__c = productlist1[i].id;
	assetObj.CH_ProductVariant__c = productlist1[i].id;
	assetObj.CH_ProductRelease__c = ProdRelObjList[i].id;
	assetObjList.add(assetObj);
			}
			insert assetObjList;
			
			List<Product2> productlist2 =new List<Product2>();
			productlist2 = CH_EntitlementTestData.createProductRecord(j);
			insert productlist2;
			
			List <CH_ProductRelease__c> ProdRelObjList2 = new List<CH_ProductRelease__c>();
			for(Integer i=0;i<j;i++){
	CH_ProductRelease__c prodRelObj = new CH_ProductRelease__c();
	prodRelObj.Name = 'testing111 prodRelObj';
	ProdRelObjList2.add(prodRelObj);
			}
			insert ProdRelObjList2;
			
			Map<ID, Asset> assetMap1 = new Map<ID, Asset>([Select ID from Asset where id IN : assetObjList]);
			
			For(Asset assetObj1: assetMap1.values() ){
	for(Integer i=0;i<j;i++){
		assetObj1.Product2Id = productlist2[i].Id;
		
		
		assetObj1.CH_ProductRelease__c = ProdRelObjList2[i].id;
	}	 
			}
			update assetMap1.values();
		}
		catch(exception e){
			System.debug('Exception while updating assetMap1:' + e.getMessage());
		}	
		
		try{			
			List<Asset> assetObjList = new List<Asset>();
			for(Integer i=0;i<j;i++){	  
	Asset assetObj = new Asset();
	assetObj.RecordTypeId = recordTypeMap.get('CH_CoveredProduct').Id;
	assetObj.Name = 'Test Asset';
	assetObj.CH_CountryISO2__c = 'US';
	assetObjList.add(assetObj);
			}
			insert assetObjList;
			
			Map<ID, Asset> assetMap = new Map<ID, Asset>([Select ID from Asset where id IN : assetObjList]);
			List<Asset> assetlist1 = [Select ID from Asset where id IN : assetObjList];
			For(Asset assetObj: assetlist1){
	for(Integer i=0;i<j;i++){
		assetObj.Name = 'Test';
		assetObj.CH_CountryISO2__c = 'SW';
	}	 
			}
			update assetMap.values();
			
		}catch(exception e){
			System.debug('The following exception has occurred: ' + e.getMessage());
		}
	test.stopTest();
  }
	
	
	//Suniti: Added code for 24960 and 24961
	
	/*Commented below code as per 36188 US 
	public static testMethod void test1() {	
	
 
		Account acc = [Select id from Account limit 1];
		Product2 product = [Select id from Product2 limit 1];
		Schema.Location loc1 = new Schema.Location();
		loc1.Name=LOCATION_NAME;
		loc1.LocationType='Site';
		insert loc1;
		
		Schema.Address addr1 = new Schema.Address();
		addr1.LocationType='Site';
		addr1.ParentId= loc1.id;
		addr1.RecordTypeId = addRecordTypeId;
		insert addr1;
		Asset neAsset2=new Asset();
		neAsset2.CH_NetworkElementID__c='Test99';
		neAsset2.Name='Test99';
		neAsset2.Status='Active';
		neAsset2.Product2Id=product.id;
		neAsset2.CH_ProductVariant__c=product.id;
		neAsset2.CH_Solution__c=product.id;
		neAsset2.AccountId=acc.id;
		neAsset2.CH_CountryISOName__c='USA';
		neAsset2.Address__c=addr1.id;
		neAsset2.RecordTypeId=assetRecordTypeId;
		Test.startTest();	
		 
		try{
		insert neAsset2;	  
		
		}
		catch(Exception ex){
			System.debug('Exception while inserting network element asset: ' + ex.getMessage());
		}	
		try{  
			Id neaRecordTypeId =Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_NetworkElementAsset').getRecordTypeId();
			List<Asset> oAssetList = new List<Asset>();
			neAsset2.CH_NetworkElementID__c='Test03';
			neAsset2.Name='Test05';
			neAsset2.RecordTypeId = neaRecordTypeId;
			neAsset2.Status='Active';
			update neAsset2;
			oAssetList.add(neAsset2);
			CH_AssetTriggerHelper.CheckDuplicateBeforeInsert(oAssetList, 'Insert');
		}
		catch(Exception ex){
			System.debug('Exception while checking duplicate:' + ex.getMessage());
		}
		Test.stopTest();
		
	} */
	
	public static testMethod void test2(){
	
		Asset neAsset1 =  [Select id from Asset where CH_NetworkElementID__c='Test91'];		
		Test.startTest();
		neAsset1.CH_NetworkElementID__c='Test93';
		neAsset1.Name='Test93';
		update neAsset1;
		Test.stopTest();
		system.debug('***test method3 getCpuTime()***'+Limits.getCpuTime());
	}
	
	public static testMethod void test3(){
	
		List<Asset> oAssetsList = new List<Asset> ();
		Asset neAsset =  [Select id from Asset where CH_NetworkElementID__c='Test91'];		
		oAssetsList.add(neAsset);		
		Account acc = [Select id from Account limit 1];
		Product2 product = [Select id from Product2 limit 1];
		Schema.Location loc2 = new Schema.Location();
		loc2.Name=LOCATION_NAME;
		loc2.LocationType='Site';		
		insert loc2;
		
		Schema.Address addr2 = new Schema.Address();
		addr2.LocationType='Site';
		addr2.ParentId= loc2.id;
		addr2.RecordTypeId = addRecordTypeId;
		insert addr2;
		Asset neAsset4=new Asset();
		neAsset4.RecordTypeId= assetRecordTypeId;
		neAsset4.CH_NetworkElementID__c='TestNEA91';
		neAsset4.Name='TestNEA91';
		neAsset4.Status='Inactive';
		neAsset4.Product2Id=product.id;
		neAsset4.CH_ProductVariant__c=product.id;
		neAsset4.CH_Solution__c=product.id;
		neAsset4.AccountId=acc.id;
		neAsset4.CH_CountryISOName__c='USA';
		neAsset4.Address__c=addr2.id;		
		test.startTest();
		CH_TestDataFactory.createCustomSettings();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createContracts(true); 
		
		List<Asset> asset = [select Id,Name ,Product2Id, CH_ProductRelease__c, CH_Solution__c, CH_ProductVariant__c,
		CH_Solution__r.Name, CH_ProductVariant__r.Name, CH_ProductRelease__r.Name
		from Asset where AccountId = :CH_TestDataFactory.tempLegalAccount.Id];
		system.assert(asset.size()>0);
		List<ContractLineItem> cli = [select Id,LineItemNumber, AssetId, CH_ServiceClassification__c  from ContractLineItem where AssetId = :asset[0].Id];
		
		ContractLineItem cliupdate = new ContractLineItem();
		cliupdate.Id = cli[0].Id;
		cliupdate.AssetId = oAssetsList[0].Id;
		cliupdate.CH_ServiceClassification__c = 'SW';
		update cliupdate;
		CH_CoveredNetworkElementAsset__c cnea=new CH_CoveredNetworkElementAsset__c();
		cnea.Name='test5';
		cnea.CH_NetworkElementAsset__c=oAssetsList[0].id;
		cnea.CH_Status__c='Active';
		cnea.CH_ContractLineItem__c=cli[0].Id;
		insert cnea;
		
		
		insert neAsset4;
		Test.stopTest();
		system.debug('***test method4 getCpuTime()***'+Limits.getCpuTime());
	} 
	
	public static testMethod void test4(){	
	
	Asset neAsset1 =  [Select id from Asset where CH_NetworkElementID__c='Test91'];		
		Test.startTest();
		neAsset1.CH_NetworkElementID__c='Test94';
		neAsset1.Name='Test94';
		update neAsset1;
		Test.stopTest();}
	
	public static testMethod void validationRuleTest(){	
	
	List<Asset> oAssetsList = new List<Asset> ();
		Asset neAsset1 =  [Select id from Asset where CH_NetworkElementID__c='Test91'];		
		oAssetsList.add(neAsset1);
		test.startTest();
		system.debug('***validationRuleTest getCpuTime Test.start()***'+Limits.getCpuTime());
		CH_TestDataFactory.createCustomSettings();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createContracts(true); 
		
		List<Asset> asset = [select Id,Name ,Product2Id, CH_ProductRelease__c, CH_Solution__c, CH_ProductVariant__c,
		CH_Solution__r.Name, CH_ProductVariant__r.Name, CH_ProductRelease__r.Name
		from Asset where AccountId = :CH_TestDataFactory.tempLegalAccount.Id];
		system.assert(asset.size()>0);
		List<ContractLineItem> cli = [select Id,LineItemNumber, AssetId, CH_ServiceClassification__c  from ContractLineItem where AssetId = :asset[0].Id];
		
		ContractLineItem cliupdate1 = new ContractLineItem();
		cliupdate1.Id = cli[0].Id;
		cliupdate1.AssetId = oAssetsList[0].Id;
		cliupdate1.CH_ServiceClassification__c = 'SW';
		update cliupdate1;
		
		CH_CoveredNetworkElementAsset__c cnea1=new CH_CoveredNetworkElementAsset__c();
		cnea1.Name='test5';
		cnea1.CH_NetworkElementAsset__c=oAssetsList[0].id;
		cnea1.CH_Status__c='InActive';
		cnea1.CH_ContractLineItem__c=cli[0].Id;
		insert cnea1;
		try{
			oAssetsList[0].CH_CountryISO2__c ='India';
			oAssetsList[0].Status ='Active';
			oAssetsList[0].CH_ContractLineItem__c = null;
			oAssetsList[0].CH_Solution__c =asset[0].CH_Solution__c;
			oAssetsList[0].CH_ProductVariant__c =asset[0].CH_ProductVariant__c;
			oAssetsList[0].Product2Id = asset[0].Product2Id;
			oAssetsList[0].RecordTypeId =asset[0].RecordTypeId;
			update oAssetsList[0];
			
			
		}
		catch(Exception ex){
			System.debug('Exception while updating asset list: ' + ex.getMessage());
		}test.stopTest();  
		system.debug('***validationRuleTest getCpuTime End after test()***'+Limits.getCpuTime());
	}
	
	public static testMethod void assetStatusCheck(){
	  
		Account acc = [Select id from Account limit 1];
		Product2 product = [Select id from Product2 limit 1];
		Schema.Location loc3 = new Schema.Location();
		loc3.Name=LOCATION_NAME;
		loc3.LocationType='Site';
		insert loc3;
		
		Schema.Address addr3 = new Schema.Address();
		addr3.LocationType='Site';
		addr3.ParentId= loc3.id;
		addr3.RecordTypeId = addRecordTypeId;
		insert addr3;
		List<Asset> oAssetsList = new List<Asset> ();
		Asset neAsset =  [Select id from Asset where CH_NetworkElementID__c='Test91'];		
		oAssetsList.add(neAsset);
		test.startTest();CH_TestDataFactory.createCustomSettings();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createContracts(true); 
		
		List<Asset> asset = [select Id,Name ,Product2Id, CH_ProductRelease__c, CH_Solution__c, CH_ProductVariant__c,
		CH_Solution__r.Name, CH_ProductVariant__r.Name, CH_ProductRelease__r.Name
		from Asset where AccountId = :CH_TestDataFactory.tempLegalAccount.Id];
		system.assert(asset.size()>0);
		List<ContractLineItem> cli = [select Id,LineItemNumber, AssetId, CH_ServiceClassification__c  from ContractLineItem where AssetId = :asset[0].Id];
		
		ContractLineItem cliupdate2 = new ContractLineItem();
		cliupdate2.Id = cli[0].Id;
		cliupdate2.AssetId = oAssetsList[0].Id;
		cliupdate2.CH_ServiceClassification__c = 'SW';
		update cliupdate2;
		
		CH_CoveredNetworkElementAsset__c cnea2=new CH_CoveredNetworkElementAsset__c();
		cnea2.Name='test5';
		cnea2.CH_NetworkElementAsset__c=oAssetsList[0].id;
		cnea2.CH_Status__c='Active';
		cnea2.CH_ContractLineItem__c=cli[0].Id;
		insert cnea2;
		
		Asset updateAsset = new Asset();
		updateAsset.Id = oAssetsList[0].Id;
		updateAsset.CH_CountryISO2__c ='India';
		updateAsset.Status ='Inactive';
		updateAsset.CH_ContractLineItem__c = null;
		
		try{
			update updateAsset;
		}
		catch(Exception ex){
			System.debug('Exception while updating Asset: ' + ex.getMessage());
		}
		updateAsset.Id = oAssetsList[0].Id;
		updateAsset.CH_CountryISO2__c ='India';
		updateAsset.Status ='Inactive';
		updateAsset.CH_ContractLineItem__c = null;
		
		try{
			update updateAsset;
		}
		catch(Exception ex){
			System.debug('Exception while updating Asset without CLI: ' + ex.getMessage());
		}
		updateAsset.CH_CountryISO2__c ='India';
		updateAsset.Status ='Inactive';
		updateAsset.CH_ContractLineItem__c = cli[0].Id;
		try{
			update updateAsset;
		}
		catch(Exception ex){
			System.debug('Exception while updating Asset with CLI: ' + ex.getMessage()); 
		}
		updateAsset.Id = oAssetsList[0].Id;
		updateAsset.Name =null;
		updateAsset.CH_NetworkElementID__c =null;
		updateAsset.CH_ContractLineItem__c = null;
		
		try{
			update updateAsset;
		}
		catch(Exception ex){
			System.debug('Exception while updating Asset without CLI and without NE Id: ' + ex.getMessage());
		}
		updateAsset.Id = oAssetsList[0].Id;
		updateAsset.Name =null;
		updateAsset.CH_NetworkElementID__c ='tested345';
		updateAsset.CH_ContractLineItem__c = null;
		
		try{
			update updateAsset;
			
			
		}
		catch(Exception ex){
			System.debug('Exception while updating Asset without CLI and with NE Id: ' + ex.getMessage());
		}
		try{
			Asset neAsset5=new Asset();
			neAsset5.RecordTypeId= assetRecordTypeId;
			neAsset5.CH_NetworkElementID__c='AeTest99';
			neAsset5.Name='56Test99';
			neAsset5.Status='Active';
			neAsset5.Product2Id=product.id;
			neAsset5.CH_ProductVariant__c=product.id;
			neAsset5.CH_Solution__c=product.id;
			neAsset5.AccountId=acc.id;
			neAsset5.CH_CountryISOName__c='USA';
			neAsset5.Address__c=addr3.id;
			neAsset5.CH_ContractLineItem__c = cli[0].Id;
			List<Asset> newAssetList = new List<Asset> ();
			newAssetList.add(neAsset5);
			CH_AssetTriggerHelper.createCoveredNEA(newAssetList);
			
		}
		catch(Exception ex){
			System.debug('Exception while creating CNEA: ' + ex.getMessage());
		}
		test.stopTest();  
		system.debug('***assetStatusCheck getCpuTime()***'+Limits.getCpuTime());
	}
	/*commented below codee as per 36188
	public static testMethod void updateNEATest(){	
	 
	 test.startTest();try{
			List<asset> oAssetsList1 = [select id, name , RecordTypeId, status, CH_AssetNameUniqueKey__c , CH_NetworkElementIDUniqueKey__c from Asset];
			CH_AssetTriggerHelper.UpdateNEA(oAssetsList1);
		}
		catch(Exception ex){
			System.debug('Exception while updating NEA: ' + ex.getMessage());
		}system.debug('***updateNEATest getCpuTime()***'+Limits.getCpuTime());
		test.stopTest();  system.debug('***updateNEATest getCpuTime()***'+Limits.getCpuTime());
	}*/	
}