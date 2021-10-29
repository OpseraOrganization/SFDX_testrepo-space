@isTest
private without sharing class userupdatetest {
    @isTest static void Testuserupdate() {
    
    String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='API Corp Integration'];
        User ur = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
         UserName=uniqueUserName);
         
        Profile pr = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'ACS Sales User'].Id,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     Support_Level__c= '1',
     Citizenship_Cntry__c = 'test',
     Managers_Name__c = [SELECT Id FROM User WHERE Name = 'Priyanka Joy' AND profileid=:pr.id].id,
     LocaleSidKey = 'en_US');
insert u;

        
        // Perform test
        Test.startTest();
        System.runas(ur){
        //u.TimeZoneSidKey= 'Asia/Kolkata';
        //u.Support_Level__c= '2';
        u.Managers_Name__c = null;
        //u.Citizenship_Cntry__c = 'test2';
        update u;
        Test.stopTest();
    }
    }
    
}