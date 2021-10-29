/**
 * Created by Satya Mohanty on 4/24/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
public class TestEgreensheetBuilder {

    private String workflowName ='workflowName';
    private String status = 'Draft';
    private String ApprovalLevelinProgress = 'Tier 1';
    private Map<String, Object> fields = new Map<String, Object>();
    public TestEgreensheetBuilder() {}

    public TestEgreensheetBuilder setWorkflowName(String workflowName) {
        this.workflowName = workflowName;

        return this;
    }
    public TestEgreensheetBuilder setStatus(String status) {
        this.status = status;

        return this;
    }
    public TestEgreensheetBuilder setApprovalLevelinProgress(String approvalLevelinProgress) {
        this.ApprovalLevelinProgress = approvalLevelinProgress;

        return this;
    }
    public TestEgreensheetBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public Workflow_details__c  build() {
        Workflow_details__c  eGreensheet = new Workflow_details__c();
        eGreensheet.Wokflow_Name__c = workflowName;
        eGreensheet.Status__c = status;
        eGreensheet.Approval_Level_in_Progress__c = ApprovalLevelinProgress;


        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            eGreensheet.put(field, value);
        }

        return eGreensheet;
    }
    public Workflow_details__c generate() {
        Workflow_details__c eGreensheet = build();
        Database.insert(eGreensheet);
        return eGreensheet;
    }


}