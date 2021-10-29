/** * File Name:  TestClass_ApexTrigger_PlannedMeeting 
* Description : Test Method for PlannedMeeting_Event_opp_relation and PlannedMeeting_Opportunity_Event_Relation
* Trigger Tested: PlannedMeeting_Event_opp_relation
* Copyright : Wipro Technologies Limited Copyright (c) 2011
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */
@isTest
private class TestClass_ApexTrgr_PlannedMeeting {

    static testMethod void PlannedMeetingTest() {
        
        Profile pf = [select name from Profile where name = 'Honeywell System Administrator'];
        User testUser = new User(FirstName = 'Trigger', LastName = 'Test User',Username = 'triggertstuser@test.com.honeywell',EmployeeNumber='E199332',Email = 'testuser@test.com',Alias = 
                'tuser' ,CommunityNickname= 'tuserhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
                'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
                'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam');
            insert testUser;
           
        
 
        
        Opportunity tstOpp = new Opportunity(
            Name='Test Opp',
            amount =100.00,
            Type = 'OCM Programs' ,
            closedate = System.today(),
            StageName='Prospecting',
            ATR_Aircraft_Quantity__c=1,
            ForecastCategoryName = 'Pipeline'
        );   
        insert tstOpp;
        
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
            Planned_Meeting__c = tstPlM.ID,
            Opportunity__c =  tstOpp.ID
        ); 
        insert tstPMO;
        
        Event__c tstevnt = new Event__c(
            Name = 'Test Event Name',
            Active__c = True
        );    
        insert tstevnt;
        
        tstPlM.Event__c = tstevnt.ID;
        Update tstPlM;
        
        tstPMO.Planned_Meeting__c = tstPlM2.ID;
        update tstPMO;
        
        tstPMO.Planned_Meeting__c = null;
        update tstPMO;
        
        delete tstPMO;
    }        
}