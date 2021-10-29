@istest
public class RDF_UpdateStatusOnCase_Test {
    static testmethod void updateTest(){
         Id devRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('One-Off Discount').getRecordTypeId();
          Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User newuser = new User(LastName = 'Test',
                            FirstName='Myname',
                            Alias = 'tmlv',
                            Email = 'Test.mytest@abc.com',
                            Username = 'test.mytests@abcd.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           );
        insert newuser;
        
          Case newcase = new Case();
        newcase.User_VN_Name__c = newuser.id; 
        newcase.status = 'Open';
        newcase.RecordTypeId = devRecordTypeId;
        newcase.Sub_Status__c ='Approved';
        insert newcase;
        
         SEA_Approval__c sea = new SEA_Approval__c();
        sea.case__c = newcase.id;
        sea.Name ='Test';
        sea.Approval_Status__c = 'Not Submitted';
        sea.Approver_Name__c = newuser.id;
        insert sea;
        sea.Approval_Status__c = 'Approved';
        update sea;
    }
}