/**
 * Created by Nikolay Kolev on 4/16/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class TestRmuProductBuilder_Test {
    @IsTest
    static void testDefaultBuild() {
        System.Test.startTest();
        Rmu_Product__c rmuProduct = new TestRmuProductBuilder()
                .build();
        System.Test.stopTest();

        System.assertEquals(null, rmuProduct.Id);
        System.assertEquals('Test Rmu Product',rmuProduct.Name);
    }
    @IsTest
    static void testGenerate() {
        Product2 product = new TestProductBuilder().generate();

        Rmu_Value__c rmuValue = new TestRmuValueBuilder().generate();

        System.Test.startTest();
        Rmu_Product__c rmuProduct = new TestRmuProductBuilder()
                .setName('My Rmu Product')
                .addField('Rmu_Product__c', product.Id)
                .setRmuValue(rmuValue.Id)
                .generate();
        System.Test.stopTest();

        Rmu_Product__c insertedRmuProduct = [
                SELECT Id
                FROM Rmu_Product__c
                WHERE Name = 'My Rmu Product'
                AND Rmu_Product__c = :product.Id
                AND Id = :rmuProduct.Id
                AND RMU__c = :rmuValue.Id
        ];

        System.assertEquals(insertedRmuProduct.Id, rmuProduct.Id);
        System.assertEquals('My Rmu Product', rmuProduct.Name);
        System.assertEquals(product.Id, rmuProduct.Rmu_Product__c);
        System.assertEquals(rmuValue.Id, rmuProduct.RMU__c);
    }
}