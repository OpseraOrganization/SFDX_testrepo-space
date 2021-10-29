/**
 * Created by Meiying Liang on 3/8/2020.
 */

@IsTest
private class ContactTaskList_Test {
    private final static String BENDIXKING = 'BendixKing';
    private final static String AMERICAS = 'Americas';
    private final static String AMERICA = 'America';
    private static Opportunity opportunity;
    private static Account acct;
    private static User userOne;
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
                .build();

        contact = new TestContactBuilder().generate();
        userOne = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();
    }

    @IsTest
    static void getContactTaskList() {
        init();

        opportunity.Opportunity_Type__c = 'Test';
        insert opportunity;

        Task newCustomerStatusTask = new Task(
                WhatId = opportunity.Id,
                WhoId = contact.Id,
                Description = 'testDescription',
                ActivityDate = Date.newInstance(2019, 12, 24));

        Task result = OpportunityTaskListView.saveOpportunityTask(newCustomerStatusTask,'Customer_Status');
        System.Test.startTest();
        List<Contact> contactTaskList = ContactTaskList.getContactTaskList(opportunity.Id);
        System.Test.stopTest();
        System.assertEquals(contactTaskList.size(),1);
    }
}