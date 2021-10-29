@isTest(SeeAllData=false)
private class TestClass_portaluserdeactivation
{
    static testMethod void TestClass_portaluserdeactivation() 
    { 
    test.starttest();
       // Profile p = [select id from profile where name='Training - Customer Portal' limit 1];
       //  system.debug(p.id);       
       // ID ProfileID = [ Select id from Profile where name = 'Training - Customer Portal'].id;
        Account A1 = new Account(Name = 'Test Account');
        insert A1;
            
        List<Contact> ContactList = new List<Contact>();
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User',Honeywell_ID__c='E407308', 
        email = 'test-user@fakeemail.com' );
        insert C1;
        
       /* User usr = new User();
        usr.alias = 'hari';
        usr.email = 'hari23@test.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='vnv';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.profileid = label.Custom_Customer_Portal;
        usr.contactid=c1.id;
        usr.isActive = true;
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='standarduser@testing.com';
        insert usr;*/
        user usr=[select id,name,IsActive from user where id=:label.test_user]; 
        
      // Test.StartTest(); 
       portaluserdeactivation pud= new portaluserdeactivation ();
       //database.executeBatch(pud,1500);
       pud.start( (Database.BatchableContext) null );
        pud.execute( (Database.BatchableContext) null,new List<User>{usr});
       //pud.execute((SchedulableContext) null );
        pud.finish( (Database.BatchableContext) null );
       Test.StopTest(); 
    }
}