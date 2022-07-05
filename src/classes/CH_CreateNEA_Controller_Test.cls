@isTest(seealldata = false)
public class CH_CreateNEA_Controller_Test {  
	
	static testmethod void CH_CreateNEA_ControllerTestMethod(){ 
		test.startTest();
		
		Schema.Location loc = new Schema.Location();
		loc.Name='My location';
		loc.LocationType='Site';
		insert loc;
		
		Schema.Address addr = new Schema.Address();
		addr.LocationType='Site';
		addr.ParentId= loc.id;
		Id addRecordTypeId=Schema.SObjectType.Address.getRecordTypeInfosByDeveloperName().get('CH_Address').getRecordTypeId();	
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
		string AccountId=acc.id;
		
		Id prodRecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		Product2 Product=new Product2();
		Product.Name='test1';
		Product.RecordTypeId=prodRecordTypeId;
		Product.Apttus_Config2__Uom__c='Each';
		Product.Apttus_Config2__ConfigurationType__c='Standalone';
		Product.Apttus_Config2__Version__c=1.00;
		Product.Is_Dummy_Bundle_CPQ__c='No';
		Product.NCP_Marketing_Text__c='Creating it for test';
		insert Product;
		string ProductId=Product.id;
		
		Id AssetRecordTypeId=Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_NetworkElementAsset').getRecordTypeId();
		Asset NEAsset=new Asset();
		NEAsset.RecordTypeId= AssetRecordTypeId;
		NEAsset.CH_NetworkElementID__c='Test99';
		NEAsset.Name='Test99';
		NEAsset.Status='Active';
		NEAsset.Product2Id=Product.id;
		NEAsset.CH_ProductVariant__c=Product.id;
		NEAsset.CH_Solution__c=Product.id;
		NEAsset.AccountId=acc.id;
		NEAsset.CH_CountryISOName__c='USA';
		NEAsset.Address__c=addr.id;
		
		CH_TestDataFactory.createCustomSettings();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createContracts(true); 
		
		List<Asset> asset = [select Id,Name from Asset where AccountId = :CH_TestDataFactory.tempLegalAccount.Id];
		system.assert(asset.size()>0);
		System.debug('asset ='+ asset[0].Id); 
		List<ContractLineItem> cli = [select Id,LineItemNumber, AssetId, CH_ServiceClassification__c  from ContractLineItem where AssetId = :asset[0].Id];
		System.debug('cli = '+ cli[0].Id); 
		string cliNumber = cli[0].Id;
		
		CH_CreateNEA_Controller.validatePermissionSet();
		CH_CreateNEA_Controller.CheckforButton(cli[0].Id);
		CH_CreateNEA_Controller.getAddressCountryName(addr.id); 
		CH_CreateNEA_Controller.saveNEARecord(NEAsset, false);
		CH_CreateNEA_Controller.getCLIDetails(cli[0].Id);
		CH_CreateNEA_Controller.getCountryName();// NOKIASC-36196
		try{
			CH_CreateNEA_Controller.getCLIDetails(NEAsset.Id); 
		}catch(Exception ex ){
			System.assert(ex.getMessage()!=null); 
		}
		try{
			CH_CreateNEA_Controller.getAddressCountryName(null); 
		}catch(Exception ex ){
			System.assert(ex.getMessage()!=null); 
		}
		try{
			CH_CreateNEA_Controller.saveNEARecord(asset[0], false);
		}catch(Exception ex ){
			System.assert(ex.getMessage()!=null); 
		}
		test.stopTest();
	}  
}