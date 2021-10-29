/**
 * Created by Satya Mohanty on 4/15/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
private class TestPlatformBuilder_Test {

    @IsTest
    static void testDefaultBuild() {
        System.Test.startTest();
        Platform__c platform = new TestPlatformBuilder()
                .build();
        System.Test.stopTest();
        System.assertEquals(null, platform.Id );
        System.assertEquals('Test Platform', platform.Name );
        System.assertEquals('36-16A', platform.Model__c );
        System.assertEquals('Various OEMS', platform.Make__c );
        System.assertEquals(true, platform.SAP_External_System__c );
    }
    @IsTest
    static void testDefaultBuildWithAddField() {
        System.Test.startTest();
        Platform__c platform = new TestPlatformBuilder()
                .build();
        System.Test.stopTest();
        System.assertEquals(null, platform.Id );
        System.assertEquals('Test Platform', platform.Name );
        System.assertEquals('36-16A', platform.Model__c );
        System.assertEquals('Various OEMS', platform.Make__c );
        System.assertEquals(true, platform.SAP_External_System__c );
    }
    @IsTest
    static void testGenerate() {
        System.Test.startTest();
        Platform__c platform = new TestPlatformBuilder()
                .setName('Test Platform')
                .setModel('36-16A')
                .setMake('Various OEMS')
                .setSAPExternalSystem(true)
                .generate();
        System.Test.stopTest();

        System.assertEquals('Test Platform', platform.Name );
        System.assertEquals('36-16A', platform.Model__c );
        System.assertEquals('Various OEMS', platform.Make__c );
        System.assertEquals(true, platform.SAP_External_System__c );
    }
}