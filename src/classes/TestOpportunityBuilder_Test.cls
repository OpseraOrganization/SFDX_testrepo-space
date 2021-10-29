/**
 * Created by Nikolay Kolev on 4/8/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class TestOpportunityBuilder_Test {
    private final static String BENDIXKING = 'BendixKing';
    @IsTest
    static void testDefaultBuild() {
        System.Test.startTest();
        Opportunity testOpportunity = new TestOpportunityBuilder()
                .build();
        System.Test.stopTest();

        System.assertEquals(null, testOpportunity.Id);
        System.assertEquals('testOpportunity', testOpportunity.Name);
        System.assertEquals('prospecting', testOpportunity.StageName);
    }
    @IsTest
    static void testDefaultBuildWithName() {
        System.Test.startTest();
        Opportunity testOpportunity = new TestOpportunityBuilder('myOpp')
                .build();
        System.Test.stopTest();

        System.assertEquals(null, testOpportunity.Id);
        System.assertEquals('myOpp', testOpportunity.Name);
        System.assertEquals('prospecting', testOpportunity.StageName);
    }
    @IsTest
    static void testDefaultBuildWithNameAndRecordType() {
        System.Test.startTest();
        Opportunity testOpportunity = new TestOpportunityBuilder('myOpp', BENDIXKING)
                .build();
        System.Test.stopTest();

        RecordType recordType = [
                SELECT
                        Id,
                        Name
                FROM RecordType
                WHERE SobjectType = 'Opportunity'
                AND DeveloperName = :BENDIXKING
                LIMIT 1
        ];

        System.assertEquals(null, testOpportunity.Id);
        System.assertEquals('myOpp', testOpportunity.Name);
        System.assertEquals('prospecting', testOpportunity.StageName);
        System.assertEquals(recordType.Id, testOpportunity.RecordTypeId);
    }
    @IsTest
    static void testBuildWithAddField() {
        System.Test.startTest();
        Opportunity testOpportunity = new TestOpportunityBuilder('myOpp', BENDIXKING)
                .addField('CloseDate', Date.newInstance(2020, 2, 20))
                .build();
        System.Test.stopTest();

        RecordType recordType = [
                SELECT
                        Id,
                        Name
                FROM RecordType
                WHERE SobjectType = 'Opportunity'
                AND DeveloperName = :BENDIXKING
                LIMIT 1
        ];

        System.assertEquals(null, testOpportunity.Id);
        System.assertEquals('myOpp', testOpportunity.Name);
        System.assertEquals('prospecting', testOpportunity.StageName);
        System.assertEquals(recordType.Id, testOpportunity.RecordTypeId);
        System.assertEquals(Date.newInstance(2020, 2, 20), testOpportunity.CloseDate);
    }
    @IsTest
    static void testGenerate() {
        System.Test.startTest();
        Opportunity testOpportunity = new TestOpportunityBuilder('myOpp', BENDIXKING)
                .setStage('Cultivate')
                .setCloseDate(Date.today())
                .generate();
        System.Test.stopTest();

        RecordType recordType = [
                SELECT
                        Id,
                        Name
                FROM RecordType
                WHERE SobjectType = 'Opportunity'
                AND DeveloperName = :BENDIXKING
                LIMIT 1
        ];

        System.assertNotEquals(null, testOpportunity.Id);
        System.assertEquals('myOpp', testOpportunity.Name);
        System.assertEquals('Cultivate', testOpportunity.StageName);
        System.assertEquals(Date.today(), testOpportunity.CloseDate);
        System.assertEquals(recordType.Id, testOpportunity.RecordTypeId);
    }
}