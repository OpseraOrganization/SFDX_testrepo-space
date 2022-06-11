@IsTest
public class HWS_TestFactoryDefaults {
	public static final String LEGAL_ENTITY ='Legal Entity';
	public  static list<Account> createAccountData(Boolean isInsert, Integer recordCount, String recordtypeName){
		List<Account> oAccountList = new list<Account>();
		String accountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordtypeName).getRecordTypeId();
		for(Integer i=0; i<recordCount ;i++)
		{
		Account acc = new Account();
		acc.RecordTypeId = accountRecordType;
		acc.name='test';
		acc.P20_Logistic_ID__c= 'test11';
		acc.HWS_Address_Status__c = 'Permanent Address';
		
		 
			oAccountList.add(acc);
		
		}
		
		if(isInsert)
		{
			insert oAccountList;
		}
		return oAccountList;
	}
	public  static list<Contact> createContact(Boolean isInsert, Integer recordCount,  String recordType, map<string,String> fieldNAme){
		list<Contact> contactList = new List<contact>();
		String CustomerAccountId = null;
		if(fieldNAme ==null  ){
			CustomerAccountId = createAccountData(true, 1, LEGAL_ENTITY)[0].Id;
		}else{
			CustomerAccountId =fieldNAme.get('AccountId');
		}
		for(Integer i=0; i<recordCount ; i++){
			Contact con = new Contact(); 
		con.LastName='test';
		con.Contact_Status__c='Active';
		con.CH_ContactType__c='Communication Contact';
		con.email='abc@example.com';
		con.AccountId=CustomerAccountId;
			contactList.add(con);
		}
		if(isInsert){
			insert contactList;
			
		}
		return contactList;
	}
	public static Case insertParentCase (boolean isInsert,Map<String, String> fieldNAme){
		String accountId = null;
		String contactId = null;
		if(fieldNAme ==null  ){
			accountId = createAccountData( true,  1,  LEGAL_ENTITY)[0].Id;
			contactId =createContact( true,  1,  'Customer',  null)[0].Id;
		}else if(fieldNAme !=null){
			accountId = fieldNAme.get('AccountId');			
			contactId = fieldNAme.get('contactId');
		}
		
		Case caserec = new Case();
		Id recordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HWS_Parent_Case').getRecordTypeId();
		for(integer i=1;i<2;i++){ 
			caserec.RecordTypeId =recordTypeId;
			caserec.Status='Closed';
			caserec.Subject='test'+i;
			caserec.Description='test' +i;
			caserec.HWS_Faulty_Serial_Number__c= 'test1234';
			caserec.HWS_ShipTopartyId__c='1234566';
		}
		if(isInsert){
			System.debug('AC ID IN CASE:'+caserec);
			insert caserec;
		}
		return caserec;
	}
	public static List<ServiceContract> createServiceContractData(Boolean isInsert, Integer recordCount, map<string,String> fieldNAme){
		List<ServiceContract> serviceContractDataList = new List<ServiceContract>();
		String accountId = null;
		Id ContractRecordTypeId;
		ContractRecordTypeId = Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
		if(fieldNAme ==null  ){
			accountId = createAccountData( true,  1,  LEGAL_ENTITY)[0].Id;
		}else if(fieldName.get('AccountId')!=null){
			accountId = fieldName.get('AccountId');
		}
		for(Integer i=0;i<recordCount ; i++){
			ServiceContract oServiceContract = new ServiceContract();
			oServiceContract.AccountId =accountId;
		oServiceContract.AccountId=accountId;
		oServiceContract.Name='Exchange in Days';
		oServiceContract.NCP_External_Status__c ='Active';
			oServiceContract.Pricebook2Id = Test.getStandardPricebookId();
		oServiceContract.HWS_SalesOrganisation__c='AWB';
		oServiceContract.recordtypeID = ContractRecordTypeId;
		serviceContractDataList.add(oServiceContract);
			
		}
		if(isInsert){
			insert serviceContractDataList; // PMD ERRORS 
		}
		System.debug('serviceContractDataList---------------------->'+serviceContractDataList);
		return serviceContractDataList;
	}
	public static list<Product2> createProductDataSetUp(Boolean isInsert, Integer recordCount, map<string,String> fieldNAme){
		list<Product2> productDataList = new list<Product2>();
		system.debug('I am here');
		String salesProductRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
		for(Integer i=0; i<recordCount ;i++){
			Product2 productData = new Product2();
			productData.Name = 'HW Services Cluster for Parts'+i;
			productData.RecordTypeId = salesProductRecordTypeId;
			productData.PMD_Portfolio_Classification__c = 'Product';
			productData.CH_Business_Unit__c = 'HW Network Management'+i;
			productDataList.add(productData);
		}
		if(isInsert){
			insert productDataList;
		}
		return productDataList;
	}
	
	// Creation PriceBook
   public static List<PriceBookEntry>  createPriceBookEntry( Boolean isInsert, map<string,String> fieldNAme){
		List<PriceBookEntry> PriceBookEntryList = new List<PriceBookEntry>();
		String productId = null;
	   String pricebookId = null;
		if(fieldNAme ==null){
			productId = createProductDataSetUp( true,  1, null)[0].Id;
			priceBookID = Test.getStandardPricebookId();
		}else{
			productId=fieldNAme.get('Product2Id');
			priceBookID = Test.getStandardPricebookId();
		}
		PriceBookEntry tempPriceBookEntry = new PriceBookEntry();
		tempPriceBookEntry.Product2Id = productId;
		tempPriceBookEntry.UnitPrice = 0;
		tempPriceBookEntry.IsActive = true;
		tempPriceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
		PriceBookEntryList.add(tempPriceBookEntry); 
		if(IsInsert){
			insert PriceBookEntryList;
		}
		return PriceBookEntryList;
	}
   
