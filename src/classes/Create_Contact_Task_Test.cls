/**
 * Created by Meiying Liang on 5/13/2020.
 */

@IsTest
private class Create_Contact_Task_Test {
    private final static String AMERICAS = 'Americas';
    private final static String AMERICA = 'America';

    private static Contact contact;
    private static Account acct;

    static void init() {
        acct = new TestAccountBuilder()
            .addField( 'Report_Country_Name__c', AMERICA )
            .addField( 'Region_Name__c', AMERICAS )
            .generate();

        contact = new TestContactBuilder()
                .addField('AccountId', acct.Id)
                .generate();
    }

    @IsTest
    static void InsertNewCustomerStatus() {
        init();

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Customer Status').getRecordTypeId();

        System.Test.startTest();

        Task newCustomerStatusTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Customer Status',
                WhoId =  contact.id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'NewCustomerStatusTask',
                ActivityDate = null,
                CreatedDate = system.now());

        insert newCustomerStatusTask;

        System.Test.stopTest();

        Task result = [Select ActivityDate,Activity_Date__c From Task Where WhoId =: contact.id Limit 1];

        System.assertEquals(date.today(), result.ActivityDate);
        System.assertEquals(date.today(), result.Activity_Date__c);

    }

    @IsTest
    static void InsertNewNextStepWithout_ActivityDate() {
        init();

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Next Step').getRecordTypeId();

        System.Test.startTest();

        Task newNextStepTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Next Step',
                WhoId =  contact.id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'NewNextStepTask',
                CreatedDate = system.now());

        insert newNextStepTask;

        System.Test.stopTest();

        Task result = [Select ActivityDate,Activity_Date__c From Task Where WhoId =: contact.id Limit 1];

        System.assertEquals(date.today(), result.ActivityDate);
        System.assertEquals(date.today(), result.Activity_Date__c);
    }

    @IsTest
    static void InsertNewNextStepWith_ActivityDate() {
        init();

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Next Step').getRecordTypeId();

        System.Test.startTest();

        Task newNextStepTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Next Step',
                WhoId =  contact.id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'NewNextStepTask',
                ActivityDate = Date.newInstance(2013, 12, 3),
                CreatedDate = system.now());

        insert newNextStepTask;

        System.Test.stopTest();

        Task result = [Select ActivityDate,Activity_Date__c From Task Where WhoId =: contact.id Limit 1];

        System.assertEquals(Date.newInstance(2013, 12, 3), result.ActivityDate);
        System.assertEquals(Date.newInstance(2013, 12, 3), result.Activity_Date__c);
    }

    @IsTest
    static void InsertNewLogF2FMeetingWithout_Activity_Date_c() {
        init();

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Log F2F Meeting').getRecordTypeId();

        System.Test.startTest();

        Task newLogF2FMeetingTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Log F2F Meeting',
                WhoId =  contact.id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'NewLogF2FMeetingTask',
                CreatedDate = system.now());

        insert newLogF2FMeetingTask;

        System.Test.stopTest();

        Task result = [Select ActivityDate,Activity_Date__c From Task Where WhoId =: contact.id Limit 1];

        System.assertEquals(date.today(), result.ActivityDate);
        System.assertEquals(date.today(), result.Activity_Date__c);
    }

    @IsTest
    static void InsertNewLogF2FMeetingWith_Activity_Date_c() {
        init();

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Log F2F Meeting').getRecordTypeId();

        System.Test.startTest();

        Task newLogF2FMeetingTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Log F2F Meeting',
                WhoId =  contact.id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'NewLogF2FMeetingTask',
                Activity_Date__c = Date.newInstance(2013, 12, 3),
                CreatedDate = system.now());

        insert newLogF2FMeetingTask;

        System.Test.stopTest();

        Task result = [Select ActivityDate,Activity_Date__c From Task Where WhoId =: contact.id Limit 1];

        System.assertEquals(Date.newInstance(2013, 12, 3), result.ActivityDate);
        System.assertEquals(Date.newInstance(2013, 12, 3), result.Activity_Date__c);
    }
}