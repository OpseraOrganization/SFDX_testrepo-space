/***
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* 
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@isTest
public class CH_ServiceContractTriggerTest {

	public static final string pricebookname= 'Nokia CARE Price Book';
	public static final string redtypecsc='CARE Service Contract';
	public static final string serContrctName='TCS Service Contract TestData1';
	public static final string capmemailadd='cmmkp7777@nokia.com';
	public static final string legalentyname='Legal Entity';
	public static final string samplemail='Test2342421@nokia.com';
	
	@testSetup
	public static void testDataFactory(){
		integer j =2;
		
		CH_EntitlementTestData.createCustomSettingData();
		CH_Import_UTIL_TEST.CreateCustomPriceBook();
		List <Account> AccountListNL = new List<Account>();
		AccountListNL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
		insert AccountListNL;
		
		List <Account> AccountListLE = new List<Account>();
		AccountListLE = CH_EntitlementTestData.createAccountRecord(j, 'Legal_Entity', AccountListNL);
		insert AccountListLE;
		
		List <Contact> ConatctList = new List<Contact>();
		ConatctList = CH_EntitlementTestData.createContactRecord(j,AccountListNL);
		insert ConatctList;
		
		List<Product2> productlist =new List<Product2>();
		productlist = CH_EntitlementTestData.createProductRecord(j);
		insert productlist;
		
		List<PricebookEntry> pricebook =new List <PricebookEntry>();
		pricebook = CH_EntitlementTestData.createPricebookEntryRecord(j, productlist);
		insert pricebook;
		
		Pricebook2 customPB1 = new Pricebook2();
		customPB1.Id = CH_EntitlementTestData.CreateCustomPriceBook();
		
		List<PricebookEntry> Custompricebook =new List <PricebookEntry>();
		Custompricebook = CH_EntitlementTestData.createCustomPricebookEntryRecord(j, productlist, customPB1.id);
		insert Custompricebook;
	 
		List <AccountContactRelation> acrList = new  List <AccountContactRelation>();
		for(Integer i=0;i<j;i++){
			AccountContactRelation acrObj = new AccountContactRelation();
			acrObj.AccountId = AccountListLE[i].id;
			acrObj.ContactId = ConatctList[i].Id;
			acrObj.NCP_Entitlement_Relationship__c = true;
			acrList.add(acrObj);
		}
		
		insert acrList;
		system.assertNotEquals(acrList[1].id, null);
	
		ServiceContract serContract =new ServiceContract();
		serContract.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_ServiceContract').Id;
		serContract.AccountId = AccountListLE[0].id;
		serContract.Name = 'TCS Service Contract TestData';
		serContract.CurrencyIsoCode='EUR';
		serContract.CH_CDB_ContractId__c = '123456test';
		serContract.StartDate = system.today();
		serContract.EndDate = system.today()+10;
		serContract.CH_CAPM_EmailAddress__c = 'cmmeekp7777@nokia.com';
		serContract.CH_PriceBook__c = pricebookname;
		serContract.Pricebook2Id = customPB1.Id;
		INSERT serContract;
		System.assertNotEquals(serContract.id, null);
	}
	
	public testMethod static void test(){
		
		
		Pricebook2 customPB1 = [SELECT Id FROM Pricebook2 where Name LIKE '%Nokia CARE Price Book%' limit 1 ];
		
		Id accRecordType=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		Id servRecordType=Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
	  
		Account acc=new Account();
		acc.Name='test';
		acc.RecordTypeId=accRecordType;
		acc.BillingCountry='India';
		acc.BillingCity='Hyd';
		acc.BillingStreet='Hyd';
		acc.Customer_Compliance__c='US_Cox';
		insert acc;
		
		Account acc1=new Account();
		acc1.Name='test11';
		acc1.RecordTypeId=accRecordType;
		acc1.BillingCountry='India';
		acc1.BillingCity='Hyd';
		acc1.BillingStreet='Hyd';
		acc1.ParentId=acc.id;
		insert acc1;
		
		ServiceContract serContract1 =new ServiceContract();
		serContract1.RecordTypeId = servRecordType;
		serContract1.AccountId = acc1.id;
		serContract1.Name = serContrctName;
		serContract1.CurrencyIsoCode='EUR';
		serContract1.CH_CDB_ContractId__c = '123456tes1t';
		serContract1.CH_CDB_PreviousContractId__c = '123456test';
		serContract1.StartDate = system.today();
		serContract1.EndDate = system.today()+10;
		serContract1.CH_CAPM_EmailAddress__c = capmemailadd;
		serContract1.CH_PriceBook__c = pricebookname;
		
		serContract1.Pricebook2Id = customPB1.Id;	
		
		Test.startTest();
		
		insert serContract1; 
		Test.stopTest();
	}
	
	public testMethod static void test1(){
		
		
		Pricebook2 custPB1 = [SELECT Id FROM Pricebook2 where Name LIKE '%Nokia CARE Price Book%' limit 1 ];
		
		Id accRecTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		Id servRecTypeId=Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
	  
		Account acc2=new Account();
		acc2.Name='test';
		acc2.RecordTypeId=accRecTypeId;
		acc2.BillingCountry='India';
		acc2.BillingCity='Hyd';
		acc2.BillingStreet='Hyd';
		acc2.Customer_Compliance__c='US_Sprint';
		insert acc2;
		
		Account acc3=new Account();
		acc3.Name='test11';
		acc3.RecordTypeId=accRecTypeId;
		acc3.BillingCountry='India';
		acc3.BillingCity='Hyd';
		acc3.BillingStreet='Hyd';
		acc3.ParentId=acc2.id;
		insert acc3;
		
		ServiceContract serContract2 =new ServiceContract();
		serContract2.RecordTypeId = servRecTypeId;
		serContract2.AccountId = acc3.id;
		serContract2.Name = serContrctName;
		serContract2.CurrencyIsoCode='EUR';
		serContract2.CH_CDB_ContractId__c = '123456tes1t';
		serContract2.CH_CDB_PreviousContractId__c = '123456test';
		serContract2.StartDate = system.today();
		serContract2.EndDate = system.today()+10;
		serContract2.CH_CAPM_EmailAddress__c = capmemailadd;
		serContract2.CH_PriceBook__c = pricebookname;
		
		serContract2.Pricebook2Id = custPB1.Id;
		Test.startTest();
		
		insert serContract2;  
		
		Test.stopTest();
	}
	
	public testMethod static void test2(){
		
		Pricebook2 cusPB1 = [SELECT Id FROM Pricebook2 where Name LIKE '%Nokia CARE Price Book%' limit 1 ];
		
		Id accRecordTypId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		Id servRecordTypId=Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
	  
		Account acc4=new Account();
		acc4.Name='test';
		acc4.RecordTypeId=accRecordTypId;
		acc4.BillingCountry='India';
		acc4.BillingCity='Hyd';
		acc4.BillingStreet='Hyd';
		acc4.Customer_Compliance__c='US_AT&T';
		insert acc4;
		
		Account acc5=new Account();
		acc5.Name='test11';
		acc5.RecordTypeId=accRecordTypId;
		acc5.BillingCountry='India';
		acc5.BillingCity='Hyd';
		acc5.BillingStreet='Hyd';
		acc5.ParentId=acc4.id;
		insert acc5;
		
		ServiceContract serContract3 =new ServiceContract();
		serContract3.RecordTypeId = servRecordTypId;
		serContract3.AccountId = acc5.id;
		serContract3.Name = serContrctName;
		serContract3.CurrencyIsoCode='EUR';
		serContract3.CH_CDB_ContractId__c = '123456tes1t';
		serContract3.CH_CDB_PreviousContractId__c = '123456test';
		serContract3.StartDate = system.today();
		serContract3.EndDate = system.today()+10;
		serContract3.CH_CAPM_EmailAddress__c = capmemailadd;
		serContract3.CH_PriceBook__c = pricebookname;
		serContract3.Pricebook2Id = cusPB1.Id;
		
		ServiceContract serContract4 =new ServiceContract();
		serContract4.RecordTypeId = servRecordTypId;
		
		serContract4.Name = 'TCS Service Contract 2';
		serContract4.CurrencyIsoCode='EUR';
		serContract4.CH_CDB_ContractId__c = '123456tes1t';
		serContract4.CH_CDB_PreviousContractId__c = '123456test';
		serContract4.StartDate = system.today();
		serContract4.EndDate = system.today()+10;
		serContract4.CH_CAPM_EmailAddress__c = 'cmmkp777@nokia.com';
		serContract4.CH_PriceBook__c = pricebookname;
		serContract4.Pricebook2Id = cusPB1.Id;
		
		Test.startTest();
		
		try{insert serContract3;
	 insert serContract4;} catch(Exception e){
		 System.assert(e.getMessage()!=null);
	 }  
		
		Test.stopTest();
	}
	
	public testMethod static void test3(){
		
		
		Pricebook2 PB1 = [SELECT Id FROM Pricebook2 where Name LIKE '%Nokia CARE Price Book%' limit 1 ];
		
		Id acctRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		Id serviRecordTypeId=Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
	  
		Account acc6=new Account();
		acc6.Name='test';
		acc6.RecordTypeId=acctRecordTypeId;
		acc6.BillingCountry='India';
		acc6.BillingCity='Hyd';
		acc6.BillingStreet='Hyd';
		acc6.Customer_Compliance__c='US_Govern';
		insert acc6;
		
		Account acc7=new Account();
		acc7.Name='test11';
		acc7.RecordTypeId=acctRecordTypeId;
		acc7.BillingCountry='India';
		acc7.BillingCity='Hyd';
		acc7.BillingStreet='Hyd';
		acc7.ParentId=acc6.id;
		insert acc7;
		
		ServiceContract serContract5 =new ServiceContract();
		serContract5.RecordTypeId = serviRecordTypeId;
		serContract5.AccountId = acc6.id;
		serContract5.Name = serContrctName;
		serContract5.CurrencyIsoCode='EUR';
		serContract5.CH_CDB_ContractId__c = '123456tes1t';
		serContract5.CH_CDB_PreviousContractId__c = '123456test';
		serContract5.StartDate = system.today();
		serContract5.EndDate = system.today()+10;
		serContract5.CH_CAPM_EmailAddress__c = capmemailadd;
		serContract5.CH_PriceBook__c = pricebookname;
		serContract5.Pricebook2Id = PB1.Id;
		Test.startTest();
		
		insert serContract5;  
		
		Test.stopTest();
	}
	
	public testMethod static void test4(){
		
		
		Pricebook2 customPB1 = [SELECT Id FROM Pricebook2 where Name LIKE '%Nokia CARE Price Book%' limit 1 ];
		
		Id accountRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		Id serviceRecordTypeId=Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
	  
		Account acc8=new Account();
		acc8.Name='test';
		acc8.RecordTypeId=accountRecordTypeId;
		acc8.BillingCountry='India';
		acc8.BillingCity='Hyd';
		acc8.BillingStreet='Hyd';
		acc8.Customer_Compliance__c='US_VWireless';
		insert acc8;
		
		Account acc9=new Account();
		acc9.Name='test11';
		acc9.RecordTypeId=accountRecordTypeId;
		acc9.BillingCountry='India';
		acc9.BillingCity='Hyd';
		acc9.BillingStreet='Hyd';
		acc9.ParentId=acc8.id;
		insert acc9;
		
		ServiceContract serContract6 =new ServiceContract();
		serContract6.RecordTypeId = serviceRecordTypeId;
		serContract6.AccountId = acc9.id;
		serContract6.Name = serContrctName;
		serContract6.CurrencyIsoCode='EUR';
		serContract6.CH_CDB_ContractId__c = '123456tes1t';
		serContract6.CH_CDB_PreviousContractId__c = '123456test';
		serContract6.StartDate = system.today();
		serContract6.EndDate = system.today()+10;
		serContract6.CH_CAPM_EmailAddress__c = capmemailadd;
		serContract6.CH_PriceBook__c = pricebookname;
		serContract6.Pricebook2Id = customPB1.Id;
		Test.startTest();
		
		insert serContract6;  
		
		Test.stopTest();
	}
	
	public testMethod static void test5(){
		
		
		Pricebook2 customPB1 = [SELECT Id FROM Pricebook2 where Name LIKE '%Nokia CARE Price Book%' limit 1 ];
		
		Id accRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		Id servRecordTypeId=Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();	
	  
		Account acc10=new Account();
		acc10.Name='test';
		acc10.RecordTypeId=accRecordTypeId;
		acc10.BillingCountry='India';
		acc10.BillingCity='Hyd';
		acc10.BillingStreet='Hyd';
		acc10.Customer_Compliance__c='US_VWireline';
		insert acc10;
		
		Account acc11=new Account();
		acc11.Name='test11';
		acc11.RecordTypeId=accRecordTypeId;
		acc11.BillingCountry='India';
		acc11.BillingCity='Hyd';
		acc11.BillingStreet='Hyd';
		acc11.ParentId=acc10.id;
		insert acc11;
		
		ServiceContract serContract7 =new ServiceContract();
		serContract7.RecordTypeId = servRecordTypeId;
		serContract7.AccountId = acc11.id;
		serContract7.Name = serContrctName;
		serContract7.CurrencyIsoCode='EUR';
		serContract7.CH_CDB_ContractId__c = '123456tes1t';
		serContract7.CH_CDB_PreviousContractId__c = '123456test';
		serContract7.StartDate = system.today();
		serContract7.EndDate = system.today()+10;
		serContract7.CH_CAPM_EmailAddress__c = capmemailadd;
		serContract7.CH_PriceBook__c = pricebookname;
		serContract7.Pricebook2Id = customPB1.Id;
		Test.startTest();
		
		insert serContract7;  
		
		Test.stopTest();
	}
	
	public testMethod static void test6(){
		
		
		Pricebook2 customPB1 = [SELECT Id FROM Pricebook2 where Name LIKE '%Nokia CARE Price Book%' limit 1 ];
		
		Id accRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		Id servRecordTypeId=Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
	  
		Account acc12=new Account();
		acc12.Name='test';
		acc12.RecordTypeId=accRecordTypeId;
		acc12.BillingCountry='India';
		acc12.BillingCity='Hyd';
		acc12.BillingStreet='Hyd';
		acc12.Customer_Compliance__c='US_ALTICE';
		insert acc12;
		
		Account acc13=new Account();
		acc13.Name='test11';
		acc13.RecordTypeId=accRecordTypeId;
		acc13.BillingCountry='India';
		acc13.BillingCity='Hyd';
		acc13.BillingStreet='Hyd';
		acc13.ParentId=acc12.id;
		insert acc13;
		
		ServiceContract serContract8 =new ServiceContract();
		serContract8.RecordTypeId = servRecordTypeId;
		serContract8.AccountId = acc13.id;
		serContract8.Name = serContrctName;
		serContract8.CurrencyIsoCode='EUR';
		serContract8.CH_CDB_ContractId__c = '123456tes1t';
		serContract8.CH_CDB_PreviousContractId__c = '123456test';
		serContract8.StartDate = system.today();
		serContract8.EndDate = system.today()+10;
		serContract8.CH_CAPM_EmailAddress__c = capmemailadd;
		serContract8.CH_PriceBook__c = pricebookname;
		serContract8.Pricebook2Id = customPB1.Id;
		Test.startTest();
		
		insert serContract8;  
		
		Test.stopTest();
	}
	
	
	public testMethod static void test7(){
		
		
		Pricebook2 customPB1 = [SELECT Id FROM Pricebook2 where Name LIKE '%Nokia CARE Price Book%' limit 1 ];
		
		Id accRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		Id servRecordTypeId=Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
	  
		Account acc14=new Account();
		acc14.Name='test';
		acc14.RecordTypeId=accRecordTypeId;
		acc14.BillingCountry='India';
		acc14.BillingCity='Hyd';
		acc14.BillingStreet='Hyd';
		acc14.Customer_Compliance__c='US_SCEC';
		insert acc14;
		
		Account acc15=new Account();
		acc15.Name='test11';
		acc15.RecordTypeId=accRecordTypeId;
		acc15.BillingCountry='India';
		acc15.BillingCity='Hyd';
		acc15.BillingStreet='Hyd';
		acc15.ParentId=acc14.id;
		insert acc15;
		
		ServiceContract serContract9 =new ServiceContract();
		serContract9.RecordTypeId = servRecordTypeId;
		serContract9.AccountId = acc15.id;
		serContract9.Name = serContrctName;
		serContract9.CurrencyIsoCode='EUR';
		serContract9.CH_CDB_ContractId__c = '123456tes1t';
		serContract9.CH_CDB_PreviousContractId__c = '123456test';
		serContract9.StartDate = system.today();
		serContract9.EndDate = system.today()+10;
		serContract9.CH_CAPM_EmailAddress__c = capmemailadd;
		serContract9.CH_PriceBook__c = pricebookname;
		serContract9.Pricebook2Id = customPB1.Id;
		Test.startTest();
		
		insert serContract9;  
		
		Test.stopTest();
	}
	
	public testMethod static void test8(){
		
		
		Pricebook2 customPB1 = [SELECT Id FROM Pricebook2 where Name LIKE '%Nokia CARE Price Book%' limit 1 ];
		
		Id accRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		Id servRecordTypeId=Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
	  
		
		Account acc16=new Account();
		acc16.Name='test';
		acc16.RecordTypeId=accRecordTypeId;
		acc16.BillingCountry='India';
		acc16.BillingCity='Hyd';
		acc16.BillingStreet='Hyd';
		acc16.Customer_Compliance__c='unassign';
		insert acc16;
		
		Account acc17=new Account();
		acc17.Name='test11';
		acc17.RecordTypeId=accRecordTypeId;
		acc17.BillingCountry='India';
		acc17.BillingCity='Hyd';
		acc17.BillingStreet='Hyd';
		acc17.ParentId=acc16.id;
		insert acc17;
		
		ServiceContract serContract10 =new ServiceContract();
		serContract10.RecordTypeId = servRecordTypeId;
		serContract10.AccountId = acc17.id;
		serContract10.Name = serContrctName;
		serContract10.CurrencyIsoCode='EUR';
		serContract10.CH_CDB_ContractId__c = '123456tes1t';
		serContract10.CH_CDB_PreviousContractId__c = '123456test';
		serContract10.StartDate = system.today();
		serContract10.EndDate = system.today()+10;
		serContract10.CH_CAPM_EmailAddress__c = capmemailadd;
		serContract10.CH_PriceBook__c = pricebookname;
		
		serContract10.Pricebook2Id = customPB1.Id;
		Test.startTest();
		
		insert serContract10;  
		
		Test.stopTest();
	}
	
	public testMethod static void test9(){
		
		
		Pricebook2 custmPB1 = [SELECT Id FROM Pricebook2 where Name LIKE '%Nokia CARE Price Book%' limit 1 ];
		
		Id accRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		Id servRecordTypeId=Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
	  
		
		Account acc18=new Account();
		acc18.Name='test';
		acc18.RecordTypeId=accRecordTypeId;
		acc18.BillingCountry='India';
		acc18.BillingCity='Hyd';
		acc18.BillingStreet='Hyd';
		acc18.Customer_Compliance__c='unassign';
		insert acc18;
		
		Account acc19=new Account();
		acc19.Name='test11';
		acc19.RecordTypeId=accRecordTypeId;
		acc19.BillingCountry='India';
		acc19.BillingCity='Hyd';
		acc19.BillingStreet='Hyd';
		acc19.ParentId=acc18.id;
		insert acc19;
		
		ServiceContract serContract11 =new ServiceContract();
		serContract11.RecordTypeId = servRecordTypeId;
		serContract11.AccountId = acc19.id;
		serContract11.Name = serContrctName;
		serContract11.CurrencyIsoCode='EUR';
		serContract11.CH_CDB_ContractId__c = '123456tes1t';
		serContract11.CH_CDB_PreviousContractId__c = '123456test';
		serContract11.StartDate = system.today();
		serContract11.EndDate = system.today()+10;
		serContract11.CH_CAPM_EmailAddress__c = capmemailadd;
		serContract11.CH_PriceBook__c = pricebookname;
		serContract11.Pricebook2Id = custmPB1.Id;
		Test.startTest();
		
		insert serContract11;  
		
		Test.stopTest();
	}
	
	//added for test of NOKIASC-31035:Eashwar
	public static testMethod void test92(){ 
		
		Pricebook2 customPB1 = [SELECT Id FROM Pricebook2 where Name LIKE '%Nokia CARE Price Book%' limit 1 ];
		
		Id accRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		Id servRecordTypeId=Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
	
		Account acc20=new Account();
		acc20.Name='test';
		acc20.RecordTypeId=accRecordTypeId;
		acc20.BillingCountry='India';
		acc20.BillingCity='Hyd';
		acc20.BillingStreet='Hyd';
		acc20.Customer_Compliance__c='US_Sprint';
		acc20.Type = 'Vendor';
		insert acc20;
		
		Account acc21=new Account();
		acc21.Name='test11';
		acc21.RecordTypeId=accRecordTypeId;
		acc21.BillingCountry='India';
		acc21.BillingCity='Hyd';
		acc21.BillingStreet='Hyd';
		acc21.Customer_Compliance__c='US_Sprint';
		acc21.ParentId=acc20.id;
		acc21.Type = 'Vendor';
		insert acc21;
		
		profile sysAdminProfile=[select id,name from profile where name='System Administrator'];
		User userPRM = new User(alias = 'abc', email = samplemail, emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',	 
		LanguageLocaleKey='en_US', localesidkey = 'en_US', profileid = sysAdminProfile.id,  
		Country__c= 'Canada',Market__c='MARKET NORTH AMERICA', 
		timezonesidkey = 'America/Los_Angeles', Username = samplemail  + '.org',Restriction_Level__c = 'Confidential', 
		Nokia_ID__c= '6777777666');
		insert userPRM;
		
		ServiceContract serContract14 =new ServiceContract();
		serContract14.RecordTypeId = servRecordTypeId;
		serContract14.AccountId = acc21.id;
		serContract14.Name = serContrctName;
		serContract14.CurrencyIsoCode='EUR';
		serContract14.CH_CDB_ContractId__c = '1234567test';
		serContract14.CH_CDB_PreviousContractId__c = '123456test';
		serContract14.StartDate = system.today();
		serContract14.EndDate = system.today()+10;
		serContract14.CH_CAPM_EmailAddress__c = capmemailadd;
		serContract14.CH_PriceBook__c = pricebookname;
		serContract14.Pricebook2Id = customPB1.Id;

		Test.startTest();  
		System.runAs(userPRM){
		insert serContract14; 
		serContract14.AccountId = acc20.id;
		serContract14.Name = 'TCS Service Contract TestData222';
		update serContract14;
		}
		Test.stopTest();
	}
	public static testMethod void test91(){
		
		Pricebook2 customPB1 = [SELECT Id FROM Pricebook2 where Name LIKE '%Nokia CARE Price Book%' limit 1 ];
		
		Id accRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		Id servRecordTypeId=Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
	
		Account acc20=new Account();
		acc20.Name='test';
		acc20.RecordTypeId=accRecordTypeId;
		acc20.BillingCountry='India';
		acc20.BillingCity='Hyd';
		acc20.BillingStreet='Hyd';
		acc20.Customer_Compliance__c='US_Sprint';
		insert acc20;
		
		Account acc21=new Account();
		acc21.Name='test11';
		acc21.RecordTypeId=accRecordTypeId;
		acc21.BillingCountry='India';
		acc21.BillingCity='Hyd';
		acc21.BillingStreet='Hyd';
		acc21.Customer_Compliance__c='US_Sprint';
		acc21.ParentId=acc20.id;
		insert acc21;
		 Contact con1 = new Contact(
			FirstName = 'McTesty',
			Lastname = String.valueOf(System.now().millisecond()),
			Email = 'email@test.com',
			AssistantName = 'Normal Contact',
			AccountId = acc21.Id
		);
		insert con1;
		User userPRM = new User(alias = 'abc', email = samplemail, emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',	 
		LanguageLocaleKey='en_US', localesidkey = 'en_US', profileid = userinfo.getProfileId(),  
		Country__c= 'Canada',Market__c='MARKET NORTH AMERICA', 
		timezonesidkey = 'America/Los_Angeles', Username = samplemail  + '.org',Restriction_Level__c = 'Confidential', 
		Nokia_ID__c= '6777777666');
		insert userPRM;
		ServiceContract serContract12 =new ServiceContract();
		serContract12.RecordTypeId = servRecordTypeId;
		serContract12.AccountId = acc21.id;
		serContract12.Name = serContrctName;
		serContract12.CurrencyIsoCode='EUR';
		serContract12.CH_CDB_ContractId__c = '1234567test';
		serContract12.CH_CDB_PreviousContractId__c = '123456test';
		serContract12.StartDate = system.today();
		serContract12.EndDate = system.today()+10;
		serContract12.CH_CAPM_EmailAddress__c = capmemailadd;
		serContract12.CH_PriceBook__c = pricebookname;
		serContract12.Pricebook2Id = customPB1.Id;
		
		ServiceContract serContract13 =new ServiceContract();
		serContract13.RecordTypeId = servRecordTypeId;
		serContract13.AccountId = acc21.id;
		serContract13.Name = 'TCS Service Contract TestData2';
		serContract13.CurrencyIsoCode='EUR';
		serContract13.CH_CDB_ContractId__c = '123456tes2t2222';
		serContract13.CH_CDB_PreviousContractId__c = '1234567test';
		serContract13.StartDate = system.today();
		serContract13.EndDate = system.today()+10;
		serContract13.CH_CAPM_EmailAddress__c = capmemailadd;
		serContract13.CH_PriceBook__c = pricebookname;
		serContract13.Pricebook2Id = customPB1.Id;
		
		
		Group GroupName = new Group();
		GroupName.DeveloperName='SEC_Sprint1';
		GroupName.Name='SEC|Sprint|||';
		insert GroupName;
		
		CH_SecurityGroups__c SecurityGroup = new CH_SecurityGroups__c();
		SecurityGroup.GroupName__c='SEC_Sprint';
		SecurityGroup.CH_CustomerCompliance__c='US_Sprint';
		SecurityGroup.Name = '123';
		SecurityGroup.GroupId__c=GroupName.Id;
		insert SecurityGroup;
		
		CH_SecurityGroups__c SecurityGroup1 = new CH_SecurityGroups__c();
		SecurityGroup1.GroupName__c='SEC_Sprint1';
		SecurityGroup1.CH_CustomerCompliance__c='ALL';
		SecurityGroup1.Name = '1234';
		SecurityGroup1.GroupId__c=GroupName.Id;
		insert SecurityGroup1;
		
		Group GroupName1 = new Group();
		GroupName1.DeveloperName='SEC_Sprint2';
		GroupName1.Name='SEC|Sprint|||';
		insert GroupName1;
		
		
		
		Test.startTest();  
		insert serContract12;
		insert serContract13;
		serContract13.AccountId = acc20.id;
		serContract13.Name = 'TCS Service Contract TestData222';
		update serContract13;
		
		ServiceContractShare oContractShare = new ServiceContractShare();   
		oContractShare.AccessLevel = 'Read';	
		oContractShare.ParentId = serContract12.Id;
		oContractShare.UserOrGroupId = userPRM.Id;
		insert oContractShare;
		
		ServiceContractShare deletedShare = [SELECT Id, IsDeleted FROM ServiceContractShare WHERE Id = :oContractShare.Id LIMIT 1];
			System.assertEquals(deletedShare.IsDeleted, false);

		ServiceContractShare oContractShare2 = new ServiceContractShare();
		oContractShare2.AccessLevel = 'Read';
		oContractShare2.ParentId = serContract13.Id;
		oContractShare2.UserOrGroupId = userPRM.Id;
		insert oContractShare2;
		Test.stopTest();
	}
	
	public static testMethod void testAuthorizedContact(){ 
		profile sysAdminProfile=[select id,name from profile where name='System Administrator'];
		User createTestUser = new User(alias = 'abc', email = samplemail, emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',	 
			LanguageLocaleKey='en_US', localesidkey = 'en_US', profileid = sysAdminProfile.id,  
			Country__c= 'Canada',Market__c='MARKET NORTH AMERICA', 
			timezonesidkey = 'America/Los_Angeles', Username = samplemail  + '.org',Restriction_Level__c = 'Confidential', 
			Nokia_ID__c= '6777777666');
		insert createTestUser;
		
		Pricebook2 pbEntry = [SELECT Id FROM Pricebook2 where Name LIKE '%Nokia CARE Price Book%' limit 1 ];
		
		Id acctRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		Id serviRecordTypeId=Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
		
		Account acc6=new Account();
		acc6.Name='test';
		acc6.RecordTypeId=acctRecordTypeId;
		acc6.BillingCountry='India';
		acc6.BillingCity='Hyd';
		acc6.BillingStreet='Hyd';
		acc6.Customer_Compliance__c='US_Govern';
		insert acc6;
		
		Account acc7=new Account();
		acc7.Name='test11';
		acc7.RecordTypeId=acctRecordTypeId;
		acc7.BillingCountry='India';
		acc7.BillingCity='Hyd';
		acc7.BillingStreet='Hyd';
		acc7.ParentId=acc6.id;
		insert acc7;
		
		ServiceContract serContract15 =new ServiceContract();
		serContract15.RecordTypeId = serviRecordTypeId;
		serContract15.AccountId = acc6.id;
		serContract15.Name = serContrctName;
		serContract15.CurrencyIsoCode='EUR';
		serContract15.CH_CDB_ContractId__c = '123456tes1t';
		serContract15.CH_CDB_PreviousContractId__c = '123456test';
		serContract15.StartDate = system.today();
		serContract15.EndDate = system.today()+10;
		serContract15.CH_CAPM_EmailAddress__c = capmemailadd;
		serContract15.CH_PriceBook__c = pricebookname;
		serContract15.Pricebook2Id = pbEntry.Id;
		Test.startTest();
		
		insert serContract15;  
		
		List<Account> getAcc = [Select id from Account LIMIT 1];
		Contact contObj = new contact();
		contObj.AccountId = getAcc[0].id;
		contObj.FirstName = 'Test Contact';
		contObj.LastName = 'TCS Data fix';
		contObj.Email =   createTestUser.Email;
		contObj.Market__c = 'Market India';
		contObj.CH_ContactType__c = 'customer';
		contObj.CurrencyIsoCode = 'EUR';
		Insert contObj;
		Map<Id,ServiceContract> oldSerConMap = new Map<Id,ServiceContract>();
		ServiceContract oldContract = new ServiceContract(id=serContract15.id, ownerID=Userinfo.getUserId());
		oldSerConMap.put(oldContract.Id, oldContract);
		serContract15.OwnerId=createTestUser.Id;
		update serContract15;
		List<ServiceContract> serConList = new List<ServiceContract>();
		serConList.add(serContract15);
		CH_ServiceContractTriggerHelper.updateAuthorizedContact(oldSerConMap,serConList);
		Test.stopTest();
	}

}