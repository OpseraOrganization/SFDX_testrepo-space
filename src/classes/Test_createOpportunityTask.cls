/**
 * Created by Satya Mohanty on 11/18/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@isTest
private  class Test_createOpportunityTask{

    public static testMethod void testStandardUserwithTask(){
        test.startTest();
        PageReference pageRef = page.task;
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        Insert objAccount;

        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(FirstName='check',LastName = 'Test UserCSO',Username = 'tu1cso123@test.com',Email = 'testuser123@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='E147567');
        insert usr;

        Opportunity objOpporunity = new Opportunity();
        objOpporunity.Name = 'Test Opporutnity';
        objOpporunity.AccountId = objAccount.Id;
        objOpporunity.StageName = 'Closed Won';
        objOpporunity.CloseDate = system.Today();
        objOpporunity.Win_Loss_Reason_Text__c = 'Test';
        objOpporunity.Win_Loss_Reason_Code__c='Best Value Solution';
        //objOpporunity.RecordTypeId = '01230000000bN7lAAE';

        Insert objOpporunity;

        Task t = new Task();
        t.whatId = objOpporunity.Id;
        t.OwnerId = usr.id;
        t.Subject='Customer status';
        t.Status='Not Started';
        t.Priority='Normal';

        insert t;
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', objOpporunity.Id);
        ApexPages.StandardController sc = new ApexPages.standardController(objOpporunity);
        createOpportunityTask cpt = new createOpportunityTask(sc);
        cpt.saveTask();
        //cpt.saveTask1();
        //cpt.saveTask2();
        //cpt.saveTask3();
        cpt.send();
        cpt.cancel();
        Test.stopTest();
    }
    public static testMethod void testStandardUserwithTask1(){
        test.startTest();
        PageReference pageRef = page.task;
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        Insert objAccount;

        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(FirstName='check',LastName = 'Test UserCSO',Username = 'tu1cso123@test.com',Email = 'testuser123@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='E147567');
        insert usr;

        Opportunity objOpporunity = new Opportunity();
        objOpporunity.Name = 'Test Opporutnity';
        objOpporunity.AccountId = objAccount.Id;
        objOpporunity.StageName = 'Closed Won';
        objOpporunity.CloseDate = system.Today();
        objOpporunity.Win_Loss_Reason_Text__c = 'Test';
        objOpporunity.Win_Loss_Reason_Code__c='Best Value Solution';
        //objOpporunity.RecordTypeId = '01230000000bN7lAAE';

        Insert objOpporunity;

        Task t = new Task();
        t.whatId = objOpporunity.Id;
        t.OwnerId = usr.id;
        t.Subject='Customer status';
        t.Status='Not Started';
        t.Priority='Normal';

        insert t;
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', objOpporunity.Id);
        ApexPages.StandardController sc = new ApexPages.standardController(objOpporunity);
        createOpportunityTask cpt = new createOpportunityTask(sc);
        //cpt.saveTask();
        cpt.saveTask1();
        //cpt.saveTask2();
        //cpt.saveTask3();
        cpt.send();
        cpt.cancel();
        Test.stopTest();
    }
    public static testMethod void testStandardUserwithTask2(){
        test.startTest();
        PageReference pageRef = page.task;
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        Insert objAccount;

        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(FirstName='check',LastName = 'Test UserCSO',Username = 'tu1cso123@test.com',Email = 'testuser123@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='E147567');
        insert usr;

        Opportunity objOpporunity = new Opportunity();
        objOpporunity.Name = 'Test Opporutnity';
        objOpporunity.AccountId = objAccount.Id;
        objOpporunity.StageName = 'Closed Won';
        objOpporunity.CloseDate = system.Today();
        objOpporunity.Win_Loss_Reason_Text__c = 'Test';
        objOpporunity.Win_Loss_Reason_Code__c='Best Value Solution';
        //objOpporunity.RecordTypeId = '01230000000bN7lAAE';

        Insert objOpporunity;

        Task t = new Task();
        t.whatId = objOpporunity.Id;
        t.OwnerId = usr.id;
        t.Subject='Customer status';
        t.Status='Not Started';
        t.Priority='Normal';

        insert t;
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', objOpporunity.Id);
        ApexPages.StandardController sc = new ApexPages.standardController(objOpporunity);
        createOpportunityTask cpt = new createOpportunityTask(sc);
        //cpt.saveTask();
        //cpt.saveTask1();
        cpt.saveTask2();
        //cpt.saveTask3();
        cpt.send();
        cpt.cancel();
        Test.stopTest();
    }
    public static testMethod void testStandardUserwithTask3(){
        test.startTest();
        PageReference pageRef = page.task;
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        Insert objAccount;

        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(FirstName='check',LastName = 'Test UserCSO',Username = 'tu1cso123@test.com',Email = 'testuser123@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='E147567');
        insert usr;

        Opportunity objOpporunity = new Opportunity();
        objOpporunity.Name = 'Test Opporutnity';
        objOpporunity.AccountId = objAccount.Id;
        objOpporunity.StageName = 'Closed Won';
        objOpporunity.CloseDate = system.Today();
        objOpporunity.Win_Loss_Reason_Text__c = 'Test';
        objOpporunity.Win_Loss_Reason_Code__c='Best Value Solution';
        //objOpporunity.RecordTypeId = '01230000000bN7lAAE';

        Insert objOpporunity;

        Task t = new Task();
        t.whatId = objOpporunity.Id;
        t.OwnerId = usr.id;
        t.Subject='Customer status';
        t.Status='Not Started';
        t.Priority='Normal';

        insert t;
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', objOpporunity.Id);
        ApexPages.StandardController sc = new ApexPages.standardController(objOpporunity);
        createOpportunityTask cpt = new createOpportunityTask(sc);
        //cpt.saveTask();
        //cpt.saveTask1();
        //cpt.saveTask2();
        cpt.saveTask3();
        cpt.send();
        cpt.cancel();
        Test.stopTest();
    }
}