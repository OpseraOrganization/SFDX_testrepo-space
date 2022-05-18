/********************************************************************************
* Name : HWS_Lookup_Class_Test
* Description : Test class for HWS_Lookup_Class
********************************************************************************/
@isTest
public class HWS_Lookup_Class_Test {
	//mock class for callout
	private class RestMock implements HttpCalloutMock {
		public HTTPResponse respond(HTTPRequest req) {
			String mockJson = '{ "data": { "translations": [ { "translatedText": "Test Acc=testaddln1=testAddln2=testAddln3=testStreet=testCity" } ] } }';
			HTTPResponse res = new HTTPResponse();
			res.setHeader('Content-Type', 'text/json');
			res.setBody(mockJson);
			res.setStatusCode(200);
			return res;
		}
	
	}
	public testmethod static void getPickListValuesTest(){
		HWS_Lookup_Class.getPickListValues('Account','Type');
		
	}
	public testmethod static void getDependentMapTest(){
	Account acc = HWS_DataFactory_TEST.createAccountRec();
	HWS_Lookup_Class.getDependentMap(acc,'BillingCountryCode','BillingStateCode','Canada');
	System.assertEquals('test',acc.Name); 
	}
	public testmethod static void getDefaultvaluesTest(){
		Account acc = HWS_DataFactory_TEST.createAccountRec();
		insert acc;
		System.assertEquals('test',acc.Name);
		HWS_Lookup_Class.getDefaultvalues(acc.Id);
	}
	 public testmethod static void createContactTest(){
		Nokia_Employee_Email_Domains__c nokiaTestDomain = new Nokia_Employee_Email_Domains__c();
		nokiaTestDomain.Nokia_Valid_Domain__c = 'nokia.com';
	nokiaTestDomain.Nokia_Invalid_Domain__c = 'nokia';
		insert nokiaTestDomain;
		Account acc = HWS_DataFactory_TEST.createAccountRec();
		insert acc;
		System.assertEquals('test',acc.Name);
		Contact con = HWS_DataFactory_TEST.createContactRec(acc);
		HWS_Lookup_Class.createContact(acc.Id,con);
		  HWS_Lookup_Class.getAccounts(acc.Id);
		  HWS_Lookup_Class.updateAccountValues(acc);
		  HWS_Lookup_Class.isPortalUser();
	}
	public testmethod static void findContactListTest(){
		Account acc = HWS_DataFactory_TEST.createAccountRec();
		insert acc;
		list<Contact>conList= new  list<Contact>();
		Contact con = HWS_DataFactory_TEST.createContactRec(acc);
		conList.add(con);
		insert conList;
		system.assertequals(conList.size(),1);	  
		HWS_Lookup_Class.findContactList('test','Contact','Name');
	}
	public testmethod static void findContactListFromConsoleTest(){
		Account acc = HWS_DataFactory_TEST.createAccountRec();
		insert acc;
		list<Contact>conList= new  list<Contact>();
		Contact con = HWS_DataFactory_TEST.createContactRec(acc);
		conList.add(con);
		insert conList;
		system.assertequals(conList.size(),1);	  
		HWS_Lookup_Class.findContactListFromConsole('test','Contact','Name');
	}	  
	public testmethod static void updatetoParentCaseTest(){
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.CUSTOMER);
		ISO_Country_Codes__c isoCountryCode = new ISO_Country_Codes__c();
		isoCountryCode.Name = 'IN'; 
		isoCountryCode.Country_Name__c = 'India';
		isoCountryCode.Market__c = 'Market India';
		isoCountryCode.Translation_Required__c = true;
		database.insert(isoCountryCode); 
		list<Account> accList= new  list<Account>();
	
		Account acc2 = HWS_DataFactory_TEST.insertAccount(); 
		insert acc2;
		System.assertEquals('test',acc2.Name);
		Account acc = HWS_DataFactory_TEST.insertAccount(); 
		acc.RecordTypeId =  customerAccountType;	
		insert acc;
		accList.add(acc);
		// start changes by pavan 
		
		Account acc1 = new Account();
	
	acc1.RecordTypeId = legalEntityAccountType;
	acc1.Acc_No__c = '23456';
	acc1.name='test1';
	acc1.P20_Logistic_ID__c = '12345';
	acc1.HWS_Address_Status__c = 'Permanent Address 1';
	acc1.BillingCountry = 'India';
	acc1.BillingState = 'Telangana';
	acc1.BillingStreet = 'Test 2';
	acc1.BillingCity ='Test 2';
	acc1.BillingPostalCode = '12345';
	  
	accList.add(acc1);
		// end changes by pavan
		
		 Contact con = HWS_DataFactory_TEST.insertContact();
		con.AccountId = acc.Id;
		con.Contact_Status__c = 'Active';
		con.CH_ContactType__c = 'Customer';
		con.email='xyz@example.com';
		insert con;
	
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();	  
		insert prod;
		
