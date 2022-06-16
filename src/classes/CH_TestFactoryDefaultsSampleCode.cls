@IsTest(seeallData=false)
public class CH_TestFactoryDefaultsSampleCode {
	
   /* public static testmethod void createUserData(){
		List<user> userList = CH_TestFactoryDefaults.createInternalUsers( true, true, 2, null);
		system.assert(userList.size()==2);
		User portalUser = CH_TestFactoryDefaults.createPortalUser(true, userList[0],null);
		system.debug('portalUser -->'+portalUser.Id);
	}*/
	
	 public static testmethod void createNetworkElementAsset() {
		 //Without Parameter
		/* List<asset> neaAsset = CH_TestFactoryDefaults.createAssetData( true, 1, 'Network Element Asset', null);
		 system.debug('neaAsset -->'+neaAsset);
		
		 System.debug('#####END ###  Limits.getQueries() ' + Limits.getQueries()); 
		 System.debug('#####END ###  Limits.getCpuTime() ' + Limits.getCpuTime()); */
		 //WithParameter		
		 /*list<Account> oAccountList = CH_TestFactoryDefaults.createAccountData( true,  1, 'Legal Entity',null, true);
		 map<string,String> fieldNAme = new map<string, string>();
		 fieldNAme.put('AccountId',oAccountList[0].ID);
		 List<Schema.Address> oAddress = CH_TestFactoryDefaults.createAddressData(true,1,fieldNAme);
		 fieldNAme.put('Address__c',oAddress[0].ID);
		 system.debug('oAddress -->'+oAddress);
		 List<asset> neaAsset = CH_TestFactoryDefaults.createAssetData( true, 1, 'Network Element Asset', fieldNAme);
		 system.debug('neaAsset With Parameter-->'+neaAsset);*/
	 }
	
	public static testmethod void createServiceContractData() {
		Map<String, String> fieldsMap = new Map<String, String>();
		List<Servicecontract> newServiceContract = new List<Servicecontract>();
		List<Account> newLegalEntity = new List<Account>();
		
		//with DML and without passing any related fields
		//newServiceContract = CH_TestFactoryDefaults.createServiceContractData(true, 1, null);
		
		//with DML and Passing Accout
	   /* newLegalEntity = CH_TestFactoryDefaults.createAccountData(true, 1, 'Legal Entity', null, true);
		fieldsMap.put('AccountId', newLegalEntity[0].Id);
		newServiceContract = CH_TestFactoryDefaults.createServiceContractData(true, 1, fieldsMap);
		System.debug('#####END ###  Limits.getQueries() ' + Limits.getQueries()); 
		System.debug('#####END ###  Limits.getCpuTime() ' + Limits.getCpuTime()); //5794
		*/
		
		//Without DML and Passing Account, mapping other required fields
	   /* newLegalEntity = CH_TestFactoryDefaults.createAccountData(true, 1, 'Legal Entity', null, true);
		fieldsMap.put('AccountId', newLegalEntity[0].Id);
		newServiceContract = CH_TestFactoryDefaults.createServiceContractData(false, 1, fieldsMap);
		newServiceContract[0].CH_PortalCaseCreationHWS__c = true;
		insert newServiceContract;
		system.assert(newServiceContract[0].ID!=null);
		
		System.debug('#####END ###  Limits.getQueries() ' + Limits.getQueries()); 
		System.debug('#####END ###  Limits.getCpuTime() ' + Limits.getCpuTime()); */
	}
	
