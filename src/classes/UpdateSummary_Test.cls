/**
 * Created by Meiying Liang on 1/18/2020.
 */

@IsTest
private class UpdateSummary_Test {
    private static Workflow_details__c workflowDetails;
    private static WorkFlow_Approval_History__c workflowHistory;
    private static User usr;

    static void init()
    {
        workflowDetails = new TestEgreensheetBuilder()
                .setApprovalLevelinProgress('Tier I')
                .addField('Summary__c','Workflow Summary')
                .generate();

        usr = new TestUserBuilder().generate();
        Approver__c approval = new Approver__c(name='Test',approver_name__c=usr.id,Business_Unit__c='ATR', email__c ='tu1egreen@test.com');
        insert approval;

        workflowHistory = new TestEgreensheetApprovalHistoryBuilder()
                .setWorkFlowId(workflowDetails.Id)
                .addField('Approval_Status__c','Approved')
                .addField('select_approver__c',approval.Id)
                .addField('email__c',approval.email__c)
                .addField('Tier__c','Tier I')
                .addField('Summary__c','Workflow Approval History Summary')
                .generate();

    }

    @IsTest
    static void AU_UpdateSummary_Test() {
        init();

        workflowDetails.Summary__c = 'Workflow Summary2';
        update workflowDetails;

        List<WorkFlow_Approval_History__c> result = [Select Summary__c From WorkFlow_Approval_History__c
        Where Workflow_details__c =:workflowDetails.Id];

        system.assertEquals('Workflow Summary2',result[0].Summary__c);
    }
}