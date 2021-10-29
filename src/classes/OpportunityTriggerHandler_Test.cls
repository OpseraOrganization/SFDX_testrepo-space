/**
 * Created by Satya Mohanty on 5/2/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
private class OpportunityTriggerHandler_Test {
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

        contact = new TestContactBuilder()
                .addField('AccountId', acct.Id)
                .generate();
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
    static void testHandleExceptionBase() {
        init();

        Exception myException;
        try {
            List<Id> myList;
            myList.get( 0 );
        } catch (Exception ex) {
            myException = ex;
        }
        List<Opportunity> opps = new List<Opportunity>{new Opportunity()};
        System.Test.startTest();
        OpportunityTriggerHandler.handleException(myException,opps);
        System.Test.stopTest();

        Error_Log__c insertedErrorLog = [
                SELECT
                        Team_Name__c,
                        Description__c,
                        Object__c
                FROM Error_Log__c
                LIMIT 1
        ];

        System.assertEquals( ErrorLogBuilder.CRM_SALES, insertedErrorLog.Team_Name__c );
        System.assertEquals( true, insertedErrorLog.Description__c.contains( NULL_POINTER_EXCEPTION ) );
        System.assertEquals( OpportunityTriggerHandler.OPPORTUNITY, insertedErrorLog.Object__c );
    }
    @IsTest
    static void BI_DefaultOpportunityStage() {
        init();

        System.Test.startTest();
        opportunity.Opportunity_Type__c = 'Test';

        insert opportunity;
        System.Test.stopTest();

        Opportunity insertedopportunity = [
                SELECT
                        Id,
                        Name,
                        StageName
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        System.assertEquals( 'Prospecting', insertedopportunity.StageName );
    }
    @IsTest
    static void BI_RestrictedOpportunity() {
        init();

        System.Test.startTest();
        opportunity.Program__c = OpportunityTriggerHelper.RESTRICTED;
        opportunity.Is_Restricted_Opportunity__c = true;
        opportunity.End_User__c = acct.Id;
        insert opportunity;

        System.Test.stopTest();

        Opportunity insertedOpportunity = [
                SELECT
                        Id,
                        Name,
                        Restricted_Opportunity_Name__c,
                        Restricted_Customer_Name__c,
                        Restricted_Program_Name__c,
                        Restricted_End_User__c
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        System.assertEquals( opportunity.Name, insertedOpportunity.Restricted_Opportunity_Name__c );
        System.assertEquals( 'Testaccount', insertedOpportunity.Restricted_Customer_Name__c );
        System.assertEquals( OpportunityTriggerHelper.RESTRICTED, insertedOpportunity.Restricted_Program_Name__c );
        System.assertEquals( 'Testaccount', insertedOpportunity.Restricted_End_User__c );
    }
    @IsTest
    static void BI_ParentOpportunity() {
        init();

        Opportunity parentOpportunity = new TestOpportunityBuilder()
                .addField('SBU__c','BGA')
                .addField('Sales_Channel__c','Divest')
                .generate();

        System.Test.startTest();
        opportunity.Parent_Opportunity__c = parentOpportunity.Id;
        insert opportunity;
        System.Test.stopTest();

        Opportunity insertedOpportunity = [
                SELECT
                        Id,
                        Name,
                        Parent_Opportunity_SBU__c,
                        Parent_Opportunity_Sales_Channel__c
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        System.assertEquals(parentOpportunity.SBU__c, insertedOpportunity.Parent_Opportunity_SBU__c);
        System.assertEquals(parentOpportunity.Sales_Channel__c, insertedOpportunity.Parent_Opportunity_Sales_Channel__c);
    }
    @IsTest
    static void BU_RevenueEndDateSingleLineItemWeekly() {
        init();

        OpportunityLineItem lineItem;

        System.Test.startTest();
        userOne.Functional_Role__c = 'Data Analyst';
        update userOne;
        acct.Account_Owner__c = userOne.Id;
        update acct;

        opportunity.SBU__c = 'ATR';
        opportunity.OwnerId = new TestUserBuilder()
                .setFirstName( 'Jane' )
                .setLastName( 'Doe' )
                .generate().Id;
        insert opportunity;

        Pricebook2 pbook = new TestPricebookBuilder()
                .generate();
        Product2 product = new TestProductBuilder()
                .addField('CanUseRevenueSchedule', true)
                .generate();
        PricebookEntry standardPricebookEntry = new PriceBookEntry(
                Pricebook2Id = System.Test.getStandardPricebookId(),
                Product2Id = product.Id,
                UnitPrice = 50
        );
        Database.insert( standardPricebookEntry );
        System.Test.stopTest();
        PricebookEntry pbookEntry = new TestPricebookEntryBuilder()
                .setPricebook(pbook.Id)
                .setProduct(product.Id)
                .generate();

        lineItem = new TestOpportunityLineItemBuilder()
                .setServiceDate( Date.today() )
                .addField('Revenue_Start_Date__c',Date.today().addDays(1))
                .addField('Revenue_End_Date__c',null)
                .addField('Terms_in_Months__c', 10)
                .addField('Schedule_Type__c', 'Weekly')
                .setUnitPrice(100)
                .setQuantity(10)
                .setPricebookEntryId(pbookEntry.Id)
                .setType('Forecast')
                .setOpportunityId(opportunity.Id)
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(1))
                .setType('Revenue')
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(10))
                .setType('Revenue')
                .generate();

        lineItem.Revenue_Start_Date__c = Date.today().addDays(1);
        lineItem.Revenue_End_Date__c = Date.today().addDays(10);
        lineItem.Terms_in_Months__c = 10;
        lineItem.Schedule_Type__c = 'Weekly';
        update lineItem;



        Opportunity insertedOpportunity = [
                SELECT
                        Program_Terms__c
                FROM Opportunity
                WHERE Id = :opportunity.Id
                LIMIT 1
        ];

        System.assertEquals('1', insertedOpportunity.Program_Terms__c);
    }
    @IsTest
    static void BU_RevenueEndDateSingleLineItemNoDate() {
        init();

        OpportunityLineItem lineItem;

        System.Test.startTest();
        userOne.Functional_Role__c = 'Data Analyst';
        update userOne;
        acct.Account_Owner__c = userOne.Id;
        update acct;

        opportunity.SBU__c = 'ATR';
        opportunity.OwnerId = new TestUserBuilder()
                .setFirstName( 'Jane' )
                .setLastName( 'Doe' )
                .generate().Id;
        insert opportunity;
        System.Test.stopTest();
        Pricebook2 pbook = new TestPricebookBuilder()
                .generate();
        Product2 product = new TestProductBuilder()
                .addField('CanUseRevenueSchedule', true)
                .generate();
        PricebookEntry standardPricebookEntry = new PriceBookEntry(
                Pricebook2Id = System.Test.getStandardPricebookId(),
                Product2Id = product.Id,
                UnitPrice = 50
        );
        Database.insert( standardPricebookEntry );

        PricebookEntry pbookEntry = new TestPricebookEntryBuilder()
                .setPricebook(pbook.Id)
                .setProduct(product.Id)
                .generate();

        lineItem = new TestOpportunityLineItemBuilder()
                .setServiceDate( Date.today() )
                .addField('Revenue_End_Date__c',Date.today().addDays(10))
                .addField('Revenue_Start_Date__c',Date.today())
                .addField('Terms_in_Months__c', 10)
                .addField('Schedule_Type__c', 'Weekly')
                .setUnitPrice(100)
                .setQuantity(10)
                .setPricebookEntryId(pbookEntry.Id)
                .setType('Forecast')
                .setOpportunityId(opportunity.Id)
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(1))
                .setType('Revenue')
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(10))
                .setType('Revenue')
                .generate();


        Opportunity insertedOpportunity = [
                SELECT
                        Program_Terms__c
                FROM Opportunity
                WHERE Id = :opportunity.Id
                LIMIT 1
        ];

        System.assertEquals('1', insertedOpportunity.Program_Terms__c);
    }
    /*
    @IsTest
    static void BU_RevenueEndDateMultipleLineItemsYearly() {
        init();

        OpportunityLineItem lineItem;
        OpportunityLineItem lineItemLongerTerm;

        System.Test.startTest();
        userOne.Functional_Role__c = 'Data Analyst';
        update userOne;
        acct.Account_Owner__c = userOne.Id;
        update acct;

        opportunity.SBU__c = 'ATR';
        opportunity.OwnerId = new TestUserBuilder()
                .setFirstName( 'Jane' )
                .setLastName( 'Doe' )
                .generate().Id;
        insert opportunity;

        Pricebook2 pbook = new TestPricebookBuilder()
                .generate();
        Product2 product = new TestProductBuilder()
                .addField('CanUseRevenueSchedule', true)
                .generate();
        Product2 productTwo = new TestProductBuilder()
                .addField('CanUseRevenueSchedule', true)
                .generate();
        PricebookEntry standardPricebookEntry = new PriceBookEntry(
                Pricebook2Id = System.Test.getStandardPricebookId(),
                Product2Id = product.Id,
                UnitPrice = 50
        );
        PricebookEntry standardPricebookEntryTwo = new PriceBookEntry(
                Pricebook2Id = System.Test.getStandardPricebookId(),
                Product2Id = productTwo.Id,
                UnitPrice = 100
        );
        Database.insert(standardPricebookEntry);
        Database.insert(standardPricebookEntryTwo);

        PricebookEntry pbookEntry = new TestPricebookEntryBuilder()
                .setPricebook(pbook.Id)
                .setProduct(product.Id)
                .generate();

        PricebookEntry pbookEntryTwo = new TestPricebookEntryBuilder()
                .setPricebook(pbook.Id)
                .setProduct(productTwo.Id)
                .generate();

        lineItem = new TestOpportunityLineItemBuilder()
                .setServiceDate( Date.today() )
                .addField('Revenue_End_Date__c',Date.today().addDays(10))
                .addField('Revenue_Start_Date__c',Date.today().addDays(1))
                .addField('Terms_in_Months__c', 10)
                .setUnitPrice(100)
                .setQuantity(10)
                .setPricebookEntryId(pbookEntry.Id)
                .setType('Forecast')
                .setOpportunityId(opportunity.Id)
                .generate();

        lineItemLongerTerm = new TestOpportunityLineItemBuilder()
                .setServiceDate( Date.today() )
                .addField('Revenue_End_Date__c',Date.today().addYears(3))
                .addField('Revenue_Start_Date__c',Date.today().addDays(1))
                .addField('Terms_in_Months__c', 20)
                .addField('Schedule_Type__c', 'Yearly')
                .setUnitPrice(100)
                .setQuantity(10)
                .setPricebookEntryId(pbookEntryTwo.Id)
                .setType('Forecast')
                .setOpportunityId(opportunity.Id)
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(1))
                .setType('Revenue')
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(10))
                .setType('Revenue')
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItemLongerTerm.Id)
                .setScheduledDate(Date.today().addYears(3))
                .setType('Revenue')
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItemLongerTerm.Id)
                .setScheduledDate(Date.today().addDays(1))
                .setType('Revenue')
                .generate();
        System.Test.stopTest();

        Opportunity insertedOpportunity = [
                SELECT
                        Program_Terms__c
                FROM Opportunity
                WHERE Id = :opportunity.Id
                LIMIT 1
        ];

        System.assertEquals('3', insertedOpportunity.Program_Terms__c);
    }
    */
    /*
    @IsTest
    static void BU_RevenueEndDateMultipleLineItemsWeekly() {
        init();

        OpportunityLineItem lineItem;
        OpportunityLineItem lineItemLongerTerm;

        System.Test.startTest();
        userOne.Functional_Role__c = 'Data Analyst';
        update userOne;
        acct.Account_Owner__c = userOne.Id;
        update acct;

        opportunity.SBU__c = 'ATR';
        opportunity.OwnerId = new TestUserBuilder()
                .setFirstName( 'Jane' )
                .setLastName( 'Doe' )
                .generate().Id;
        insert opportunity;

        Pricebook2 pbook = new TestPricebookBuilder()
                .generate();
        Product2 product = new TestProductBuilder()
                .addField('CanUseRevenueSchedule', true)
                .generate();
        Product2 productTwo = new TestProductBuilder()
                .addField('CanUseRevenueSchedule', true)
                .generate();
        PricebookEntry standardPricebookEntry = new PriceBookEntry(
                Pricebook2Id = System.Test.getStandardPricebookId(),
                Product2Id = product.Id,
                UnitPrice = 50
        );
        PricebookEntry standardPricebookEntryTwo = new PriceBookEntry(
                Pricebook2Id = System.Test.getStandardPricebookId(),
                Product2Id = productTwo.Id,
                UnitPrice = 100
        );
        Database.insert(standardPricebookEntry);
        Database.insert(standardPricebookEntryTwo);

        PricebookEntry pbookEntry = new TestPricebookEntryBuilder()
                .setPricebook(pbook.Id)
                .setProduct(product.Id)
                .generate();

        PricebookEntry pbookEntryTwo = new TestPricebookEntryBuilder()
                .setPricebook(pbook.Id)
                .setProduct(productTwo.Id)
                .generate();

        lineItem = new TestOpportunityLineItemBuilder()
                .setServiceDate( Date.today() )
                .addField('Revenue_End_Date__c',Date.today().addDays(10))
                .addField('Revenue_Start_Date__c',Date.today().addDays(1))
                .addField('Terms_in_Months__c', 10)
                .setUnitPrice(100)
                .setQuantity(10)
                .setPricebookEntryId(pbookEntry.Id)
                .setType('Forecast')
                .setOpportunityId(opportunity.Id)
                .generate();

        lineItemLongerTerm = new TestOpportunityLineItemBuilder()
                .setServiceDate( Date.today() )
                .addField('Revenue_End_Date__c',Date.today().addYears(3))
                .addField('Revenue_Start_Date__c',Date.today().addDays(1))
                .addField('Terms_in_Months__c', 20)
                .addField('Schedule_Type__c', 'Weekly')
                .setUnitPrice(100)
                .setQuantity(10)
                .setPricebookEntryId(pbookEntryTwo.Id)
                .setType('Forecast')
                .setOpportunityId(opportunity.Id)
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(1))
                .setType('Revenue')
                .generate();
        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(10))
                .setType('Revenue')
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItemLongerTerm.Id)
                .setScheduledDate(Date.today().addYears(3))
                .setType('Revenue')
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItemLongerTerm.Id)
                .setScheduledDate(Date.today().addDays(1))
                .setType('Revenue')
                .generate();
        System.Test.stopTest();

        Opportunity insertedOpportunity = [
                SELECT
                        Program_Terms__c
                FROM Opportunity
                WHERE Id = :opportunity.Id
                LIMIT 1
        ];

        System.assertEquals('3', insertedOpportunity.Program_Terms__c);
    }
     */

    @IsTest
    static void BU_RevenueEndDateError() {

        init();

        OpportunityLineItem lineItem;

        System.Test.startTest();
        userOne.Functional_Role__c = 'Data Analyst';
        update userOne;
        acct.Account_Owner__c = userOne.Id;
        update acct;

        opportunity.SBU__c = 'ATR';
        opportunity.OwnerId = new TestUserBuilder()
                .setFirstName( 'Jane' )
                .setLastName( 'Doe' )
                .generate().Id;
        insert opportunity;

        Pricebook2 pbook = new TestPricebookBuilder()
                .generate();
        Product2 product = new TestProductBuilder()
                .addField('CanUseRevenueSchedule', true)
                .generate();
        PricebookEntry standardPricebookEntry = new PriceBookEntry(
                Pricebook2Id = System.Test.getStandardPricebookId(),
                Product2Id = product.Id,
                UnitPrice = 50
        );
        Database.insert( standardPricebookEntry );
        System.Test.stopTest();
        PricebookEntry pbookEntry = new TestPricebookEntryBuilder()
                .setPricebook(pbook.Id)
                .setProduct(product.Id)
                .generate();

        lineItem = new TestOpportunityLineItemBuilder()
                .setServiceDate( Date.today() )
                .addField('Revenue_End_Date__c',Date.today().addDays(10))
                .addField('Revenue_Start_Date__c',Date.today().addDays(1))
                .addField('Terms_in_Months__c', 10)
                .addField('Schedule_Type__c', 'Weekly')
                .setUnitPrice(100)
                .setQuantity(10)
                .setPricebookEntryId(pbookEntry.Id)
                .setType('Forecast')
                .setOpportunityId(opportunity.Id)
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(10))
                .setType('Revenue')
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(1))
                .setType('Revenue')
                .generate();

        String exceptionMessage;
        try {
            opportunity.Program_Terms__c = '5';
            update opportunity;
        } catch (Exception ex) {
            exceptionMessage = ex.getMessage();
        }


        System.assertEquals(true, exceptionMessage.contains('You can not change Program Term. Program Term will be auto populated based on Revenue Schedule'));
    }

    @IsTest
    static void BU_RestrictedOppTrueToFalseFollowOnTrue() {
        init();

        delete oppType;

        OppType__c oppType = new OppType__c(
                D_S_Catalog_FollowOn__c=String.valueOf(TestOpportunityBuilder.getRecordType('AM_Catalog').Id),
                Catalog__c = String.valueOf(TestOpportunityBuilder.getRecordType('BendixKing').Id),
                Name = 'TestOppType' );
        insert oppType;



        System.Test.startTest();
        opportunity.Name = 'Test';
        opportunity.AccountId = acct.Id;
        opportunity.Program__c = OpportunityTriggerHelper.RESTRICTED;
        opportunity.Description = 'test Description';
        opportunity.End_User__c = acct.Id;
        opportunity.Is_Restricted_Opportunity__c = true;
        opportunity.Is_Follow_On_Opportunity__c = true;
        opportunity.RecordTypeId = oppType.D_S_Catalog_FollowOn__c;
        insert opportunity;

        opportunity.Is_Restricted_Opportunity__c = false;
        opportunity.RecordTypeId = oppType.Catalog__c;
        update opportunity;

        Opportunity updatedOpportunity = [
                SELECT
                        Name,
                        Restricted_Opportunity_Name__c,
                        Program__c,
                        End_User__c,
                        Description,
                        Restricted_Customer_Name__c,
                        Restricted_Program_Name__c,
                        AccountId,
                        Restricted_Comments_Description__c,
                        Restricted_End_User__c,
                        RecordTypeId
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];

        System.Test.stopTest();

        System.assertEquals('Test', updatedOpportunity.Name);
        System.assertEquals(acct.Id, updatedOpportunity.AccountId);
        System.assertEquals(OpportunityTriggerHelper.RESTRICTED, updatedOpportunity.Program__c);
        System.assertEquals('test Description', updatedOpportunity.Description);
        System.assertEquals(acct.Id, updatedOpportunity.End_User__c);
        System.assertEquals(null, updatedOpportunity.Restricted_Opportunity_Name__c);
        System.assertEquals(null, updatedOpportunity.Restricted_Program_Name__c);
        System.assertEquals(null, updatedOpportunity.Restricted_Comments_Description__c);
        System.assertEquals(null, updatedOpportunity.Restricted_End_User__c);
        System.assertEquals(oppType.D_S_Catalog_FollowOn__c, updatedOpportunity.RecordTypeId);
    }
