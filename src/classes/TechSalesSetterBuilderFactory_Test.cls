/**
 * Created by Nikolay Kolev on 4/15/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class TechSalesSetterBuilderFactory_Test {
    private static Product_Line__c productLine;
    private static Contact contact;
    private static Product_Line_Cross_Ref__c productLineCrossRef;
    private static Opportunity baseOpportunity;
    private final static String BENDIXKING = 'BendixKing';
    private final static String PRODUCT_LINE_TECH_SALES = 'Test Sales';
    private final static String BGA = 'BGA';
    private final static String AMERICAS = 'Americas';
    private final static String AMERICA = 'America';
    private static Pricebook2 pbook;
    private static PricebookEntry pbookEntry;
    private static OpportunityLineItem insertedLineItem;
    private final static String BK_FLIGHT_CONTROLS = 'BK-Flight Controls';
    private static User opportunityTechSalesManager;
    private static User productLineTechSalesManager;
    private static Map<String, Id> users;
    private static Product_Line_Tech_Sales__c insertedProductLineTechSales;
    private static Map<Integer, Product_Line_Tech_Sales__c> productLineTechSales = new Map<Integer, Product_Line_Tech_Sales__c>();

    private static void init() {
        Account acct = new TestAccountBuilder()
                .addField('Report_Country_Name__c', AMERICA)
                .addField('Region_Name__c', AMERICAS)
                .generate();
        contact = new TestContactBuilder().generate();
        pbook = new TestPricebookBuilder()
                .generate();
        Product2 product  = new TestProductBuilder()
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
        opportunityTechSalesManager = new TestUserBuilder().generate();
        productLineTechSalesManager = new TestUserBuilder().generate();
        baseOpportunity = new TestOpportunityBuilder('Test', BENDIXKING)
                .addField('Tech_Sales__c', BENDIXKING)
                .addField('Tech_Sales_Product_Area__c', BK_FLIGHT_CONTROLS)
                .addField('Tech_Sales1__c', opportunityTechSalesManager.Name)
                .addField('Default_Tech_Sales__c', BENDIXKING)
                .addField('Default_Tech_Sales_Product__c', BK_FLIGHT_CONTROLS)
                .addField('Default_Tech_Sales_Manager__c', opportunityTechSalesManager.Id)
                .addField('SBU__c', BGA)
                .addField('AccountId', acct.Id)
                .generate();
        // Create OpportunityLineItem using the lineItemBuilder class.
        OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setServiceDate(Date.today())
                .setproductCrossReferenceId(productLineCrossRef.Id)
                .setOpportunityId(baseOpportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();
        // Querrying for the OLI in order to get the formula field values like region/country and sbu.
        insertedLineItem = [
                SELECT
                        Id,
                        SBU__c,
                        Tech_Sales_Product_Line__c,
                        Tech_Sales_Region__c,
                        Tech_Sales_Country__c
                FROM OpportunityLineItem
                WHERE Id = :lineItem.Id
        ];
        // Create Product Line Tech Sale using the tech sale builder class.
        Product_Line_Tech_Sales__c productLineTechSalesMain = new TestProductLineTechSalesBuilder()
                .setSBU(BGA)
                .setRegion(AMERICAS)
                .addField('Country__c', AMERICA)
                .setProductLine(productLine.Id)
                .addField('Tech_Sales__c', PRODUCT_LINE_TECH_SALES)
                .addField('Tech_Sales_Product__c', PRODUCT_LINE_TECH_SALES)
                .addField('Tech_Sales_Manager__c', productLineTechSalesManager.Id)
                .generate();
        // Querrying for the product line tech sales to get the product_line__r.name relationship availbale.
        insertedProductLineTechSales = [
                SELECT
                        Id,
                        Country__c,
                        Tech_Sales__c,
                        Product_Line__r.Name,
                        Region__c,
                        SBU__c,
                        Tech_Sales_Product__c,
                        Tech_Sales_Manager__c
                FROM Product_Line_Tech_Sales__c
                WHERE Id = :productLineTechSalesMain.Id
                LIMIT 1
        ];
        productLineTechSales.put(
                new TechSalesHashBuilder()
                        .setName(insertedProductLineTechSales.Product_Line__r.Name)
                        .setSbu(insertedProductLineTechSales.SBU__c)
                        .setRegion(insertedProductLineTechSales.Region__c)
                        .setCountry(insertedProductLineTechSales.Country__c)
                        .getHash(TechSalesHashBuilder.Criteria.ALL),
                insertedProductLineTechSales
        );
        users = new Map<String, Id>();
        users.put(opportunityTechSalesManager.Name, opportunityTechSalesManager.Id);
    }
    @IsTest
    static void testDefaultTechSalesPath() {
        init();

        System.Test.startTest();
        TechSalesSettable techSalesSetter = TechSalesSetterBuilderFactory.getTechSalesSetter(
                baseOpportunity,
                insertedLineItem,
                productLineTechSales,
                users
        );
        techSalesSetter.setTechSales();
        System.Test.stopTest();

        System.assertEquals(BENDIXKING, insertedLineItem.Tech_Sales__c);
        System.assertEquals(BK_FLIGHT_CONTROLS, insertedLineItem.Tech_Sales_Product__c);
        System.assertEquals(opportunityTechSalesManager.Id, insertedLineItem.Tech_Sales_Manager__c);
    }
    /**
     * Get rid of the default tech sales on Opportunity and the product line tech sales to force the factory to go
     * through the base tech sales on Opportunity when assigning the tech sales to the line item.
     */
    @IsTest
    static void testBaseOpportunityPath() {
        init();

        productLineTechSales = new Map<Integer, Product_Line_Tech_Sales__c>();

        baseOpportunity.Default_Tech_Sales__c = null;
        baseOpportunity.Default_Tech_Sales_Product__c = null;
        baseOpportunity.Default_Tech_Sales_Manager__c = new TestUserBuilder().generate().Id;
        update baseOpportunity;

        System.Test.startTest();
        TechSalesSettable techSalesSetter = TechSalesSetterBuilderFactory.getTechSalesSetter(
                baseOpportunity,
                insertedLineItem,
                productLineTechSales,
                users
        );
        techSalesSetter.setTechSales();
        System.Test.stopTest();

        System.assertEquals(BENDIXKING, insertedLineItem.Tech_Sales__c);
        System.assertEquals(BK_FLIGHT_CONTROLS, insertedLineItem.Tech_Sales_Product__c);
        System.assertEquals(opportunityTechSalesManager.Id, insertedLineItem.Tech_Sales_Manager__c);
    }
    // Get rid of default tech sales in order to set the tech sales through the product line tech sales.
    @IsTest
    static void testProductLineTechSalesAllPath() {
        init();

        baseOpportunity.Default_Tech_Sales__c = null;
        baseOpportunity.Default_Tech_Sales_Product__c = null;
        baseOpportunity.Default_Tech_Sales_Manager__c = null;
        update baseOpportunity;

        System.Test.startTest();
        TechSalesSettable techSalesSetter = TechSalesSetterBuilderFactory.getTechSalesSetter(
                baseOpportunity,
                insertedLineItem,
                productLineTechSales,
                users
        );
        techSalesSetter.setTechSales();
        System.Test.stopTest();

        System.assertEquals(PRODUCT_LINE_TECH_SALES, insertedLineItem.Tech_Sales__c);
        System.assertEquals(PRODUCT_LINE_TECH_SALES, insertedLineItem.Tech_Sales_Product__c);
        System.assertEquals(productLineTechSalesManager.Id, insertedLineItem.Tech_Sales_Manager__c);
    }
    // Get rid of the country on product line tech sales but verify that it still pulls from that object.
    @IsTest
    static void testProductLineTechSalesNoCountryPath() {
        init();

        baseOpportunity.Default_Tech_Sales__c = null;
        baseOpportunity.Default_Tech_Sales_Product__c = null;
        baseOpportunity.Default_Tech_Sales_Manager__c = null;
        update baseOpportunity;

        insertedProductLineTechSales.Country__c = null;
        productLineTechSales = new Map<Integer, Product_Line_Tech_Sales__c>();
        productLineTechSales.put(
                new TechSalesHashBuilder()
                        .setName(insertedProductLineTechSales.Product_Line__r.Name)
                        .setSbu(insertedProductLineTechSales.SBU__c)
                        .setRegion(insertedProductLineTechSales.Region__c)
                        .getHash(TechSalesHashBuilder.Criteria.ALL),
                insertedProductLineTechSales
        );

        System.Test.startTest();
        TechSalesSettable techSalesSetter = TechSalesSetterBuilderFactory.getTechSalesSetter(
                baseOpportunity,
                insertedLineItem,
                productLineTechSales,
                users
        );
        techSalesSetter.setTechSales();
        System.Test.stopTest();

        System.assertEquals(PRODUCT_LINE_TECH_SALES, insertedLineItem.Tech_Sales__c);
        System.assertEquals(PRODUCT_LINE_TECH_SALES, insertedLineItem.Tech_Sales_Product__c);
        System.assertEquals(productLineTechSalesManager.Id, insertedLineItem.Tech_Sales_Manager__c);
    }
    // Get rid of country AND region and ensure that no tech sales get assigned to OLI since there's no match.
    @IsTest
    static void testProductLineTechSalesNoCountryAndNoRegionPath() {
        init();

        baseOpportunity.Default_Tech_Sales__c = null;
        baseOpportunity.Default_Tech_Sales_Product__c = null;
        baseOpportunity.Default_Tech_Sales_Manager__c = null;
        baseOpportunity.Tech_Sales__c = null;
        baseOpportunity.Tech_Sales_Product_Area__c = null;
        baseOpportunity.Tech_Sales1__c = null;
        update baseOpportunity;

        insertedProductLineTechSales.Country__c = null;
        insertedProductLineTechSales.Region__c = null;
        productLineTechSales = new Map<Integer, Product_Line_Tech_Sales__c>();
        productLineTechSales.put(
                new TechSalesHashBuilder()
                        .setName(insertedProductLineTechSales.Product_Line__r.Name)
                        .setSbu(insertedProductLineTechSales.SBU__c)
                        .getHash(TechSalesHashBuilder.Criteria.ALL),
                insertedProductLineTechSales
        );

        users = new Map<String, Id>();

        System.Test.startTest();
        TechSalesSettable techSalesSetter = TechSalesSetterBuilderFactory.getTechSalesSetter(
                baseOpportunity,
                insertedLineItem,
                productLineTechSales,
                users
        );
        techSalesSetter.setTechSales();
        System.Test.stopTest();

        // Asserting that the values are null since the region is missing on the product line tech sales.
        System.assertEquals(null, insertedLineItem.Tech_Sales__c);
        System.assertEquals(null, insertedLineItem.Tech_Sales_Product__c);
        System.assertEquals(null, insertedLineItem.Tech_Sales_Manager__c);
    }
}