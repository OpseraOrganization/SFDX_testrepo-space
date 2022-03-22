@istest
public class CH_EntitlementTestData {
	public static Map < String, RecordType > recordTypeMap = getRecordTypeByDeveloperName();
	
	public static Map < String, RecordType > getRecordTypeByDeveloperName() {
		if(recordTypeMap == null) {
			recordTypeMap = new Map < String, RecordType > ();
			for(RecordType recordTypeObj: [SELECT Id, Name, DeveloperName FROM RecordType where SobjectType = :'Account' OR SobjectType = :'Case' OR SobjectType = :'ServiceContract' OR SobjectType = :'Entitlement' OR SobjectType = :'Asset' OR SobjectType = :'Product'] ) {
				recordTypeMap.put(recordTypeObj.DeveloperName, recordTypeObj);
			}
		}
		return recordTypeMap;
	}
	
	static BusinessHours stdBusinessHours = [select id, name from BusinessHours where IsActive = true AND IsDefault = true];
	
	public static void createCustomSettingData(){ 
		//Creating Custom Setting Data for Valid Account Name
		CH_AccountName__c accauth = new CH_AccountName__c();
		accauth.CH_InvalidName__c = 'Nokia';
		accauth.CH_ValidName__c = 'Nokia-OYJ';
		insert accauth;		
	}
	
	public static List < Group > createGroups() {
		List < Group > groupList = new List < Group > ();
		Group groupObj = new Group();
		groupObj.Name = 'SEC|Cox|||';
		groupObj.type ='Regular';
		groupObj.DeveloperName = 'SECCox1';
		groupList.add(groupObj);
		
		groupObj = new Group();
		groupObj.Name = 'SEC|Sprint|||';
		groupObj.type ='Regular';
		groupObj.DeveloperName = 'SECSprint1';
		groupList.add(groupObj);
		
		groupObj = new Group();
		groupObj.Name = 'SEC|ATT|||';
		groupObj.type ='Regular';
		groupObj.DeveloperName = 'SECATT1';
		groupList.add(groupObj);
		
		groupObj = new Group();
		groupObj.Name = 'SEC|USG|||';
		groupObj.type ='Regular';
		groupObj.DeveloperName = 'SECUSG1';
		groupList.add(groupObj);
		
		groupObj = new Group();
		groupObj.Name = 'SEC|VWireless|||';
		groupObj.type ='Regular';
		groupObj.DeveloperName = 'SECVWireless1';
		groupList.add(groupObj);
		
		groupObj = new Group();
		groupObj.Name = 'SEC|VWireline|||';
		groupObj.type ='Regular';
		groupObj.DeveloperName = 'SECVWireline1';
		groupList.add(groupObj);
		
		groupObj = new Group();
		groupObj.Name = 'SEC|ALTICE|||';
		groupObj.type ='Regular';
		groupObj.DeveloperName = 'SECALTICE1';
		groupList.add(groupObj);
		
		groupObj = new Group();
		groupObj.Name = 'SEC|SCEC|||';
		groupObj.type ='Regular';
		groupObj.DeveloperName = 'SECSCEC1';
		groupList.add(groupObj);
		
		groupObj = new Group();
		groupObj.Name = 'SEC|NATO|||';
		groupObj.type ='Regular';
		groupObj.DeveloperName = 'SECNATO1';
		groupList.add(groupObj);
		
		groupObj = new Group();
		groupObj.Name = 'PGRoleMembers';
		groupObj.type ='Regular';
		groupObj.DeveloperName = 'PGRoleMembers1';
		groupList.add(groupObj);
		
		groupObj = new Group();
		groupObj.Name = 'GwcEngineerGroup';
		groupObj.type ='Regular';
		groupObj.DeveloperName = 'GwcEngineerGroup1';
		groupList.add(groupObj);
		
		return groupList;
	}
	
