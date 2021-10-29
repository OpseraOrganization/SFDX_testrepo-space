/**
 * Created by Nikolay Kolev on 4/12/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class TestPricebookBuilder_Test {
    private static String TEST_PRICEBOOK = 'Test Pricebook';
    @IsTest
    static void testDefaultBuild() {
        System.Test.startTest();
        Pricebook2 pbook  = new TestPricebookBuilder()
                .build();
        System.Test.stopTest();

        System.assertEquals(null, pbook.Id);
        System.assertEquals(TEST_PRICEBOOK, pbook.Name);
    }
    @IsTest
    static void testDefaultBuildWithAddName() {
        System.Test.startTest();
        Pricebook2 pbook  = new TestPricebookBuilder()
                .addField('Name', 'Test')
                .build();
        System.Test.stopTest();

        System.assertEquals(null, pbook.Id);
        System.assertEquals('Test', pbook.Name);
    }
    @IsTest
    static void testDefaultBuildwithName() {
        System.Test.startTest();
        Pricebook2 pbook  = new TestPricebookBuilder('My Book')
                .build();
        System.Test.stopTest();

        System.assertEquals(null, pbook.Id);
        System.assertEquals('My Book', pbook.Name);
    }
    @IsTest
    static void testGenerate() {
        System.Test.startTest();
        Pricebook2 pbook = new TestPricebookBuilder()
                .generate();
        System.Test.stopTest();

        Pricebook2 insertedPb = [
                SELECT Id
                FROM Pricebook2
                WHERE Name = :TEST_PRICEBOOK
        ];

        System.assertEquals(insertedPb.Id, pbook.Id);
        System.assertEquals(TEST_PRICEBOOK, pbook.Name);
    }
}