//    @IsTest
//    static void BU_D_S_Competitive_Restricted_FollowOnTrue() {
//        init();
//
//        delete oppType;
//
//        OppType__c oppType = new OppType__c(
//                D_S_Competitive_Restricted_FollowOn__c=String.valueOf(TestOpportunityBuilder.getRecordType('D_S_PrePriced').Id),
//                Catalog__c = String.valueOf(TestOpportunityBuilder.getRecordType('D_S_Run_Rate').Id),
//                Name = 'TestOppType' );
//        insert oppType;
//
//        System.Test.startTest();
//        opportunity.Name = 'Test';
//        opportunity.AccountId = acct.Id;
//        opportunity.Program__c = OpportunityTriggerHelper.RESTRICTED;
//        opportunity.Description = 'test Description';
//        opportunity.End_User__c = acct.Id;
//        opportunity.Is_Restricted_Opportunity__c = false;
//        opportunity.Is_Follow_On_Opportunity__c = true;
//        insert opportunity;
//
//        opportunity.Is_Restricted_Opportunity__c = true;
//        opportunity.RecordTypeId = oppType.D_S_Competitive_Restricted_FollowOn__c;
//        update opportunity;
//
//        Opportunity updatedOpportunity = [
//                SELECT
//                        Name,
//                        Restricted_Opportunity_Name__c,
//                        Program__c,
//                        End_User__c,
//                        Description,
//                        Restricted_Customer_Name__c,
//                        Restricted_Program_Name__c,
//                        AccountId,
//                        Restricted_Comments_Description__c,
//                        Restricted_End_User__c,
//                        RecordTypeId
//                FROM Opportunity
//                WHERE Id = :opportunity.Id
//        ];
//
//        System.Test.stopTest();
//
//        System.assertEquals('Test', updatedOpportunity.Name);
//        System.assertEquals(acct.Id, updatedOpportunity.AccountId);
//        System.assertEquals(OpportunityTriggerHelper.RESTRICTED, updatedOpportunity.Program__c);
//        System.assertEquals('test Description', updatedOpportunity.Description);
//        System.assertEquals(acct.Id, updatedOpportunity.End_User__c);
//        System.assertEquals(null, updatedOpportunity.Restricted_Opportunity_Name__c);
//        System.assertEquals(null, updatedOpportunity.Restricted_Program_Name__c);
//        System.assertEquals(null, updatedOpportunity.Restricted_Comments_Description__c);
//        System.assertEquals(null, updatedOpportunity.Restricted_End_User__c);
//        System.assertEquals(oppType.D_S_Competitive_Restricted_FollowOn__c, updatedOpportunity.RecordTypeId);
//    }
    @IsTest
    static void BU_RestrictedOppTrueToFalseFollowOnFalse() {
        init();

        delete oppType;

        OppType__c oppType = new OppType__c(
                D_S_Catalog_FollowOn__c=String.valueOf(TestOpportunityBuilder.getRecordType('AM_Standard').Id),
                Catalog__c = String.valueOf(TestOpportunityBuilder.getRecordType('OpportunityBGA').Id),
                Name = 'TestOppType' );
        insert oppType;

        System.Test.startTest();
        opportunity.End_User__c = acct.Id;
        opportunity.Is_Restricted_Opportunity__c = true;
        opportunity.Is_Follow_On_Opportunity__c = false;
        //opportunity.RecordTypeId = oppType.D_S_Catalog_FollowOn__c;
        insert opportunity;

        opportunity.Is_Restricted_Opportunity__c = false;
        opportunity.RecordTypeId = oppType.D_S_Catalog_FollowOn__c;
        update opportunity;

        Opportunity updatedOpportunity = [
                SELECT
                        Name,
                        Restricted_Opportunity_Name__c,
                        Program__c,
                        End_User__c,
                        Description,
                        Restricted_Customer_Name__c,
                        Restricted_Program_Name__c,
                        AccountId,
                        Restricted_Comments_Description__c,
                        Restricted_End_User__c,
                        RecordTypeId
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];

        System.Test.stopTest();

        System.assertEquals(acct.Id, updatedOpportunity.End_User__c);
        System.assertEquals(null, updatedOpportunity.Restricted_Opportunity_Name__c);
        System.assertEquals(null, updatedOpportunity.Restricted_Program_Name__c);
        System.assertEquals(null, updatedOpportunity.Restricted_Comments_Description__c);
        System.assertEquals(null, updatedOpportunity.Restricted_End_User__c);
        System.assertEquals(oppType.Catalog__c, updatedOpportunity.RecordTypeId);
    }
    @IsTest
    static void BU_RestrictedOppFalseToTrueFollowOnTrue() {
        init();

        delete oppType;

        OppType__c oppType = new OppType__c(
                D_S_Catalog_Restricted_FollowOn__c=String.valueOf(TestOpportunityBuilder.getRecordType('AM_Complex').Id),
                Restricted_Catalog__c = String.valueOf(TestOpportunityBuilder.getRecordType('BGA_Operator').Id),
                Name = 'TestOppType' );
        insert oppType;

        System.Test.startTest();
        opportunity.Restricted_Opportunity_Name__c = 'test';
        opportunity.Is_Restricted_Opportunity__c = false;
        opportunity.Is_Follow_On_Opportunity__c = true;
        insert opportunity;

        opportunity.Is_Restricted_Opportunity__c = true;
        opportunity.RecordTypeId = oppType.Restricted_Catalog__c;
        update opportunity;

        Opportunity updatedOpportunity = [
                SELECT
                        Name,
                        Restricted_Opportunity_Name__c,
                        Program__c,
                        End_User__c,
                        Description,
                        Restricted_Customer_Name__c,
                        Restricted_Program_Name__c,
                        AccountId,
                        Restricted_Comments_Description__c,
                        Restricted_End_User__c,
                        RecordTypeId
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];

        System.Test.stopTest();

        System.assertEquals('test', updatedOpportunity.Restricted_Opportunity_Name__c);
        System.assertEquals(null, updatedOpportunity.Restricted_Program_Name__c);
        System.assertEquals(null, updatedOpportunity.Restricted_Comments_Description__c);
        System.assertEquals(null, updatedOpportunity.Restricted_End_User__c);
        System.assertEquals(oppType.D_S_Catalog_Restricted_FollowOn__c, updatedOpportunity.RecordTypeId);
    }
    @IsTest
    static void BU_RestrictedOppTrueToFalseFollowOnFalseToTrue() {
        init();

        delete oppType;

        OppType__c oppType = new OppType__c(
                D_S_Competitive_FollowOn__c=String.valueOf(TestOpportunityBuilder.getRecordType('AM_Complex').Id),
                Restricted_Complex__c = String.valueOf(TestOpportunityBuilder.getRecordType('BGA_Operator').Id),
                Name = 'TestOppType' );
        insert oppType;

        System.Test.startTest();
        opportunity.Restricted_Opportunity_Name__c = null;
        opportunity.Is_Restricted_Opportunity__c = false;
        opportunity.Is_Follow_On_Opportunity__c = true;
        insert opportunity;

        opportunity.Is_Restricted_Opportunity__c = true;
        opportunity.Is_Follow_On_Opportunity__c = false;
        opportunity.RecordTypeId = oppType.D_S_Competitive_FollowOn__c;
        update opportunity;

        Opportunity updatedOpportunity = [
                SELECT
                        Name,
                        Restricted_Opportunity_Name__c,
                        Program__c,
                        End_User__c,
                        Description,
                        Restricted_Customer_Name__c,
                        Restricted_Program_Name__c,
                        AccountId,
                        Restricted_Comments_Description__c,
                        Restricted_End_User__c,
                        RecordTypeId
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];

        System.Test.stopTest();

        System.assertEquals('Test', updatedOpportunity.Restricted_Opportunity_Name__c);
        System.assertEquals(null, updatedOpportunity.Restricted_Program_Name__c);
        System.assertEquals(null, updatedOpportunity.Restricted_Comments_Description__c);
        System.assertEquals(null, updatedOpportunity.Restricted_End_User__c);
        System.assertEquals(oppType.Restricted_Complex__c, updatedOpportunity.RecordTypeId);
    }
    @IsTest
    static void BU_RestrictedOpp1() {
        init();

        delete oppType;

        OppType__c oppType = new OppType__c(
                D_S_Catalog_FollowOn__c=String.valueOf(TestOpportunityBuilder.getRecordType('AM_Complex').Id),
                Restricted_Catalog__c = String.valueOf(TestOpportunityBuilder.getRecordType('BGA_Operator').Id),
                Name = 'TestOppType' );
        insert oppType;

        System.Test.startTest();
        opportunity.Restricted_Opportunity_Name__c = 'test';
        opportunity.Is_Restricted_Opportunity__c = false;
        opportunity.Is_Follow_On_Opportunity__c = false;
        insert opportunity;

        opportunity.Is_Restricted_Opportunity__c = true;
        opportunity.RecordTypeId = oppType.D_S_Catalog_FollowOn__c;
        update opportunity;

        Opportunity updatedOpportunity = [
                SELECT
                        Name,
                        Restricted_Opportunity_Name__c,
                        Program__c,
                        End_User__c,
                        Description,
                        Restricted_Customer_Name__c,
                        Restricted_Program_Name__c,
                        AccountId,
                        Restricted_Comments_Description__c,
                        Restricted_End_User__c,
                        RecordTypeId
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];

        System.Test.stopTest();

        System.assertEquals('test', updatedOpportunity.Restricted_Opportunity_Name__c);
        System.assertEquals(null, updatedOpportunity.Restricted_Program_Name__c);
        System.assertEquals(null, updatedOpportunity.Restricted_Comments_Description__c);
        System.assertEquals(null, updatedOpportunity.Restricted_End_User__c);
        System.assertEquals(oppType.Restricted_Catalog__c, updatedOpportunity.RecordTypeId);
    }
    @IsTest
    static void BU_Mpm_Licensing() {
        init();

        System.Test.startTest();
        RecordType recordType  = [SELECT
                Id,
                Name
        FROM RecordType
        WHERE SobjectType = 'Opportunity'
        AND DeveloperName =  'M_PM_SIM_Licensing'
        LIMIT 1
        ];
        opportunity.RecordTypeId = recordType.Id;
        insert opportunity;

        opportunity.HIPI_CONTRACT_NUMBER__c = '123';
        update opportunity;
        System.Test.stopTest();

        Opportunity insertedOpportunity = [
                SELECT
                        Request_Contract_Number__c,
                        Appendix_Review_Engineer_Name__c,
                        License_Draft__c,
                        License_Review__c,
                        Engineer_Manager_Review_Date__c,
                        Workbook_Complete__c,
                        Account_manager_review_Date__c,
                        Revenue_Recognized_Date__c,
                        Invoice_Requested_date__c
                FROM Opportunity
                WHERE Id = :opportunity.Id
                LIMIT 1
        ];

        // No need to assert all of the helper functionality from the handling of MPM as this is tested in the helper test
        // class.
        System.assertEquals( false, insertedOpportunity.Request_Contract_Number__c );
    }
    @IsTest
    static void BU_NoRfpExpectedDueDate() {
        init();

        System.Test.startTest();
        RecordType recordType  = [SELECT
                Id,
                Name
        FROM RecordType
        WHERE SobjectType = 'Opportunity'
        AND DeveloperName =  'D_S_Standard'
        LIMIT 1
        ];
        opportunity.RecordTypeId = recordType.Id;
        insert opportunity;

        User standardUser = new TestUserBuilder()
                .addField('ProfileId', [
                        SELECT Id
                        FROM Profile
                        WHERE Name = 'Developer Administrator'
                ].Id)
                .generate();

        String exceptionMessage;
        try {
            System.runAs(standardUser) {
                opportunity.RFP_Expected_Due_Date__c = null;
                opportunity.StageName = 'Launch';
                update opportunity;
            }
        }catch(Exception ex) {
            exceptionMessage = ex.getMessage();
        }
        System.Test.stopTest();

        System.assertEquals(true, exceptionMessage.contains('Please enter a value in this field.'));
    }
    @IsTest
    static void BU_NoProposalComplexityDescription() {
        init();

        System.Test.startTest();
        RecordType recordType  = [SELECT
                Id,
                Name
        FROM RecordType
        WHERE SobjectType = 'Opportunity'
        AND DeveloperName =  'D_S_Standard'
        LIMIT 1
        ];
        opportunity.RecordTypeId = recordType.Id;
        insert opportunity;

        User standardUser = new TestUserBuilder()
                .addField('ProfileId', [
                        SELECT Id
                        FROM Profile
                        WHERE Name = 'Developer Administrator'
                ].Id)
                .generate();

        String exceptionMessage;
        try {
            System.runAs(standardUser) {
                opportunity.RFP_Expected_Due_Date__c = Date.today().addDays(25);
                opportunity.Proposal_Complexity_Description__c = null;
                opportunity.Proposal_Complexity__c = 'Undetermined';
                opportunity.StageName = 'Launch';
                update opportunity;
            }
        }catch(Exception ex) {
            exceptionMessage = ex.getMessage();
        }
        System.Test.stopTest();

        System.assertEquals(true, exceptionMessage.contains('Please enter a value in this field.'));
    }
    @IsTest
    static void BU_NoCertificationRequirements() {
        init();

        System.Test.startTest();
        RecordType recordType  = [SELECT
                Id,
                Name
        FROM RecordType
        WHERE SobjectType = 'Opportunity'
        AND DeveloperName =  'D_S_Standard'
        LIMIT 1
        ];
        opportunity.RecordTypeId = recordType.Id;
        insert opportunity;

        User standardUser = new TestUserBuilder()
                .addField('ProfileId', [
                        SELECT Id
                        FROM Profile
                        WHERE Name = 'Developer Administrator'
                ].Id)
                .generate();

        String exceptionMessage;
        try {
            System.runAs(standardUser) {
                opportunity.RFP_Expected_Due_Date__c = Date.today().addDays(25);
                opportunity.Proposal_Complexity_Description__c = 'Test';
                opportunity.Proposal_Complexity__c = 'Undetermined';
                opportunity.Certification_Requirements__c = null;
                opportunity.StageName = 'Launch';
                update opportunity;
            }
        }catch(Exception ex) {
            exceptionMessage = ex.getMessage();
        }
        System.Test.stopTest();

        System.assertEquals(true, exceptionMessage.contains('Please enter a value in this field.'));
    }
    @IsTest
    static void BU_ATR_PartnerProfileId() {
        init();

        System.Test.startTest();

        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
        User accountOwner;
        System.runAs(userOne) {
            accountOwner = new TestUserBuilder()
                    .addField('UserRoleId', portalRole.Id)
                    .setFirstName('John')
                    .setLastName('Doe')
                    .generate();
        }
        acct.OwnerId = accountOwner.Id;
        update acct;

        contact.Email = 'someemail@test.com';
        contact.AccountId = acct.Id;
        update contact;

        User standardUser;
        System.runAs(userOne) {
            standardUser = new TestUserBuilder()
                    .addField('contactId', contact.Id)
                    .addField('PortalRole', 'Manager')
                    .addField('ProfileId', Label.D_S_Partner_ProfileId)
                    .generate();
        }

        String exceptionMessage;
        try {
            System.runAs(standardUser) {
                opportunity.AccountId = acct.Id;
                opportunity.SBU__c = 'ATR';
                opportunity.Pgo__c = '1';
                opportunity.PWin__c= '1';
                insert opportunity;
                system.debug('LOG 1');
                update opportunity;
                system.debug('LOG 2');
            }
        }catch(Exception ex) {
            exceptionMessage = ex.getMessage();
        }
        System.Test.stopTest();

        system.debug('exceptionMessage is ' + exceptionMessage);

        System.assertEquals(false, exceptionMessage.contains('SBU needs to be D&S'));
    }
    @IsTest
    static void AI_LicenseDraftEmail() {
        init();

        System.Test.startTest();
        contact.Email = 'someemail@test.com';
        update contact;

        opportunity.License_Draft__c = Date.today();
        RecordType recordType  = [SELECT
                Id,
                Name
        FROM RecordType
        WHERE SobjectType = 'Opportunity'
        AND DeveloperName = 'M_PM_SIM_Licensing'
        LIMIT 1
        ];
        opportunity.RecordTypeId = recordType.Id;
        opportunity.Record_Data_Owner__c = contact.Id;
        insert opportunity;
        Integer emailInvocations = Limits.getEmailInvocations();
        System.Test.stopTest();

        System.assertEquals(1, emailInvocations);
    }
    @IsTest
    static void AI_BusinessContactEmail() {
        init();

        System.Test.startTest();
        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
        User accountOwner;
        System.runAs(userOne) {
            accountOwner = new TestUserBuilder()
                    .addField('UserRoleId', portalRole.Id)
                    .setFirstName('John')
                    .setLastName('Doe')
                    .generate();
        }
        acct.OwnerId = accountOwner.Id;
        update acct;

        contact.Email = 'someemail@test.com';
        contact.AccountId = acct.Id;
        update contact;

        User standardUser;
        System.runAs(userOne) {
            standardUser = new TestUserBuilder()
                    .addField('contactId', contact.Id)
                    .addField('PortalRole', 'Manager')
                    .addField('ProfileId', Label.D_S_Partner_ProfileId)
                    .generate();
        }

        RecordType recordType = [SELECT
                Id,
                Name
        FROM RecordType
        WHERE SobjectType = 'Opportunity'
        AND DeveloperName = 'M_PM_SIM_Licensing'
        LIMIT 1
        ];
        opportunity.RecordTypeId = recordType.Id;
        opportunity.License_Draft__c = Date.today();
        opportunity.BusinessContact__c = standardUser.Id ;
        opportunity.Record_Data_Owner__c = null;
        insert opportunity;

        System.runAs(userOne) {
            EmailTemplate validEmailTemplate = new EmailTemplate();
            validEmailTemplate.IsActive = true;
            validEmailTemplate.Name = 'name';
            validEmailTemplate.DeveloperName = 'unique_name_addSomethingSpecialHere';
            validEmailTemplate.TemplateType = 'text';
            validEmailTemplate.FolderId = UserInfo.getUserId();
            validEmailTemplate.Subject = 'Your Subject Here';

            insert validEmailTemplate;
        }
        Integer emailInvocations = Limits.getEmailInvocations();
        System.Test.stopTest();

        System.assertEquals(2, emailInvocations);
    }
    @IsTest
    static void AU_LicenseDraftOldEmail() {
        init();

        System.Test.startTest();
        contact.Email = 'someemail@test.com';
        update contact;

        opportunity.License_Draft__c = Date.today().addDays(10);
        opportunity.LicenseDraft__c = true;
        RecordType recordType  = [SELECT
                Id,
                Name
        FROM RecordType
        WHERE SobjectType = 'Opportunity'
        AND DeveloperName = 'M_PM_SIM_Licensing'
        LIMIT 1
        ];
        opportunity.RecordTypeId = recordType.Id;
        opportunity.Record_Data_Owner__c = contact.Id;
        insert opportunity;

        opportunity.License_Draft__c = Date.today();
        update opportunity;

        Integer emailInvocations = Limits.getEmailInvocations();
        System.Test.stopTest();

        System.assertEquals(true, emailInvocations > 0);
    }
    @IsTest
    static void AU_BusinessContactOldEmail() {
        init();

        System.Test.startTest();
        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
        User accountOwner;
        System.runAs(userOne) {
            accountOwner = new TestUserBuilder()
                    .addField('UserRoleId', portalRole.Id)
                    .setFirstName('John')
                    .setLastName('Doe')
                    .generate();
        }
        acct.OwnerId = accountOwner.Id;
        update acct;

        contact.Email = 'someemail@test.com';
        contact.AccountId = acct.Id;
        update contact;

        User standardUser;
        System.runAs(userOne) {
            standardUser = new TestUserBuilder()
                    .addField('contactId', contact.Id)
                    .addField('PortalRole', 'Manager')
                    .addField('ProfileId', Label.D_S_Partner_ProfileId)
                    .generate();
        }

        RecordType recordType = [SELECT
                Id,
                Name
        FROM RecordType
        WHERE SobjectType = 'Opportunity'
        AND DeveloperName = 'M_PM_SIM_Licensing'
        LIMIT 1
        ];
        opportunity.RecordTypeId = recordType.Id;
        opportunity.License_Draft__c = null;
        opportunity.BusinessContact__c = standardUser.Id ;
        opportunity.Record_Data_Owner__c = null;
        opportunity.Engineer_Manager_Review__c = false;
        insert opportunity;

        system.debug('to update opportunity');
        opportunity.LicenseDraft__c = true;
        opportunity.BusinessContact__c = standardUser.Id;
        opportunity.License_Draft__c = Date.today();
        opportunity.recordTypeId = recordType.Id;
        update opportunity;
        system.debug('finished updating opportunity');

        System.runAs(userOne) {
            EmailTemplate validEmailTemplate = new EmailTemplate();
            validEmailTemplate.IsActive = true;
            validEmailTemplate.Name = 'name';
            validEmailTemplate.DeveloperName = 'unique_name_addSomethingSpecialHere';
            validEmailTemplate.TemplateType = 'text';
            validEmailTemplate.FolderId = UserInfo.getUserId();
            validEmailTemplate.Subject = 'Your Subject Here';

            insert validEmailTemplate;
        }
        Integer emailInvocations = Limits.getEmailInvocations();
        System.Test.stopTest();

        System.assertEquals(true, emailInvocations > 0);
    }
    @IsTest
    static void AU_EngineerManagerReviewDateEmail() {
        init();

        System.Test.startTest();

        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
        User accountOwner;
        System.runAs(userOne) {
            accountOwner = new TestUserBuilder()
                    .addField('UserRoleId', portalRole.Id)
                    .setFirstName('John')
                    .setLastName('Doe')
                    .generate();
        }
        acct.OwnerId = accountOwner.Id;
        update acct;

        contact.Email = 'someemail@test.com';
        contact.AccountId = acct.Id;
        update contact;

        User standardUser;
        System.runAs(userOne) {
            standardUser = new TestUserBuilder()
                    .addField('contactId', contact.Id)
                    .addField('PortalRole', 'Manager')
                    .addField('ProfileId', Label.D_S_Partner_ProfileId)
                    .addField('Email', 'someemail@test.com')
                    .generate();
        }

        RecordType recordType  = [SELECT
                Id,
                Name
        FROM RecordType
        WHERE SobjectType = 'Opportunity'
        AND DeveloperName = 'M_PM_SIM_Licensing'
        LIMIT 1
        ];
        opportunity.Engineer_Manager_Review_Date__c = Date.today().addDays(10);
        opportunity.Engineer_Manager_Review__c = true;
        opportunity.RecordTypeId = recordType.Id;
        opportunity.BusinessContact__c = standardUser.Id;
        insert opportunity;

        system.debug('standardUser.Id is ' + standardUser.Id);
        system.debug('standardUser.contactId is ' + standardUser.contactId);
        opportunity.BusinessContact__c = standardUser.Id;
        opportunity.Engineer_Manager_Review_Date__c = Date.today();
        update opportunity;

        Integer emailInvocations = Limits.getEmailInvocations();
        System.Test.stopTest();

        System.assertEquals(true, emailInvocations > 0);
    }
    @IsTest
    static void AU_CaseCreationProductList() {
        acct = new TestAccountBuilder()
                .addField( 'Report_Country_Name__c', AMERICA )
                .addField( 'Region_Name__c', AMERICAS )
                .generate();

        opportunity = new TestOpportunityBuilder( 'Test', BENDIXKING )
                .addField( 'AccountId', acct.Id )
                .addField( 'SBU__c', 'BGA' )
                .addField( 'StageName', 'Launch' )
                .generate();

        Pricebook2 pbook = new TestPricebookBuilder()
                .generate();
        Product2 product = new TestProductBuilder()
                .addField('CanUseRevenueSchedule', true)
                .generate();
        PricebookEntry standardPricebookEntry = new PriceBookEntry(
                Pricebook2Id = System.Test.getStandardPricebookId(),
                Product2Id = product.Id,
                UnitPrice = 50
        );
        Database.insert( standardPricebookEntry );

        PricebookEntry pbookEntry = new TestPricebookEntryBuilder()
                .setPricebook(pbook.Id)
                .setProduct(product.Id)
                .generate();

        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setServiceDate( Date.today() )
                .addField('Revenue_Start_Date__c',Date.today().addDays(1))
                .addField('Revenue_End_Date__c',null)
                .addField('Terms_in_Months__c', 10)
                .addField('Schedule_Type__c', 'Weekly')
                .setUnitPrice(100)
                .setQuantity(10)
                .setPricebookEntryId(pbookEntry.Id)
                .setType('Forecast')
                .setOpportunityId(opportunity.Id)
                .generate();

        System.Test.startTest();
        PO_tracker_Case_Creation_Products__c po_tracker_case = new PO_tracker_Case_Creation_Products__c();
        po_tracker_case.Product_Name_del__c = 'Test Product';
        po_tracker_case.Name = 'Test';
        insert po_tracker_case;

        opportunity.StageName = 'Closed Won';
        update opportunity;

        List<Case> insertedCases = [
                SELECT
                        Id,
                        Opportunity__c
                FROM Case
        ];

        System.Test.stopTest();

        System.assertEquals(true, insertedCases.size() > 0);
    }
    @IsTest
    static void AU_OpportunitySalesTeamOpportunityShare() {
        init();

        opportunity.OwnerId = userOne.Id;
        insert opportunity;

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .addField('Contact__c', contact.Id)
                .generate();

        User newUser = new TestUserBuilder()
                .setFirstName( 'Jane' )
                .setLastName( 'Doe' )
                .generate();

        opportunity.OwnerId = newUser.Id;
        update opportunity;

        List<OpportunityShare> opShares = [
                SELECT
                        Id,
                        UserOrGroupId
                FROM OpportunityShare
                WHERE OpportunityId = :opportunity.Id
                AND UserOrGroupId = :newUser.Id
        ];

        System.assertEquals(newUser.Id, opShares.get(0).UserOrGroupId);
    }
