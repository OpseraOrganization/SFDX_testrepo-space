/**
 * Created by Satya Mohanty on 4/9/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
private class TestProductLineTechSalesBuilder_Test {
    private static Product_Line__c productLine;
    private static final String BGA_AFTERMARKET = 'BGA Aftermarket';
    private static final String AMERICAS = 'Americas';
    private static final String BGA = 'BGA';
    private static final String TEST_PRODUCT_LINE = 'Test Product Line';

    private static void init() {
        productLine = new TestProductTypeBuilder()
                .setName(TEST_PRODUCT_LINE)
                .generate();
    }

    @IsTest
    static void testDefaultBuild() {
        System.Test.startTest();
        Product_Line_Tech_Sales__c productLineTechSales = new  TestProductLineTechSalesBuilder()
        .build();
        System.Test.stopTest();

        System.assertEquals(null, productLineTechSales.Id);
        System.assertEquals(BGA_AFTERMARKET, productLineTechSales.CBT__c);
        System.assertEquals(BGA, productLineTechSales.SBU__c);
        System.assertEquals(AMERICAS, productLineTechSales.Region__c);
    }
    @IsTest
    static void testDefaultBuildWithAddField() {
        System.Test.startTest();
        Product_Line_Tech_Sales__c productLineTechSales = new TestProductLineTechSalesBuilder()
                .addField('SBU__c', BGA)
                .build();
        System.Test.stopTest();

        System.assertEquals(null, productLineTechSales.Id);
        System.assertEquals(BGA_AFTERMARKET,productLineTechSales.CBT__c);
        System.assertEquals(BGA,productLineTechSales.SBU__c);
        System.assertEquals(AMERICAS, productLineTechSales.Region__c);
    }
    @IsTest
    static void testGenerate() {
        init();

        System.Test.startTest();
        Product_Line_Tech_Sales__c productLineTechSales = new TestProductLineTechSalesBuilder()
                .setCBT(BGA_AFTERMARKET)
                .setSBU(BGA)
                .setRegion(AMERICAS)
                .setProductLine(productLine.Id)
                .generate();
        System.Test.stopTest();

        Product_Line_Tech_Sales__c insertedProductLineTechSales = [
                SELECT Id
                FROM Product_Line_Tech_Sales__c
                WHERE CBT__c = :BGA_AFTERMARKET
                AND SBU__c = :BGA
                AND Product_Line__c = :productLine.Id
        ];

        System.assertEquals(insertedProductLineTechSales.Id, productLineTechSales.Id);
        System.assertEquals(BGA_AFTERMARKET, productLineTechSales.CBT__c);
        System.assertEquals(BGA, productLineTechSales.SBU__c);
        System.assertEquals(AMERICAS, productLineTechSales.Region__c);
    }
}