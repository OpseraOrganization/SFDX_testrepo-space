@isTest
private class TestClass_User_Sync_FunctionalRoles {
    
    static testMethod void oppTriggTestTest() {
         Profile pf = [select name from Profile where name = 'System Administrator'];
           Role__c role = new Role__c(name='test role');
           insert role;
            User testUser = new User(firstName='Test888',lastName='user888',CommunityNickname='Test888User888',Alias='Tu888',TimeZoneSidKey='America/Los_Angeles',Email='test888@test.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',IsPortalSelfRegistered=true,IsActive=true,Functional_Role__c='Business Analyst',ProfileID=pf    .id,USername='TEst455@test455.com',localesidkey='en_US');
            insert testUser;
            
     }
     
     static testMethod void oppTriggTestTest2() {
         DS_Sales_Profilelist__c setting = new DS_Sales_Profilelist__c(name='User_Sync_FunctionalRoles');
         insert setting;
         User testUser = [select id,name,email,Functional_Role__c,PS_Manager_EID__c from user where isactive=true and Functional_Role__c<>null limit 1];
            Contact contacto = new Contact();
            contacto.Primary_Email_Address__c = testUser.Email;
            contacto.LastName ='abc';
            insert contacto;
            
             Role__c role = new Role__c(name='test role');
           insert role;
           
            testUser.Functional_Role__c = 'testrole1';
            testUser.PS_Manager_EID__c = 'U12345';
            update testUser;
           
     }
}