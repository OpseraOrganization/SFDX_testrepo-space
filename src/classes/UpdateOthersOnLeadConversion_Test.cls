/**
 * Created by Meiying Liang on 1/26/2020.
 */

@IsTest
private class UpdateOthersOnLeadConversion_Test {
    private final static Lead lead = new Lead();
    private final static Event__c event = new Event__c();

    private final static String BENDIXKING = 'BendixKing';
    private final static String AMERICAS = 'Americas';
    private final static String AMERICA = 'America';
    private static Opportunity opportunity;
    private static Account acct;
    private static OppType__c oppType;
    private static Contact contact;

    static void init() {
        acct = new TestAccountBuilder()
                .addField( 'Report_Country_Name__c', AMERICA )
                .addField( 'Region_Name__c', AMERICAS )
                .generate();
        oppType = new OppType__c( RestrictedAccount__c = acct.Id, Name = 'Test' );
        insert oppType;
        opportunity = new TestOpportunityBuilder( 'Test', BENDIXKING )
                .addField( 'AccountId', acct.Id )
                .addField( 'SBU__c', 'BGA' )
                .addField( 'StageName', 'Closed Won' )
                .generate();

        contact = new TestContactBuilder().generate();

        event.name = 'test';
        event.Location__c='test';
        event.Website__c= 'www.google.com';
        event.Start_Date__c = system.today().addDays(1);
        event.Active__c = true;
        event.type__C = 'BGA Events';

        insert event;

        lead.Status = 'Sales Qualified Lead (SQL)';
        lead.Event__c = event.Id;
        lead.Opportunity_Name__c = opportunity.Id;
        lead.LastName = 'Doe';
        lead.Company = 'Honeywell';
        lead.Contact__c = contact.Id;
        lead.Account__c = acct.Id;
    }

    @IsTest
    static void LeadConvert_InsertEventAndOpportunity() {
        init();

        Id recordTypeIdBeforeConvert = Schema.SObjectType.Lead.getRecordTypeInfosByName()
                .get('Lead Convert Layout').getRecordTypeId();

        lead.RecordTypeId = recordTypeIdBeforeConvert;

        Test.startTest();

        insert lead;

        Id recordTypeIdAfterConvert = Schema.SObjectType.Lead.getRecordTypeInfosByName()
                .get('Lead Converted Layout').getRecordTypeId();

        lead.RecordTypeId = recordTypeIdAfterConvert;
        lead.Status = 'Converted';
        update lead;

        Test.stopTest();

        Event_and_Opportunity__c eventAndOpp = [Select Event__c,Opportunity__c,Stage_Migration__c From
                Event_and_Opportunity__c Where Event__c =: event.Id and Opportunity__c =: opportunity.Id LIMIT 1];

        system.assertEquals(eventAndOpp.Stage_Migration__c,'Prospecting');
    }
}