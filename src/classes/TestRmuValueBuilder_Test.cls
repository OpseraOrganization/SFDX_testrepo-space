/**
 * Created by Nikolay Kolev on 4/16/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class TestRmuValueBuilder_Test {
    @IsTest
    static void testDefaultBuild() {
        System.Test.startTest();
        Rmu_Value__c rmuValue = new TestRmuValueBuilder()
                .build();
        System.Test.stopTest();

        System.assertEquals(null, rmuValue.Id);
        System.assertEquals('Test Rmu Value',rmuValue.Name);
    }
    @IsTest
    static void testGenerate() {
        System.Test.startTest();
        Rmu_Value__c rmuValue = new TestRmuValueBuilder()
                .setName('My Rmu Value')
                .addField('RMU_Type__c', 'Product')
                .generate();
        System.Test.stopTest();

        Rmu_Value__c insertedRmuProduct = [
                SELECT Id
                FROM Rmu_Value__c
                WHERE Name = 'My Rmu Value'
                AND Id = :rmuValue.Id
                AND RMU_Type__c = 'Product'
        ];

        System.assertEquals(insertedRmuProduct.Id, rmuValue.Id);
        System.assertEquals('My Rmu Value', rmuValue.Name);
    }
}