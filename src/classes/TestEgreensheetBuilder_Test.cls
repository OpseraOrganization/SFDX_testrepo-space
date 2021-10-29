/**
 * Created by Satya Mohanty on 4/24/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
private class TestEgreensheetBuilder_Test {

    @IsTest
    static void testDefaultBuild() {

        System.Test.startTest();
        Workflow_details__c eGreensheet = new TestEgreensheetBuilder()
                .build();
        System.Test.stopTest();

        System.assertEquals(null, eGreensheet.Id);
        System.assertEquals('workflowName', eGreensheet.Wokflow_Name__c);
        System.assertEquals('Draft', eGreensheet.Status__c);
        System.assertEquals('Tier 1', eGreensheet.Approval_Level_in_Progress__c);
    }
    @IsTest
    static void testGenerateWithAddField() {

        System.Test.startTest();
        Workflow_details__c eGreensheet = new TestEgreensheetBuilder()
                .setWorkflowName('workflowName')
                .setStatus('Draft')
                .addField('Exposed_Cost__c',1000)
                .setApprovalLevelinProgress('Tier 1')
                .generate();
        System.Test.stopTest();

        Workflow_details__c insertedeGreensheet = [
                SELECT Id
                FROM Workflow_details__c
                WHERE Status__c = 'Draft'
                AND Approval_Level_in_Progress__c = 'Tier 1'
                AND Id = : eGreensheet.Id
                AND Exposed_Cost__c =1000
              ];

        System.assertEquals(insertedeGreensheet.Id,eGreensheet.Id);
        System.assertEquals('workflowName', eGreensheet.Wokflow_Name__c);
        System.assertEquals('Draft', eGreensheet.Status__c);
        System.assertEquals('Tier 1', eGreensheet.Approval_Level_in_Progress__c);
        System.assertEquals(1000, eGreensheet.Exposed_Cost__c);
    }
}