/**
*
* Name              : SHMapCtrl_Test
* Created Date      : 15 MAY 18
* Created By        : Aamir Sharif (Honeywell)
* Purpose           : Controller Test class for 'SHMap' page (HSMapCtrl Class) - logic to display stakeholder hierarchy up to 10 levels.
                    : Included the logic to attach the map as part of the Notes and Attachment section under Intelliplan record
* Last Updated By   :  
*
* NOTES: [1] This is not the orignal test class provided by the authour Manjunath Holekade (TEKSystems)
**/
@isTest
private class SHMapCtrl_Test{
  @testSetup
  static void setupTestData(){
    test.startTest();
    Account account_Obj = new Account(Name='Name951', ShippingStreet='PratapNagar', ShippingCity='New York', ShippingState='New York', ShippingPostalCode='Z1P', ShippingCountry='United States', Phone='54343-34518');
    Insert account_Obj; 
      
    // Contacts need to be UNIQUE - identified via EMAIL
    Contact contact1_Obj = new Contact(FirstName='Name951', LastName='Name951', email='emailme@home.com', MailingState='New York', MailingPostalCode='Z1P', MailingCountry='United States', AccountId=account_Obj.id);
    Insert contact1_Obj;
    Contact contact2_Obj = new Contact(FirstName='Name952', LastName='Name952', email='emailmetoo@home.com', MailingState='New York', MailingPostalCode='Z1P', MailingCountry= 'United States', ReportsToId=contact1_Obj.Id, AccountId = account_Obj.id);
    Insert contact2_Obj;
    Contact contact3_Obj = new Contact(FirstName= 'Name953', LastName= 'Name953', email= 'emailmeaswell@home.com', MailingState= 'New York', MailingPostalCode= 'Z1P', MailingCountry= 'United States', ReportsToId=contact2_Obj.Id, AccountId = account_Obj.id);
    Insert contact3_Obj;
    Contact contact4_Obj = new Contact(FirstName= 'Name954', LastName= 'Name954', email= 'dontemailme@home.com', MailingState= 'New York', MailingPostalCode= 'Z1P', MailingCountry= 'United States', ReportsToId=contact2_Obj.Id, AccountId = account_Obj.id);
    Insert contact4_Obj;
      
    HON_Account_Plan__c hon_account_plan_Obj = new HON_Account_Plan__c(Name = 'Name854', Account__c = account_Obj.id);
    Insert hon_account_plan_Obj; 
    
    // Each Stakeholder shoudl have a different Contact
    Stakeholder__c stakeholder1_Obj = New Stakeholder__c(Contact__c = contact1_Obj.Id, Influence__c = 'Low', Support_Level__c = 'Sponsor', HON_Account_Plan__c = hon_account_plan_Obj.Id);
    Insert stakeholder1_Obj;
    Stakeholder__c stakeholder2_Obj = New Stakeholder__c(Contact__c = contact2_Obj.Id, Influence__c = 'Medium', Support_Level__c = 'Sponsor', HON_Account_Plan__c = hon_account_plan_Obj.Id);
    Insert stakeholder2_Obj;
    Stakeholder__c stakeholder3_Obj = New Stakeholder__c(Contact__c = contact3_Obj.Id, Influence__c = 'High', Support_Level__c = 'Anti-Sponsor', HON_Account_Plan__c = hon_account_plan_Obj.Id);
    Insert stakeholder3_Obj;
    Stakeholder__c stakeholder4_Obj = New Stakeholder__c(Contact__c = contact4_Obj.Id, Influence__c = 'High', Support_Level__c = 'Neutral', HON_Account_Plan__c = hon_account_plan_Obj.Id);
    Insert stakeholder4_Obj;
    test.stopTest();
  }
  static testMethod void test_attach_UseCase1(){
    List<Account> account_Obj  =  [SELECT Id,Name,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,Phone from Account];
    System.assertEquals(true,account_Obj.size()>0);
    List<HON_Account_Plan__c> hon_account_plan_Obj = [SELECT Id,Name,Account__c from HON_Account_Plan__c];
    System.assertEquals(true,hon_account_plan_Obj.size()>0);
    List<Stakeholder__c> stakeholder_obj = [select Id from Stakeholder__c];
    System.assertEquals(true,Stakeholder_obj.size()>0);
    PageReference pageRef = Page.SHMap;
    pageRef.getParameters().put('id','test');
    Test.setCurrentPage(pageRef);
    SHMapCtrl obj01 = new SHMapCtrl(new ApexPages.StandardController(hon_account_plan_Obj[0]));
//    obj01.attach();
  }

    static testMethod void test_attach_UseCase2(){
    List<Account> account_Obj  =  [SELECT Id,Name,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,Phone from Account];
    System.assertEquals(true,account_Obj.size()>0);
    List<HON_Account_Plan__c> hon_account_plan_Obj  =  [SELECT Id,Name,Account__c from HON_Account_Plan__c];
    System.assertEquals(true,hon_account_plan_Obj.size()>0);
    PageReference pageRef = Page.SHMap;
    pageRef.getParameters().put('id','test');
    Test.setCurrentPage(pageRef);
    SHMapCtrl obj01 = new SHMapCtrl(new ApexPages.StandardController(hon_account_plan_Obj[0]));
//    account_Obj[0];
//    Update account_Obj[0];
//    obj01.attach();
    }}