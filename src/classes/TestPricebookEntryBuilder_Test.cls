/**
 * Created by Nikolay Kolev on 4/12/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class TestPricebookEntryBuilder_Test {
    private static Pricebook2 pbook;
    private static Product2 product;

    static void init() {
        pbook = new TestPricebookBuilder()
                .generate();

        product  = new TestProductBuilder()
                .generate();

        PricebookEntry standardPricebookEntry= new PriceBookEntry(
                Pricebook2Id = System.Test.getStandardPricebookId(),
                Product2Id = product.Id,
                UnitPrice = 50
        );
        Database.insert(standardPricebookEntry);
    }
    @IsTest
    static void testDefaultBuild() {
        init();

        System.Test.startTest();
        PricebookEntry pbookEntry = new TestPricebookEntryBuilder()
                .setPricebook(pbook.Id)
                .setProduct(product.Id)
                .setIsActive(false)
                .build();
        System.Test.stopTest();

        System.assertEquals(null, pbookEntry.Id);
        System.assertEquals(pbook.Id, pbookEntry.Pricebook2Id);
        System.assertEquals(product.Id, pbookEntry.Product2Id);
        System.assertEquals(false, pbookEntry.IsActive);
    }
    @IsTest
    static void testGenerateWithAddField() {
        init();

        System.Test.startTest();
        PricebookEntry pbookEntry = new TestPricebookEntryBuilder()
                .setPricebook(pbook.Id)
                .setProduct(product.Id)
                .addField('SIOP_Product__c',true)
                .generate();
        System.Test.stopTest();

        PricebookEntry insertedPbookEntry = [
                SELECT Id
                FROM PricebookEntry
                WHERE Pricebook2Id = :pbook.Id
                AND Product2Id = :product.Id
        ];

        System.assertEquals(insertedPbookEntry.Id, pbookEntry.Id);
        System.assertEquals(pbook.Id, pbookEntry.Pricebook2Id);
        System.assertEquals(product.Id, pbookEntry.Product2Id);
        System.assertEquals(true, pbookEntry.IsActive);
    }
}