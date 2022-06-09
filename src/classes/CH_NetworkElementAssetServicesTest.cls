@isTest(seealldata = false)
private class CH_NetworkElementAssetServicesTest { 

	public static final string locationvalue='My location';
	public static final string getHWSfieldvalue='HW Service';
	public static final string assetstrng = 'asset =';
	public static final string clistring='cli = ';
	
	@testSetup static void setup() {
		
		Schema.Location loc = new Schema.Location();
		loc.Name=locationvalue;
		loc.LocationType='Site';
		insert loc;
		
		
		Id addRecordTypeId=Schema.SObjectType.Address.getRecordTypeInfosByDeveloperName().get('CH_Address').getRecordTypeId();
		Schema.Address addr = new Schema.Address();
		addr.LocationType='Site';
		addr.RecordTypeId = addRecordTypeId;
		addr.ParentId= loc.id;
		insert addr;
		 
	}
	
	static testmethod void test1(){ 
		
		test.startTest();
		
		map<String,string> result = CH_NetworkElementAssetServices.getFieldDetails(getHWSfieldvalue);
		system.assert(result.size()>0);
		
		test.stopTest();
		
	}
	
	static testmethod void test2(){ 
		
		test.startTest();
		
		List<String> existingFilter = new List<String>();
		existingFilter.add('CH_NetworkElementID__c');
		List<String> result = CH_NetworkElementAssetServices.getFilterPickListValue(existingFilter, getHWSfieldvalue);
		system.assert(result.size()>0);
		
		test.stopTest();
		
	}
 
	
	static testmethod void test4(){ 
		
		test.startTest();
		
		CH_TestDataFactory.createCustomSettings();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createContracts(true);
		
		List<String> existingFilter = new List<String>();
		existingFilter.add('CH_NetworkElementID__c');
		
		List<Asset> asset = [select Id,Name from Asset where AccountId = :CH_TestDataFactory.tempLegalAccount.Id];
		system.assert(asset.size()>0);
		System.debug(assetstrng+ asset[0].Id); 
		List<ContractLineItem> cli = [select Id,LineItemNumber, AssetId from ContractLineItem 
	 where AssetId = :asset[0].Id];
		System.debug(clistring+ cli[0].Id); 
		string cliNumber = cli[0].Id;
		
		String fieldLabel='';
		List<String> existingFilter1 = new List<String>();
		CH_NetworkElementAssetServices.getFilterFieldDetails(fieldLabel,existingFilter,false,cliNumber,getHWSfieldvalue);
		CH_NetworkElementAssetServices.getFilterFieldDetails(fieldLabel,existingFilter1,false,cliNumber,getHWSfieldvalue);
		
		test.stopTest();
		
	}
	
	static testmethod void test5(){ 
		
		test.startTest();
		
		String jsonFieldFilter;
		string jsonFieldFilterList;
		List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper> filterWarpperList =  new List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>();
		CH_NetworkElementAssetWrapper.FilterSelectionWrapper fWrapper = new CH_NetworkElementAssetWrapper.FilterSelectionWrapper();
		filterWarpperList.add(fWrapper);
		jsonFieldFilterList = JSON.serialize(filterWarpperList);
		jsonFieldFilter = JSON.serialize(fWrapper);
		CH_NetworkElementAssetServices.assignSelectedFieldsForFilter(jsonFieldFilter,jsonFieldFilterList);
		
		test.stopTest();
		
	}
	
	static testmethod void test6(){ 
		//As per sonarcube fixes removed unused local variables in this method
		test.startTest();
		
		CH_TestDataFactory.createCustomSettings();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createContracts(true);
		
		List<Asset> asset = [select Id,Name from Asset where AccountId = :CH_TestDataFactory.tempLegalAccount.Id];
		system.assert(asset.size()>0);
		System.debug(assetstrng+ asset[0].Id); 
		
		List<ContractLineItem> cli = [select Id,LineItemNumber, AssetId from ContractLineItem 
	 where AssetId = :asset[0].Id];
		
		string cliNumber = cli[0].Id;
		
		List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper> sFWrapper = new List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>();
		
		String searchKeyWord = '123';
		String sortedBy = 'AssetNID';
		String sortedDirection = 'DESC';
		
		String jsonFiterSelected1='[{"fieldAPI":"CH_City__c","fieldList":["Status","Network Element ID","State/Province","City"],"fieldName":"City","isNew":true,"isPickValue":true,"isSelected":false,"operators":["Equals","NotEquals"],"picklistValue":["Casablanca","Geneva","Kolkata","Lisboa"],"fieldValue":"Geneva","fieldOperator":"Equal"}]';
		
		CH_NetworkElementAssetServices.fetchAssetNetworkElementWithSearch(1,10,cliNumber,searchKeyWord,jsonFiterSelected1,sortedBy,sortedDirection,'Unlink',getHWSfieldvalue); 
		CH_NetworkElementAssetUtility.fetchAssetNetworkElementWithSearch(1, 10, cliNumber, 'test', jsonFiterSelected1, 'AssetName', 'ASC', 'HWS Service') ;
	 
		test.stopTest();
	}
	
