/**
 * Created by Haritha Lekkala on 4/30/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class TestLeadBuilder_Test {

    @IsTest
    static void testDefaultBuild() {

        System.Test.startTest();
    Lead lead = new TestLeadBuilder()
                    .build();
        System.Test.stopTest();

        System.assertEquals(null, lead.Id);
        System.assertEquals('Inquiry', lead.Status);
        System.assertEquals('Business Aviation', lead.Lead_Market_Selection__c);
        System.assertEquals('Americas', lead.Lead_Region__c);

        }

    @IsTest
    static void testDefaultbuildWithaddfield() {
            System.Test.startTest();
    Lead lead = new TestLeadBuilder()
                .setCompany('Honeywell')
                .setLeadMarket('Business Aviation')
                .setLeadRegion('Americas')
                .setStatus('Inquiry')
                .setLastName('LastName')
                .setProductInformation('Lead Record')
                .addField('SBU__c', 'ATR')
                .build();
            System.Test.stopTest();

        System.assertEquals(null, lead.Id);
        System.assertEquals('Inquiry', lead.Status);
        System.assertEquals('Business Aviation', lead.Lead_Market_Selection__c);
        System.assertEquals('Honeywell', lead.Company);
        System.assertEquals('LastName', lead.LastName);
        System.assertEquals('ATR', lead.SBU__c);
        System.assertEquals('Americas', lead.Lead_Region__c);
    }

    @IsTest
    static void testGenerate() {
            System.Test.startTest();
        Lead lead = new TestLeadBuilder()
                .generate();
            System.Test.stopTest();

        Lead insertedlead = [
                SELECT Id
                FROM Lead
                WHERE Status = 'Inquiry'
                AND  Id = :lead.Id
        ];
        System.assertEquals(insertedlead.Id, lead.Id);
        System.assertEquals('Inquiry', lead.Status);
        System.assertEquals('Business Aviation', lead.Lead_Market_Selection__c);
        System.assertEquals('Americas', lead.Lead_Region__c);
        System.assertEquals('Honeywell', lead.Company);
        System.assertEquals('LastName', lead.LastName);

    }
}