//    @IsTest
//    static void APAC_AM_SalesSurveyAutopopup() {
//        acct = new TestAccountBuilder()
//                .addField( 'Report_Country_Name__c', 'India' )
//                .addField( 'Region_Name__c', 'Asia/Pacific Rim' )
//                .generate();
//        opportunity = new TestOpportunityBuilder( 'Test', 'AM_Standard' )
//                .addField( 'AccountId', acct.Id )
//                .addField( 'SBU__c', 'ATR' )
//                .addField( 'StageName', 'Prospecting' )
//                .addField( 'Amount', 1200000 )
//                .generate();
//
//
//        opportunity.StageName = 'Closed Won';
//        update opportunity;
//
//        List<Opportunity> op = [
//                SELECT
//                        Id,
//                        StageName,
//                        Autopopoff__c,
//                        Pipeline_Amount__c,
//                        Account.ATR_Channel_Partner__c,
//                        Is_HAT__c
//                FROM Opportunity
//                WHERE Id = :opportunity.Id
//        ];
//        System.assertEquals(1200000, op.get(0).Pipeline_Amount__c);
//        System.assertEquals( false, op.get(0).Account.ATR_Channel_Partner__c);
//        System.assertEquals( false, op.get(0).Is_HAT__c);
//        System.assertEquals('Prospecting', op.get(0).StageName);
//        System.assertEquals(true, op.get(0).Autopopoff__c);
//    }
//    @IsTest
//    static void BGA_SalesSurveyAutopopup() {
//        acct = new TestAccountBuilder()
//                .addField( 'Report_Country_Name__c', 'India' )
//                .addField( 'Region_Name__c', 'Asia/Pacific Rim' )
//                .generate();
//        opportunity = new TestOpportunityBuilder( 'Test', 'BGA_Operator' )
//                .addField( 'AccountId', acct.Id )
//                .addField( 'SBU__c', 'BGA' )
//                .addField( 'StageName', 'Prospecting' )
//                .addField( 'Win_Loss_Amount__c', 50000 )
//                .generate();
//
//        opportunity.StageName = 'Closed Won';
//        update opportunity;
//
//        List<Opportunity> op = [
//                SELECT
//                        Id,
//                        StageName,
//                        Autopopoff__c,
//                        Pipeline_Amount__c,
//                        Account.ATR_Channel_Partner__c,
//                        Is_HAT__c
//                FROM Opportunity
//                WHERE Id = :opportunity.Id
//        ];
//        System.assertEquals(50000, op.get(0).Pipeline_Amount__c);
//        System.assertEquals('Closed Won', op.get(0).StageName);
//        System.assertEquals(false, op.get(0).Autopopoff__c);
//    }

    @IsTest
    static void AU_UpdateOpportunity_FollowOn()
    {
        init();

        System.Test.startTest();

        Opportunity parentOpportunity = new TestOpportunityBuilder()
                .addField('SBU__c','BGA')
                .addField('Sales_Channel__c','Divest')
                .generate();

        opportunity.Next_Step__c = 'UpdatedNextStepTask';
        opportunity.Next_Step_Date__c = Date.newInstance(2019,12,25);
        opportunity.RecordTypeId = TestOpportunityBuilder.getRecordType('AM_Catalog').Id;
        opportunity.Parent_Opportunity__c = parentOpportunity.id;
        opportunity.Is_Follow_On_Opportunity__c = true;
        opportunity.Win_Only_Opportunity__c = true;

        insert opportunity;
        System.Test.stopTest();

        List<Task> nextStepTasks = [SELECT Id FROM Task Where WhatId =: opportunity.Id And Subject = 'Next Step' LIMIT 1];

        System.assertEquals(1, nextStepTasks.size());
    }

    @IsTest
    static void BU_PGo_Pwin_test_case() {
        init();
        OpportunityLineItem lineItem;
        System.Test.startTest();
        opportunity.Pgo__c = '1';
        opportunity.PWin__c = '0.25';
        insert opportunity;

        Pricebook2 pbook = new TestPricebookBuilder()
                .generate();
        Product2 product = new TestProductBuilder()
                .addField('CanUseRevenueSchedule', true)
                .generate();
        PricebookEntry standardPricebookEntry = new PriceBookEntry(
                Pricebook2Id = System.Test.getStandardPricebookId(),
                Product2Id = product.Id,
                UnitPrice = 50
        );
        Database.insert( standardPricebookEntry );
        PricebookEntry pbookEntry = new TestPricebookEntryBuilder()
                .setPricebook(pbook.Id)
                .setProduct(product.Id)
                .generate();

        lineItem = new TestOpportunityLineItemBuilder()
                .setServiceDate( Date.today() )
                .setOpportunityId(opportunity.Id )
                .setUnitPrice(100)
                .setQuantity(10)
                .setPricebookEntryId(pbookEntry.Id)
                .setType('Forecast')
                .setOpportunityId(opportunity.Id)
                .generate();

        update opportunity;
        OpportunityLineItem insertedOLI = [
                SELECT
                        Id,
                        Probability__c,
                        ServiceDate
                FROM OpportunityLineItem
                WHERE Id = :lineItem.Id
                LIMIT 1
        ];
        System.Test.stopTest();
        System.assertEquals(100,insertedOLI.Probability__c);
        //  System.assertEquals(Date.today().addDays(10),insertedOLI.ServiceDate);
    }

