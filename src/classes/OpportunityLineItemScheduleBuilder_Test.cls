/**
 * Created by Satya Mohanty on 4/19/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
private class OpportunityLineItemScheduleBuilder_Test {

    private static Product_Line__c productLine;
    private static Contact contact;
    private static Product_Line_Cross_Ref__c productLineCrossRef;
    private static Opportunity testOpportunity;
    private final static String BENDIXKING = 'BendixKing';
    private static Pricebook2 pbook;
    private static PricebookEntry pbookEntry;
    private static OpportunityLineItem testLineItem;

    private static void init() {
        contact = new TestContactBuilder().generate();
        testOpportunity = new TestOpportunityBuilder('Test', BENDIXKING)
                .generate();
        pbook = new TestPricebookBuilder()
                .generate();
        Product2 product  = new TestProductBuilder()
                .addField('CanUseRevenueSchedule', true)
                .addField('ProductCode','xxx')
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

        testLineItem = new TestOpportunityLineItemBuilder()
                .setServiceDate(Date.today())
                .setUnitPrice(100)
                .setQuantity(10)
                .setproductCrossReferenceId(productLineCrossRef.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .setType('Forecast')
                .addField('OpportunityId', testOpportunity.Id)
                .generate();
    }
    @IsTest
    static void testDefaultBuild(){
        System.Test.startTest();
        OpportunityLineItemSchedule lineItemSchedule = new TestOpportunityLineItemScheduleBuilder()
                .build();
        System.Test.stopTest();

        System.assertEquals(null,lineItemSchedule.Id);
        System.assertEquals(10,lineItemSchedule.Revenue);
    }
    @IsTest
    static void testDefaultBuildWithaddField(){
        System.Test.startTest();
        OpportunityLineItemSchedule lineItemSchedule = new TestOpportunityLineItemScheduleBuilder()
                .addField('OpportunityLineItemId','OpportunityLineItemId')
                .build();
        System.Test.stopTest();

        System.assertEquals(null,lineItemSchedule.Id);
        System.assertEquals(10,lineItemSchedule.Revenue);
    }
    @IsTest
    static void testGenerate() {
        init();
        System.Test.startTest();
        OpportunityLineItemSchedule lineItemSchedule = new TestOpportunityLineItemScheduleBuilder()
                .setRevenue(10)
                .setOpportunityLineItemId(testLineItem.Id)
                .setScheduledDate(Date.today())
                .setType('Revenue')
                .generate();

        System.Test.stopTest();
        OpportunityLineItemSchedule insertlineItemSchedule =[
                SELECT Id
                FROM OpportunityLineItemSchedule
                WHERE Revenue = 10
                AND Id = :lineItemSchedule.Id
        ];
        System.assertEquals(insertlineItemSchedule.Id,lineItemSchedule.Id);
        System.assertEquals(10,lineItemSchedule.Revenue);
        System.assertEquals('Revenue',lineItemSchedule.Type);
        System.assertEquals(testLineItem.Id, lineItemSchedule.OpportunityLineItemId);
    }
}