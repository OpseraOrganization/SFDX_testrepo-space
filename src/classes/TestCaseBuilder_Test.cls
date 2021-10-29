/**
 * Created by Satya Mohanty on 5/17/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
private class TestCaseBuilder_Test {

    @IsTest
    static void testDefaultBuildWithAddField(){
        System.Test.startTest();
        Case newCase = new TestCaseBuilder()
                .addField('Resolution__c','Resolved')
                .build();
        System.Test.stopTest();

        System.assertEquals(null,newCase.Id);
        System.assertEquals('Email',newCase.Origin);
        System.assertEquals('Resolved',newCase.Resolution__c);
    }
    @IsTest
    static void testGenerate() {
        System.Test.startTest();
        Case newCase = new TestCaseBuilder()
                .setOrigin('Email')
                .setStatus('Open')
                .generate();
        System.Test.stopTest();
        Case insertcase =[
                SELECT Id
                FROM Case
                WHERE Origin = 'Email'
                And Status = 'Open'
                AND Id = :newCase.Id
        ];
        System.assertEquals(insertcase.Id,newCase.Id);
        System.assertEquals('Email',newCase.Origin);
    }
}