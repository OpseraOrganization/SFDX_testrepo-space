/**
 * Created by Satya Mohanty on 3/22/2019.
 * Refactored by Nikolay Kolev on 3/25/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@isTest
private class OpportunityLineItemTriggerHandler_Test {
    private static Product_Line__c productLine;
    private final static String BENDIXKING = 'BendixKing';
    private final static String BK_FLIGHT_CONTROLS = 'BK-Flight Controls';
    private final static String AMERICAS = 'Americas';
    private final static String AMERICA = 'America';
    private final static String NULL_POINTER_EXCEPTION = 'Attempt to de-reference a null object';
    private static RMU_VALUE__c rmuValueOne;
    private static Product2 productOne;
    private static Platform__c platformOne;
    private static Platform__c platformTwo;
    private static Product_Line_Cross_Ref__c productLineCrossRef;
    private static Opportunity opportunity;
    private static Pricebook2 pbook;
    private static PricebookEntry pbookEntry;
    private static User techSalesManager;
    private static Fleet_Asset_Detail__c fleetAssetDetail;

    static void init() {
        Account acct = new TestAccountBuilder()
                .addField('Report_Country_Name__c', AMERICA)
                .addField('Region_Name__c', AMERICAS)
                .generate();

        opportunity = new TestOpportunityBuilder('Test', BENDIXKING)
                .addField('AccountId', acct.Id)
                .addField('SBU__c', 'BGA')
                .addField('StageName', 'Closed Won')
                .generate();

        Contact contact = new TestContactBuilder().generate();

        productOne = new TestProductBuilder('My Product One')
                .generate();

        rmuValueOne = new TestRmuValueBuilder().generate();

        platformOne = new TestPlatformBuilder()
                .setName('TestPlatformOne')
                .setModel('36-16A')
                .setMake('Various OEMS')
                .setSAPExternalSystem(true)
                .addField('Active__c', true)
                .generate();

        platformTwo = new TestPlatformBuilder()
                .setName('TestPlatformTwo')
                .setModel('36-16A')
                .setMake('Various OEMS')
                .setSAPExternalSystem(true)
                .addField('Active__c', true)
                .generate();

        fleetAssetDetail = new TestFleetAssetDetailBuilder()
                .setPlatform(platformOne.Id)
                .generate();

        Platform_cross_ref__c platformCrossRef = new Platform_cross_ref__c();
        platformCrossRef.External_System_Name__c = 'FleetAnalyzer';
        platformCrossRef.Platform_Parent__c = platformOne.Id;
        insert platformCrossRef;

        Platform_cross_ref__c platformCrossRefTwo = new Platform_cross_ref__c();
        platformCrossRefTwo.External_System_Name__c = 'FleetAnalyzer';
        platformCrossRefTwo.Platform_Parent__c = platformTwo.Id;
        insert platformCrossRefTwo;

        pbook = new TestPricebookBuilder()
                .generate();
        Product2 product = new TestProductBuilder()
                .addField('CanUseRevenueSchedule', true)
                .generate();
        PricebookEntry standardPricebookEntry= new PriceBookEntry(
                Pricebook2Id = System.Test.getStandardPricebookId(),
                Product2Id = product.Id,
                UnitPrice = 50
        );
        Database.insert(standardPricebookEntry);
        pbookEntry = new TestPricebookEntryBuilder()
                .setPricebook(pbook.Id)
                .setProduct(product.Id)
                .generate();
        productLine = new TestProductTypeBuilder().generate();
        productLineCrossRef = new TestProductLineCrossRefBuilder('TestName')
                .setProductType(productLine.Id)
                .setProductLeader(contact.Id)
                .generate();
        techSalesManager = new TestUserBuilder().generate();
    }
    @IsTest
    static void testHandleExceptionBase() {
        init();

        Exception myException;
        try {
            List<Id> myList;
            myList.get(0);
        } catch(Exception ex) {
            myException = ex;
        }

        System.Test.startTest();
        OpportunityLineItemTriggerHandler.handleException(myException);
        System.Test.stopTest();

        Error_Log__c insertedErrorLog = [
                SELECT
                        Team_Name__c,
                        Description__c,
                        Object__c
                FROM Error_Log__c
                LIMIT 1
        ];

        System.assertEquals(ErrorLogBuilder.CRM_SALES, insertedErrorLog.Team_Name__c);
        System.assertEquals(true, insertedErrorLog.Description__c.contains(NULL_POINTER_EXCEPTION));
        System.assertEquals(OpportunityLineItemTriggerHandler.OPPORTUNITY_LINE_ITEM, insertedErrorLog.Object__c);
    }
    @IsTest
    static void testHandleExceptionFull() {
        init();

        Exception myException;
        try {
            List<Id> myList;
            myList.get(0);
        } catch(Exception ex) {
            myException = ex;
        }

        System.Test.startTest();
        Product2 productTwo = new TestProductBuilder('My Product Two')
                .generate();
        OpportunityLineItemTriggerHandler.handleException(
                myException,
                new Set<Id> {opportunity.Id},
                new Set<Id> {productLineCrossRef.Id},
                new Set<Id> {productOne.Id, productTwo.Id},
                new Set<Id> {productLine.Id}
        );
        System.Test.stopTest();

        Error_Log__c insertedErrorLog = [
                SELECT
                        Team_Name__c,
                        Description__c,
                        Object__c
                FROM Error_Log__c
                LIMIT 1
        ];

        System.assertEquals(ErrorLogBuilder.CRM_SALES, insertedErrorLog.Team_Name__c);
        System.assertEquals(true, insertedErrorLog.Description__c.contains(opportunity.Id));
        System.assertEquals(true, insertedErrorLog.Description__c.contains(productLineCrossRef.Id));
        System.assertEquals(true, insertedErrorLog.Description__c.contains(productOne.Id));
        System.assertEquals(true, insertedErrorLog.Description__c.contains(productTwo.Id));
        System.assertEquals(true, insertedErrorLog.Description__c.contains(productLine.Id));
        System.assertEquals(true, insertedErrorLog.Description__c.contains(NULL_POINTER_EXCEPTION));
        System.assertEquals(OpportunityLineItemTriggerHandler.OPPORTUNITY_LINE_ITEM, insertedErrorLog.Object__c);
    }
    @IsTest
    static void BI_ForecastFactorHundred() {
        init();

        System.Test.startTest();
        opportunity.StageName = 'Closed Won';
        update opportunity;

        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Forecast_Factor_AI__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(100, insertedLineItem.Forecast_Factor_AI__c);
    }
    @IsTest
    static void BI_ForecastFactorClosedLostZero() {
        init();

        opportunity.StageName = 'Closed Lost';
        update opportunity;

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Forecast_Factor_AI__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(0, insertedLineItem.Forecast_Factor_AI__c);
    }
    @IsTest
    static void BI_ForecastFactorClosedCancelledZero() {
        init();

        System.Test.startTest();
        opportunity.StageName = 'Closed Cancelled';
        update opportunity;

        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Forecast_Factor_AI__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(0, insertedLineItem.Forecast_Factor_AI__c);
    }
    @IsTest
    static void BI_TypeBookedProbabilityHundred() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('Type__c', 'Booked')
                .generate();
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Probability__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(100, insertedLineItem.Probability__c);
    }
    @IsTest
    static void BI_TypeBookedUserNotAdmin() {
        init();

        OpportunityLineItem lineItem;

        System.Test.startTest();
        User standardUser = new TestUserBuilder()
                .addField('ProfileId', [
                        SELECT Id
                        FROM Profile
                        WHERE Name = 'Developer Administrator'
                ].Id)
                .generate();

        opportunity.ATR_Probability__c = 100;
        opportunity.Program_Go_Probability__c = 100;
        opportunity.StageName = 'Prospecting';
        update opportunity;

        Opportunity insertedOpportunity = [
                SELECT Combined_Probability__c
                FROM Opportunity
                WHERE Id=:opportunity.Id
        ];

        System.runAs(standardUser) {
            lineItem = new TestOpportunityLineItemBuilder()
                    .setOpportunityId(opportunity.Id)
                    .setPricebookEntryId(pbookEntry.Id)
                    .addField('Type__c', 'Booked')
                    .generate();
        }
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Probability__c,
                        Type__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals('Forecast', insertedLineItem.Type__c);
        System.assertEquals(insertedOpportunity.Combined_Probability__c, insertedLineItem.Probability__c);
    }
    @IsTest
    static void BI_TypeNotBookedProbabilityFromOpportunity() {
        init();

        opportunity.ATR_Probability__c = 100;
        opportunity.Program_Go_Probability__c = 100;
        update opportunity;

        Opportunity insertedOpportunity = [
                SELECT Combined_Probability__c
                FROM Opportunity
                WHERE Id=:opportunity.Id
        ];

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('Type__c', 'Forecast')
                .generate();
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Probability__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(insertedOpportunity.Combined_Probability__c, insertedLineItem.Probability__c);
    }
    @IsTest
    static void BI_ProductLineFromProductCrossReference() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('M_PM_Product__c', productLineCrossRef.Id)
                .generate();
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        M_PM_Product_Line__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(productLine.Id, insertedLineItem.M_PM_Product_Line__c);
    }
    @IsTest
    static void BI_ProductCrossReferenceFromProductLine() {
        init();

        List<SObject> sObjects = new List<SObject>();
        productLine.Name = 'Test Line';
        productLineCrossRef.Name = 'Test Line';
        sObjects.add(productLine);
        sObjects.add(productLineCrossRef);
        update sObjects;

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('M_PM_Product_Line__c', productLine.Id)
                .generate();
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        M_PM_Product__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(productLineCrossRef.Id, insertedLineItem.M_PM_Product__c);
    }
    @IsTest
    static void BI_RmuFromRmuProduct() {
        init();

        System.Test.startTest();
        RMU_Product__c rmuProductOne = new TestRmuProductBuilder()
                .setName('My Rmu Product One')
                .addField('Rmu_Product__c', productOne.Id)
                .setRmuValue(rmuValueOne.Id)
                .generate();

        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('Product2Id', productOne.Id)
                .generate();
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        RMU__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(rmuProductOne.RMU__c, insertedLineItem.RMU__c);
    }
    @IsTest
    static void BI_RmuPlatform() {
        init();

        System.Test.startTest();
        RMU_Product__c rmuProductOne = new TestRmuProductBuilder()
                .setName('My Rmu Product One')
                .addField('Rmu_Product__c', productOne.Id)
                .setRmuValue(rmuValueOne.Id)
                .generate();

        OFFERING_MAPPER__c offeringMapperOne = new TestOfferingMapperBuilder()
                .setRmuValue(rmuValueOne.Id)
                .addField('Aircraft_Platform__c', platformOne.Id)
                .generate();

        opportunity.Aircraft_Ref__c = fleetAssetDetail.Id;
        update opportunity;

        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('Product2Id', productOne.Id)
                .generate();
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        RMU_Platform__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(offeringMapperOne.Id, insertedLineItem.RMU_Platform__c);
    }
    @IsTest
    static void BI_SetTechSalesFromDefaultOpportunity() {
        init();

        opportunity.Default_Tech_Sales__c = BENDIXKING;
        opportunity.Default_Tech_Sales_Product__c = BK_FLIGHT_CONTROLS;
        opportunity.Default_Tech_Sales_Manager__c = techSalesManager.Id;
        update opportunity;

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('Product2Id', productOne.Id)
                .generate();
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Tech_Sales__c,
                        Tech_Sales_Product__c,
                        Tech_Sales_Manager__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(opportunity.Default_Tech_Sales__c, insertedLineItem.Tech_Sales__c);
        System.assertEquals(opportunity.Default_Tech_Sales_Product__c, insertedLineItem.Tech_Sales_Product__c);
        System.assertEquals(opportunity.Default_Tech_Sales_Manager__c, insertedLineItem.Tech_Sales_Manager__c);
    }
    @IsTest
    static void BI_SetTechSalesFromProductLineTechSales() {
        init();

        Product_Line_Tech_Sales__c productLineTechSales = new TestProductLineTechSalesBuilder()
                .setSBU('BGA')
                .setRegion(AMERICAS)
                .setProductLine(productLine.Id)
                .addField('Tech_Sales__c', BENDIXKING)
                .addField('Tech_Sales_Product__c', BK_FLIGHT_CONTROLS)
                .addField('Tech_Sales_Manager__c', techSalesManager.Id)
                .addField('Country__c', AMERICA)
                .generate();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('Product2Id', productOne.Id)
                .setproductCrossReferenceId(productLineCrossRef.Id)
                .generate();
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Tech_Sales__c,
                        Tech_Sales_Product__c,
                        Tech_Sales_Manager__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(productLineTechSales.Tech_Sales__c, insertedLineItem.Tech_Sales__c);
        System.assertEquals(productLineTechSales.Tech_Sales_Product__c, insertedLineItem.Tech_Sales_Product__c);
        System.assertEquals(productLineTechSales.Tech_Sales_Manager__c, insertedLineItem.Tech_Sales_Manager__c);
    }
    @IsTest
    static void BI_SetTechSalesFromProductLineTechSalesNoCountry() {
        init();

        Product_Line_Tech_Sales__c productLineTechSales = new TestProductLineTechSalesBuilder()
                .setSBU('BGA')

                .setRegion(AMERICAS)
                .setProductLine(productLine.Id)
                .addField('Tech_Sales__c', BENDIXKING)
                .addField('Tech_Sales_Product__c', BK_FLIGHT_CONTROLS)
                .addField('Tech_Sales_Manager__c', techSalesManager.Id)
                .addField('Product_Line__c', productLine.Id)
                .generate();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('Product2Id', productOne.Id)
                .setproductCrossReferenceId(productLineCrossRef.Id)
                .generate();
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Tech_Sales__c,
                        Tech_Sales_Product__c,
                        Tech_Sales_Manager__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(productLineTechSales.Tech_Sales__c, insertedLineItem.Tech_Sales__c);
        System.assertEquals(productLineTechSales.Tech_Sales_Product__c, insertedLineItem.Tech_Sales_Product__c);
        System.assertEquals(productLineTechSales.Tech_Sales_Manager__c, insertedLineItem.Tech_Sales_Manager__c);
    }
    @IsTest
    static void BI_SetTechSalesFromBaseOpportunity() {
        init();

        User insertedUser = [
                SELECT Name
                FROM User
                WHERE Id = :techSalesManager.Id
        ];

        opportunity.Tech_Sales__c = BENDIXKING;
        opportunity.Tech_Sales_Product_Area__c = BK_FLIGHT_CONTROLS;
        opportunity.Tech_Sales1__c = insertedUser.Name;
        update opportunity;

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('Product2Id', productOne.Id)
                .generate();
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Tech_Sales__c,
                        Tech_Sales_Product__c,
                        Tech_Sales_Manager__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(opportunity.Tech_Sales__c, insertedLineItem.Tech_Sales__c);
        System.assertEquals(opportunity.Tech_Sales_Product_Area__c, insertedLineItem.Tech_Sales_Product__c);
        System.assertEquals(techSalesManager.Id, insertedLineItem.Tech_Sales_Manager__c);
    }
    @IsTest
    static void BU_ForecastFactorHundred() {
        init();

        System.Test.startTest();
        opportunity.StageName = 'Closed Lost';
        update opportunity;
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        opportunity.StageName = 'Closed Won';
        update opportunity;

        lineItem.UnitPrice = 999;
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Forecast_Factor_AI__c,
                        UnitPrice
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(100, insertedLineItem.Forecast_Factor_AI__c);
        System.assertEquals(999, insertedLineItem.UnitPrice);
    }
    @IsTest
    static void BU_ForecastFactorClosedLostZero() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        opportunity.StageName = 'Closed Lost';
        update opportunity;

        lineItem.UnitPrice = 999;
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Forecast_Factor_AI__c,
                        UnitPrice
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(0, insertedLineItem.Forecast_Factor_AI__c);
        System.assertEquals(999, insertedLineItem.UnitPrice);
    }
    @IsTest
    static void BU_ForecastFactorClosedCancelledZero() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        opportunity.StageName = 'Closed Cancelled';
        update opportunity;

        lineItem.UnitPrice = 999;
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Forecast_Factor_AI__c,
                        UnitPrice
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(0, insertedLineItem.Forecast_Factor_AI__c);
        System.assertEquals(999, insertedLineItem.UnitPrice);
    }
    @IsTest
    static void BU_TypeBookedProbabilityHundred() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        lineItem.Type__c = 'Booked';
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Probability__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(100, insertedLineItem.Probability__c);
    }
    @IsTest
    static void BU_TypeNotBookedProbabilityFromOpportunity() {
        init();

        System.Test.startTest();
        opportunity.ATR_Probability__c = 100;
        opportunity.Program_Go_Probability__c = 100;
        update opportunity;

        Opportunity insertedOpportunity = [
                SELECT Combined_Probability__c
                FROM Opportunity
                WHERE Id=:opportunity.Id
        ];
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        lineItem.Type__c = 'Forecast';
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Probability__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(insertedOpportunity.Combined_Probability__c, insertedLineItem.Probability__c);
    }
    @IsTest
    static void BU_ProductLineFromProductCrossReference() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        lineItem.M_PM_Product__c = productLineCrossRef.Id;
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        M_PM_Product_Line__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(productLine.Id, insertedLineItem.M_PM_Product_Line__c);
    }
    @IsTest
    static void BU_ProductCrossReferenceFromProductLine() {
        init();

        System.Test.startTest();
        List<SObject> sObjects = new List<SObject>();
        productLine.Name = 'Test Line';
        productLineCrossRef.Name = 'Test Line';
        sObjects.add(productLine);
        sObjects.add(productLineCrossRef);
        update sObjects;

        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        lineItem.M_PM_Product_Line__c = productLine.Id;
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        M_PM_Product__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(productLineCrossRef.Id, insertedLineItem.M_PM_Product__c);
    }
    @IsTest
    static void BU_SetTechSalesFromDefaultOpportunity() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('Product2Id', productOne.Id)
                .generate();

        opportunity.Default_Tech_Sales__c = BENDIXKING;
        opportunity.Default_Tech_Sales_Product__c = BK_FLIGHT_CONTROLS;
        opportunity.Default_Tech_Sales_Manager__c = techSalesManager.Id;
        update opportunity;

        lineItem.UnitPrice = 999;
        lineItem.M_PM_Product__c = productLineCrossRef.Id;
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Tech_Sales__c,
                        Tech_Sales_Product__c,
                        Tech_Sales_Manager__c,
                        UnitPrice
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(opportunity.Default_Tech_Sales__c, insertedLineItem.Tech_Sales__c);
        System.assertEquals(opportunity.Default_Tech_Sales_Product__c, insertedLineItem.Tech_Sales_Product__c);
        System.assertEquals(opportunity.Default_Tech_Sales_Manager__c, insertedLineItem.Tech_Sales_Manager__c);
        System.assertEquals(999, insertedLineItem.UnitPrice);
    }
    @IsTest
    static void BU_SetTechSalesFromProductLineTechSales() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('Product2Id', productOne.Id)
                .generate();

        Product_Line_Tech_Sales__c productLineTechSales = new TestProductLineTechSalesBuilder()
                .setSBU('BGA')
                .setRegion(AMERICAS)
                .setProductLine(productLine.Id)
                .addField('Tech_Sales__c', BENDIXKING)
                .addField('Tech_Sales_Product__c', BK_FLIGHT_CONTROLS)
                .addField('Tech_Sales_Manager__c', techSalesManager.Id)
                .addField('Country__c', AMERICA)
                .generate();

        lineItem.M_PM_Product__c = productLineCrossRef.Id;
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Tech_Sales__c,
                        Tech_Sales_Product__c,
                        Tech_Sales_Manager__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(productLineTechSales.Tech_Sales__c, insertedLineItem.Tech_Sales__c);
        System.assertEquals(productLineTechSales.Tech_Sales_Product__c, insertedLineItem.Tech_Sales_Product__c);
        System.assertEquals(productLineTechSales.Tech_Sales_Manager__c, insertedLineItem.Tech_Sales_Manager__c);
    }
    @IsTest
    static void BU_SetTechSalesFromBaseOpportunity() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('Product2Id', productOne.Id)
                .generate();

        User insertedUser = [
                SELECT Name
                FROM User
                WHERE Id = :techSalesManager.Id
        ];

        opportunity.Tech_Sales__c = BENDIXKING;
        opportunity.Tech_Sales_Product_Area__c = BK_FLIGHT_CONTROLS;
        opportunity.Tech_Sales1__c = insertedUser.Name;
        update opportunity;

        lineItem.UnitPrice = 999;
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Tech_Sales__c,
                        Tech_Sales_Product__c,
                        Tech_Sales_Manager__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(opportunity.Tech_Sales__c, insertedLineItem.Tech_Sales__c);
        System.assertEquals(opportunity.Tech_Sales_Product_Area__c, insertedLineItem.Tech_Sales_Product__c);
        System.assertEquals(techSalesManager.Id, insertedLineItem.Tech_Sales_Manager__c);
    }
    @IsTest
    static void BU_BookedTypeNotAdminReturnsError() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        User standardUser = new TestUserBuilder()
                .addField('ProfileId', [
                        SELECT Id
                        FROM Profile
                        WHERE Name = 'Developer Administrator'
                ].Id)
                .generate();

        String exMessage;
        try {
            System.runAs(standardUser) {
                lineItem.Type__c = 'APO';
                update lineItem;
            }
        } catch(Exception ex) {
            exMessage = ex.getMessage();
        }
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Type__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(true, exMessage.contains('Opportunity Product can be changed only by an admin'));
        System.assertEquals('Forecast', insertedLineItem.Type__c);
    }
    @IsTest
    static void BU_ScheduleTypeDaily() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today())
                .setType('Revenue')
                .generate();

        lineItem.UnitPrice = 999;
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Schedule_Type__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals('Daily', insertedLineItem.Schedule_Type__c);
    }
    @IsTest
    static void BU_ScheduleTypeWeekly() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today())
                .setType('Revenue')
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(5))
                .setType('Revenue')
                .generate();

        lineItem.UnitPrice = 999;
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Schedule_Type__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals('Weekly', insertedLineItem.Schedule_Type__c);
    }
    @IsTest
    static void BU_ScheduleTypeMonthly() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today())
                .setType('Revenue')
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(20))
                .setType('Revenue')
                .generate();

        lineItem.UnitPrice = 999;
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Schedule_Type__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals('Monthly', insertedLineItem.Schedule_Type__c);
    }
    @IsTest
    static void BU_ScheduleTypeQuarterly() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today())
                .setType('Revenue')
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(50))
                .setType('Revenue')
                .generate();

        lineItem.UnitPrice = 999;
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Schedule_Type__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals('Quarterly', insertedLineItem.Schedule_Type__c);
    }
    @IsTest
    static void BU_ScheduleTypeYearly() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today())
                .setType('Revenue')
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(120))
                .setType('Revenue')
                .generate();

        lineItem.UnitPrice = 999;
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Schedule_Type__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals('Yearly', insertedLineItem.Schedule_Type__c);
    }
    @IsTest
    static void BU_ScheduleTermsInMonths() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today())
                .setType('Revenue')
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addMonths(4))
                .setType('Revenue')
                .generate();

        lineItem.UnitPrice = 999;
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Terms_in_Months__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(4, insertedLineItem.Terms_in_Months__c);
    }
    @IsTest
    static void BU_ScheduleRevenueDates() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        OpportunityLineItemSchedule scheduleOne = new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today())
                .setType('Revenue')
                .generate();

        OpportunityLineItemSchedule scheduleTwo = new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(120))
                .setType('Revenue')
                .generate();

        lineItem.ServiceDate = Date.today().addDays(35);
        update lineItem;
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Revenue_Start_Date__c,
                        Revenue_End_Date__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(Date.today().addDays(5), insertedLineItem.Revenue_Start_Date__c);
        System.assertEquals(Date.today().addDays(125), insertedLineItem.Revenue_End_Date__c);
    }
    @IsTest
    static void BU_ScheduleRevenueDateError() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today())
                .setType('Revenue')
                .generate();

        new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(120))
                .setType('Revenue')
                .generate();

        String exceptionMessage;
        lineItem.Revenue_Start_Date__c = Date.today().addDays(35);
        lineItem.Revenue_End_Date__c = Date.today().addDays(35);
        try {
            update lineItem;
        } catch(Exception ex) {
            exceptionMessage = ex.getMessage();
        }
        System.Test.stopTest();

        System.assertEquals(true, exceptionMessage.contains('Please edit Revenue Schedule to change Revenue Start or End date.'));
    }
    @IsTest
    static void BD_TypeBookedGetsDeleted() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        String exceptionMessage;
        lineItem.Type__c = 'Booked';
        try {
            delete lineItem;
        } catch(Exception ex) {
            exceptionMessage = ex.getMessage();
        }
        System.Test.stopTest();

        List<OpportunityLineItem> insertedLineItems = [
                SELECT
                        Id,
                        Revenue_Start_Date__c,
                        Revenue_End_Date__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(0, insertedLineItems.size());
    }
    /*@IsTest
    static void BD_TypeBookedThrowsError() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('Type__c', 'APO')
                .generate();


        User standardUser = new TestUserBuilder()
                .addField('ProfileId', [
                        SELECT Id
                        FROM Profile
                        WHERE Name = 'Developer Administrator'
                ].Id)
                .generate();

        String exMessage;
        try {
            System.runAs(standardUser) {
                delete lineItem;
            }
        } catch(Exception ex) {
            exMessage = ex.getMessage();
        }
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT
                        Id,
                        Revenue_Start_Date__c,
                        Revenue_End_Date__c
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id
        ];

        System.assertEquals(false, exMessage.contains('Opportunity Product can be deleted only by an admin'));
        System.assertEquals(lineItem.Id, insertedLineItem.Id);
    }*/
    @IsTest
    static void AU_OpportunityLineItemScheduleUpdateScheduleDate() {
        init();

        System.Test.startTest();
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('ServiceDate', Date.today())
                .generate();

        OpportunityLineItemSchedule scheduleOne = new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today())
                .setType('Revenue')
                .generate();

        OpportunityLineItemSchedule scheduleTwo = new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(20)
                .setOpportunityLineItemId(lineItem.Id)
                .setScheduledDate(Date.today().addDays(120))
                .setType('Revenue')
                .generate();

        lineItem.ServiceDate = Date.today().addDays(5);
        update lineItem;
        System.Test.stopTest();

        List<OpportunityLineItemSchedule> insertedOliSchedules = [
                SELECT
                        Revenue,
                        ScheduleDate
                FROM OpportunityLineItemSchedule
                WHERE OpportunityLineItemId =: lineItem.Id
        ];

        Map<Id, Date> schedules = new Map<Id, Date>();
        for (OpportunityLineItemSchedule oliSchedule: insertedOliSchedules) {
            schedules.put(oliSchedule.Id, oliSchedule.ScheduleDate);
        }

        System.assertEquals(Date.today().addDays(5), schedules.get(scheduleOne.Id));
        System.assertEquals(Date.today().addDays(125), schedules.get(scheduleTwo.Id));
    }
  }