	public static List<Account> createAccountRecord(Integer size, String recordTypeName, List<Account> parentAccountId){
		List<Account> accNL =new List<Account>();
		
		if(recordTypeName == 'Prospect'){		
			//Creating Non Legal Entity Accounts
			for(integer i=0;i<size;i++){
				Account accObjNL = new Account();
				accObjNL.RecordTypeId = recordTypeMap.get('Prospect').Id;				
				accObjNL.Name ='testNL'+i;
				accObjNL.BillingCity= 'Hyderabad';
				accObjNL.BillingCountry = 'India';
				accObjNL.BillingState = 'telangana';
				accObjNL.BillingStreet = '18/89 Ayyappa colony';
				accNL.add(accObjNL);
			}			
		} else if(recordTypeName == 'Legal_Entity'){
			for (Integer k=0;k<size;k++) {
				Account accObjLE = new Account();
				accObjLE.RecordTypeId = recordTypeMap.get('Legal_Entity').Id;				
				accObjLE.Name ='testLE'+ k;
				//accObjLE.AccountNumber ='76521test'+ k;
				accObjLE.ParentId = parentAccountId[k].id;
				accNL.add(accObjLE);
			}
		}
		return accNL;
	}
	
	public static List<Contact> createContactRecord(Integer size, List <Account> accNL){ 
		//creating Contact record
		List<contact> cont = new List <Contact>();
		for(Integer j=0;j<size;j++){
			Contact contObj = new contact();
			contObj.AccountId = accNL[j].id;
			contObj.FirstName = 'Test'+j;
			contObj.LastName = 'TCS Data'+j;
			//contObj.CH_Legal_Entity_Name__c = accNL[j].Name;
			contObj.Email = 'testaccount'+j+'@aometh.com';
			contObj.Market__c = 'Market India';
			contObj.CH_ContactType__c = 'customer';
			contObj.CurrencyIsoCode = 'EUR';
			cont.add(contObj);
		}
		return cont;
	} 
	
	public static List<Product2> createProductRecord(Integer size){
		List<Product2> productlist =new List<Product2>();
		for(integer i=0;i<size;i++){
			Product2 prodObj = new Product2();
			prodObj.Name ='Test'+i;
			prodObj.ProductCode ='133-047489_0'+i;
			prodObj.DataUsage__c = 'CARES';
			prodObj.PMD_Portfolio_Classification__c = 'Product';
			prodObj.NCP_CAREACTIVATE__c ='Test';
			prodObj.DataUsage__c='CARES';
			prodObj.NCP_CAREACTIVATE__c='Test';
			prodObj.CH_ParentProductId__c=prodObj.Id;
			//prodObj.CH_Valid__c =True;
			productlist.add(prodObj);
			System.debug('Product List'+productlist);
		}
		return productlist;
	}
	
	public static List<PricebookEntry> createPricebookEntryRecord(Integer size,List<Product2> productlist){
		Id pricebook2Id = Test.getStandardPricebookId();
		List<PricebookEntry> pricebook =new List <PricebookEntry>();
		for(integer i=0;i<size;i++){
			PricebookEntry standardPrice = new PricebookEntry();
			standardPrice.Pricebook2Id= pricebook2id;
			standardPrice.Product2Id= productlist[i].id;
			standardPrice.UnitPrice = 10000;
			standardPrice.IsActive = true;
			pricebook.add(standardPrice);
		}
		return pricebook;
	}
	
	public static ID CreateCustomPriceBook(){
		// Create a custom price book
		Pricebook2 customPB = new Pricebook2();
		customPB.Name = 'Nokia CARE Price Book';  
		customPB.IsActive = true;
		insert customPB;
		return customPB.id;
	}
	
	public static List<PricebookEntry> createCustomPricebookEntryRecord(Integer size,List<Product2> productlist,ID customPB){
		List<PricebookEntry> Custompricebook =new List <PricebookEntry>();
		for(integer i=0;i<size;i++){
			PricebookEntry customPrice = new PricebookEntry();
			customPrice.Pricebook2Id= customPB;
			customPrice.Product2Id= productlist[i].id;
			customPrice.UnitPrice = 10000;
			customPrice.IsActive = true;
			Custompricebook.add(customPrice);
		}
		return Custompricebook;
	}
	
	
	public static List<ServiceContract> createServiceContractRecord(Integer size,List <Account> accNL,  ID stdBusinessHours, ID customPB){
		List<ServiceContract> ServiceContractlist =new List<ServiceContract>();
		for(integer i=0;i<size;i++){			
			ServiceContract serContract =new ServiceContract();
			serContract.RecordTypeId = recordTypeMap.get('CH_ServiceContract').Id;
			serContract.AccountId = accNL[i].id;
			serContract.Name = 'TCS Service Contract TestData'+ i;
			serContract.CurrencyIsoCode='EUR';
			serContract.CH_CDB_ContractId__c = '123456test'+ (i-1);
			serContract.CH_CDB_PreviousContractId__c = '123456test' + i;
			serContract.StartDate = system.today();
			serContract.EndDate = system.today()+10;
			//serContract.CH_Entitlement__c = entObj.id;
			serContract.Pricebook2Id = customPB;
			ServiceContractlist.add(serContract);
		}
		return ServiceContractlist;
	}
	
