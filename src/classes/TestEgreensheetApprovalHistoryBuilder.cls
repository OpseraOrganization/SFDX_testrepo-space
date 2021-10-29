/**
 * Created by Meiying Liang on 1/18/2020.
 */

public with sharing class TestEgreensheetApprovalHistoryBuilder {
    private String WorkflowId;
    private Map<String, Object> fields = new Map<String, Object>();

    public TestEgreensheetApprovalHistoryBuilder() {}

    
    public TestEgreensheetApprovalHistoryBuilder setWorkFlowId(Id workflowId) {
        this.WorkflowId = workflowId;

        return this;
    }

    public TestEgreensheetApprovalHistoryBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }

    public WorkFlow_Approval_History__c  build() {
        WorkFlow_Approval_History__c  eGreensheetApprovalHistory = new WorkFlow_Approval_History__c();

        eGreensheetApprovalHistory.Workflow_details__c = this.WorkflowId;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            eGreensheetApprovalHistory.put(field, value);
        }

        return eGreensheetApprovalHistory;
    }
    public WorkFlow_Approval_History__c generate() {
        WorkFlow_Approval_History__c eGreensheetApprovalHistory = build();
        Database.insert(eGreensheetApprovalHistory);
        return eGreensheetApprovalHistory;
    }

}