@isTest
class TestSalesSurveyController{
    static testMethod void testinitC() {
        
    
        String str = 'My Contact';        
        Account acc= new Account(Name='New Account',BillingStreet = '1st street', BillingCity = 'Phoenix', BillingCountry = 'United States', Phone = '7708218788');
        insert acc;
        Contact c1 = new Contact(FirstName='My Contact', LastName='My Contact', AccountID=acc.id, Email = 'test@test.com');
        insert c1;
        Contact c2 = new Contact(FirstName='My Contact',LastName='Contact2', AccountID=acc.id, Email = 'test2@test2.com');
        insert c2;
        Contact c3 = new Contact(FirstName='My Contact',LastName='Test Contact3', AccountID=acc.id, Email = 'test3@test3.com');
        insert c3;
        List<id> lstConID = new List<id>();
        lstConID.add(c1.id);
        lstConID.add(c2.id);
        lstConID.add(c3.id);
        
        Opportunity opp = new Opportunity(name='My New Opportunity', amount=600000, AccountID=acc.id,AutopopOff__c = false);
        
        SalesSurveyController.initC(opp.id);
    }
    static testMethod void testsendEmailA() {
        
    
        String str = 'My Contact';        
        Account acc= new Account(Name='New Account',BillingStreet = '1st street', BillingCity = 'Phoenix', BillingCountry = 'United States', Phone = '7708218788');
        insert acc;
        Contact c1 = new Contact(FirstName='My Contact',LastName='My Contact', AccountID=acc.id, Email = 'test@test.com');
        insert c1;
        Contact c2 = new Contact(FirstName='My Contact',LastName='Contact2', AccountID=acc.id, Email = 'test2@test2.com');
        insert c2;
        Contact c3 = new Contact(FirstName='My Contact',LastName='Test Contact3', AccountID=acc.id, Email = 'test3@test3.com');
        insert c3;
        List<id> lstConID = new List<id>();
        lstConID.add(c1.id);
        lstConID.add(c2.id);
        lstConID.add(c3.id);
        
        Opportunity opp = new Opportunity(name='My New Opportunity', amount=600000, AccountID=acc.id,AutopopOff__c = false);
        
        SalesSurveyController.sendEmailA(lstConID,opp.id);
    }
    
    static testMethod void testsendEmailAelseblock() {
        
    
        String str = 'My Contact';        
        Account acc= new Account(Name='New Account',BillingStreet = '1st street', BillingCity = 'Phoenix', BillingCountry = 'United States', Phone = '7708218788');
        insert acc;
        
        List<id> lstConID = new List<id>();
        
        Opportunity opp = new Opportunity(name='My New Opportunity', amount=600000, AccountID=acc.id,AutopopOff__c = false);
        
        SalesSurveyController.sendEmailA(lstConID,opp.id);
    }
    
    static testMethod void testgetGlobalContacts() {
        String str = 'My Contact';        
        Account acc= new Account(Name='New Account',BillingStreet = '1st street', BillingCity = 'Phoenix', BillingCountry = 'United States', Phone = '7708218788');
        insert acc;
        Contact c1 = new Contact(FirstName='My Contact',LastName='My Contact', AccountID=acc.id, Email = 'test@test.com');
        insert c1;
        Contact c2 = new Contact(FirstName='My Contact',LastName='Contact2', AccountID=acc.id, Email = 'test2@test2.com');
        insert c2;
        Contact c3 = new Contact(FirstName='My Contact',LastName='Test Contact3', AccountID=acc.id, Email = 'test3@test3.com');
        insert c3;
        List<id> lstConID = new List<id>();
        lstConID.add(c1.id);
        lstConID.add(c2.id);
        lstConID.add(c3.id);
        
        Opportunity opp = new Opportunity(name='My New Opportunity', amount=600000, AccountID=acc.id,AutopopOff__c = false);
        
        SalesSurveyController.getGlobalContacts(str,acc.id);
    }
    
    static testMethod void testsaveReasonA() {
        String strreason = 'My Reason';  
        String strcomments = 'My Comments';       
        Account acc= new Account(Name='New Account',BillingStreet = '1st street', BillingCity = 'Phoenix', BillingCountry = 'United States', Phone = '7708218788');
        insert acc;
        Contact c1 = new Contact(FirstName='My Contact',LastName='My Contact', AccountID=acc.id, Email = 'test@test.com');
        insert c1;
        Contact c2 = new Contact(FirstName='My Contact',LastName='Contact2', AccountID=acc.id, Email = 'test2@test2.com');
        insert c2;
        Contact c3 = new Contact(FirstName='My Contact',LastName='Test Contact3', AccountID=acc.id, Email = 'test3@test3.com');
        insert c3;
        List<id> lstConID = new List<id>();
        lstConID.add(c1.id);
        lstConID.add(c2.id);
        lstConID.add(c3.id);
        
        Opportunity opp = new Opportunity( name='My New Opportunity', amount=600000, AccountID=acc.id,AutopopOff__c = false,StageName = 'CLosed Won', CloseDate = system.today());
        insert opp;
        
        SalesSurveyController.saveReasonA(opp.id,strreason);
    }
    
    
    static testMethod void testgetRelatedContacts() {
        String strreason = 'My Reason';  
        String strcomments = 'My Comments';       
        Account acc= new Account(Name='New Account',BillingStreet = '1st street', BillingCity = 'Phoenix', BillingCountry = 'United States', Phone = '7708218788');
        insert acc;
        Contact c1 = new Contact(FirstName='My Contact',LastName='My Contact', AccountID=acc.id, Email = 'test@test.com');
        insert c1;
        Contact c2 = new Contact(FirstName='My Contact',LastName='Contact2', AccountID=acc.id, Email = 'test2@test2.com');
        insert c2;
        Contact c3 = new Contact(FirstName='My Contact',LastName='Test Contact3', AccountID=acc.id, Email = 'test3@test3.com');
        insert c3;
        List<id> lstConID = new List<id>();
        lstConID.add(c1.id);
        lstConID.add(c2.id);
        lstConID.add(c3.id);
        OppCloseDate__c ocd = new OppCloseDate__c(Name='Test',CloseDateNum__c =10);
        insert ocd;
        Opportunity opp = new Opportunity( name='My New Opportunity', amount=600000, AccountID=acc.id,end_user__c =acc.id,AutopopOff__c = false,StageName = 'CLosed Won', CloseDate = system.today());
        insert opp;
        
        SalesSurveyController.getRelatedContacts(acc.id,opp.id,opp.end_user__c,'D&S Standard');
        SalesSurveyController.validateOpptyRecord(opp.id);
    }
    
}