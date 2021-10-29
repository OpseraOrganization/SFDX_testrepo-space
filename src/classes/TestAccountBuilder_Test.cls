/**
 * Created by Satya Mohanty on 4/10/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
public class TestAccountBuilder_Test {

    @IsTest
    static void testDefaultBuild() {
        System.Test.startTest();
        Account acc  = new TestAccountBuilder()
        .build();
        System.Test.stopTest();

        System.assertEquals(null, acc.Id);
        System.assertEquals('Testaccount',acc.Name);
    }
    @IsTest
    static void testGenerate() {
        System.Test.startTest();
        Account acc = new TestAccountBuilder()
                .setName('My Account')
                .addField('NumberOfEmployees', 111)
                .generate();
        System.Test.stopTest();

        Account insertedAccount = [
                SELECT Id
                FROM Account
                WHERE Name = 'My Account'
                AND NumberOfEmployees = 111
        ];

        System.assertEquals(insertedAccount.Id, acc.Id);
        System.assertEquals('My Account', acc.Name);
        System.assertEquals(111, acc.NumberOfEmployees);
    }

}