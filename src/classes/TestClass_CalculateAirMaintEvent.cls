/** * File Name:  TestClass_CalculateAirMaintEvent
* Description Test Method
* Trigger Tested: NotifyWhenEventCreatedForOpportunity 
* Copyright : Wipro Technologies Limited Copyright (c) 2011
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private class TestClass_CalculateAirMaintEvent {
    
    static testMethod void CalculateAirMaintEvent() {
        Profile pf = [select name from Profile where name = 'System Administrator'];
        User testUser = new User(FirstName = 'Test', LastName = 'User',Username = 'testuser@wipro.com.name',Email = 'testuser@wipro.com',
        Alias = 'tuser' ,CommunityNickname= 'tuserhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',
        EmailEncodingKey = 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole',
        SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam');
        insert testUser;
      
        system.runAs(testUser){
            Platform__c plat1 = New Platform__c(Name = 'Test PLatform', C_Event_Duration__c = 10.00, CCHK_NUM__c = 5.00, Avg_Flying_Hours_Per_Month__c = 10.00);
            insert plat1;
            Set<Id> platId1 = New Set<Id>();
            platId1.add(plat1.Id);
          
            Fleet_Asset_Detail__c fleet1 = New Fleet_Asset_Detail__c(Name = 'Test Fleet', Platform_Name__c = plat1.id, Previous_C_Check_Event_Date__c = system.today()-100);
            insert fleet1;
          
            Maintenance_Events__c maint1 = New Maintenance_Events__c(Name = 'Test Maint', Check_Name__c = 'C', Aircraft__c = fleet1.id );
            insert maint1;
            
            RMU_VALUE__c rmuval= New RMU_VALUE__c(Name='test RMU');
            insert rmuval;
          
            OFFERING_MAPPER__c rmu1 = New OFFERING_MAPPER__c(Name = 'Test RMU', Aircraft_Platform__c = 'a0J1300000WnTkP', Valid_For_Check_C__c = true,RMU_VALUE__c=rmuval.id);
            insert rmu1;


            Platform__c plat2 = New Platform__c(Name = 'Test PLatform', B_Event_Duration__c = 10.00, BCHK_NUM__c = 5.00, Avg_Flying_Hours_Per_Month__c = 10.00);
            insert plat2;
            Set<Id> platId2 = New Set<Id>();
            platId2.add(plat2.Id);
          
            Fleet_Asset_Detail__c fleet2 = New Fleet_Asset_Detail__c(Name = 'Test Fleet', Platform_Name__c = plat2.id, Previous_B_Check_Event_Date__c = system.today()-150);
            insert fleet2;
          
            Maintenance_Events__c maint2 = New Maintenance_Events__c(Name = 'Test Maint', Check_Name__c = 'B', Aircraft__c = fleet2.id );
            insert maint2;
            
            RMU_VALUE__c rmuval1= New RMU_VALUE__c(Name='test RMU');
            insert rmuval1;
          
            OFFERING_MAPPER__c rmu2 = New OFFERING_MAPPER__c(Name = 'Test RMU', Aircraft_Platform__c = 'a0J1300000WnTkQ', Valid_For_Check_B__c = true,RMU_VALUE__c=rmuval1.id);
            insert rmu2;
          

            Platform__c plat3 = New Platform__c(Name = 'Test PLatform', A_Event_Duration__c = 10.00, ACHK_NUM__c = 5.00, Avg_Flying_Hours_Per_Month__c = 10.00);
            insert plat3;
            Set<Id> platId3 = New Set<Id>();
            platId3.add(plat3.Id);
          
            Fleet_Asset_Detail__c fleet3 = New Fleet_Asset_Detail__c(Name = 'Test Fleet', Platform_Name__c = plat3.id, Previous_A_Check_Event_Date__c = system.today()-150);
            insert fleet3;
          
            Maintenance_Events__c maint3 = New Maintenance_Events__c(Name = 'Test Maint', Check_Name__c = 'A', Aircraft__c = fleet3.id );
            insert maint3;
            
            RMU_VALUE__c rmuval2= New RMU_VALUE__c(Name='test RMU');
            insert rmuval2;
          
            OFFERING_MAPPER__c rmu3 = New OFFERING_MAPPER__c(Name = 'Test RMU', Aircraft_Platform__c = 'a0J1300000WnTkR', Valid_For_Check_A__c = true,RMU_VALUE__c=rmuval2.id);
            insert rmu3;


          
            Test.startTest();
                try{
                    Boolean abc = CalculateAircraftMaintenanceEvent.gen_C_EventData(platId1);
                    Boolean def = CalculateAircraftMaintenanceEvent.gen_B_EventData(platId2);
                    Boolean ghi = CalculateAircraftMaintenanceEvent.gen_A_EventData(platId3);            
                   }
                catch(Exception e){
                   }
        }  
    }
}