/**
 * Created by Nikolay Kolev on 4/12/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class TestContactBuilder_Test {
    @IsTest
    static void testBuild() {
        System.Test.startTest();
        Contact testContact  = new TestContactBuilder('Doe')
                .build();
        System.Test.stopTest();

        System.assertEquals(null, testContact.Id);
        System.assertEquals('Doe', testContact.LastName);
        System.assertEquals('John',testContact.FirstName);
    }
    @IsTest
    static void testDefaultBuildWithAddField(){
        System.Test.startTest();
        Contact testContact = new TestContactBuilder()
                .addField('SBU_Contact__c','ATR')
                .build();
        System.Test.stopTest();

        System.assertEquals(null,testContact.Id);
        System.assertEquals('Doe',testContact.LastName);
        System.assertEquals('John',testContact.FirstName);
    }
    @IsTest
    static void testGenerate() {
        System.Test.startTest();
        Contact testContact  = new TestContactBuilder('Doe')
                .generate();
        System.Test.stopTest();

        Contact insertedContact = [
                SELECT Id
                FROM Contact
                WHERE LastName = 'Doe'
        ];

        System.assertEquals(insertedContact.Id, testContact.Id);
        System.assertEquals('Doe', testContact.LastName);
        System.assertEquals('John',testContact.FirstName);
    }
}