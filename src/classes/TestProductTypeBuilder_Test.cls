/**
 * Created by Satya Mohanty on 4/10/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
public class TestProductTypeBuilder_Test {

    @IsTest
    static void testDefaultBuild() {
        System.Test.startTest();
        Product_Line__c pl  = new TestProductTypeBuilder()
                .addField('Active__c', true)
                .build();
        System.Test.stopTest();

        System.assertEquals(null, pl.Id);
        System.assertEquals('testpl',pl.Name);
        System.assertEquals(true,pl.Active__c);
    }
    @IsTest
    static void testDefaultBuildwithName() {
        System.Test.startTest();
        Product_Line__c pl  = new TestProductTypeBuilder()
            .build();
        System.Test.stopTest();

        System.assertEquals(null, pl.Id);
        System.assertEquals('testpl',pl.Name);
    }
    @IsTest
    static void testGenerate() {
        System.Test.startTest();
        Product_Line__c pl = new TestProductTypeBuilder()
                .setName('testpl')
                .generate();
        System.Test.stopTest();

        Product_Line__c insertedPl = [
                SELECT Id
                FROM Product_Line__c
                WHERE Name = 'testpl'
        ];

        System.assertEquals(insertedPl.Id, pl.Id);
        System.assertEquals('testpl', pl.Name);
    }
}