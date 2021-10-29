/**
 * Created by Meiying Liang on 12/7/2019.
 */

@IsTest
private class createOpportunityTask_Test {
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
        createOpportunityTask controller = new createOpportunityTask(null);
        PageReference result = controller.saveTask();

        System.assertEquals(null, result);
    }

    @IsTest
    static void SaveNextStepTask() {
        createOpportunityTask controller = new createOpportunityTask(null);
        PageReference result = controller.saveTask1();

        System.assertEquals(null, result);
    }

    @IsTest
    static void SaveGeneralTask() {
        createOpportunityTask controller = new createOpportunityTask(null);
        PageReference result = controller.saveTask2();

        System.assertEquals(null, result);
    }

    @IsTest
    static void SaveSalesActivityTask() {
        createOpportunityTask controller = new createOpportunityTask(null);
        PageReference result = controller.saveTask3();

        System.assertEquals(null, result);
    }

    @IsTest
    static  void SendEmail(){
        init();

        opportunity.Opportunity_Type__c = 'Test';
        insert opportunity;

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(opportunity);
        createOpportunityTask taskController = new createOpportunityTask(sc);

        PageReference pageRef = Page.Task;
        pageRef.getParameters().put('id', String.valueOf(opportunity.Id));
        Test.setCurrentPage(pageRef);

        PageReference result = taskController.send();
        Test.stopTest();

        System.assertEquals(null, result);
    }

    @IsTest
    static  void Cancel() {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        insert opportunity;

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(opportunity);
        createOpportunityTask taskController = new createOpportunityTask(sc);

        PageReference pageRef = Page.Task;
        pageRef.getParameters().put('id', String.valueOf(opportunity.Id));
        Test.setCurrentPage(pageRef);

        PageReference result = taskController.cancel();
        Test.stopTest();

        System.assertNotEquals(null, result);
    }
}