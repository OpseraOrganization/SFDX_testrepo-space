@isTest(SeeAllData=True)
private without sharing class userupdatetest1{
    @isTest(SeeAllData=True)static void Testuserupdate1() {
    
    String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile pr = [SELECT Id FROM Profile WHERE Name='Sales Admin'];
        User ur = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pr.Id,
        TimeZoneSidKey='America/Los_Angeles',
         UserName=uniqueUserName);
         insert ur;
         
        // Test data setup
        // Create an account with an opportunity, and then try to delete it              
        // Perform test
        PermissionSet pps = new PermissionSet(Label = 'TestPS',Name = 'Test_PS',PermissionsManageInternalUsers = TRUE);
        insert pps;
        //PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Manage_External_Users'];
        insert new PermissionSetAssignment(AssigneeId = ur.id, PermissionSetId = pps.Id);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'ACS Sales User'];
        Test.startTest();
        System.runas(ur){
        //Profile[] p = [SELECT Id FROM Profile WHERE Name = 'ACS Sales User'];        
         User u = new User(
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
     US_Permanent_Resident__c = TRUE,
     LocaleSidKey = 'en_US',
     ProfileId = p.id);
insert u;

        //u.TimeZoneSidKey= 'Asia/Kolkata';
        //u.Support_Level__c= '2';
        u.LastName= 'test';
        //u.Citizenship_Cntry__c = 'test2';
        update u;
        Test.stopTest();
    }
    }
    
}