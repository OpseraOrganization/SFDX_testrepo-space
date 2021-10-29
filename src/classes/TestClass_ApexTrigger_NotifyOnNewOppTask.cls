/** * File Name:  TestClass_ApexTrigger_NotifyOnNewOppTask 
* Description Test Method
* Trigger Tested: NotifyOnNewOpportunityTask 
* Copyright : Wipro Technologies Limited Copyright (c) 2011
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private class TestClass_ApexTrigger_NotifyOnNewOppTask {

    static testMethod void notifyOnNewOppTaskTest() {
            Profile pf = [select name from Profile where name = 'System Administrator'];
            User testUser = new User(FirstName = 'Trigger',LastName = 'Test User',Username = 'triggertstuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 
                'tuser' ,CommunityNickname= 'tuserhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
                'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
                'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam');
            insert testUser;
            
            RecordType tstBGARecTyp = [select id , name from RecordType where name='BGA AM'];
            
            Account tstAcc = New Account(Name= 'Task trigger Test Account', 
                    Strategic_Business_Unit__c = 'D&S', 
                    CBT__c = 'HTSI');
                insert tstAcc;
            system.runAs(testUser){             
                RecordType tstRecTyp = [select id , name from RecordType where name='General Task'];
                Opportunity tstOpp = new Opportunity(Name='Test Task Trigger Opp',Accountid=tstAcc.Id,StageName='Prospecting',
                    CloseDate=System.today(), recordtypeid=tstBGARecTyp.id, Owner=testUser,dealer_account__c='0013000000bFxtr');
                insert tstOpp;
                Opportunity tstOpp1 = new Opportunity(Name='Test Task Trigger Opp',Accountid=tstAcc.Id,StageName='Prospecting',
                    CloseDate=System.today(), recordtypeid=tstBGARecTyp.id, Owner=testUser,Opportunity_Co_owner_new__c=testUser.id,dealer_account__c='0013000000bFxtr');
                insert tstOpp1;
                Test.startTest();
                try{


                    Task tstTask1= new Task(whatId =tstAcc.id, recordtypeid= tstRecTyp.id);
                    insert tstTask1;
                    Task tstTask2= new Task (whatId=tstOpp.Id,ownerid=testUser.Id,recordtypeid = tstRecTyp.id);
                    insert tstTask2;
                    Opportunity_Sales_Team__c tstOppSalesTeam = new Opportunity_Sales_Team__c(User__c = testUser.id ,Opportunity__c = tstOpp.id );
                    insert tstOppSalesTeam;
                    Task tstTask3= new Task (whatId=tstOpp.Id,ownerid=testUser.Id, recordtypeid = tstRecTyp.id);
                    insert tstTask3;
                    Task tstTask4= new Task();
                    insert tstTask4;
                    Task tstTask5= new Task(whatId=tstOpp1.Id,ownerid=testUser.Id, recordtypeid = tstRecTyp.id);
                    insert tstTask5;
                 
                    }
                catch(Exception e)
                    {
                            
                    }
                Test.stopTest();
                }
                 
    }
}