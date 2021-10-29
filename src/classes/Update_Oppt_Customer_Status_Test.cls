/**
 * Created by Meiying Liang on 12/7/2019.
 */

@IsTest
private class Update_Oppt_Customer_Status_Test {
    private final static String BENDIXKING = 'BendixKing';
    private final static String AMERICAS = 'Americas';
    private final static String AMERICA = 'America';
    private final static String RESTRICTED = 'Restricted';

    private static Opportunity opportunity;
    private static Account acct;
    private static User userOne;
    private static OppType__c oppType;
    private static Contact contact;

    static void init() {
        acct = new TestAccountBuilder()
                .addField( 'Report_Country_Name__c', AMERICA )
                .addField( 'Region_Name__c', AMERICAS )
                .generate();
        oppType = new OppType__c( RestrictedAccount__c = acct.Id, Name = 'Test' );
        insert oppType;
        opportunity = new TestOpportunityBuilder( 'Test', BENDIXKING )
                .addField( 'AccountId', acct.Id )
                .addField( 'SBU__c', 'BGA' )
                .addField( 'StageName', 'Closed Won' )
                .build();

        contact = new TestContactBuilder()
                .addField( 'AccountId', acct.Id )
                .generate();
        userOne = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();
    }

    @IsTest
    static void InsertNewOpportunityWithCustomerStatus() {
        init();

        System.Test.startTest();
        opportunity.Opportunity_Type__c = 'Test';
        opportunity.Status__c = 'TestCustomerStatus';
        insert opportunity;
        System.Test.stopTest();

        List<Task> newCustomerStatusTasks = [Select Description From Task Where WhatId =: opportunity.Id LIMIT 1];

        System.assertEquals(1,newCustomerStatusTasks.size());
        System.assertEquals('TestCustomerStatus', newCustomerStatusTasks[0].Description);
    }

    @IsTest
    static void InsertNewOpportunityWithNextStep(){
        init();

        System.Test.startTest();
        opportunity.Opportunity_Type__c = 'Test';
        opportunity.Next_Step__c = 'TestNextStep';
        opportunity.Next_Step_Date__c = Date.newInstance(2019, 12, 24);
        insert opportunity;
        System.Test.stopTest();

        List<Task> newNextStepTasks = [Select Description, ActivityDate From Task Where WhatId =: opportunity.Id LIMIT 1];

        System.assertEquals(1, newNextStepTasks.size());
        System.assertEquals('TestNextStep', newNextStepTasks[0].Description);
        System.assertEquals(Date.newInstance(2019, 12, 24), newNextStepTasks[0].ActivityDate);
    }

    @IsTest
    static void UpdateOpportunityWithCustomerStatus() {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        opportunity.Status__c = 'TestCustomerStatus';
        insert opportunity;

        System.Test.startTest();
        opportunity.Status__c = 'UpdatedTestCustomerStatus';
        update opportunity;

        System.Test.stopTest();

        List<Task> newCustomerStatusTasks = [Select Description From Task Where WhatId =: opportunity.Id ORDER By CreatedDate DESC LIMIT 1];

        System.assertEquals(1,newCustomerStatusTasks.size());
        System.assertEquals('UpdatedTestCustomerStatus', newCustomerStatusTasks[0].Description);
    }

    @IsTest
    static void UpdateOpportunityWithNextStep() {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        opportunity.Next_Step__c = 'TestNextStep';
        opportunity.Next_Step_Date__c = Date.newInstance(2019, 12, 24);
        insert opportunity;

        System.Test.startTest();
        opportunity.Next_Step__c = 'UpdatedTestNextStep';
        opportunity.Next_Step_Date__c = Date.newInstance(2019, 12, 25);
        update opportunity;

        System.Test.stopTest();

        List<Task> newNextStepTasks = [Select Description, ActivityDate From Task Where WhatId =: opportunity.Id ORDER BY CreatedDate DESC LIMIT 1];

        System.assertEquals(1,newNextStepTasks.size());
        System.assertEquals('UpdatedTestNextStep', newNextStepTasks[0].Description);
        System.assertEquals(Date.newInstance(2019, 12, 25), newNextStepTasks[0].ActivityDate);
    }

    @IsTest
    static void InsertNewCustomerStatusTask(){
        init();

        opportunity.Opportunity_Type__c = 'Test';
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Customer Status').getRecordTypeId();

        Task newCustomerStatusTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Customer Status',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'NewCustomerStatusTask',
                ActivityDate = null,
                CreatedDate = system.now());

        System.Test.startTest();

        insert newCustomerStatusTask;

