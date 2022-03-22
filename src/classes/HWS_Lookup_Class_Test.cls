@isTest
public class HWS_Lookup_Class_Test {
	public testmethod static void getPickListValuesTest(){
		HWS_Lookup_Class.getPickListValues('Account','Type');
		
	}
	public testmethod static void getDependentMapTest(){
	Account acc = HWS_DataFactory_TEST.createAccountRec();
	HWS_Lookup_Class.getDependentMap(acc,'BillingCountryCode','BillingStateCode');
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
	
		HWS_Lookup_Class.updatetoParentCase(accList,acc1,lstasst);
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
		
		test.startTest();
		HWS_Lookup_Class.searchShiptoParty('Test','Contact','Name','testvalue','shipToParty',lstasst,accList, 'console', logisticAcc.BillingCountry);
		HWS_Lookup_Class.searchShiptoParty('test','Contact','Name','testvalue','wareHouseAddress',lstasst,accList, 'console', logisticAcc.BillingCountry);
		test.stopTest();	
	}	 
}