//    @IsTest
//    static void BU_WinLossAmountWithTotalWinLoss() {
//        init();
//
//
//        System.Test.startTest();
//        opportunity.StageName = 'Launch';
//        opportunity.Total_Win_Loss_Amount__c = 10;
//        opportunity.Win_Loss_Amount__c = 20;
//        insert opportunity;
//        System.Test.stopTest();
//
//        Opportunity insertedOpportunity = [
//                SELECT
//                        Total_Win_Loss_Amount__c
//                FROM Opportunity
//                WHERE Id = :opportunity.Id
//                LIMIT 1
//        ];
//
//        System.assertEquals(30, insertedOpportunity.Total_Win_Loss_Amount__c);
//    }
//    @IsTest
//    static void BU_WinLossAmountWithoutTotalWinLoss() {
//        init();
//
//
//        System.Test.startTest();
//        opportunity.StageName = 'Launch';
//        opportunity.Win_Loss_Amount__c = 20;
//        insert opportunity;
//        System.Test.stopTest();
//
//        Opportunity insertedOpportunity = [
//                SELECT
//                        Total_Win_Loss_Amount__c
//                FROM Opportunity
//                WHERE Id = :opportunity.Id
//                LIMIT 1
//        ];
//
//        System.assertEquals(20, insertedOpportunity.Total_Win_Loss_Amount__c);
//    }
    @IsTest
    static void AI_NewCustomerStatusTaskCreation()
    {
        init();

        System.Test.startTest();
        opportunity.Status__c = 'NewCustomerStatusTask';
        insert opportunity;
        System.Test.stopTest();

        List<Task> customerStatusTasks = [SELECT Id FROM Task Where WhatId =: opportunity.Id LIMIT 1];

        System.assertEquals(1, customerStatusTasks.size());
    }

    @IsTest
    static void AI_NewNextStepTaskCreation()
    {
        init();

        System.Test.startTest();
        opportunity.Next_Step__c = 'NewNextStepTask';
        //opportunity.Next_Step_Date__c = Date.newInstance(2019,12,24);
        insert opportunity;
        System.Test.stopTest();

        List<Task> nextStepTasks = [SELECT Id FROM Task Where WhatId =: opportunity.Id LIMIT 1];

        System.assertEquals(1, nextStepTasks.size());
    }

    @IsTest
    static void AI_NewLogVirtualMeetingTaskCreation()
    {
        init();

        System.Test.startTest();
        opportunity.Log_Virtual_Meeting__c = 'NewLogVirtualMeetingTask';
        //opportunity.Log_Virtual_Meeting_Date__c = Date.newInstance(2019,12,24);
        insert opportunity;
        System.Test.stopTest();

        List<Task> logVirtualMeetingTasks = [SELECT Id FROM Task Where WhatId =: opportunity.Id LIMIT 1];

        System.assertEquals(1, logVirtualMeetingTasks.size());
    }

    @IsTest
    static void AI_NewLogF2FMeetingTaskCreation()
    {
        init();

        System.Test.startTest();
        opportunity.Log_F2F_Meeting__c = 'NewLogF2FMeetingTask';
        //opportunity.Log_F2F_Meeting_Date__c = Date.newInstance(2019,12,24);
        insert opportunity;
        System.Test.stopTest();

        List<Task> logF2FMeetingTasks = [SELECT Id FROM Task Where WhatId =: opportunity.Id LIMIT 1];

        System.assertEquals(1, logF2FMeetingTasks.size());
    }

    @IsTest
    static void AU_UpdateOpportunity_NewCustomerStatusTaskCreation()
    {
        init();

        insert opportunity;

        opportunity.Status__c = 'UpdatedCustomerStatusTask';

        System.Test.startTest();
        update opportunity;
        System.Test.stopTest();

        List<Task> customerStatusTasks = [SELECT Id FROM Task Where WhatId =: opportunity.Id And Subject = 'Customer Status' LIMIT 1];

        System.assertEquals(1, customerStatusTasks.size());
    }

   /* @IsTest
    static void AU_UpdateOpportunity_NewNextStepTaskCreation()
    {
        init();

        insert opportunity;

        opportunity.Next_Step__c = 'UpdatedNextStepTask';
        //opportunity.Next_Step_Date__c = Date.newInstance(2019,12,25);

        System.Test.startTest();
        //update opportunity;
        System.Test.stopTest();

        List<Task> nextStepTasks = [SELECT Id FROM Task Where WhatId =: opportunity.Id And Subject = 'Next Step' LIMIT 1];

        System.assertEquals(1, nextStepTasks.size());
    }*/

    @IsTest
    static void AU_UpdateOpportunity_NewLogVirtualMeetingTaskCreation()
    {
        init();

        insert opportunity;

        opportunity.Log_Virtual_Meeting__c = 'UpdatedLogVirtualMeetingTask';
        //opportunity.Log_Virtual_Meeting_Date__c = Date.newInstance(2019,12,25);

        System.Test.startTest();
        update opportunity;
        System.Test.stopTest();

        List<Task> logVirtualMeetingTasks = [SELECT Id FROM Task Where WhatId =: opportunity.Id And Subject = 'Log Virtual Meeting' LIMIT 1];

        System.assertEquals(1, logVirtualMeetingTasks.size());
    }

    @IsTest
    static void AU_UpdateOpportunity_NewLogF2FMeetingTaskCreation()
    {
        init();

        insert opportunity;

        opportunity.Log_F2F_Meeting__c = 'UpdatedLogF2FMeetingTask';
        //opportunity.Log_F2F_Meeting_Date__c = Date.newInstance(2019,12,25);

        System.Test.startTest();
        update opportunity;
        System.Test.stopTest();

        List<Task> logF2FMeetingTasks = [SELECT Id FROM Task Where WhatId =: opportunity.Id And Subject = 'Log F2F Meeting' LIMIT 1];

        System.assertEquals(1, logF2FMeetingTasks.size());
    }

    @IsTest
    static void AI_TactAI_NewCustomerStatus_NonStandardSubject()
    {
        init();

        System.Test.startTest();
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Customer Status').getRecordTypeId();

        Task newCustomerStatusTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Customer Status123',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'NewCustomerStatusTask',
                ActivityDate = null,
                CreatedDate = system.now());

        insert newCustomerStatusTask;

        System.Test.stopTest();

        Opportunity oppResult = [SELECT Id FROM Opportunity Where Id =: opportunity.Id  LIMIT 1];

        System.assertEquals('Customer Status123', newCustomerStatusTask.Subject);
    }

    @IsTest
    static void AI_TactAI_NewNextStep_NonStandardSubject()
    {
        init();

        System.Test.startTest();
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Next Step').getRecordTypeId();

        Task newNextStepTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Next Step123',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'NewNextStepTask',
                ActivityDate = Date.newInstance(2019, 12, 25),
                CreatedDate = system.now());

        insert newNextStepTask;

        System.Test.stopTest();

        Opportunity oppResult = [SELECT Id FROM Opportunity Where Id =: opportunity.Id  LIMIT 1];

        System.assertEquals('Next Step123', newNextStepTask.Subject);
    }

    @IsTest
    static void AI_TactAI_NewLogVirtualMeeting_NonStandardSubject()
    {
        init();

        System.Test.startTest();
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Log Virtual Meeting').getRecordTypeId();

        Task newLogVirtualMeetingTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Log Virtual Meeting123',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'NewLogVirtualMeetingTask',
                Activity_Date__c = Date.newInstance(2019, 12, 25),
                CreatedDate = system.now());

        insert newLogVirtualMeetingTask;

        System.Test.stopTest();

        Opportunity oppResult = [SELECT Id FROM Opportunity Where Id =: opportunity.Id  LIMIT 1];

        System.assertEquals('Log Virtual Meeting123', newLogVirtualMeetingTask.Subject);
    }

    @IsTest
    static void AI_TactAI_NewLogF2FMeeting_NonStandardSubject()
    {
        init();

        System.Test.startTest();
        insert opportunity;

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Log F2F Meeting').getRecordTypeId();

        Task newLogF2FMeetingTask = new Task(
                RecordtypeID = recTypeId,
                Subject = 'Log F2F Meeting123',

                WhatId = opportunity.Id,
                //This is the default..
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed',
                Type = 'Call',
                Description = 'NewLogF2FMeetingTask',
                Activity_Date__c = Date.newInstance(2019, 12, 25),
                CreatedDate = system.now());

        insert newLogF2FMeetingTask;

        System.Test.stopTest();

        Opportunity oppResult = [SELECT Id FROM Opportunity Where Id =: opportunity.Id  LIMIT 1];

        System.assertEquals('Log F2F Meeting123', newLogF2FMeetingTask.Subject);
    }

}