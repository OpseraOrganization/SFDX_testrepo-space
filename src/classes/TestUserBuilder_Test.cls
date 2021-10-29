/**
 * Created by Nikolay Kolev on 4/12/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class TestUserBuilder_Test {

    @IsTest
    static void testBuild() {
        System.Test.startTest();
        User user = new  TestUserBuilder()
                .build();
        System.Test.stopTest();

        System.assertEquals(null, user.Id);
        System.assertEquals('John', user.FirstName);
        System.assertEquals('Doe', user.LastName);
        System.assertEquals('jdoey', user.Alias);
        System.assertEquals([
                        SELECT Id
                        FROM Profile
                        WHERE Name = 'System Administrator'
                        ].Id,
                user.ProfileId);
    }
    @IsTest
    static void testGenerate() {
        System.Test.startTest();
        User user = new  TestUserBuilder()
                .setFirstName('Jane')
                .setLastName('Doey')
                .setAlias('jdoey')
                .addField('TimezoneSidKey', 'America/Phoenix')
                .generate();
        System.Test.stopTest();

        User insertedUser = [
                SELECT Id
                FROM User
                WHERE FirstName = 'Jane'
                AND LastName = 'Doey'
                AND Alias = 'jdoey'
                AND TimezoneSidKey = 'America/Phoenix'
        ];

        System.assertEquals(insertedUser.Id, user.Id);
        System.assertEquals('Jane', user.FirstName);
        System.assertEquals('Doey', user.LastName);
        System.assertEquals('jdoey', user.Alias);
        System.assertEquals([
                SELECT Id
                FROM Profile
                WHERE Name = 'System Administrator'
        ].Id,
                user.ProfileId);
        System.assertEquals('America/Phoenix', user.TimezoneSidKey);
    }
}