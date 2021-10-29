/** * File Name: delete_workflow*
 Description :Trigger to Delete   wrkflw approval history
* when workflow is deleted
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
 * @author : Wipro
 * Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------* */ 
trigger delete_workflow on Workflow_details__c (before delete) {
//variable declaration
list<WorkFlow_Approval_History__c> AppList = new list<WorkFlow_Approval_History__c>();
List<ID> WFIDs = new List<ID>();
for(Workflow_details__c wf1 : Trigger.Old){
    WFIDs.add(wf1.Id);
}
//Deletion from  wrkflw approval history
AppList =[select Id, Name from WorkFlow_Approval_History__c where Workflow_details__c in: WFIDs];
if(AppList.size()>0)
    Delete AppList;
}