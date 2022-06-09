/**
* Class used to construct data for VF Component used inside Approval process Vf Email Template
*/
public with sharing class NF_EmailTemplateAttachementsCtrl {
	
	public String oppId {get;set;}
	//Received approvalRequest from EmailTemplate
	public Apttus_Approval__Approval_Request__c approvalRequest{
		get{
			if(approvalRequest== null) approvalRequest = new Apttus_Approval__Approval_Request__c();
			List<Apttus_Approval__Approval_Request__c> requests = [
			SELECT
				Apttus_Approval__Action__c,
				Id,
				OwnerId,
				Apttus_Approval__Approval_Status__c,
				Apttus_Approval__Date__c,
				Apttus_Approval__Assigned_To_Name__c,
				Apttus_Approval__Request_Comments__c,
				Apttus_Approval__Approver_Comments__c,
				Apttus_Approval__Related_Opportunity__r.Name,
				Apttus_Approval__Related_Opportunity__r.Owner.Name,
				Apttus_Approval__Related_Opportunity__r.Account.Name,
				Apttus_Approval__Related_Opportunity__r.Amount,
				Apttus_Approval__SubmissionComment1__c
			FROM
				Apttus_Approval__Approval_Request__c
			WHERE
			Id = :approvalRequest.Id
			];
			if(!requests.isEmpty()){
				approvalRequest = requests[0];
			}
			return approvalRequest;
		}
		set;
	}
	//Construct Appovals Links based on  formula field, please include namespace in the VF page name : Apttus_Approval__
	// Reassign, approveReject, addComment
	public String reassign{
		get{
			if(approvalRequest.Apttus_Approval__Action__c != null && approvalRequest.Apttus_Approval__Action__c.contains('reassign')){
				reassign = URL.getSalesforceBaseUrl().toExternalForm()+ '/apex/Apttus_Approval__ApprovalSummaryLaunch?id='+approvalRequest.Id+'&pageMode=reassign&actionName=reassign_approval_request';
			}
			return reassign;
		}
		set;
	}

	public String approveReject{
	   get{
			if(approvalRequest.Apttus_Approval__Action__c != null && approvalRequest.Apttus_Approval__Action__c.contains('approveReject')){
				approveReject = URL.getSalesforceBaseUrl().toExternalForm()+ '/apex/Apttus_Approval__OpportunityApprovalSummary?id='+approvalRequest.Id+'&pageMode=approveReject&actionName=oppty_approval_summary';
			}
			return approveReject;
		}
		set;
	}

	public String addComment{
		get{
			if(approvalRequest.Apttus_Approval__Action__c != null && approvalRequest.Apttus_Approval__Action__c.contains('addComment')){
				addComment = URL.getSalesforceBaseUrl().toExternalForm()+ '/apex/Apttus_Approval__OpportunityApprovalSummary?id='+approvalRequest.Id+'&pageMode=addComment&actionName=oppty_approval_summary';
			}
			return addComment;
		}
		set;
	}

	public String escalate{
		get{
			if(approvalRequest.Apttus_Approval__Action__c != null && approvalRequest.Apttus_Approval__Action__c.contains('Apttus_Approval__ApprovalRequestEscalate')){
				escalate = URL.getSalesforceBaseUrl().toExternalForm()+ '/apex/Apttus_Approval__ApprovalRequestEscalate?id='+approvalRequest.Id;
			}
			return escalate;
		}
		set;
	}

	//replace values from Labels tomake it custom.
	public String oppLink {
		get{
			oppLink = Label.Apttus_Approval.ApprovalRecordLinkInstruction.replace('{0}', 'Opportunity');
			return oppLink;
		}
		set;
	}
	//Construct the opportunity whole URL
	public String oppUrl {
		get{
			// Create a link to the file.
			oppUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/' + oppId;
			return oppUrl;
		}
		set;
	}
	
	public Boolean isApprover {
		get {
			if(approvalRequest.Apttus_Approval__Approval_Status__c.equalsIgnoreCase('Assigned')){
				isApprover = true;
			}else if(approvalRequest.Apttus_Approval__Approval_Status__c.equalsIgnoreCase('Notified')){
				isApprover = false;
			}
			return isApprover;
		}
		set;
	}
	//Construct List of approvalRequests to be shown in a table.
	public List<Apttus_Approval__Approval_Request__c> oppApprovalRequests {
		get{
			if(String.isNotBlank(oppId)){
				oppApprovalRequests =[
									SELECT
										Apttus_Approval__Step_Name__c,
										Apttus_Approval__Approval_Status__c,
										Apttus_Approval__Date__c,
										Apttus_Approval__Assigned_To_Name__c,
										NF_Assignee_Type__c,
										Apttus_Approval__Actual_Approver__c,
										Apttus_Approval__Approver_Comments__c,
										NF_Role_Name__c,
										NF_Organization_Level__c
									FROM
										Apttus_Approval__Approval_Request__c
									WHERE
										Apttus_Approval__Related_Opportunity__c = :oppId
										AND
										Apttus_Approval__Approval_Status__c != 'Not Submitted'
									];
			}
			return oppApprovalRequests;
		}
		set;
	}

}