public static List<ContractLineItem> createContractLineItemData(Boolean isInsert, Integer recordCount, map<string,String> fieldNAme){
		List<ContractLineItem> ContractLineItemDataList = new List<ContractLineItem>();
		String serviceContractId = null;
		string pricebookEntryId = null;
		
		if(fieldNAme ==null ){
			serviceContractId =createServiceContractData( true,  1,  null)[0].ID;
		  pricebookEntryId = createPriceBookEntry(true, null)[0].Id;
		} else{
			serviceContractId = fieldName.get('ServiceContractId') ;
		  pricebookEntryId = fieldName.get('pricebookEntryId') ;
		}
		for(Integer i=0;i<recordCount ; i++){
			ContractLineItem oContractLineItem = new ContractLineItem();
			oContractLineItem.ServiceContractId =serviceContractId;
		   
		//System.DmlException: Insert failed. First exception on row 0; first error: FIELD_INTEGRITY_EXCEPTION, The price book entry is in a different price book than the one assigned to the Service Contract, or Service Contract has no price book assigned.: [PricebookEntryId]
			oContractLineItem.PricebookEntryId = pricebookEntryId;
			oContractLineItem.UnitPrice = 0;
			oContractLineItem.Quantity=1;
			ocontractLineItem.NCP_External_Status__c ='Active';
			oContractLineItem.CH_CountryISOName__c = 'USA';
			oContractLineItem.CH_CDB_EntitlementId__c = 'TEST'+i;
			oContractLineItem.CH_ServiceOffering__c = 'Advanced Exchange in Days (AE-D) (5C)';
			oContractLineItem.CH_ServiceClassification__c = 'HWS Service';
			ContractLineItemDataList.add(oContractLineItem);
		}
		if(isInsert){
			insert ContractLineItemDataList;
		}
		System.debug('ContractLineItemDataList---------------------->'+ContractLineItemDataList);
		return ContractLineItemDataList;
	}
	public  static list<Asset> createAssetData(Boolean isInsert, Integer recordCount, string recordTypeName, map<string,String> fieldNAme){
		list<Asset> oAssetDataList = new list<Asset>();
		String assetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
		String accountId = null;
		String productId =null;
		string addressId =null;
		string cliId = null;
		map<string,String> fieldMap = new map<string,String> ();
		if(fieldNAme ==null){
			accountId =createAccountData( true,  1,  LEGAL_ENTITY)[0].Id;
			cliId = createContractLineItemData(true, 1, null)[0].Id;
			productId = createProductDataSetUp( true, 1,  null)[0].Id; 
			fieldMap.put('AccountId',accountId );
		   
		}
		else {
			accountId = fieldNAme.get('AccountId');
			productId = fieldNAme.get('product2Id');
			addressId = fieldNAme.get('Address__c');
			cliId = fieldNAme.get('ContractLineItemId');
			
		}
	  
		for(Integer i=0; i<recordCount ;i++)
		{
			Asset oASsetData = new Asset();
			oASsetData.Name = 'TestAsset'+i;
			oASsetData.CH_CDB_ExternalAssetId__c = '12334';
			oASsetData.HWS_ContractLineItem__c = cliId;
			oASsetData.recordTypeId = assetRecordTypeId;
			oASsetData.AccountId = accountId;
			oASsetData.product2Id = productId;
			oASsetData.Status='Active';
			if(recordTypeName == 'Covered Part'){
				oASsetData.RecordTypeId= AssetRecordTypeId;
				oASsetData.CH_NetworkElementID__c='Test99'+i;
				oASsetData.Name='Test99'+i;
				oASsetData.CH_CountryISOName__c='USA';
				oASsetData.Address__c=addressId;
			}
			oAssetDataList.add(oASsetData);
		}
		if(isInsert){
			insert oAssetDataList;
		}
		return oAssetDataList;
	}
	Public Static list<HWS_VersionItem__c> createVerionsItems(boolean isInsert, Integer Count, Map<String,String> fieldNAme){
		String productId = null;
		if(fieldNAme ==null  ){
			productId = createProductDataSetUp( true, 1,  null)[0].Id;
		}else if(fieldNAme.get('productId')!=null){
			productId = fieldNAme.get('productId');
		}
		list<HWS_VersionItem__c> version = new list<HWS_VersionItem__c>();
		id  productId1 = createProductDataSetUp( true, 1,  null)[0].Id; 
		HWS_VersionItem__c vid= new HWS_VersionItem__c();
		vid.Name='Test Verion Item';
		vid.HWS_Serial_Number_Traceable__c ='No';
		vid.HWS_Hardware_Sellable_Item__c=productId1;
		version.add(vid);
		if(isInsert){
			insert version;
		}
		return version;
	}
	
	
	public static List<Case> insertChildCase (boolean isInsert, Integer Count, String recordType, Map<String, String> fieldNAme){
		List<Case> childCaseList = new List<Case>();
		String accountId = null;
		String contactId = null;
		String ServiceContractID = null;
		String productId = null;
		String parentCaseId = null;
		String AssetId= null;
		String versionId = null;
		if(fieldNAme ==null  ){
			accountId = createAccountData( true,  1,  LEGAL_ENTITY)[0].Id;
			contactId =createContact( true,  1,  'Customer',  null)[0].Id;
			ServiceContractID =createServiceContractData( true,  1,  null)[0].Id;
			productId = createProductDataSetUp( true, 1,  null)[0].Id;
		   AssetId =createAssetData( true,  1,'Covered Part', null)[0].id;
			parentCaseId = insertParentCase(true, null).Id;
			versionId = createVerionsItems(true, 1, null)[0].id;
		}else if(fieldNAme !=null){
			accountId = fieldNAme.get('AccountId');
			contactId = fieldNAme.get('contactId');
			ServiceContractID = fieldNAme.get('ServiceContractId');
			productId = fieldNAme.get('Product2Id');
			AssetId = fieldNAme.get('AssetId');
			parentCaseId = fieldNAme.get('ParentCase');
			versionId = fieldNAme.get('versionItemId');
		}
		Case childcaserec = new Case();
		Id recordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId();
		for(integer i=1;i<=Count;i++){
			childcaserec.RecordTypeId =recordTypeId;
			childcaserec.AccountId = accountId;
			childcaserec.ContactId = contactId;
			childcaserec.ServiceContractId = ServiceContractID;
			childcaserec.ProductId = productId;
			childcaserec.AssetId = AssetId;
			childcaserec.HWS_Stockable_Product__c = versionId;
			childcaserec.Status='Draft';
			childcaserec.Subject='test'+i;
			childcaserec.Description='test' +i;
			childcaserec.HWS_Faulty_Serial_Number__c= 'test1234';
			childcaserec.HWS_ShipTopartyId__c='1234566';
			childcaserec.ParentId = parentCaseId;
			childcaserec.Country__c = 'United States of America';
			childcaserec.HWS_Sellable_Product__c = productId;
			childcaserec.HWS_RequestHWRCAFMA__c=true;
			childcaserec.HWS_RelatedSoftwareTicketNumber__c='12345';
			childcaserec.HWS_Sponsor__c = 'Test Sponsor';
		
			childCaseList.add(childcaserec);
		}
		if(isInsert){
			try{
			insert childCaseList;
			}
			catch(Exception e){
				childCaseList = new List<Case>();
				for(integer i=1;i<=Count;i++){
					childcaserec.RecordTypeId =recordTypeId;
					childcaserec.AccountId = accountId;
					childcaserec.ContactId = contactId;
					childcaserec.ServiceContractId = ServiceContractID;
					childcaserec.ProductId = productId;
					childcaserec.AssetId = AssetId;
					childcaserec.HWS_Stockable_Product__c = versionId;
					childcaserec.Status='Draft';
					childcaserec.Subject='test'+i;
					childcaserec.Description='test' +i;
					childcaserec.HWS_Faulty_Serial_Number__c= 'test1234';
					childcaserec.HWS_ShipTopartyId__c='1234566';
					childcaserec.ParentId = parentCaseId;
					childcaserec.Country__c = 'United States of America';
					childcaserec.HWS_Sellable_Product__c = productId;
					childcaserec.HWS_RequestHWRCAFMA__c=true;
					childCaseList.add(childcaserec);
				}
				if(isInsert){
					insert childCaseList;
				}
			}
		}
		return childCaseList;
	}
	Public Static Case createCase(Id recordType){
		Case newCase = new Case();
		newCase.RecordTypeId=recordType;
		newCase.Subject='Test Subject';
		newCase.Description='Test desc';
		return newCase;
	}
}