/** 
* About 
* ----- 
* @Description	  : Case Handling Covered Network Element Asset Object Utility Test Class.
* @Project	: Case Handling.
* @Modification Log : 
*  Created  : 2020 11 03 – tiago.almeida@nokia.com
* ----- 
**/
@isTest
public class CH_CoveredNetworkElementAssetUtils_Test {
	private static List<Asset> oAssetList = new List<Asset>();
	private static ContractLineItem oContractLineItem;
	private static ContractLineItem CLIObj ;
	
	@testSetup	
	static void setupTestData() {
		List<Account> oProspectList = TestDataFactory.createAccount('Prospect', 1, null);
		insert oProspectList;
		//
		Account oLegalEntity = TestDataFactory.createAccount('Legal_Entity', 1, oProspectList.get(0).Id).get(0);
		insert oLegalEntity;
		//
		Contact oContact = TestDataFactory.createContact(1, oProspectList.get(0)).get(0);
		oContact.LastName = 'Test LastName';
		oContact.CH_ContactType__c = 'customer';
		insert oContact;
		//
		List<Product2> oProduct2List = TestDataFactory.createProduct(1);
		insert oProduct2List;
		//
		Schema.Location oLocation = new Schema.Location();
		oLocation.Name='My location';
		oLocation.LocationType='Site';
		oLocation.CH_AccountName__c = oProspectList.get(0).Id;
		insert oLocation;
		//
		Schema.Address oAddress = new Schema.Address();
		oAddress.LocationType='Site';
		oAddress.RecordTypeId = Schema.SObjectType.Address.getRecordTypeInfosByDeveloperName().get('CH_Address').getRecordTypeId();
		oAddress.ParentId= oLocation.id;
		insert oAddress;
		//
		Asset oAsset = TestDataFactory.createAsset('CH_CoveredProduct', 1, oLegalEntity, oProduct2List.get(0)).get(0);
		
		oAsset.Status = 'Active';
		oAssetList.add(oAsset);
		//
		oAsset = TestDataFactory.createAsset('CH_NetworkElementAsset', 1, oProspectList.get(0), oProduct2List.get(0)).get(0);
		
		oAsset.Status = 'Active';
		oAsset.Address__c = oAddress.Id;
		oAssetList.add(oAsset);
		insert oAssetList;
		//
		PriceBookEntry oPriceBookEntry = TestDataFactory.createPriceBookEntry(1, oProduct2List.get(0)).get(0);
		insert oPriceBookEntry;
		//
		ServiceContract oServiceContract = TestDataFactory.createServiceContract(1, oProspectList.get(0), true).get(0);
		oServiceContract.NCP_External_Status__c = 'Active';
		insert oServiceContract;
		//
		oContractLineItem = TestDataFactory.createContractLineItem(1, oServiceContract, oAssetList.get(0), oPriceBookEntry, false).get(0);
		oContractLineItem.CH_ServiceType__c = 'Customer Support';
		oContractLineItem.NCP_External_Status__c = 'Active';
		
		
		CLIObj = new ContractLineItem();
			CLIObj.ServiceContractId = oServiceContract.Id;system.debug('oAssetList sent--->'+oAssetList.get(1).Id);
			
			CLIObj.AssetId = oAssetList.get(1).Id;
			CLIObj.CH_ServiceClassification__c = 'SW Service';
			CLIObj.UnitPrice = 0;
			CLIObj.Quantity = 1;
			CLIObj.PricebookEntryId = oPriceBookEntry.Id;
			CLIObj.CH_ServiceOffering__c = 'test123';
			CLIObj.CH_ServiceType__c = 'Customer Support'; 
			CLIObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';  
			
			Insert CLIObj;
	}
	
	public static testMethod void test1() {
		setupTestData();
		test.startTest();
		//
		insert new Global_Control__c(Other_ProcessFlow__c='CLI-CPBC',All_ProcessFlow__c=true,Disabled__c=true);
		
		List<CH_CoveredNetworkElementAsset__c> oCNEA = CH_CoveredNetworkElementAssetUtils.getAvailableForLinking(CLIObj.Id);
		System.debug('Tiago : ' + oCNEA);
		CH_CoveredNetworkElementAssetUtils.link(oCNEA);
		
		CH_CoveredNetworkElementAssetUtils.get(CLIObj.Id, true);
		CH_CoveredNetworkElementAssetUtils.unlink(oCNEA);
		//
		test.stopTest();
	}
}