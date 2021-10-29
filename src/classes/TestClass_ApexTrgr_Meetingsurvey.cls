@isTest(seealldata=true)
private class TestClass_ApexTrgr_Meetingsurvey {

    static testMethod void MeetingsurveyTest() {
        
        Profile pf = [select name from Profile where name = 'Honeywell System Administrator'];
        User testUser = new User(FirstName = 'Trigger', LastName = 'Test User',Username = 'triggertstuser@test.com.honeywell',EmployeeNumber='E199332',Email = 'testuser@test.com',Alias = 
                'tuser' ,CommunityNickname= 'tuserhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
                'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
                'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam');
            insert testUser;
        Contact testContact = new Contact(LastName = 'TestLN' ,FirstName = 'TestLN' ,Email ='test@nttdata.com',Primary_Email_Address__c ='test@nttdata.com' ,Phone_3__c ='415298923' ,Phone_1__c ='123' ,SBU_Contact__c = 'BGA' ,CBT__c = 'After market' ,CBT_Team__c = 'Bus Av Operators');
            insert testContact;
           RecordType[] rts = [select Id from RecordType where SobjectType = 'Planned_Meeting__c' and DeveloperName = 'Contact_Plan']; 
        CreateSurveyURL.testing = true;
        Planned_Meeting__c tstPlM = new Planned_Meeting__c(
            Assigned_To__c = testUser.ID,
            Name = 'Test PLanned Meeting',
            Start_Date__c = System.today(),
            Location__c = 'Bangalore',
            End_Date__c = System.today() + 3,
            Meeting_Purpose__c = 'Test Meeting Purpose',
            RecordTypeId = rts[0].id,
            Contact_Name__c = testContact.ID
        );
        insert tstPlM;  
        
           tstPlM.Completed_Date__c = system.today();
           tstPlM.send_survey__c = true;
           tstPlM.Meeting_Status__c ='Done';
        update tstPlM;
    }        
}