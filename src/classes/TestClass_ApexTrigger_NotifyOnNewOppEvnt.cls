/** * File Name:  TestClass_ApexTrigger_NotifyOnNewOppEvnt 
* Description Test Method
* Trigger Tested: NotifyWhenEventCreatedForOpportunity 
* Copyright : Wipro Technologies Limited Copyright (c) 2011
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private class TestClass_ApexTrigger_NotifyOnNewOppEvnt {

    static testMethod void notifyOnNewOppEvntTest() {
    List<User> usrlst = new List<User>();
            Profile pf = [select name from Profile where name = 'System Administrator'];
            User testUser = new User(FirstName = 'Trigger', LastName = 'Test User',Username = 'triggertstuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 
                'tuser' ,CommunityNickname= 'tuserhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
                'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
                'en_US',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam');
          //  insert testUser;
            usrlst.add(testUser);
            
            User testUser1 = new User(FirstName = 'Trigger', LastName = 'Opp CoOwnerUser',Username = 'oppcoowner@test.com.honeywell',Email = 'oppcoowner@test.com',Alias = 
                'oppcoown' ,CommunityNickname= 'coownerrhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
                'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
                'en_US',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam');
           // insert testUser1;
            
            usrlst.add(testUser1);
            insert usrlst;
            
          //  system.runAs(testUser){
                Account tstAcc = New Account(Name= 'Task trigger Test Account');
                insert tstAcc;
                RecordType tstRecTyp = [select id , name from RecordType where name='BGA Event'];
                RecordType tstBGARecTyp = [select id , name from RecordType where name='BGA AM'];
                RecordType tstBGASTRecTyp = [select id , name from RecordType where name='BGA'];
                Opportunity tstOpp = new Opportunity(Name='Test Task Trigger Opp',Accountid=tstAcc.Id,StageName='Prospecting',
                    CloseDate=System.today(), Owner=testUser,recordtypeid=tstBGARecTyp.id,Opportunity_Co_owner_new__r=testUser1,dealer_account__c='0013000000bFxtr');
                insert tstOpp;

                Opportunity_Sales_Team__c mem1 = new Opportunity_Sales_Team__c(User__c=testUser1.ID,recordtypeid=tstBGASTRecTyp.id,Opportunity__c= tstOpp.id,Opportunity_Team_Role__c='Sales Manager');
                    insert mem1;
            
              //  Test.startTest();
                 
                    Note tstNote = new Note(Title='Testnote',parentid =tstOpp.id,isprivate=false,Body='note trigger test');
                    insert tstNote;
                     
                    Event tstTask1= new Event(whatId =tstAcc.id, recordtypeid = tstRecTyp.id, DurationInMinutes = 10, ActivityDateTime = system.now());
                    insert tstTask1;
                    Event tstTask2= new Event (whatId=tstOpp.Id,ownerid=testUser.Id,recordtypeid = tstRecTyp.id, DurationInMinutes = 10, ActivityDateTime = system.now());
                    insert tstTask2;
                  /*  Opportunity_Sales_Team__c tstOppSalesTeam = new Opportunity_Sales_Team__c(User__c = testUser.id ,Opportunity__c = tstOpp.id );
                    insert tstOppSalesTeam;*/
                    Event tstTask3= new Event (whatId=tstOpp.Id,ownerid=testUser.Id, recordtypeid = tstRecTyp.id, DurationInMinutes = 10, ActivityDateTime = system.now());
                    insert tstTask3;
                    Event tstTask4= new Event(DurationInMinutes = 10, ActivityDateTime = system.now());
                    insert tstTask4;
                 
                     
               // Test.stopTest();
             //   }
    }
}