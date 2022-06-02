@isTest
private class NCP_Favourites_COM_Test {
	public static final string ACCOUNT_NAME = 'LEGAL-ACCOUNT';
	@isTest
	static void TestIsAuthenticated(){
		Test.startTest();
		boolean b = NCP_Favourites_COM.isAuthenticated();
		System.assertEquals(b,true);
		Test.stopTest();
	}
	@isTest
	static void TestCheckForEntitledProducts(){
		Test.startTest();
		boolean b = NCP_Favourites_COM.checkForEntitledProducts();
		Test.stopTest();
	}

	@isTest
	static void TestCheckForEntitlements(){
		Test.startTest();
		List<NCP_MyEntitlements_Wrapper> wrapp = NCP_Favourites_COM.checkForEntitlements();
		Test.stopTest();
	}

	@isTest
	static void TestGetLink(){
		Test.startTest();
		Map<string, object> getLinksMap  = NCP_Favourites_COM.getLinks();
		System.assertEquals(getLinksMap.size()>0,true);
		Test.stopTest();
	}
	
	@isTest
	static void testGetLink2(){
		Account acc ;
		Account legalAccount ;
		Contact cont ;
		User customerUser ;	
		List<Account> legalAccountList = new List<Account> ();
		List<Entitlement> entitlementlist =new List<Entitlement>();
		List<ContractLineItem> contLineLst = new List<ContractLineItem>();
		List<EntitlementContact> entconList = new List <EntitlementContact>();
		
		acc = NCP_TestFactory.createAccount();
		//Create legal entity
		Id accountLegalEntityRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		legalAccount = new Account(
			Name = ACCOUNT_NAME,
			Country__c = 'Sweden',
			RecordTypeId = accountLegalEntityRecordType,
			ParentId = acc.Id
		);
		insert legalAccount;
		cont = TestDataFactory.createContact2(1, acc)[0];	
		insert cont;
		
		String username = 'abc' + Crypto.getRandomLong() + '@test.com';
		customerUser = NCP_TestFactory.createUser(false, 'test', cont, username);			
		insert customerUser;
		
		Product2 pr = NCP_TestFactory.createProduct();
		ID Pricebk2Id = Test.getStandardPricebookId();
		PricebookEntry pbe = new PricebookEntry(Pricebook2Id = Pricebk2Id, Product2Id = pr.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
		insert pbe;
		
		legalAccountList.add(legalAccount);
		List<ServiceContract> serviceContractLst = CH_EntitlementTestData.createServiceContractRecord(1, legalAccountList, null, Pricebk2Id);
		ServiceContract serviceContract = serviceContractLst[0];
		serviceContract.CurrencyIsoCode = pbe.CurrencyIsoCode;
		serviceContract.NCP_External_Status__c = 'Active';
		serviceContract.CH_PortalCaseCreationSWMaintenance__c = true;
		serviceContract.CH_PortalCaseCreationHWS__c = true;
		insert serviceContract;	
		
		/*ServiceContractShare scShare = new ServiceContractShare(ParentId = serviceContract.Id, UserOrGroupId = customerUser.Id, AccessLevel = 'Read');
		insert scShare;*/
		
		List<Asset> assetObjList  = TestDataFactory.createAsset('CH_CoveredProduct', 1, legalAccount, pr);
		insert assetObjList;
		
		contLineLst = TestDataFactory.createContractLineItem(1, serviceContract, assetObjList[0], pbe, false);
		contLineLst[0].NCP_External_Status__c = 'Active';
		contLineLst[0].StartDate = System.today();
		contLineLst[0].EndDate = System.today() + 10;
		contLineLst[0].CH_ServiceClassification__c = 'SW Maintenance';
		insert contLineLst;
		
		entitlementlist = CH_EntitlementTestData.createEntitlementRecord(1, legalAccountList, contLineLst, null, serviceContractLst);
		insert entitlementlist;	
		
		entconList = TestDataFactory.createEntitlementContact(1, entitlementlist[0], cont);
		insert entconList;
		Test.startTest();
		AccountContactRelation acrObj = new AccountContactRelation();
		acrObj.AccountId = legalAccount.id;
		acrObj.ContactId = cont.Id;
		acrObj.NCP_Entitlement_Relationship__c = true;
		insert acrObj;
		
		System.runAs(customerUser){
			
			Map<string, object> getLinksMap  = NCP_Favourites_COM.getLinks();
			System.assertEquals(getLinksMap.size()>0,true);
			Test.stopTest();
		}
		
	}
}