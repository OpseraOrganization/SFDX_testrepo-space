/**
 * Created by Nikolay Kolev on 4/11/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class SetTechSalesFromProductLineTechSale_Test {
    private static Product_Line__c productLine;
    private static Contact contact;
    private static Product_Line_Cross_Ref__c productLineCrossRef;
    private static Opportunity testOpportunity;
    private final static String BENDIXKING = 'BendixKing';
    private final static String BK_FLIGHT_CONTROLS = 'BK-Flight Controls';
    private static Pricebook2 pbook;
    private static PricebookEntry pbookEntry;
    private static OpportunityLineItem lineItem;
    private static Product_Line_Tech_Sales__c productLineTechSales;
    private static User techSalesManager;

    private static void init() {
        contact = new TestContactBuilder().generate();
        testOpportunity = new TestOpportunityBuilder('Test', BENDIXKING)
                .generate();
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
        // Create OpportunityLineItem using the lineItemBuilder class.
        lineItem = new TestOpportunityLineItemBuilder()
                .setServiceDate(Date.today())
                .setProductCrossReferenceId(productLineCrossRef.Id)
                .setOpportunityId(testOpportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();
        // Create Product Type using the builder class.
        Product_Line__c productLine = new TestProductTypeBuilder().generate();
        techSalesManager = new TestUserBuilder().generate();
        // Create Product Line Tech Sale using the tech sale builder class.
        productLineTechSales = new TestProductLineTechSalesBuilder()
                .setCBT('BGA Aftermarket')
                .setSBU('BGA')
                .setRegion('Americas')
                .setProductLine(productLine.Id)
                .addField('Tech_Sales__c', BENDIXKING)
                .addField('Tech_Sales_Product__c', BK_FLIGHT_CONTROLS)
                .addField('Tech_Sales_Manager__c', techSalesManager.Id)
                .generate();
    }

    @IsTest
    static void testBehavior() {
        init();

        System.Test.startTest();
        SetTechSalesFromProductLineTechSale techSalesSetter = new SetTechSalesFromProductLineTechSale(
                lineItem,
                productLineTechSales
        );
        techSalesSetter.setTechSales();
        System.Test.stopTest();

        System.assertEquals(BENDIXKING, lineItem.Tech_Sales__c);
        System.assertEquals(BK_FLIGHT_CONTROLS, lineItem.Tech_Sales_Product__c);
        System.assertEquals(techSalesManager.Id, lineItem.Tech_Sales_Manager__c);
    }
}