        System.Test.stopTest();

        Opportunity updatedOpportunity = [SELECT Id,Status__c FROM Opportunity WHERE Id =:opportunity.Id LIMIT 1];

        System.assertEquals('NewCustomerStatusTask', updatedOpportunity.Status__c);
    }

    @IsTest
    static void InsertNewNextStepTask(){
        init();

        opportunity.Opportunity_Type__c = 'Test';
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Next Step').getRecordTypeId();

        Task newNextStepTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Next Step',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'NewNextStepTask',
                ActivityDate = Date.newInstance(2019, 12, 25),
                CreatedDate = system.now());

        System.Test.startTest();

        insert newNextStepTask;

        System.Test.stopTest();

        Opportunity updatedOpportunity = [SELECT Id,Next_Step__c,Next_Step_Date__c FROM Opportunity WHERE Id =:opportunity.Id LIMIT 1];

        System.assertEquals('NewNextStepTask', updatedOpportunity.Next_Step__c);
        System.assertEquals(Date.newInstance(2019, 12, 25), updatedOpportunity.Next_Step_Date__c);

    }

    @IsTest
    static void DeleteTheOnlyCustomerStatusTask()
    {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        opportunity.Status__c = 'CustomerStatusTask';
        insert opportunity;

        List<Task> customerStatusTasks = [SELECT Id From Task Where WhatId =: opportunity.Id LIMIT 1];

        System.Test.startTest();
        delete customerStatusTasks[0];
        System.Test.stopTest();

        Opportunity updatedOpportunity = [SELECT  Id, Status__c FROM Opportunity WHERE Id =: opportunity.Id LIMIT 1];

        System.assertEquals(true, String.isBlank(updatedOpportunity.Status__c));
    }

    @IsTest
    static void DeleteTheOnlyNextStepTask()
    {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        opportunity.Next_Step__c = 'NextStepTask';
        opportunity.Next_Step_Date__c = Date.newInstance(2019, 12, 24);
        insert opportunity;

        List<Task> nextStepTasks = [SELECT Id From Task Where WhatId =: opportunity.Id LIMIT 1];

        System.Test.startTest();
        delete nextStepTasks[0];
        System.Test.stopTest();

        Opportunity updatedOpportunity = [SELECT  Id, Next_Step__c, Next_Step_Date__c FROM Opportunity WHERE Id =: opportunity.Id LIMIT 1];

        System.assertEquals(true, String.isBlank(updatedOpportunity.Next_Step__c));
        System.assertEquals(null, updatedOpportunity.Next_Step_Date__c);
    }

    @IsTest
    static void DeleteTheOnlyLogVirtualMeetingTask()
    {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        opportunity.Log_Virtual_Meeting__c = 'LogVirtualMeetingTask';
        opportunity.Log_Virtual_Meeting_Date__c = Date.newInstance(2019, 12, 24);
        insert opportunity;

        List<Task> logVirtualMeetingTasks = [SELECT Id From Task Where WhatId =: opportunity.Id LIMIT 1];

        System.Test.startTest();
        delete logVirtualMeetingTasks[0];
        System.Test.stopTest();

        Opportunity updatedOpportunity = [SELECT  Id, Log_Virtual_Meeting__c, Log_Virtual_Meeting_Date__c FROM Opportunity WHERE Id =: opportunity.Id LIMIT 1];

        System.assertEquals(true, String.isBlank(updatedOpportunity.Log_Virtual_Meeting__c));
        System.assertEquals(null, updatedOpportunity.Log_Virtual_Meeting_Date__c);
    }

    @IsTest
    static void DeleteTheOnlyLogF2FMeetingTask()
    {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        opportunity.Log_F2F_Meeting__c = 'LogF2FMeetingTask';
        opportunity.Log_F2F_Meeting_Date__c = Date.newInstance(2019, 12, 24);
        insert opportunity;

        List<Task> logF2FMeetingTasks = [SELECT Id From Task Where WhatId =: opportunity.Id LIMIT 1];

        System.Test.startTest();
        delete logF2FMeetingTasks[0];
        System.Test.stopTest();

        Opportunity updatedOpportunity = [SELECT  Id, Log_F2F_Meeting__c, Log_F2F_Meeting_Date__c FROM Opportunity WHERE Id =: opportunity.Id LIMIT 1];

        System.assertEquals(true, String.isBlank(updatedOpportunity.Log_F2F_Meeting__c));
        System.assertEquals(null, updatedOpportunity.Log_F2F_Meeting_Date__c);
    }

    @IsTest
    static void DeleteLatestCustomerStatusTask()
    {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        opportunity.Status__c = 'FirstCustomerStatusTask';
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Customer Status').getRecordTypeId();

        Task newCustomerStatusTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Customer Status',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'SecondCustomerStatusTask',
                ActivityDate = null,
                CreatedDate = system.now());

        insert newCustomerStatusTask;

        List<Task> customerStatusTasks = [SELECT Id From Task Where WhatId =: opportunity.Id ORDER BY CreatedDate DESC LIMIT 1];

        System.Test.startTest();
        delete customerStatusTasks[0];
        System.Test.stopTest();

        Opportunity updatedOpportunity = [SELECT  Id, Status__c FROM Opportunity WHERE Id =: opportunity.Id LIMIT 1];

        System.assertEquals('FirstCustomerStatusTask', updatedOpportunity.Status__c);
    }

    @IsTest
    static void DeleteLatestNextStepTask()
    {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        opportunity.Next_Step__c = 'FirstNextStepTask';
        opportunity.Next_Step_Date__c = Date.newInstance(2019, 12, 24);
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Next Step').getRecordTypeId();

        Task newNextStepTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Next Step',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'SecondNextStepTask',
                ActivityDate = Date.newInstance(2019, 12, 25),
                CreatedDate = system.now());

        insert newNextStepTask;

        List<Task> nextStepTasks = [SELECT Id From Task Where WhatId =: opportunity.Id ORDER BY CreatedDate DESC LIMIT 1];

        System.Test.startTest();
        delete nextStepTasks[0];
        System.Test.stopTest();

        Opportunity updatedOpportunity = [SELECT Id, Next_Step__c, Next_Step_Date__c FROM Opportunity WHERE Id =: opportunity.Id LIMIT 1];


        System.assertEquals('FirstNextStepTask', updatedOpportunity.Next_Step__c);
        System.assertEquals(Date.newInstance(2019, 12, 24), updatedOpportunity.Next_Step_Date__c);
    }

    @IsTest
    static void DeleteLatestLogVirtualMeetingTask()
    {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        opportunity.Log_Virtual_Meeting__c = 'FirstLogVirtualMeetingTask';
        opportunity.Log_Virtual_Meeting_Date__c = Date.newInstance(2019, 12, 24);
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Log Virtual Meeting').getRecordTypeId();

        Task newLogVirtualMeetingTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Log Virtual Meeting',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'SecondLogVirtualMeetingTask',
                ActivityDate = Date.newInstance(2019, 12, 25),
                Activity_Date__c = Date.newInstance(2019, 12, 25),
                CreatedDate = system.now());

        insert newLogVirtualMeetingTask;

        List<Task> logVirtualMeetingTasks = [SELECT Id From Task Where WhatId =: opportunity.Id ORDER BY CreatedDate DESC LIMIT 1];

        System.Test.startTest();
        delete logVirtualMeetingTasks[0];
        System.Test.stopTest();

        Opportunity updatedOpportunity = [SELECT Id, Log_Virtual_Meeting__c, Log_Virtual_Meeting_Date__c FROM Opportunity WHERE Id =: opportunity.Id LIMIT 1];


        System.assertEquals('FirstLogVirtualMeetingTask', updatedOpportunity.Log_Virtual_Meeting__c);
        System.assertEquals(Date.newInstance(2019, 12, 24), updatedOpportunity.Log_Virtual_Meeting_Date__c);
    }

    @IsTest
    static void DeleteLatestLogF2FMeetingTask()
    {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        opportunity.Log_F2F_Meeting__c = 'FirstLogF2FMeetingTask';
        opportunity.Log_F2F_Meeting_Date__c = Date.newInstance(2019, 12, 24);
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Log F2F Meeting').getRecordTypeId();

        Task newLogF2FMeetingTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Log F2F Meeting',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'SecondLogF2FMeetingTask',
                ActivityDate = Date.newInstance(2019, 12, 25),
                Activity_Date__c = Date.newInstance(2019, 12, 25),
                CreatedDate = system.now());

        insert newLogF2FMeetingTask;

        List<Task> logF2FMeetingTasks = [SELECT Id From Task Where WhatId =: opportunity.Id ORDER BY CreatedDate DESC LIMIT 1];

        System.Test.startTest();
        delete logF2FMeetingTasks[0];
        System.Test.stopTest();

        Opportunity updatedOpportunity = [SELECT Id, Log_F2F_Meeting__c, Log_F2F_Meeting_Date__c FROM Opportunity WHERE Id =: opportunity.Id LIMIT 1];


        System.assertEquals('FirstLogF2FMeetingTask', updatedOpportunity.Log_F2F_Meeting__c);
        System.assertEquals(Date.newInstance(2019, 12, 24), updatedOpportunity.Log_F2F_Meeting_Date__c);
    }

    @IsTest
    static void InsertNullDateForNewNextStepTaskFromTactAI()
    {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Next Step').getRecordTypeId();

        Task newNextStepTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Next Step',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'NewNextStepTask',
                ActivityDate = null,
                Source__c = 'TACT AI',
                CreatedDate = system.now());

        System.Test.startTest();

        insert newNextStepTask;

        System.Test.stopTest();

        Task insertedTask = [SELECT ActivityDate,Activity_Date__c FROM Task WHERE Id =:newNextStepTask.Id LIMIT 1];

        System.assertEquals(insertedTask.ActivityDate, date.today());
        System.assertEquals(insertedTask.Activity_Date__c, date.today());
    }

    @IsTest
    static void InsertDateForNewNextStepTaskFromTactAI()
    {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Next Step').getRecordTypeId();

        Task newNextStepTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Next Step',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'NewNextStepTask',
                ActivityDate = Date.newInstance(2019, 12, 25),
                Source__c = 'TACT AI',
                CreatedDate = system.now());

        System.Test.startTest();

        insert newNextStepTask;

        System.Test.stopTest();

        Task insertedTask = [SELECT ActivityDate,Activity_Date__c FROM Task WHERE Id =:newNextStepTask.Id LIMIT 1];

        System.assertEquals(insertedTask.Activity_Date__c, Date.newInstance(2019, 12, 25));
    }

    @IsTest
    static void CloneCustomerStatusTaskForLogF2F_FromTactAI()
    {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Log_F2F').getRecordTypeId();

        Task newLogF2FTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Customer Status',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'ClonedTask',
                //ActivityDate = Date.newInstance(2019, 12, 25),
                //Activity_Date__c = Date.newInstance(2019, 12, 25),
                Source__c = 'TACT AI',
                Type__c = 'Customer Status',
                CreatedDate = system.now());

        System.Test.startTest();

        insert newLogF2FTask;

        System.Test.stopTest();

        //System.assertEquals(insertedTask.size(),2);
    }

    @IsTest
    static void CloneLogMeetingTaskForCustomerStatus_FromTactAI()
    {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Customer_Status').getRecordTypeId();

        Task newCustomerStatusTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Customer Status',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'ClonedTask',
                ActivityDate = Date.newInstance(2019, 12, 25),
                Activity_Date__c = Date.newInstance(2019, 12, 25),
                Source__c = 'TACT AI',
                Type__c = 'Log Virtual Meeting',
                CreatedDate = system.now());

        System.Test.startTest();

        insert newCustomerStatusTask;

        System.Test.stopTest();

        List<Task> insertedTask = [SELECT ActivityDate,Activity_Date__c FROM Task WHERE WhatId =: opportunity.Id And Activity_Date__c < YESTERDAY];

        System.assertEquals(insertedTask.size(),2);
    }

    @IsTest
    static void CloneLogCallTaskForCustomerStatus_FromTactAI()
    {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Customer_Status').getRecordTypeId();

        Task newCusotmerStatusTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Customer Status',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'ClonedTask',
                ActivityDate = Date.newInstance(2019, 12, 25),
                Source__c = 'TACT AI',
                Type__c = 'Log Call',
                CreatedDate = system.now());

        System.Test.startTest();

        insert newCusotmerStatusTask;

        System.Test.stopTest();

        List<Task> insertedTask = [SELECT ActivityDate,Activity_Date__c FROM Task WHERE WhatId =: opportunity.Id];

        System.assertEquals(insertedTask.size(),2);
    }

    @IsTest
    static void CloneLogF2FMeetingTaskForCustomerStatus_FromTactAI()
    {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Customer_Status').getRecordTypeId();

        Task newCustomerStatusTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Log F2F Meeting',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'ClonedTask',
                ActivityDate = Date.newInstance(2019, 12, 25),
                Activity_Date__c = Date.newInstance(2019, 12, 25),
                Source__c = 'TACT AI',
                Type__c = 'Log F2F Meeting',
                CreatedDate = system.now());

        System.Test.startTest();

        insert newCustomerStatusTask;

        System.Test.stopTest();

        List<Task> insertedTask = [SELECT ActivityDate,Activity_Date__c FROM Task WHERE WhatId =: opportunity.Id And Activity_Date__c < YESTERDAY];

        System.assertEquals(insertedTask.size(),2);
    }

}