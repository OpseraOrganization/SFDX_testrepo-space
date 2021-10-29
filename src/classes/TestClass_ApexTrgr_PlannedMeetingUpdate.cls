@isTest
private class TestClass_ApexTrgr_PlannedMeetingUpdate {

    static testMethod void PlannedMeetingTest() {
        
        Profile pf = [select name from Profile where name = 'Honeywell System Administrator'];
        User testUser = new User(FirstName = 'Trigger', LastName = 'Test User',Username = 'triggertstuser@test.com.honeywell',EmployeeNumber='U99332',Email = 'testuser@test.com',Alias = 
                'tuser' ,CommunityNickname= 'tuserhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
                'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
                'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam');
            insert testUser;
            
            Country__c co1 = new Country__c();
    co1.Name = 'US';
    co1.SFDC_Country_Name__c = 'Test US';
    insert co1;
            
            Account a2 = new Account();
        a2.name = 'Test AccountPrajnya2';
        a2.Customer_Status__c = 'Active';
        a2.Region_Name__c = 'Americas';
        a2.Country__c = co1.id;
        a2.Service_Level__c = 'Comprehensive';
        a2.Strategic_Business_Unit__c = 'ATR';
        a2.CurrencyIsoCode = 'USD';
        a2.type = 'Dealer';
        a2.Tech_Support_Portal__c = true;
    insert a2;
           
        Contact testContact = new Contact(LastName = 'TestLN' ,Account = a2, AccountId = a2.id, AIN_Survey_Recipient__c = FALSE, ProPilot_Survey_Recipient__c=FALSE, FirstName = 'TestLN' ,Primary_Email_Address__c ='test@nttdata.com' ,Phone_3__c ='415298923' ,Phone_1__c ='123' ,SBU_Contact__c = 'BGA' ,CBT__c = 'After market' ,CBT_Team__c = 'Bus Av Operators');
            insert testContact;
            system.debug('--- '+testContact);
        
        /*Contact tstCon = new Contact(
            Name='Test Con'
         );   
        insert tstCon;*/
        
        Planned_Meeting__c tstPM = new Planned_Meeting__c(
            Assigned_To__c = testUser.ID,
            Name = 'Test PLanned Meeting',
            Start_Date__c = System.today(),
            Location__c = 'Bangalore',
            End_Date__c = System.today() + 3,
            Contact_Name__c = testContact.ID,
            AIN_Survey_Recipient__c = TRUE,
            ProPilot_Recipient__c = TRUE
        );
        insert tstPM;
        tstPM.AIN_Survey_Recipient__c = FALSE;
        update tstPM;
        
        tstPM.AIN_Survey_Recipient__c = TRUE;
        tstPM.ProPilot_Recipient__c = FALSE;
        update tstPM;
        
        /*Opportunity tstOpp = new Opportunity(
            Name='Test Opp',
            amount =100.00,
            Type = 'OCM Programs' ,
            closedate = System.today(),
            ForecastCategoryName = 'Pipeline'
        );   
        insert tstOpp;*/
        
        Planned_Meeting__c tstPlM = new Planned_Meeting__c(
            Assigned_To__c = testUser.ID,
            Name = 'Test PLanned Meeting',
            Start_Date__c = System.today(),
            Location__c = 'Bangalore',
            End_Date__c = System.today() + 3,
            Meeting_Purpose__c = 'Test Meeting Purpose'
        );
        insert tstPlM;  
        
        Planned_Meeting__c tstPlM2 = new Planned_Meeting__c(
            Assigned_To__c = testUser.ID,
            Name = 'Test PLanned Meeting',
            Start_Date__c = System.today(),
            Location__c = 'Bangalore',
            End_Date__c = System.today() + 3,
            Meeting_Purpose__c = 'Test Meeting Purpose'
        );
        insert tstPlM2;  
        
             
        Planned_Meeting_and_Opportunity__c tstPMO = new Planned_Meeting_and_Opportunity__c(
            Planned_Meeting__c = tstPlM.ID
            //Opportunity__c =  tstOpp.ID
        ); 
        //insert tstPMO;
        
        Event__c tstevnt = new Event__c(
            Name = 'Test Event Name',
            Active__c = True
        );    
        insert tstevnt;
        
        tstPlM.Event__c = tstevnt.ID;
        Update tstPlM;
        
        tstPMO.Planned_Meeting__c = tstPlM2.ID;
        //update tstPMO;
        
        tstPMO.Planned_Meeting__c = null;
        //update tstPMO;
        
        //delete tstPMO;
    }        
}