	  @isTest
	public static void createContractLineItemData(){
		Map<String, String> fieldsMap = new Map<String, String>();
		List<ContractLineItem> newContractLineItems = new List<ContractLineItem>();
		List<Servicecontract> newServiceContract = new List<Servicecontract>();
		List<Account> newLegalEntity = new List<Account>();
		List<Asset> newAssets = new List<Asset>();
		List<PriceBookEntry> newPricebookEntry = new List<PriceBookEntry>();
		
		//With DML and without passing any realted fields data
	   /* newContractLineItems = CH_TestFactoryDefaults.createContractLineItemData(true, 1, null);
		system.debug('newContractLineItems Without Parameter '+newContractLineItems);*/
		
		/*newLegalEntity = CH_TestFactoryDefaults.createAccountData(true, 1, 'Legal Entity', null, true);
		fieldsMap.put('AccountId', newLegalEntity[0].Id);
		newServiceContract = CH_TestFactoryDefaults.createServiceContractData(true, 1, fieldsMap);
		fieldsMap.put('ServiceContractId', newServiceContract[0].Id);
		newAssets = CH_TestFactoryDefaults.createAssetData(true, 1,'Covered Product', fieldsMap);
		fieldsMap.Put('AssetId',newAssets[0].Id);
		newContractLineItems = CH_TestFactoryDefaults.createContractLineItemData(true, 1, fieldsMap);
		
		System.debug('#####END ###  Limits.getQueries() ' + Limits.getQueries()); 
		System.debug('#####END ###  Limits.getCpuTime() ' + Limits.getCpuTime());//8649
		*/
		
		
		
		//WithDML - Passing Only AccountId
	   /* newLegalEntity = CH_TestFactoryDefaults.createAccountData(true, 1, 'Legal Entity', null, true);
		fieldsMap.put('AccountId', newLegalEntity[0].Id);
		newContractLineItems = CH_TestFactoryDefaults.createContractLineItemData(false, 2, fieldsMap);
		for(ContractLineItem cli : newContractLineItems){
			cli.CH_ServiceOffering__c ='test2';
		}
		insert newContractLineItems;
		system.assert(newContractLineItems.size() ==2);
		system.assert(newContractLineItems[0].CH_ServiceOffering__c =='test2');	
		system.debug('newContractLineItems With Parameter Only AccountID-- '+newContractLineItems);
		*/
		//WithDML - Passing Only ServiceContract and AccountID 
		//Note - If we pass ServiceContract ID make sure to pass Service Contract's Account Id Only to match with asset's Account Id
	  	/*newServiceContract = CH_TestFactoryDefaults.createServiceContractData(true, 1, null);
		fieldsMap.put('AccountId', newServiceContract[0].AccountId);
		fieldsMap.put('ServiceContractId', newServiceContract[0].Id);
		newContractLineItems = CH_TestFactoryDefaults.createContractLineItemData(true, 1, fieldsMap);
		system.debug('newContractLineItems With Parameter AccountID and ServiceContractId-- '+newContractLineItems);
		*/
		
		//WithDML - Passing Only AssetId and AccountID 
		//Note - If we pass AssetId ID make sure to pass Asset's Account Id Only to match with ServiceContract's Account Id
	  	/*newAssets = CH_TestFactoryDefaults.createAssetData(true, 1,'Covered Product', null);
		fieldsMap.Put('AssetId',newAssets[0].Id);
		fieldsMap.put('AccountId', newAssets[0].AccountId);
		newContractLineItems = CH_TestFactoryDefaults.createContractLineItemData(true, 1, fieldsMap);
		system.debug('newContractLineItems With Parameter AccountID and AssetID-- '+newContractLineItems);*/
		
		//With  DML passing only PricebookEntry
		/*newPricebookEntry = CH_TestFactoryDefaults.createPriceBookEnttry(true,1,null);
		fieldsMap.Put('PriceBookEntryId',newPricebookEntry[0].Id);
		newContractLineItems = CH_TestFactoryDefaults.createContractLineItemData(true, 1, fieldsMap);
		system.debug('newContractLineItems With Parameter PriceBookEntry-- '+newContractLineItems);*/
		
		
		//with DML and Passing all lookup values
	   /* newLegalEntity = CH_TestFactoryDefaults.createAccountData(true, 1, 'Legal Entity', null, true);
		fieldsMap.put('AccountId', newLegalEntity[0].Id);
		newServiceContract = CH_TestFactoryDefaults.createServiceContractData(true, 1, fieldsMap);
		fieldsMap.put('ServiceContractId', newServiceContract[0].Id);
		newAssets = CH_TestFactoryDefaults.createAssetData(true, 1,'Covered Product', fieldsMap);
		fieldsMap.Put('AssetId',newAssets[0].Id);
		newPricebookEntry = CH_TestFactoryDefaults.createPriceBookEnttry(true,1,null);
		fieldsMap.Put('PriceBookEntryId',newPricebookEntry[0].Id);
		newContractLineItems = CH_TestFactoryDefaults.createContractLineItemData(true, 1, fieldsMap);
		
		system.assert(newContractLineItems[0].Id!=null);
		system.debug('With all Look up fields --'+newContractLineItems);
		*/
		
	}
	  @isTest
	public static void createEntitlementData(){
		Map<String, String> fieldsMap = new Map<String, String>();
		List<ContractLineItem> newContractLineItems = new List<ContractLineItem>();
		List<Servicecontract> newServiceContract = new List<Servicecontract>();
		List<Account> newLegalEntity = new List<Account>();
		List<Asset> newAssets = new List<Asset>();
		List<PriceBookEntry> newPricebookEntry = new List<PriceBookEntry>();
		List<Entitlement> newEntiltment = new List<Entitlement>();
		
		//With DML and without passing any realted fields data
	   /*newEntiltment = CH_TestFactoryDefaults.createEntitlement(true, 1, null);
		
	   
		system.assert(newEntiltment[0].ID!=null);
		system.debug('newEntiltment Without Parameter -->'+newEntiltment);
		*/
		
		//With Parameter
		/*newLegalEntity = CH_TestFactoryDefaults.createAccountData(true, 1, 'Legal Entity', null, true);
		fieldsMap.put('AccountId', newLegalEntity[0].Id);
		newServiceContract = CH_TestFactoryDefaults.createServiceContractData(true, 1, fieldsMap);
		fieldsMap.put('ServiceContractId', newServiceContract[0].Id);
		newAssets = CH_TestFactoryDefaults.createAssetData(true, 1,'Covered Product', fieldsMap);
		fieldsMap.Put('AssetId',newAssets[0].Id);
		newContractLineItems = CH_TestFactoryDefaults.createContractLineItemData(true, 1, fieldsMap);
		fieldsMap.Put('ContractLineItemId',newContractLineItems[0].Id);
		
		newEntiltment = CH_TestFactoryDefaults.createEntitlement(true, 1, fieldsMap);
		system.assert(newEntiltment[0].ID!=null);
		system.debug('newEntiltment passing All  -->'+newEntiltment);
		
		System.debug('#####END ###  Limits.getQueries() ' + Limits.getQueries()); 
		System.debug('#####END ###  Limits.getCpuTime() ' + Limits.getCpuTime());//7590
		
		*/
		
		//With DML -  passing Only AccountID
		/*newLegalEntity = CH_TestFactoryDefaults.createAccountData(true, 1, 'Legal Entity', null, true);
		fieldsMap.put('AccountId', newLegalEntity[0].Id);
		newEntiltment = CH_TestFactoryDefaults.createEntitlement(true, 1, fieldsMap);
		system.assert(newEntiltment[0].ID!=null);
		system.debug('newEntiltment passing Only AccountID -->'+newEntiltment);
		*/
		
		//With DML -  passing Only ServiceContractId & AccountID
	   /* newServiceContract = CH_TestFactoryDefaults.createServiceContractData(true, 1, null);
		fieldsMap.put('AccountId', newServiceContract[0].AccountId);
		fieldsMap.put('ServiceContractId', newServiceContract[0].Id);
		newEntiltment = CH_TestFactoryDefaults.createEntitlement(true, 1, fieldsMap);
		system.assert(newEntiltment[0].ID!=null);
		system.debug('newEntiltment passing Only ServiceContractId & AccountID -->'+newEntiltment);
	   */
		 //With DML -  passing Only AssetID & AccountID
	   /* newAssets = CH_TestFactoryDefaults.createAssetData(true, 1,'Covered Product', null);
		fieldsMap.Put('AssetId',newAssets[0].Id);
		fieldsMap.put('AccountId', newAssets[0].AccountId);
		newEntiltment = CH_TestFactoryDefaults.createEntitlement(true, 1, fieldsMap);
		system.assert(newEntiltment[0].ID!=null);
		system.debug('newEntiltment passing Only AssetID & AccountID -->'+newEntiltment);
		*/
		
		//With DML -  passing LineItemId
		/*newContractLineItems = CH_TestFactoryDefaults.createContractLineItemData(true, 1, fieldsMap);
		fieldsMap.Put('AssetId',newContractLineItems[0].AssetId);
		fieldsMap.Put('ServiceContractId',newContractLineItems[0].ServiceContractId);
		fieldsMap.Put('ContractLineItemId',newContractLineItems[0].Id);
		//fieldsMap.put('AccountId', newAssets[0].AccountId);//Must pass by doing query
		newEntiltment = CH_TestFactoryDefaults.createEntitlement(true, 1, fieldsMap);
		system.assert(newEntiltment[0].ID!=null);
		system.debug('newEntiltment passing All  -->'+newEntiltment);*/
		
		//Create Case 
		/*List<user> userList = CH_TestFactoryDefaults.createInternalUsers( true, true, 2, null);
		system.assert(userList.size()==2);
		system.runAs(userList[0]){
			map<string,String> fieldNAme = new map<string,String>();
			List<Entitlement> EntitlementList =  CH_TestFactoryDefaults.createEntitlement(true, 1, null); 
			List<Entitlement> oEntitlementQuery = [select id,AccountId, Account.ParentId, AssetId, Asset.Product2Id from Entitlement where id = :EntitlementList[0].Id];
			system.debug('oEntitlementQuery ---'+oEntitlementQuery);
			List<String> ContactId = CH_TestFactoryDefaults.oAccountContactMap.get(oEntitlementQuery[0].Account.ParentId);
			List<case> caseList = new List<case>();
			Test.startTest();
			Case caseData =  CH_TestFactoryDefaults.createCaseNotSaved('Critical','Yes', false, ContactId[0], oEntitlementQuery[0]);
			system.assert(caseData.Id !=null);
			Test.stopTest();
		}*/
	}
	
	
	
}