	static testmethod void test7(){ 
		
		test.startTest();
		
		List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper> fieldList = new List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>();
		
		String jsonFieldFilterList1 = JSON.serialize(fieldList);
		CH_NetworkElementAssetServices.cancelSelectedFieldsForFilter(jsonFieldFilterList1);
		
		test.stopTest();
		
	}  
	
	static testmethod void test8(){ 
		//As per sonarcube fixes removed unused local variables
		test.startTest();
		
		CH_TestDataFactory.createCustomSettings();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createContracts(true);
		
		List<Asset> asset = [select Id,Name from Asset where AccountId = :CH_TestDataFactory.tempLegalAccount.Id];
		System.debug(assetstrng+ asset[0].Id); 
		system.assert(asset.size()>0);
		List<ContractLineItem> cli = [select Id,LineItemNumber, AssetId from ContractLineItem  where AssetId = :asset[0].Id];
		System.debug(clistring+ cli[0].Id); 
		string cliNumber = cli[0].Id;
		ContractLineItem cliUpdate = new ContractLineItem();
		cliUpdate.ID = cli[0].Id;
		cliUpdate.CH_ServiceClassification__c ='SW Service';
		update cliUpdate;
		String jsonFieldFilter;
		string jsonFieldFilterList;
		List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper> filterWarpperList = new List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>();
		CH_NetworkElementAssetWrapper.FilterSelectionWrapper fWrapper = new CH_NetworkElementAssetWrapper.FilterSelectionWrapper();
		filterWarpperList.add(fWrapper);
		jsonFieldFilterList = JSON.serialize(filterWarpperList);
		jsonFieldFilter = JSON.serialize(fWrapper);
		
		List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper> sFWrapper = new List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>();
		String jsonFiterSelected = JSON.serialize(sFWrapper);
		String searchKeyWord = '123';
		String sortedBy = 'AssetNID';// 'CH_NetworkElementAsset__r.CH_NetworkElementID__c'
		String sortedDirection = 'DESC';
		
		
		CH_NetworkElementAssetServices.fetchAsset(1,10,cliNumber,searchKeyWord,jsonFiterSelected,sortedBy,sortedDirection,getHWSfieldvalue);
		 List<string> selectedRowID = new  List<string>();
		selectedRowID.add(asset[0].Id);
		CH_NetworkElementAssetServices.unlinkToCoveredNetworkElement(cliNumber, selectedRowID);
		CH_NetworkElementAssetServices.getServiceClassification(cliNumber);
		test.stopTest();
	}  
	
	static testmethod void test9(){ 
	   //As per sonarcube fixes removed unused local variables
		test.startTest();
		
		CH_TestDataFactory.createCustomSettings();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createContracts(true);
		
		List<String> existingFilter = new List<String>();
		existingFilter.add('CH_NetworkElementID__c');
		CH_NetworkElementAssetServices.getFilterPickListValue(existingFilter, getHWSfieldvalue);
		
		List<Asset> asset = [select Id,Name from Asset where AccountId = :CH_TestDataFactory.tempLegalAccount.Id];
		System.debug(assetstrng+ asset[0].Id); 
		List<ContractLineItem> cli = [select Id,LineItemNumber, AssetId from ContractLineItem 
	 where AssetId = :asset[0].Id];/*where ServiceContractId=:sContract.Id*/
		System.debug(clistring+ cli[0].Id); 
		string cliNumber = cli[0].Id;
		
		List<String> result = CH_NetworkElementAssetServicesHelper.getAddressesOptions(cliNumber,'CH_City__c' ); 
		system.assert(result.size()==0);	
		
		test.stopTest();
		
	}
	
	static testmethod void test10(){ 
		// As per sonarcube fixes removed unused local variables
		test.startTest();
		
		CH_TestDataFactory.createCustomSettings();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createContracts(true);
		
		List<String> existingFilter = new List<String>();
		existingFilter.add('CH_NetworkElementID__c');
		CH_NetworkElementAssetServices.getFilterPickListValue(existingFilter, getHWSfieldvalue);
		
		List<Asset> asset = [select Id,Name from Asset where AccountId = :CH_TestDataFactory.tempLegalAccount.Id];
		System.debug(assetstrng+ asset[0].Id); 
		List<ContractLineItem> cli = [select Id,LineItemNumber, AssetId from ContractLineItem 
	 where AssetId = :asset[0].Id];/*where ServiceContractId=:sContract.Id*/
		System.debug(clistring+ cli[0].Id); 
		string cliNumber = cli[0].Id;
		
		CH_NetworkElementAssetServicesHelper.getServiceClassificationType(cliNumber);	
		test.stopTest();
		
	}
	
