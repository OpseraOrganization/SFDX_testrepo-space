/**
 * Created by Satya Mohanty on 11/18/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
public class Test_TaskController_oppty {
    public static testMethod void testStandardUserwithTask(){
        test.startTest();
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(FirstName='check',LastName = 'Test UserCSO',Username = 'tu1cso123@test.com',Email = 'testuser123@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='E147567');
        insert usr;

        Account objAccount = new Account();
        objAccount.Name = 'Test';
        Insert objAccount;

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
        t.Description ='Test';
        insert t;
        TaskController.loadTasks(objOpporunity.Id);
        TaskController.GetPriority();
        TaskController.GetOpportunityStage();
        TaskController.saveTask(t);
        //TaskController.saveTask1(t);
        //TaskController.saveTask2(t);
        //TaskController.saveTask3(t);
        test.stopTest();
    }
    public static testMethod void testStandardUserwithTask1(){
        test.startTest();
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(FirstName='check',LastName = 'Test UserCSO',Username = 'tu1cso123@test.com',Email = 'testuser123@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='E147567');
        insert usr;

        Account objAccount = new Account();
        objAccount.Name = 'Test';
        Insert objAccount;

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
        t.Description ='Test';
        insert t;
        TaskController.loadTasks(objOpporunity.Id);
        TaskController.GetPriority();
        TaskController.GetOpportunityStage();
        //TaskController.saveTask(t);
        TaskController.saveTask1(t);
        //TaskController.saveTask2(t);
        //TaskController.saveTask3(t);
        test.stopTest();
    }
    public static testMethod void testStandardUserwithTask2(){
        test.startTest();
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(FirstName='check',LastName = 'Test UserCSO',Username = 'tu1cso123@test.com',Email = 'testuser123@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='E147567');
        insert usr;

        Account objAccount = new Account();
        objAccount.Name = 'Test';
        Insert objAccount;

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
        t.Description ='Test';
        insert t;
        TaskController.loadTasks(objOpporunity.Id);
        TaskController.GetPriority();
        TaskController.GetOpportunityStage();
        //TaskController.saveTask(t);
        //TaskController.saveTask1(t);
        TaskController.saveTask2(t);
        //TaskController.saveTask3(t);
        test.stopTest();
    }
    public static testMethod void testStandardUserwithTask3(){
        test.startTest();
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(FirstName='check',LastName = 'Test UserCSO',Username = 'tu1cso123@test.com',Email = 'testuser123@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',EmployeeNumber='E147567');
        insert usr;

        Account objAccount = new Account();
        objAccount.Name = 'Test';
        Insert objAccount;

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
        t.Description ='Test';
        insert t;
        TaskController.loadTasks(objOpporunity.Id);
        TaskController.GetPriority();
        TaskController.GetOpportunityStage();
        //TaskController.saveTask(t);
        //TaskController.saveTask1(t);
        //TaskController.saveTask2(t);
        TaskController.saveTask3(t);
        test.stopTest();
    }
}