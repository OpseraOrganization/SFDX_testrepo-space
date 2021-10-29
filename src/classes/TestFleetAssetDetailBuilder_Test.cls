/**
 * Created by Nikolay Kolev on 4/18/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class TestFleetAssetDetailBuilder_Test {
    @IsTest
    static void testDefaultBuild() {
        System.Test.startTest();
        Fleet_Asset_Detail__c fleetAssetDetail = new TestFleetAssetDetailBuilder()
                .build();
        System.Test.stopTest();

        System.assertEquals(null, fleetAssetDetail.Id);
        System.assertEquals('Test_Fleet_Asset_Detail',fleetAssetDetail.Name);
    }
    @IsTest
    static void testDefaultBuildSetName() {
        System.Test.startTest();
        Fleet_Asset_Detail__c fleetAssetDetail = new TestFleetAssetDetailBuilder()
                .setName('My_Fleet_Asset_Detail')
                .build();
        System.Test.stopTest();

        System.assertEquals(null, fleetAssetDetail.Id);
        System.assertEquals('My_Fleet_Asset_Detail',fleetAssetDetail.Name);
    }
    @IsTest
    static void testGenerate() {
        Platform__c platform = new TestPlatformBuilder().generate();

        System.Test.startTest();
        Fleet_Asset_Detail__c fleetAssetDetail = new TestFleetAssetDetailBuilder()
                .addField('Status__c', 'In Service')
                .setPlatform(platform.Id)
                .generate();
        System.Test.stopTest();

        Fleet_Asset_Detail__c insertedFleetAssetDetail = [
                SELECT
                        Id,
                        Platform_Name__c
                FROM Fleet_Asset_Detail__c
                WHERE Id = :fleetAssetDetail.Id
                AND Status__c = 'In Service'
                AND Platform_Name__c = :platform.Id
        ];

        System.assertEquals(insertedFleetAssetDetail.Id, fleetAssetDetail.Id);
    }
}