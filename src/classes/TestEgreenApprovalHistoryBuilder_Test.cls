/**
 * Created by H379353 on 1/18/2020.
 */

@IsTest
private class TestEgreenApprovalHistoryBuilder_Test {
    @IsTest
    static void testBuild() {
        Test.startTest();
        WorkFlow_Approval_History__c testApproval  = new TestEgreensheetApprovalHistoryBuilder()
                .build();
        Test.stopTest();

        System.assertEquals(null, testApproval.Id);
    }

    @IsTest
    static void testDefaultBuildWithAddField(){
        Test.startTest();
        WorkFlow_Approval_History__c testApproval = new TestEgreensheetApprovalHistoryBuilder()
                .addField('Approval_Status__c','Approved')
                .build();
        Test.stopTest();

        System.assertEquals(null,testApproval.Id);
        System.assertEquals('Approved',testApproval.Approval_Status__c);
    }

    @IsTest
    static void testGenerate() {
        Test.startTest();

        Workflow_details__c workflowDetails = new TestEgreensheetBuilder()
                .setApprovalLevelinProgress('Tier I')
                .addField('Summary__c','Workflow Summary')
                .generate();

        User usr = new TestUserBuilder().generate();
        Approver__c approval = new Approver__c(name='Test',approver_name__c=usr.id,Business_Unit__c='ATR',
                email__c ='tu1egreen@test.com');
        insert approval;

        WorkFlow_Approval_History__c workflowHistory = new TestEgreensheetApprovalHistoryBuilder()
                .setWorkFlowId(workflowDetails.Id)
                .addField('Approval_Status__c','Approved')
                .addField('select_approver__c',approval.Id)
                .addField('email__c',approval.email__c)
                .addField('Tier__c','Tier I')
                .addField('Summary__c','Workflow Approval History Summary')
                .generate();

        Test.stopTest();

        WorkFlow_Approval_History__c insertedApprovalHistory = [
                SELECT Id, Approval_Status__c, Tier__c
                FROM WorkFlow_Approval_History__c
                WHERE Workflow_details__c =: workflowDetails.Id
        ];

        System.assertEquals('Approved', insertedApprovalHistory.Approval_Status__c);
        System.assertEquals('Tier I',insertedApprovalHistory.Tier__c);
    }
}