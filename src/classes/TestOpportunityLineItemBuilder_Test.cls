/**
 * Created by Satya Mohanty on 4/9/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
private  class TestOpportunityLineItemBuilder_Test {
    private static Product_Line__c productLine;
    private static Contact contact;
    private static Product_Line_Cross_Ref__c productLineCrossRef;
    private static Opportunity testOpportunity;
    private final static String BENDIXKING = 'BendixKing';
    private static Pricebook2 pbook;
    private static PricebookEntry pbookEntry;

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
        productLine = new TestProductTypeBuilder()
                .setName('testpl')
                .generate();
        productLineCrossRef = new TestProductLineCrossRefBuilder('TestName')
                .setProductType(productLine.Id)
                .setProductLeader(contact.Id)
                .generate();
    }

    @IsTest
    static void testDefaultBuild() {
        init();

        System.Test.startTest();
        OpportunityLineItem testLineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(testOpportunity.Id)
                .setProductCrossReferenceId(productLineCrossRef.Id)
                .build();
        System.Test.stopTest();

        System.assertEquals(null, testLineItem.Id);
        System.assertEquals(Date.today().addDays(30), testLineItem.ServiceDate);
        System.assertEquals(100, testLineItem.UnitPrice);
        System.assertEquals(1, testLineItem.Quantity);
        System.assertEquals('Forecast', testLineItem.Type__c);
        System.assertEquals(productLineCrossRef.Id,testLineItem.M_PM_Product__c);

    }
    @IsTest
    static void testGenerate() {
        init();

        System.Test.startTest();
        OpportunityLineItem testLineItem = new TestOpportunityLineItemBuilder()
            .setServiceDate(Date.today())
            .setUnitPrice(100)
            .setQuantity(1)
            .setproductCrossReferenceId(productLineCrossRef.Id)
            .setPricebookEntryId(pbookEntry.Id)
            .setType('Forecast')
            .addField('OpportunityId', testOpportunity.Id)
            .generate();
        System.Test.stopTest();

        OpportunityLineItem insertedLineItem = [
                SELECT Id
                FROM OpportunityLineItem
                WHERE Type__c = 'Forecast'
                AND UnitPrice = 100
                AND ServiceDate = :Date.today()
                AND Quantity = 1
                AND M_PM_Product__c = :productLineCrossRef.Id
        ];
        
        System.assertEquals(insertedLineItem.Id, testLineItem.Id);
        System.assertEquals(Date.today(), testLineItem.ServiceDate);
        System.assertEquals(100, testLineItem.UnitPrice);
        System.assertEquals(1, testLineItem.Quantity);
        System.assertEquals('Forecast', testLineItem.Type__c);
        System.assertEquals(productLineCrossRef.Id, testLineItem.M_PM_Product__c);
        System.assertEquals(testOpportunity.Id, testLineItem.OpportunityId);
    }
}