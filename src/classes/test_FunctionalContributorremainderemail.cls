@isTest(SeeAllData=false)
private class test_FunctionalContributorremainderemail
{
    static testMethod void FunctionalContributorremainderemail()
    {
        Profile pf = [select name from Profile where name = 'System Administrator'];
        User testUser = new User(LastName = 'Trigger Test User',Username = 'triggertstuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 
            'tuser' ,CommunityNickname= 'tuserhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
            'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
            'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam',
            Phone='123456789',Extension='234',Fax='123456789',MobilePhone='123456788'
            );
        insert testUser;
        
        User testUser2 = new User(LastName = 'Trigger Test User2',Username = 'triggertstuser2@test.com.honeywell',Email = 'testuser2@test.com',Alias = 
            'tuser2' ,CommunityNickname= 'tuser2honey' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
            'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
            'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam',
            Phone='123456789',Extension='234',Fax='123456789',MobilePhone='123456788'
            );
        insert testUser2;
            
        Test.startTest();
        system.runAs(testUser)
        {             
                        
            Functional_Contributor_Update__c fc=new Functional_Contributor_Update__c();
            //fc.Opportunity_Proposal__c=opppro.id;
            fc.Non_SFDC_Recipient__c='venkatesh.athanti@nttdata.com';
            fc.Email_Update_Status__c='In progress';
            fc.Request_Date__c=system.today()+3;
            insert fc;
            
            Functional_Contributor_Update__c fc1=new Functional_Contributor_Update__c();
            //fc1.Opportunity_Proposal__c=opppro.id;
            fc1.Non_SFDC_Recipient__c='venkatesh.athanti@nttdata.com';
            fc1.Email_Update_Status__c='In progress';
            fc1.Reminder_Email_Date__c = null;
            fc1.X3_Days_Reminder__c=false;
            fc1.Request_Date__c=system.today()-3;
            insert fc1;
            
            Functional_Contributor_Update__c fc2=new Functional_Contributor_Update__c();
            //fc2.Opportunity_Proposal__c=opppro.id;
            fc2.Non_SFDC_Recipient__c='venkatesh.athanti@nttdata.com';
            fc2.Email_Update_Status__c='In progress';
            fc2.Reminder_Email_Date__c = system.today()+1;
            fc2.X3_Days_Reminder__c=true;
            fc2.Request_Date__c=system.today()-5;
            insert fc2; 
                     
            FunctionalContributorremainderemail functionalbatch = new FunctionalContributorremainderemail();
            database.executeBatch(functionalbatch,600);
            
            System.schedule('functionalreminder123', '0 44 * * * ?', new FunctionalContributorremainderemail());         
            test.stopTest();          
        }
    }
}