	static testmethod void testUtility1(){ 
		// As per sonarcube fixes removed unused local variables
		test.startTest();
		
		CH_TestDataFactory.createCustomSettings();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createContracts(true);
		
		List<String> existingFilter = new List<String>();
		existingFilter.add('CH_NetworkElementID__c');
		CH_NetworkElementAssetServices.getFilterPickListValue(existingFilter, getHWSfieldvalue);
		
		List<Asset> asset = [select Id,Name from Asset where AccountId = :CH_TestDataFactory.tempLegalAccount.Id];
		System.debug(assetstrng+ asset[0].Id); 
		List<ContractLineItem> cli = [select Id,LineItemNumber, AssetId from ContractLineItem 
	 where AssetId = :asset[0].Id];/*where ServiceContractId=:sContract.Id*/
		System.debug(clistring+ cli[0].Id);	string cliNumber = cli[0].Id;
		
		CH_NetworkElementAssetUtility.unlinkToCoveredNetworkElement(cliNumber,new List<String>());
		test.stopTest();
		
	}
	
	static testmethod void testUtility2(){ 
		// As per sonarcube fixes removed unused local variables
		test.startTest();
		
		CH_TestDataFactory.createCustomSettings();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createContracts(true);
		
		List<String> existingFilter = new List<String>();
		existingFilter.add('CH_NetworkElementID__c');
		CH_NetworkElementAssetServices.getFilterPickListValue(existingFilter, getHWSfieldvalue);
		
		List<Asset> asset = [select Id,Name from Asset where AccountId = :CH_TestDataFactory.tempLegalAccount.Id];
		System.debug(assetstrng+ asset[0].Id); 
		List<ContractLineItem> cli = [select Id,LineItemNumber, AssetId from ContractLineItem 
	 where AssetId = :asset[0].Id];/*where ServiceContractId=:sContract.Id*/
		System.debug(clistring+ cli[0].Id); 
	  
		string cliNumber = cli[0].Id;
		
	
		
		CH_NetworkElementAssetUtility.addToCoveredNetworkElement(cliNumber,new List<String>());
		test.stopTest();
		
	}
	
