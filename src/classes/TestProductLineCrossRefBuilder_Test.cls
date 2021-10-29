/**
 * Created by Nikolay Kolev on 4/16/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class TestProductLineCrossRefBuilder_Test {
    private static Contact contact;
    private static Product_Line__c productLine;
    static void init() {
        contact = new TestContactBuilder().generate();
        productLine = new TestProductTypeBuilder().generate();
    }
    @IsTest
    static void testDefaultBuild() {
        init();

        System.Test.startTest();
        Product_Line_Cross_Ref__c crossRef  = new TestProductLineCrossRefBuilder()
                .setProductLeader(contact.Id)
                .setProductType(productLine.Id)
                .build();
        System.Test.stopTest();

        System.assertEquals(null, crossRef.Id);
        System.assertEquals('testpl', crossRef.Name);
        System.assertEquals(contact.Id, crossRef.Product_Leader__c);
        System.assertEquals(productLine.Id, crossRef.Product_Line__c);
    }
    @IsTest
    static void testGenerateWithNameAndAddField() {
        init();

        System.Test.startTest();
        Product_Line_Cross_Ref__c crossRef  = new TestProductLineCrossRefBuilder('Test Cross Ref')
                .addField('Product_Line_Cross_Ref_Type__c', 'Product')
                .setProductLeader(contact.Id)
                .setProductType(productLine.Id)
                .generate();
        System.Test.stopTest();

        Product_Line_Cross_Ref__c insertedCrossRef = [
                SELECT
                        Id,
                        Name,
                        Product_Line_Cross_Ref_Type__c,
                        Product_Leader__c,
                        Product_Line__c
                FROM Product_Line_Cross_Ref__c
                WHERE Id = :crossRef.Id
                AND Product_Leader__c = :contact.Id
                AND Product_Line__c = :productLine.Id
                AND Product_Line_Cross_Ref_Type__c = 'Product'
        ];

        System.assertEquals(insertedCrossRef.Id, crossRef.Id);
        System.assertEquals(insertedCrossRef.Name, crossRef.Name);
        System.assertEquals(insertedCrossRef.Product_Leader__c, crossRef.Product_Leader__c);
        System.assertEquals(insertedCrossRef.Product_Line__c, crossRef.Product_Line__c);
        System.assertEquals(insertedCrossRef.Product_Line_Cross_Ref_Type__c, crossRef.Product_Line_Cross_Ref_Type__c);
    }
}