	public static List<ContractLineItem> createContractLineItemRecord(Integer size,List<PricebookEntry> Custompricebook, List<ServiceContract> ServiceContractlist){
		List<ContractLineItem> ContractLineItemList =new List<ContractLineItem>();
		for(integer i=0;i<size;i++){
			ContractLineItem contLine = new ContractLineItem();
			contLine.CH_BusinessHourName__c = stdBusinessHours.Id;
			//contLine.CH_CDB_EntitlementId__c = entObj.CH_CDB_EntitlementId__c;
			contLine.PricebookEntryId = Custompricebook[i].id;
			contLine.Quantity = 55;
			contLine.UnitPrice = 55;
			contLine.ServiceContractId = ServiceContractlist[i].id;
			ContLine.CH_ServiceOffering__c = 'Test'+i;
			contLine.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';
			contLine.CH_CDB_EntitlementId__c = '1test'+i;
			ContractLineItemList.add(contLine);   
		}
		return ContractLineItemList;
	}	
	
	
	public static List<Entitlement> createEntitlementRecord(Integer size,List <Account> accNL, List<ContractLineItem> ContractLineItemList, ID stdBusinessHours, List<ServiceContract> ServiceContractlist){
		//creating Entitlement record
		List<Entitlement> entitlementlist =new List<Entitlement>();
		for(integer i=0;i<size;i++){
			Entitlement entiObj = new Entitlement();
			entiObj.Name ='test'+ i;
			entiObj.AccountId = accNL[i].id;
			entiObj.CH_CDB_EntitlementId__c = '1test'+ i;
			entiObj.StartDate = System.today();
			entiObj.EndDate = System.today() + 10;
			entiObj.ContractLineItemId = ContractLineItemList[i].id;
			entiObj.BusinessHoursId = stdBusinessHours;
			entiObj.CH_EntitlementType__c = 'Entitled Asset';
			entiObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
			entiobj.ServiceContractId = ServiceContractlist[i].id;
			entitlementlist.add(entiObj);
		}
		return entitlementlist;   
	}

	public static Entitlement createS2SEntitlement(String entName, Id assetId, Id accId, Id prodId, String cdbEntId, String serviceMappingId, Boolean hasEntitlementScript){
		PriceBookEntry tempPriceBookEntry = new PriceBookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = prodId,
			UnitPrice = 0,
			CurrencyIsoCode = 'EUR',
			IsActive = true
		);
		Insert tempPriceBookEntry;
		ServiceContract serviceContract = new ServiceContract(
			AccountId = accId, 
			Name = 'TestServiceContract',
			CH_CDB_ContractId__c = 'Test',
			CH_EntitlementScript__c = (hasEntitlementScript) ? 'Header Script' : '',
			Pricebook2Id = Test.getStandardPricebookId()
		);
		Insert serviceContract;
		CH_AuthorizedAccount__c authorizedAccount = new CH_AuthorizedAccount__c();
		authorizedAccount.CH_Account__c = accId;
		authorizedAccount.CH_ServiceContract__c = serviceContract.Id;
		insert authorizedAccount;

		// Create Contract Line Item 
		ContractLineItem contractLineItem = new ContractLineItem(
			ServiceContractId = serviceContract.Id,
			AssetId = assetId,
			UnitPrice = 0,
			Quantity = 1,
			PricebookEntryId = tempPriceBookEntry.Id,
			CH_LineItemEntitlementScript__c = (hasEntitlementScript) ? 'Script' : '',
			CH_CDB_EntitlementId__c = 'TEST', 
			CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7'
		);
		Insert contractLineItem;

		Entitlement entTest = new Entitlement();
		entTest.Name = entName;
		entTest.ContractLineItemId = contractLineItem.Id;
		entTest.ServiceContractId = serviceContract.Id;
		entTest.AssetId = assetId;
		entTest.AccountId = accId;
		entTest.CH_CDB_EntitlementId__c = cdbEntId;
		entTest.CH_ServiceMappingId__c = serviceMappingId;
		insert entTest;

		serviceContract.CH_Entitlement__c = entTest.Id;
		update serviceContract;

		return entTest;   
	}
	
}