/**
 * Created by Meiying Liang on 6/3/2020.
 */

@IsTest
private class UpdateOppandOppProposal_Test {
    private final static String BENDIXKING = 'BendixKing';
    private final static String AMERICAS = 'Americas';
    private final static String AMERICA = 'America';

    private static Opportunity opportunity;
    private static Account account;
    private static Case newCase;
    private static Workflow_details__c workflow;
    private static Opportunity_Proposal__c oppro;

    static void init() {
        account = new TestAccountBuilder()
                .addField( 'Report_Country_Name__c', AMERICA )
                .addField( 'Region_Name__c', AMERICAS )
                .generate();

        opportunity = new TestOpportunityBuilder( 'Test', BENDIXKING )
                .addField( 'AccountId', account.Id )
                .addField( 'SBU__c', 'BGA' )
                .addField( 'StageName', 'Closed Won' )
                .build();

        oppro = new Opportunity_Proposal__c();
        oppro.Opportunity__c = opportunity.Id;

        insert oppro;
    }

    @IsTest
    static void Update_eGreenSheet_With_OpportunityId_In_Case() {
        init();

        newCase = new TestCaseBuilder()
                .addField('RecordtypeId', Label.D_S_Clear_House_RecordTypeId_Case)
                .addField('Opportunity_Proposal__c', oppro.Id)
                .addField('Opportunity__c', opportunity.Id)
                .generate();

        workflow = new Workflow_details__c();
        workflow.Customer_Name__c=account.id;
        workflow.Status__c='Draft';
        workflow.Opportunity_Number__c = opportunity.Opportunity_Number__c;
        workflow.Case__c = newCase.Id;

        insert workflow;

        Workflow_details__c newWorkflow = [Select Id,Status__c,Opportunity_Description__c from Workflow_details__c Where Id =: workflow.Id];

        newWorkflow.Status__c = 'Completed';

        update newWorkflow;

        System.assertEquals(newWorkflow.Opportunity_Description__c, opportunity.Id);
    }

    @IsTest
    static void Update_eGreenSheet_With_Changed_CaseId() {
        init();

        newCase = new TestCaseBuilder()
                .addField('Opportunity_Proposal__c', oppro.Id)
                .addField('Opportunity__c', opportunity.Id)
                .generate();

        workflow = new Workflow_details__c();
        workflow.Customer_Name__c=account.id;
        workflow.Status__c='Draft';
        workflow.Opportunity_Number__c = opportunity.Opportunity_Number__c;
        workflow.Case__c = newCase.Id;

        insert workflow;

        Case anotherCase = new TestCaseBuilder()
                .addField('Opportunity_Proposal__c', oppro.Id)
                .addField('Opportunity__c', opportunity.Id)
                .generate();

        Workflow_details__c newWorkflow = [Select Id,Opportunity_Number__c from Workflow_details__c Where Id =: workflow.Id];

        newWorkflow.Case__c = anotherCase.Id;

        update newWorkflow;

        System.assertEquals(null, newWorkflow.Opportunity_Number__c);
    }
}