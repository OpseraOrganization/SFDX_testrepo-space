/**
About
-----
Description: This Class is used to delete approval request records which has been processed 2 weeks ago and move it to approval request history.

Created for: SCRM
Created: 15 07 2019
DEM0042865

Update History
--------------
Created: 05 07 2019 – gunjan.sidhwani.ext@nokia.com   
-------------
**/
  
global without sharing class BuildARHistorywithARDeletion implements Database.Batchable<sObject>{
   
   /*
  * @description  remove approval request which are approved 2 weeks ago.
  * @param	  
  * @return	
  */
  
   List<Apttus_Approval__Approval_Request_History__c> arhList = new List<Apttus_Approval__Approval_Request_History__c>();
   List<id> arList = new List<id>();
   Database.SaveResult[] saveResultList;
   global Set<Id> failureIdsSet;
   datetime dt = system.today()- 14;
   datetime dt1 = dt-3;
   User NokiasCRMId= [Select id from User where name = 'Nokia CRM'];
   global final String Query = 'SELECT ApprovalDateTechField__c,Approval_Action__c,Approver_User_Check__c,Approver_User__c,Aproval_Completion_days__c,APTSCU_Approval_Action__c,Apttus_Approval__Action_Approve_Id__c,Apttus_Approval__Action_Prefix__c,Apttus_Approval__Action_Reassign_Id__c,Apttus_Approval__Action__c,Apttus_Approval__Active__c,Apttus_Approval__ActualApproverName__c,Apttus_Approval__Actual_Approver__c,Apttus_Approval__AgreementLineItemId__c,Apttus_Approval__ApprovalCount__c,Apttus_Approval__ApprovalFromEmail__c,Apttus_Approval__ApprovalPercent__c,Apttus_Approval__ApprovalPolicy__c,Apttus_Approval__Approval_Process__c,Apttus_Approval__Approval_Status__c,Apttus_Approval__Approver_Comments__c,Apttus_Approval__Assigned_To_Id__c,Apttus_Approval__Assigned_To_Link__c,Apttus_Approval__Assigned_To_Name__c,Apttus_Approval__Assigned_To_Type__c,Apttus_Approval__Assigned_To__c,Apttus_Approval__AutoEscalate__c,Apttus_Approval__AutoReapprove__c,Apttus_Approval__Auto_Complete__c,Apttus_Approval__Backup_From_User__c,Apttus_Approval__CanEscalate__c,Apttus_Approval__ChildObjectId__c,Apttus_Approval__ChildObjectLink__c,Apttus_Approval__ChildObjectName__c,Apttus_Approval__ChildObjectRefId__c,Apttus_Approval__ChildObjectType__c,Apttus_Approval__ContinuePolicyApprovalOnAReject__c,Apttus_Approval__CriteriaFieldNames__c,Apttus_Approval__DateApproved__c,Apttus_Approval__DateAssigned__c,Apttus_Approval__DateCancelled__c,Apttus_Approval__DateEscalated__c,Apttus_Approval__DateReassigned__c,Apttus_Approval__DateRejected__c,Apttus_Approval__Date__c,Apttus_Approval__DelegateApproverIds__c,Apttus_Approval__DelegateApprover__c,Apttus_Approval__DependsOn__c,Apttus_Approval__EscalatedToHighestLevel__c,Apttus_Approval__EscalateToChain__c,Apttus_Approval__EscalateToId__c,Apttus_Approval__EscalateToName__c,Apttus_Approval__EscalateToType__c,Apttus_Approval__ExpectedCompletionDate__c,Apttus_Approval__ExpectedDaysToComplete__c,Apttus_Approval__ExpectedHoursToComplete__c,Apttus_Approval__ExpectedMinutesToComplete__c,Apttus_Approval__Group_Unique_Id__c,Apttus_Approval__Group__c,Apttus_Approval__HasAttachments__c,Apttus_Approval__HasDelegateApprover__c,Apttus_Approval__InEscalation__c,Apttus_Approval__Initial_Submitter__c,Apttus_Approval__Internal_Comments__c,Apttus_Approval__IsAdhoc__c,Apttus_Approval__IsAutoReapprovalEnabled__c,Apttus_Approval__IsSubprocess__c,Apttus_Approval__Notify_Only__c,Apttus_Approval__ObjectRefId__c,Apttus_Approval__Object_Id_Link__c,Apttus_Approval__Object_Id__c,Apttus_Approval__Object_Name__c,Apttus_Approval__Object_Type__c,Apttus_Approval__ParentRequestId__c,Apttus_Approval__Parent_Agreement__c,Apttus_Approval__PrevAssignedToId__c,Apttus_Approval__PrevAssignedToName__c,Apttus_Approval__PrevAssignedToType__c,Apttus_Approval__ProcessInstanceId__c,Apttus_Approval__Rejection_Action__c,Apttus_Approval__Related_Agreement_Owner__c,Apttus_Approval__Related_Agreement_Requestor__c,Apttus_Approval__Related_Agreement_Term_Exception__c,Apttus_Approval__Related_Agreement__c,Apttus_Approval__Related_Opportunity_Owner__c,Apttus_Approval__Related_Opportunity__c,Apttus_Approval__RequestType__c,Apttus_Approval__Request_Comments__c,Apttus_Approval__Send_Email__c,Apttus_Approval__SequenceString__c,Apttus_Approval__Sequence__c,Apttus_Approval__Status_Link__c,Apttus_Approval__StepLabel__c,Apttus_Approval__StepNameLink__c,Apttus_Approval__StepSequenceString__c,Apttus_Approval__StepSequence__c,Apttus_Approval__Step_Group_Seq_Number__c,Apttus_Approval__Step_Name__c,Apttus_Approval__Step__c,Apttus_Approval__SubmissionComment1__c,Apttus_Approval__SubmissionComment2__c,Apttus_Approval__SubmissionComment3__c,Apttus_Approval__SubprocessDependsOn__c,Apttus_Approval__SubprocessName__c,Apttus_Approval__SubprocessSequence__c,Apttus_Approval__SubstepDependsOn__c,Apttus_Approval__SubstepName__c,Asigneed_User_NSA_Check__c,CreatedById,CreatedDate,CurrencyIsoCode,Delegate_Approvers__c,Delegate_User1__c,Delegate_User2__c,Delegate_User3__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,NF_Approval_Visibility_Status__c,NF_Assignee_Type__c,NF_Assignee_Value__c,NF_BG_Attribute__c,NF_MyApproval_List__c,NF_Organization_Level__c,NF_PSR_Date_Check__c,NF_Recursive_Reminder__c,NF_Remaindercount__c,NF_Remaninder_Subject__c,NF_Role_Code__c,NF_Role_Name__c,Opportunity_Value__c,Oppty_Cust_compliance__c,Oppty_LOA_Level__c,Org_L2__c,Org_L3__c,Org_L4__c,Org_L5__c,Org_L6__c,Org_L7__c,OwnerId,owner.isActive,RecordTypeId,Related_Sales_Role__c,Stakeholder_notified_of_recall__c,SystemModstamp,Tech_Approval_Date__c,tech_field_reminder__c,Tech_Status__c,Validation_Completion_Date__c,Validator_Request_Status__c,Validator_Status__c FROM Apttus_Approval__Approval_Request__c WHERE (Apttus_Approval__Related_Opportunity__r.recordTypeId = \'01241000001HzdS\' OR Apttus_Approval__Related_Opportunity__r.recordTypeId = \'01241000001HzdT\' OR Apttus_Approval__Related_Opportunity__r.recordTypeId = \'01241000001I9Gq\' OR Apttus_Approval__Related_Opportunity__r.recordTypeId = \'01241000001I9Gr\'  OR Apttus_Approval__Related_Opportunity__r.recordTypeId = \'01241000001AXC9\'  OR Apttus_Approval__Related_Opportunity__r.recordTypeId = \'01241000001AXCA\') AND (Apttus_Approval__Related_Opportunity__r.phase_status__c != \'Submitted for G2 Approval\' AND Apttus_Approval__Related_Opportunity__r.phase_status__c != \'Submitted for G3 Approval\' AND Apttus_Approval__Related_Opportunity__r.phase_status__c  != \'Submitted for G4 Approval\' AND Apttus_Approval__Related_Opportunity__r.phase_status__c != \'Submitted for G5 Approval\' AND Apttus_Approval__Related_Opportunity__r.phase_status__c != \'Submitted for G6 Approval\' AND Apttus_Approval__Related_Opportunity__r.StageName != \'Submitted For Approval\') AND (Tech_Approval_Date__c <: dt  OR (Tech_Approval_Date__c = null AND ApprovalDateTechField__c  <: dt1))';
   global Database.QueryLocator start(Database.BatchableContext BC){
	system.debug('Query'+Query);
	return Database.getQueryLocator(Query);
   }

   global void execute(Database.BatchableContext BC, List<Apttus_Approval__Approval_Request__c> scope){
  
	
	for(Apttus_Approval__Approval_Request__c ar: scope){
	  if(ar != null){
		
		 
		  try{
			Apttus_Approval__Approval_Request_History__c arh = new Apttus_Approval__Approval_Request_History__c();
			arh.Apttus_Approval__SubprocessDependsOn__c=ar.Apttus_Approval__SubprocessDependsOn__c;
			arh.Apttus_Approval__ChildObjectId__c=ar.Apttus_Approval__ChildObjectId__c;
			arh.Apttus_Approval__IsSubprocess__c=ar.Apttus_Approval__IsSubprocess__c;
			arh.Apttus_Approval__Related_Opportunity__c=ar.Apttus_Approval__Related_Opportunity__c;
			arh.Apttus_Approval__ApprovalPolicy__c=ar.Apttus_Approval__ApprovalPolicy__c;
			arh.Apttus_Approval__Group__c=ar.Apttus_Approval__Group__c;
			arh.Apttus_Approval__StepSequence__c=ar.Apttus_Approval__StepSequence__c;
			arh.Apttus_Approval__Related_Agreement_Owner__c=ar.Apttus_Approval__Related_Agreement_Owner__c;
			arh.Validator_Status__c=ar.Validator_Status__c;
			arh.Apttus_Approval__RequestType__c=ar.Apttus_Approval__RequestType__c;
			arh.Apttus_Approval__Internal_Comments__c=ar.Apttus_Approval__Internal_Comments__c;
			arh.NF_Assignee_Type__c=ar.NF_Assignee_Type__c;
			arh.Apttus_Approval__ContinuePolicyApprovalOnAReject__c=ar.Apttus_Approval__ContinuePolicyApprovalOnAReject__c;
			arh.Apttus_Approval__PrevAssignedToType__c=ar.Apttus_Approval__PrevAssignedToType__c;
			arh.Apttus_Approval__ParentRequestId__c=ar.Apttus_Approval__ParentRequestId__c;
			arh.Apttus_Approval__SubmissionComment3__c=ar.Apttus_Approval__SubmissionComment3__c;
			arh.Apttus_Approval__EscalateToType__c=ar.Apttus_Approval__EscalateToType__c;
			arh.Apttus_Approval__Object_Id__c=ar.Apttus_Approval__Object_Id__c;
			arh.Apttus_Approval__Notify_Only__c=ar.Apttus_Approval__Notify_Only__c;
			arh.Apttus_Approval__ExpectedMinutesToComplete__c=ar.Apttus_Approval__ExpectedMinutesToComplete__c;
			arh.Apttus_Approval__Group_Unique_Id__c=ar.Apttus_Approval__Group_Unique_Id__c;
			arh.Apttus_Approval__ApprovalFromEmail__c=ar.Apttus_Approval__ApprovalFromEmail__c;
			arh.Apttus_Approval__Action_Approve_Id__c=ar.Apttus_Approval__Action_Approve_Id__c;
			arh.Apttus_Approval__StepLabel__c=ar.Apttus_Approval__StepLabel__c;
			arh.Apttus_Approval__HasDelegateApprover__c=ar.Apttus_Approval__HasDelegateApprover__c;
			arh.Apttus_Approval__DateRejected__c=ar.Apttus_Approval__DateRejected__c;
			arh.Apttus_Approval__Assigned_To_Type__c=ar.Apttus_Approval__Assigned_To_Type__c;
			arh.Apttus_Approval__Object_Type__c=ar.Apttus_Approval__Object_Type__c;
			arh.CreatedById=ar.CreatedById;
			arh.Apttus_Approval__Send_Email__c=ar.Apttus_Approval__Send_Email__c;
			arh.Apttus_Approval__Date__c=ar.Apttus_Approval__Date__c;
			arh.Apttus_Approval__SubstepName__c=ar.Apttus_Approval__SubstepName__c;
			arh.Apttus_Approval__DateReassigned__c=ar.Apttus_Approval__DateReassigned__c;
			arh.Apttus_Approval__DateApproved__c=ar.Apttus_Approval__DateApproved__c;
			arh.Apttus_Approval__AutoEscalate__c=ar.Apttus_Approval__AutoEscalate__c;
			arh.CurrencyIsoCode=ar.CurrencyIsoCode;
			arh.CreatedDate=ar.CreatedDate;
			arh.Apttus_Approval__AutoReapprove__c=ar.Apttus_Approval__AutoReapprove__c;
			arh.Apttus_Approval__EscalateToName__c=ar.Apttus_Approval__EscalateToName__c;
			arh.Apttus_Approval__Auto_Complete__c=ar.Apttus_Approval__Auto_Complete__c;
			arh.Apttus_Approval__Backup_From_User__c=ar.Apttus_Approval__Backup_From_User__c;
			arh.Apttus_Approval__AgreementLineItemId__c=ar.Apttus_Approval__AgreementLineItemId__c;
			arh.Apttus_Approval__Related_Agreement__c=ar.Apttus_Approval__Related_Agreement__c;
			arh.Apttus_Approval__DateCancelled__c=ar.Apttus_Approval__DateCancelled__c;
			arh.Apttus_Approval__SubprocessName__c=ar.Apttus_Approval__SubprocessName__c;
			arh.NF_Role_Name__c=ar.NF_Role_Name__c;
			arh.Apttus_Approval__EscalateToId__c=ar.Apttus_Approval__EscalateToId__c;
			arh.Apttus_Approval__Step_Group_Seq_Number__c=ar.Apttus_Approval__Step_Group_Seq_Number__c;
			arh.Apttus_Approval__Approval_Status__c=ar.Apttus_Approval__Approval_Status__c;
			arh.Apttus_Approval__Sequence__c=ar.Apttus_Approval__Sequence__c;
			arh.Apttus_Approval__DelegateApproverIds__c=ar.Apttus_Approval__DelegateApproverIds__c;
			arh.Apttus_Approval__Related_Agreement_Requestor__c=ar.Apttus_Approval__Related_Agreement_Requestor__c;
			arh.Apttus_Approval__DelegateApprover__c=ar.Apttus_Approval__DelegateApprover__c;
			arh.Apttus_Approval__IsAdhoc__c=ar.Apttus_Approval__IsAdhoc__c;
			arh.Apttus_Approval__InEscalation__c=ar.Apttus_Approval__InEscalation__c;
			arh.Apttus_Approval__DateAssigned__c=ar.Apttus_Approval__DateAssigned__c;
			arh.Apttus_Approval__Assigned_To_Name__c=ar.Apttus_Approval__Assigned_To_Name__c;
			arh.Apttus_Approval__ProcessInstanceId__c=ar.Apttus_Approval__ProcessInstanceId__c;
			arh.Apttus_Approval__Object_Name__c=ar.Apttus_Approval__Object_Name__c;
			arh.Apttus_Approval__CanEscalate__c=ar.Apttus_Approval__CanEscalate__c;
			arh.Apttus_Approval__DateEscalated__c=ar.Apttus_Approval__DateEscalated__c;
			arh.Apttus_Approval__Rejection_Action__c=ar.Apttus_Approval__Rejection_Action__c;
			arh.Apttus_Approval__EscalatedToHighestLevel__c=ar.Apttus_Approval__EscalatedToHighestLevel__c;
			arh.ExternalId__c=ar.Id;
			arh.Apttus_Approval__Related_Agreement_Term_Exception__c=ar.Apttus_Approval__Related_Agreement_Term_Exception__c;
			arh.Apttus_Approval__Actual_Approver__c=ar.Apttus_Approval__Actual_Approver__c;
			arh.Apttus_Approval__Assigned_To__c=ar.Apttus_Approval__Assigned_To__c;
			arh.Apttus_Approval__Approver_Comments__c=ar.Apttus_Approval__Approver_Comments__c;
			arh.BG_Attribute__c=ar.NF_BG_Attribute__c;
			if(ar.owner.isActive == true)
			  arh.OwnerId  = ar.OwnerId; 
			else
			  arh.OwnerId = NokiasCRMId.id;
			arh.Apttus_Approval__ExpectedDaysToComplete__c=ar.Apttus_Approval__ExpectedDaysToComplete__c;
			arh.Apttus_Approval__Active__c=ar.Apttus_Approval__Active__c;
			arh.Apttus_Approval__Request_Comments__c=ar.Apttus_Approval__Request_Comments__c;
			arh.Apttus_Approval__Approval_Process__c=ar.Apttus_Approval__Approval_Process__c;
			arh.Apttus_Approval__HasAttachments__c=ar.Apttus_Approval__HasAttachments__c;
			arh.Apttus_Approval__Assigned_To_Id__c=ar.Apttus_Approval__Assigned_To_Id__c;
			arh.Apttus_Approval__Action_Reassign_Id__c=ar.Apttus_Approval__Action_Reassign_Id__c;
			arh.Apttus_Approval__ChildObjectType__c=ar.Apttus_Approval__ChildObjectType__c;
			arh.Apttus_Approval__SubmissionComment1__c=ar.Apttus_Approval__SubmissionComment1__c;
			arh.Apttus_Approval__PrevAssignedToId__c=ar.Apttus_Approval__PrevAssignedToId__c;
			arh.Apttus_Approval__ExpectedCompletionDate__c=ar.Apttus_Approval__ExpectedCompletionDate__c;
			arh.Apttus_Approval__Initial_Submitter__c=ar.Apttus_Approval__Initial_Submitter__c;
			arh.NF_Organization_Level__c=ar.NF_Organization_Level__c;
			arh.Apttus_Approval__ExpectedHoursToComplete__c=ar.Apttus_Approval__ExpectedHoursToComplete__c;
			arh.Apttus_Approval__Step__c=ar.Apttus_Approval__Step__c;
			arh.Apttus_Approval__EscalateToChain__c=ar.Apttus_Approval__EscalateToChain__c;
			arh.Apttus_Approval__Parent_Agreement__c=ar.Apttus_Approval__Parent_Agreement__c;
			arh.Apttus_Approval__DependsOn__c=ar.Apttus_Approval__DependsOn__c;
			arh.Apttus_Approval__Step_Name__c=ar.Apttus_Approval__Step_Name__c;
			arh.NF_Role_Code__c=ar.NF_Role_Code__c;
			arh.Apttus_Approval__CriteriaFieldNames__c=ar.Apttus_Approval__CriteriaFieldNames__c;
			arh.Apttus_Approval__IsAutoReapprovalEnabled__c=ar.Apttus_Approval__IsAutoReapprovalEnabled__c;
			arh.Apttus_Approval__SubprocessSequence__c=ar.Apttus_Approval__SubprocessSequence__c;
			arh.Apttus_Approval__ApprovalPercent__c=ar.Apttus_Approval__ApprovalPercent__c;
			arh.Apttus_Approval__PrevAssignedToName__c=ar.Apttus_Approval__PrevAssignedToName__c;
			arh.Apttus_Approval__ApprovalCount__c=ar.Apttus_Approval__ApprovalCount__c;
			arh.Apttus_Approval__Related_Opportunity_Owner__c=ar.Apttus_Approval__Related_Opportunity_Owner__c;
			arh.Apttus_Approval__ChildObjectName__c=ar.Apttus_Approval__ChildObjectName__c;
			arh.Apttus_Approval__SubstepDependsOn__c=ar.Apttus_Approval__SubstepDependsOn__c;
			arh.Apttus_Approval__SubmissionComment2__c=ar.Apttus_Approval__SubmissionComment2__c;
  
			arList.add(ar.id);
			arhList.add(arh);
		
		   }  
		   catch(Exception ex){
			system.debug('Exception'+ex);
			} 
		
	  }   
	  
		  
	}
	//insert approval request history
	try{
	  system.debug('arhList' + arhList);
	  system.debug('arList' + arList);
	  saveResultList = Database.insert(arhList, false);
	}
	catch(Exception ex){
	  system.debug('Exception'+ex);
		
	}
	
	Set<Id> arhInserted = new Set<Id>();
	List<Apttus_Approval__Approval_Request_History__c> arhUpdateList= new List<Apttus_Approval__Approval_Request_History__c>();
	List<Apttus_Approval__Approval_Request__c> arDeleteList = new List<Apttus_Approval__Approval_Request__c>();
	  
	if(saveResultList.size() > 0){
	   for(Database.SaveResult sr :saveResultList){
		if(sr.isSuccess()){
		  arhInserted.add(sr.getId());
		  system.debug('arhInserted sr.getId'+arhInserted);
		}
		else{
		   for(Database.Error err : sr.getErrors()) {
			 System.debug(err.getStatusCode() + ': ' + err.getMessage());
			 System.debug('fields that affected this error: ' + err.getFields());
			 system.debug(failureIdsSet);
			}
		 }
		}
	} 
	
	if(arhInserted.size()>0){
	  
		for(Apttus_Approval__Approval_Request_History__c arhUpdate: [Select id,ExternalId__c,NF_Role_Code__c,NF_Role_Name__c,NF_Organization_Level__c,BG_Attribute__c,Validator_Status__c from Apttus_Approval__Approval_Request_HIstory__c where Id IN: arhInserted]){
		  if(arhUpdate != null){
			System.debug('arhUpdate'+arhUpdate);
			for(Apttus_Approval__Approval_Request__c arUpdate: scope){
			  if(arhUpdate.ExternalId__c == arUpdate.id){
				arhUpdate.NF_Role_Code__c = arUpdate.NF_Role_Code__c;
				arhUpdate.NF_Role_Name__c = arUpdate.NF_Role_Name__c;
				arhUpdate.NF_Organization_Level__c = arUpdate.NF_Organization_Level__c;
				arhUpdate.BG_Attribute__c  = arUpdate.NF_BG_Attribute__c;
				  if(arUpdate.Validator_Status__c == 'Approved')
					arhUpdate.Validator_Status__c = 'Validated';
				  
				arDeleteList.add(arUpdate);
			  }
			}
			
		  }
			
		  arhUpdateList.add(arhUpdate);
	  
		 }
	   }	  
			 
	   
	update arhUpdateList;
	 //delete approval request
	Database.DeleteResult[] DR_Dels = Database.delete(arDeleteList);
	system.debug('ar'+arList);
	system.debug('arhList finish' +arhList);
	system.debug('arhUpdateList'+arhUpdateList);
	system.debug('execute exit');
  }

   global void finish(Database.BatchableContext BC){
   
   
   }
}