/****************************************
* Class Name : CH_CLI_AutocopyCNEABatch_Test
* Created Date: 23 March 2020
* Created By : lokanadha.reddy.ext@nokia.com
* Last Modified by: lokanadha.reddy.ext@nokia.com
* Last Modified Date: 23 March 2020
* Description : This test class for CH_CLI_AutocopyCNEABatch is used to update Covered network element Asset records when Previous CDB on Contract line item is equal to CDB Entitlement id of previous records of CLI.
* Reference: NOKIASC-27536
*****************************************/
@isTest
public class CH_CLI_AutocopyCNEABatch_Test {
	public static User runAsUser = new User(Id = UserInfo.getUserId());
	private static PriceBookEntry tempPriceBookEntry;
	static testmethod void Ch_cneatest(){ 
		test.startTest();
		// Creation Location
		Schema.Location loc = new Schema.Location();
		loc.Name='My location';
		loc.LocationType='Site';
		insert loc;
		// Creation Address
		Id addRecordTypeId=Schema.SObjectType.Address.getRecordTypeInfosByName().get('CH Address').getRecordTypeId();
		Schema.Address addr = new Schema.Address();
		addr.RecordTypeId = addRecordTypeId;
		addr.LocationType='Site';
		addr.ParentId= loc.id;
		insert addr;
		
		Id accRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		Account acc=new Account();
		acc.Name='test';
		acc.RecordTypeId=accRecordTypeId;
		acc.BillingCountry='India';
		acc.BillingCity='Hyd';
		acc.BillingStreet='Hyd';
		acc.Customer_Compliance__c='US_Sprint';
		insert acc;
		string AccountId=acc.id;
		
		Id prodRecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Business Line').getRecordTypeId();
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
		 CH_ProductRelease__c prodRelObj = new CH_ProductRelease__c();
	  prodRelObj.Name = 'testing prodRelObj';
		insert prodRelObj;
		
		Id AssetRecordTypeId1=Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Network Element Asset').getRecordTypeId();
		Asset Asset2=new Asset();
		Asset2.RecordTypeId = AssetRecordTypeId1;
		Asset2.CH_NetworkElementID__c='Test99';
		Asset2.Name='Test99';
		Asset2.Status='Active';
		Asset2.Product2Id=Product.id;
		Asset2.CH_ProductVariant__c=Product.id;
		Asset2.CH_Solution__c=Product.id;
		Asset2.AccountId=acc.id;
		Asset2.CH_CountryISOName__c='USA';
		Asset2.Address__c=addr.id;
		Asset2.CH_ProductRelease__c= prodRelObj.id;
		insert Asset2;
		
		Id AssetRecordTypeId=Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Network Element Asset').getRecordTypeId();
		Asset NEAsset=new Asset();
		NEAsset.RecordTypeId= AssetRecordTypeId;
		NEAsset.CH_NetworkElementID__c='Test998';
		NEAsset.Name='Test998';
		NEAsset.Status='Active';
		NEAsset.Product2Id=Product.id;
		NEAsset.CH_ProductVariant__c=Product.id;
		NEAsset.CH_Solution__c=Product.id;
		NEAsset.AccountId=acc.id;
		NEAsset.CH_CountryISOName__c='USA';
		NEAsset.Address__c=addr.id;
		insert NEAsset;
		string NEA=NEAsset.id;
		
		// Creation PriceBook
		PriceBookEntry tempPriceBookEntry = new PriceBookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = ProductId,
			UnitPrice = 0,
			CurrencyIsoCode = 'EUR',
			IsActive = true
		);
		Insert tempPriceBookEntry;
		string tempid = tempPriceBookEntry.id;
		
		// Service contract
		Id SCID=Schema.SObjectType.ServiceContract.getRecordTypeInfosByName().get('Parent Service Contract').getRecordTypeId();
		ServiceContract serviceContract = new ServiceContract();
		serviceContract.RecordTypeId = SCID;
		serviceContract.Name = 'SCCLI';
		serviceContract.AccountId = AccountId;
		serviceContract.Pricebook2Id = Test.getStandardPricebookId();
		serviceContract.CurrencyIsoCode = tempPriceBookEntry.CurrencyIsoCode;
		insert serviceContract;
		string sccid = serviceContract.id;
		
		//CLI Creation 2
		ContractLineItem cli2 = new ContractLineItem();
		cli2.PricebookEntryId = tempid;
		cli2.Quantity = 3;
		cli2.ServiceContractId = sccid;
		cli2.UnitPrice = 5;
		cli2.CH_isCNEACopyRequied__c = true;
		cli2.CH_PreviousCDBEntitlementId__c = '10024';
		cli2.CH_ServiceClassification__c = 'HWS Service';
		cli2.CH_CountryISOName__c = 'USA';
		cli2.AssetId = Asset2.Id;
		insert cli2;
		
		//CLI Creation
		ContractLineItem cli = new ContractLineItem();
		cli.PricebookEntryId = tempid;
		cli.Quantity = 2;
		cli.ServiceContractId = sccid;
		cli.UnitPrice = 4;
		cli.CH_CDB_EntitlementId__c = '10024';
		cli.CH_ServiceClassification__c = 'HWS Service';
		cli.CH_CountryISOName__c = 'USA';
		cli.AssetId = Asset2.Id;
		insert cli;
		string cliid = cli.id;
		
		// CNEA record creation
		CH_CoveredNetworkElementAsset__c cnea = new CH_CoveredNetworkElementAsset__c();
		cnea.Name = 'rcnea';
		cnea.CH_Status__c = 'Active';
		cnea.CH_ContractLineItem__c = cli.id;
		cnea.CH_NetworkElementAsset__c = NEAsset.id;
		insert cnea;
	
		CH_CLI_AutocopyCNEABatch batch11 = new CH_CLI_AutocopyCNEABatch();
		Database.executebatch(batch11);
		test.stopTest();
		
	}
}