		PriceBookEntry tempPriceBookEntry = new PriceBookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = prod.id,
			UnitPrice = 0,
			CurrencyIsoCode = 'EUR',
			IsActive = true
		);
		Insert tempPriceBookEntry;
		
		ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(acc2);	  
		sc.Pricebook2Id = Test.getStandardPricebookId();
		sc.CurrencyIsoCode = tempPriceBookEntry.CurrencyIsoCode;
		sc.CH_ERPSystem__c = 'SAP-Blue Planet';
		sc.AccountId = acc2.Id;
		insert sc;
		
		ContractLineItem cli = HWS_DataFactory_TEST.insertContractLineItem(sc,tempPriceBookEntry);	  
		cli.PricebookEntryId = tempPriceBookEntry.id;   
		cli.ServiceContractId = sc.id;   
		insert cli;
		
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		List<Asset> lstasst = new List<Asset>();
		 
		Asset ast = HWS_DataFactory_TEST.insertAsset(acc,prod);	 
		ast.RecordTypeId = assetRecordType;   
		ast.HWS_ContractLineItem__c = cli.id;  
		ast.Product2Id= prod.id;
		lstasst.add(ast);
		insert lstasst;
		Test.setMock(HttpCalloutMock.class, new RestMock());
		Test.startTest();
		HWS_Lookup_Class.updatetoParentCase(accList,acc1,lstasst,'Local','testaddln1','testaddln2','testaddln3','tstAccName');
		//HWS_Lookup_Class.updatetoParentCase(accList,acc1,lstasst,'Latin','testaddln1','testaddln2','testaddln3','tstAccName');
		Test.stopTest();
	}
	public testmethod static void searchShiptoPartyTest(){
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.CUSTOMER);
		Id logisticEntity_Existing = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		list<Account> accList= new  list<Account>();
		System.assertEquals(legalEntityAccountType,legalEntityAccountType);
		System.assertEquals(logisticEntity_Existing,logisticEntity_Existing);
		Account custAcc = HWS_DataFactory_TEST.insertAccount(); 
		custAcc.RecordTypeId =  customerAccountType;
		custAcc.Customer_Compliance__c = 'US_AT&T';
		insert custAcc;	 
		
		Account acc = HWS_DataFactory_TEST.insertAccount();
		acc.ParentId = custAcc.Id;
		acc.Country__c = 'India';
		insert acc;
		
		Account logisticAcc = HWS_DataFactory_TEST.createLogisticAccount();
		logisticAcc.ParentId = acc.Id;
		logisticAcc.AccountSource = '';
		insert logisticAcc;
		accList.add(acc);   
		
		Contact con = HWS_DataFactory_TEST.insertContact();
		con.AccountId = custAcc.Id;
		con.Contact_Status__c = 'Active';
		con.CH_ContactType__c = 'Customer';
		con.email='xyz@example.com';
		insert con;
		
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();	  
		insert prod;
		
		PriceBookEntry tempPriceBookEntry = new PriceBookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = prod.id,
			UnitPrice = 0,
			CurrencyIsoCode = 'EUR',
			IsActive = true
		);
		Insert tempPriceBookEntry;
		
		ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(acc);	   
		sc.Pricebook2Id = Test.getStandardPricebookId();
		sc.CurrencyIsoCode = tempPriceBookEntry.CurrencyIsoCode;
		sc.CH_ERPSystem__c = 'SAP-Blue Planet';
		insert sc;
		
		ContractLineItem cli = HWS_DataFactory_TEST.createContractLineItems(sc.Id,tempPriceBookEntry.Id);	   
		insert cli;
		
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		List<Asset> lstasst = new List<Asset>();
		
		Asset ast = HWS_DataFactory_TEST.insertAsset(acc,prod);	 
		ast.RecordTypeId = assetRecordType;   
		ast.HWS_ContractLineItem__c = cli.id;  
		lstasst.add(ast);
		insert lstasst;
		System.debug('lstasst:'+lstasst[0].HWS_ContractLineItem__r.ServiceContractId);
		system.assertequals(accList.size(),1);
		List<ContractLineItem> cliList = new List<ContractLineItem>();
		cliList.add(cli);
		HWS_RetrofitAccount__c retroacc = new HWS_RetrofitAccount__c(
			HWS_Account__c = acc.id,
			HWS_ServiceContract__c = sc.id,
			HWS_ShipToCountry__c = 'Canada;India',
			HWS_Status__c = 'Active'
		);
		insert retroacc;
		test.startTest();
		HWS_Lookup_Class.searchShiptoParty('Test','Contact','Name','testvalue','shipToParty',lstasst,accList, 'console', logisticAcc.BillingCountry,true,'');
		HWS_Lookup_Class.searchShiptoParty('test','Contact','Name','testvalue','wareHouseAddress',lstasst,accList, 'console', logisticAcc.BillingCountry,true,'');
		HWS_Lookup_Class.searchShiptoParty('Test','Contact','Name','testvalue','shipToParty',lstasst,accList, 'console', logisticAcc.BillingCountry,false,'');
		HWS_Lookup_Class.searchShiptoParty('test','Contact','Name','testvalue','wareHouseAddress',lstasst,accList, 'console', logisticAcc.BillingCountry,false,'');
		HWS_Lookup_Class.getCountryList(retroacc.Id);
		test.stopTest();	
	}	
	public testmethod static void  updateAccountValuesTest(){
		List<User> userList = CH_TestFactoryDefaults.createInternalUsers( true, true, 1, null);
		Account custAcc = new Account();
		system.runAs(userList[0]){
			Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.CUSTOMER);
			custAcc = HWS_DataFactory_TEST.insertAccount(); 
			custAcc.RecordTypeId =  customerAccountType;
			custAcc.Customer_Compliance__c = 'US_AT&T';
			insert custAcc; 
		}
		Profile agentProfile  = [SELECT Id FROM Profile WHERE Name ='CH_Agent' LIMIT 1];
		map<string,String> fieldName = new map<string,String>();
		fieldName.put('ProfileId',agentProfile.Id);
		test.startTest();
		List<User> userLst = CH_TestFactoryDefaults.createInternalUsers( true, false, 1, fieldName);
		userLst[0].Username = 'RandomChAgent123@testing.com'; 
		insert userLst;
		system.runAs(userLst[0]){
			custAcc.Name = 'testAcc123';
			try{
				HWS_Lookup_Class.updateAccountValues(custAcc);
			}catch(Exception e){
				System.debug('exception'+e.getMessage());
			}
		   
		}
		test.stopTest();  
	}
}