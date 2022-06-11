@IsTest

//Test Class for Account Trigger
private class AccountTriggerhelperCOETest{
  
  @testSetup static void createTestData() {
	NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
	cs.Name = 'Default';
	cs.Customer_Account__c = 'Customer - test';
	cs.Customer_Account_Number__c = '12345';
	cs.Customer_User_Profile__c = 'Customers';
	insert cs;
  }
  //Unit Test 1
  static testMethod void UnitTest1(){
  
  List<Account> accountList = new  List<Account>();
  List<Account> accountListTemp = new  List<Account>();
  Map<Id,Account> oldMap = new Map<Id,Account>();
  Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
  Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(); 
  
  accountList = TestDataFactory.createAccount(2);
  accountList[0].recordtypeid = custRecordTypeId;
  accountList[1].recordtypeid = LERecordTypeId;
  accountList[0].CTHeadEmail__c = 'anirudh.b.khanna@accenture.com';
  
  database.insert(accountList[0]); 
  accountList[1].parentid = accountList[0].id;
  accountList[1].Default_Legal_Entity__c = true;
  accountList[1].AccountNumber = '1000087011';
  accountList[1].NokiaCPQ_Applicable_Price_Lists__c = '';

  database.insert(accountList[1]);
  //accountList[1].NokiaCPQ_Applicable_Price_Lists__c = 'C Spire Price List (USD)';
   
  // database.update(accountList[1]);
  for(Integer i=1;i<accountList.size();i++){
	accountListTemp.add(accountList[i]);
  }
 
  //AccountTriggerHandlerCOE.beforeUpdateOperation(accountList,oldMap,true );
  //AccountTriggerhelperCOE.ValidatePricelist(accountListTemp);
  }
  
  //Unit Test 3
  static testMethod void UnitTest3(){
  Map<Id,Account> oldMap = new Map<Id,Account>();
  List<Account> accountList = new  List<Account>();
  List<Account> accountListTemp = new  List<Account>();
  Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
  Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(); 
	
  Apttus_Config2__PriceList__c pricelist=new Apttus_Config2__PriceList__c();
  pricelist.Name='CLP';
  pricelist.Apttus_Config2__Active__c=true;
  pricelist.CurrencyIsoCode='USD';
  insert pricelist;

  accountList = TestDataFactory.createAccount(3);
  accountList[0].recordtypeid = custRecordTypeId;
  accountList[1].recordtypeid = LERecordTypeId;
  accountList[2].recordtypeid = LERecordTypeId;
  
  database.insert(accountList[0]); 
  accountList[1].parentid = accountList[0].id;
  accountList[1].Default_Legal_Entity__c = false;
  accountList[1].AccountNumber = '1000087011';
  accountList[1].NokiaCPQ_Applicable_Price_Lists__c = 'CLP';
  accountList[1].CurrencyIsoCode = 'USD';
  database.insert(accountList[1]); 
  
  for(Integer i=1;i<accountList.size();i++){
	accountListTemp.add(accountList[i]);
  }   
  //AccountTriggerHandlerCOE.beforeUpdateOperation(accountList,oldMap,true );
  //AccountTriggerhelperCOE.ValidatePricelist(accountListTemp);
  }
  
  
  //Unit Test 12
  static testMethod void UnitTest12(){
  Map<Id,Account> oldMap = new Map<Id,Account>();
  List<Account> accountList = new  List<Account>();
  List<Account> accountListTemp = new  List<Account>();
  Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
  Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(); 
	
  Apttus_Config2__PriceList__c pricelist=new Apttus_Config2__PriceList__c();
  pricelist.Name='CLPEUR';
  pricelist.Apttus_Config2__Active__c=true;
  pricelist.CurrencyIsoCode='EUR';
  insert pricelist;

  accountList = TestDataFactory.createAccount(3);
  accountList[0].recordtypeid = custRecordTypeId;
  accountList[1].recordtypeid = LERecordTypeId;
  accountList[2].recordtypeid = LERecordTypeId;
  
  database.insert(accountList[0]); 
  accountList[1].parentid = accountList[0].id;
  accountList[1].Default_Legal_Entity__c = false;
  accountList[1].AccountNumber = '1000087011';
  accountList[1].NokiaCPQ_Applicable_Price_Lists__c = 'CLPEUR';
   accountList[1].CurrencyIsoCode = 'EUR';
  database.insert(accountList[1]); 
  
  for(Integer i=1;i<accountList.size();i++){
	accountListTemp.add(accountList[i]);
  }   
  //AccountTriggerHandlerCOE.beforeUpdateOperation(accountList,oldMap,true);
 // AccountTriggerhelperCOE.ValidatePricelist(accountListTemp);
  }   
}