	static testmethod void CH_CreateNEA_ControllerTestMethod(){ 
	
		// As per sonarcube fixes removed unused local variables
		Schema.Location loc = new Schema.Location();
		loc.Name=locationvalue;
		loc.LocationType='Site';
		insert loc;
		
		
		Id addRecordTypeId=Schema.SObjectType.Address.getRecordTypeInfosByDeveloperName().get('CH_Address').getRecordTypeId();
		Schema.Address addr = new Schema.Address();
		addr.LocationType='Site';
		addr.RecordTypeId = addRecordTypeId;
		addr.ParentId= loc.id;
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
		insert NEAsset;
		CH_TestDataFactory.createCustomSettings();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createContracts(true); 
		 test.startTest();
		List<Asset> asset = [select Id,Name ,Product2Id, CH_ProductRelease__c, CH_Solution__c, CH_ProductVariant__c,
		CH_Solution__r.Name, CH_ProductVariant__r.Name, CH_ProductRelease__r.Name
		from Asset where AccountId = :CH_TestDataFactory.tempLegalAccount.Id];
		system.assert(asset.size()>0);
		System.debug(assetstrng+ asset[0].Id); 
		List<ContractLineItem> cli = [select Id,LineItemNumber, AssetId, CH_ServiceClassification__c  from ContractLineItem where AssetId = :asset[0].Id];
		System.debug(clistring+ cli[0].Id); 
		string cliNumber = cli[0].Id;
	
		ContractLineItem cliupdate = new ContractLineItem();
		cliupdate.Id = cli[0].Id;
		cliupdate.AssetId = NEAsset.Id;
		cliupdate.CH_ServiceClassification__c = 'SW';
		update cliupdate;
		
		CH_CoveredNetworkElementAsset__c cnea=new CH_CoveredNetworkElementAsset__c();
		cnea.Name='test5';
		cnea.CH_NetworkElementAsset__c=NEAsset.id;
		cnea.CH_Status__c='Active';
		cnea.CH_ContractLineItem__c=cli[0].Id;
		insert cnea;
		
		CH_NetworkElementAssetServices.fetchAssetFromNetworkElement(1,20,cliNumber); 
		CH_NetworkElementAssetWrapper.AssetPagerWrapper obj = new CH_NetworkElementAssetWrapper.AssetPagerWrapper ();
		List<Asset> oAssets = new List<Asset> ();
		oAssets.add(NEAsset);
		obj.oAssets = oAssets;
		CH_NetworkElementAssetServicesHelper.assignPicklistValueForasset(obj);
		test.stopTest();
		
	 }  
	
	
	 static testmethod void addNETestMethod(){ 
	
		// As per sonarcube fixes removed unused local variables
		Schema.Location loc = new Schema.Location();
		loc.Name=locationvalue;
		loc.LocationType='Site';
		insert loc;
		
		Id addRecordTypeId=Schema.SObjectType.Address.getRecordTypeInfosByDeveloperName().get('CH_Address').getRecordTypeId();
		Schema.Address addr = new Schema.Address();
		addr.LocationType='Site';
		addr.RecordTypeId = addRecordTypeId;
		addr.ParentId= loc.id;
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
		
		List<Asset> oAssetsList = new List<Asset> ();
		Id AssetRecordTypeId=Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_NetworkElementAsset').getRecordTypeId();
		Asset NEAsset=createNEAASset(AssetRecordTypeId,'90999', 'T90999','Active',Product,addr.id,acc );
		
		oAssetsList.add( NEAsset);
		 
		Asset NEAsset2=createNEAASset(AssetRecordTypeId,'90Test999', 'T90est999','Active',Product,addr.id,acc );
		oAssetsList.add( NEAsset2);
		Asset NEAsset3=createNEAASset(AssetRecordTypeId,'90T0est999', 'T90est9990','Active',Product,addr.id,acc );
		oAssetsList.add( NEAsset3);
	insert  oAssetsList;
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
		System.debug(assetstrng+ asset[0].Id); 
		List<ContractLineItem> cli = [select Id,LineItemNumber, AssetId, CH_ServiceClassification__c  from ContractLineItem where AssetId = :asset[0].Id];
		System.debug(clistring+ cli[0].Id); 
		
	  
		ContractLineItem cliupdate = new ContractLineItem();
		cliupdate.Id = cli[0].Id;
		cliupdate.AssetId = oAssetsList[0].Id;
		cliupdate.CH_ServiceClassification__c = 'SW';
		update cliupdate;
		 
	Asset asset1 = [select Id,Name ,Product2Id, CH_ProductRelease__c, CH_Solution__c, CH_ProductVariant__c,
		CH_Solution__r.Name, CH_ProductVariant__r.Name, CH_ProductRelease__r.Name
		from Asset where recordTypeId = :AssetRecordTypeId limit 1]; 
		
		CH_CoveredNetworkElementAsset__c cnea=new CH_CoveredNetworkElementAsset__c();
		cnea.Name='test5';
		cnea.CH_NetworkElementAsset__c=asset1.id;
		cnea.CH_Status__c='InActive';
		cnea.CH_ContractLineItem__c=cli[0].Id;
		insert cnea;
	
		 List<string> selectedRowID = new List<string> ();
		 selectedRowID.add(asset1.id);
		 try{
	 CH_NetworkElementAssetUtility.addToCoveredNetworkElement(cli[0].Id, selectedRowID);
		 }
		 catch(Exception ex){
			System.assert(ex.getMessage()!=null);
		 }
		 try{
	 CH_NetworkElementAssetUtility.unlinkToCoveredNetworkElement(cli[0].Id, selectedRowID);
		 }
		 catch(Exception ex){
			System.assert(ex.getMessage()!=null);
		 }
		 CH_NetworkElementAssetUtility.getAllAssetId( oAssetsList);
		 List<CH_CoveredNetworkElementAsset__c> networkEleAssests = new List<CH_CoveredNetworkElementAsset__c> ();
		networkEleAssests.add(cnea);
		CH_NetworkElementAssetUtility.getAllNEId( networkEleAssests);
		test.stopTest();
		
	 }
	
	public static Asset createNEAASset(String AssetRecordTypeId, String neid, string name, string status, Product2 oProduct, String addressId, account acc){
		Asset NEAsset=new Asset();
		NEAsset.RecordTypeId= AssetRecordTypeId;
		NEAsset.CH_NetworkElementID__c=neid;
		NEAsset.Name=name;
		NEAsset.Status=status;
		NEAsset.Product2Id=oProduct.id;
		NEAsset.CH_ProductVariant__c=oProduct.id;
		NEAsset.CH_Solution__c=oProduct.id;
		NEAsset.AccountId=acc.id;
		NEAsset.CH_CountryISOName__c='USA';
		NEAsset.Address__c=addressId;
		return NEAsset;
	}
	
}