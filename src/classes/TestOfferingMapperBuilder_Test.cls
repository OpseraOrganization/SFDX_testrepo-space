/**
 * Created by Nikolay Kolev on 4/17/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class TestOfferingMapperBuilder_Test {
    @IsTest
    static void testDefaultBuild() {
        System.Test.startTest();
        OFFERING_MAPPER__c offeringMapper = new TestOfferingMapperBuilder()
                .build();
        System.Test.stopTest();

        System.assertEquals(null, offeringMapper.Id);
        System.assertEquals('Test_Offering_Mapper',offeringMapper.Name);
    }
    @IsTest
    static void testDefaultBuildWithSetName() {
        System.Test.startTest();
        OFFERING_MAPPER__c offeringMapper = new TestOfferingMapperBuilder()
                .setName('My_Offering_Mapper')
                .build();
        System.Test.stopTest();

        System.assertEquals(null, offeringMapper.Id);
        System.assertEquals('My_Offering_Mapper',offeringMapper.Name);
    }
    @IsTest
    static void testGenerate() {
        RMU_VALUE__c rmuValue = new TestRmuValueBuilder()
                .generate();

        System.Test.startTest();
        OFFERING_MAPPER__c offeringMapper = new TestOfferingMapperBuilder()
                .setRmuValue(rmuValue.Id)
                .generate();
        System.Test.stopTest();

        OFFERING_MAPPER__c insertedOfferingMapper = [
                SELECT Id, Name
                FROM OFFERING_MAPPER__c
                WHERE Id = :offeringMapper.Id
                AND RMU_VALUE__c = :rmuValue.Id
        ];

        System.assertEquals(insertedOfferingMapper.Id, offeringMapper.Id);
        System.assertEquals('Test_Offering_Mapper', offeringMapper.Name);
    }
    @IsTest
    static void testGenerateAddField() {
        RMU_VALUE__c rmuValue = new TestRmuValueBuilder()
                .generate();

        System.Test.startTest();
        OFFERING_MAPPER__c offeringMapper = new TestOfferingMapperBuilder()
                .addField('RMU_VALUE__c', rmuValue.Id)
                .generate();
        System.Test.stopTest();

        OFFERING_MAPPER__c insertedOfferingMapper = [
                SELECT Id, Name
                FROM OFFERING_MAPPER__c
                WHERE Id = :offeringMapper.Id
                AND RMU_VALUE__c = :rmuValue.Id
        ];

        System.assertEquals(insertedOfferingMapper.Id, offeringMapper.Id);
        System.assertEquals('Test_Offering_Mapper', offeringMapper.Name);
    }
}