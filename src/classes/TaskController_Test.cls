/**
 * Created by Meiying Liang on 12/7/2019.
 */

@IsTest
private class TaskController_Test {
    private final static String BENDIXKING = 'BendixKing';
    private final static String AMERICAS = 'Americas';
    private final static String AMERICA = 'America';
    private final static String ACS_LABS = 'ACS Labs';
    private final static String NULL_POINTER_EXCEPTION = 'Attempt to de-reference a null object';
    private final static String RESTRICTED = 'Restricted';
    private final static String PROSPECTING = 'Prospecting';
    private final static String MPM_SIM_LICENSING = 'M&PM SIM Licensing';
    private final static String PRODUCT_TESTING = 'Product Testing';
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

        contact = new TestContactBuilder().generate();
        userOne = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();
        Product2 product = new TestProductBuilder()
                .addField( 'CanUseRevenueSchedule', true )
                .generate();
        PricebookEntry standardPricebookEntry = new PriceBookEntry(
                Pricebook2Id = System.Test.getStandardPricebookId(),
                Product2Id = product.Id,
                UnitPrice = 50
        );

        Database.insert(standardPricebookEntry);
    }

    @IsTest
    static void SaveCustomerStatusTask() {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        insert opportunity;

        Task newCustomerStatusTask = new Task(
                WhatId = opportunity.Id,
                Description = 'testDescription',
                ActivityDate = Date.newInstance(2019, 12, 24));

        System.Test.startTest();
        Task result = TaskController.saveTask(newCustomerStatusTask);
        System.Test.stopTest();
        System.assertEquals(null,result);
    }

    @IsTest
    static void SaveNextStepTask() {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        insert opportunity;

        Task newNextStepTask = new Task(
                WhatId = opportunity.Id,
                Description = 'testDescription',
                ActivityDate = Date.newInstance(2019, 12, 24));

        System.Test.startTest();
        Task result = TaskController.saveTask1(newNextStepTask);
        System.Test.stopTest();
        System.assertEquals(null,result);
    }

    @IsTest
    static void SaveGeneralTask() {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        insert opportunity;

        Task newGeneralTask = new Task(
                WhatId = opportunity.Id,
                Description = 'testDescription',
                ActivityDate = Date.newInstance(2019, 12, 24));

        System.Test.startTest();
        Task result = TaskController.saveTask2(newGeneralTask);
        System.Test.stopTest();
        System.assertEquals(null,result);
    }

    @IsTest
    static void SaveSalesActivityTask() {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        insert opportunity;

        Task newSalesActivityTask = new Task(
                WhatId = opportunity.Id,
                Description = 'testDescription',
                ActivityDate = Date.newInstance(2019, 12, 24));

        System.Test.startTest();
        Task result = TaskController.saveTask3(newSalesActivityTask);
        System.Test.stopTest();
        System.assertEquals(null,result);
    }

    @IsTest
    static void GetPriority()
    {
        List<String> priorities = TaskController.GetPriority();

        System.assertEquals(1, priorities.size());
        System.assertEquals('Normal', priorities[0]);
    }

    @IsTest
    static void GetOpportunityStage()
    {
        List<String> stages = TaskController.GetOpportunityStage();

        System.assertEquals(1, stages.size());
        System.assertEquals('In Progress', stages[0]);
    }

    @IsTest
    static void LoadTasks()
    {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        opportunity.Status__c ='TestTask';
        insert opportunity;

        List<Task> loadedTasks = TaskController.loadTasks(opportunity.Id);

        System.assertEquals(1, loadedTasks.size());
    }
}