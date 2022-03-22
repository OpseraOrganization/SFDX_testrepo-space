/****************************************
 * Class Name : NF_FacilitatorReject 
 * Created Date: 5th June 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : Class used to reject the G3 facilitaor request
 *****************************************/

public class NF_FacilitatorReject {
	public Opportunity currentOpp {get;set;}
	public Boolean isAlreadyNotified {get;set;}
	public Boolean hasPermissionToredirect {get;set;}
	public Boolean hasNoSubmitForApproval {get;set;}
	public String currentOppId {get;set;}

	public string comments {get;set;}
	
	
	private static final String STAGE_DEVELOP_OPPORTUNITY = 'Develop Opportunity';
	 public static  map<id,id> G3facilitatorId= new map<id,id>();

	public enum ApprovalsRedirection { APPROVALCONTEXTSUBMIT, MYAPPROVALS , PREVIEWSUBMITAPPROVALS }


	 /*
	 * @desc	the method used to initiate the VF NF_FacilitatorNotification 
	 * @return   PageReference: 
	 */
	 
	 /*
	 * @desc	the method used to initiate the VF NF_FacilitatorNotification 
	 * @return   PageReference: 
	 */
	public PageReference init(){
		//Following line used to check wheter the call is from Preview My approvals or Submit&Preview Approvals or Submit from relatedList
 
		 currentOppId = ApexPages.currentPage().getParameters().get('oppId');
		 currentOpp =[
		SELECT  
			Id,
			NF_Facilitator_Notified__c,
			NF_Facilitator_User__c,
			StageName,
			Facilitator_Delegate_1__c,
			Facilitator_Delegate_2__c,
			Facilitator_Delegate_3__c,
			Facilitator_Backup__c,
	Lead_BG__c,
			Lead_BU__c, 
			Supporting_BGs_BUs__c,
			Queue_Id__c,
			Queue_Name__c,
			Type_of_Request__c,
			Business_Type__c,
			OIF_Lines__c,
			G3_Recall__c,
			G3_Recall_Commets__c
		FROM 
			Opportunity
		WHERE 
			Id = :currentOppId
		];
		
			
	 G3facilitatorId.put(currentOpp.NF_Facilitator_User__c,currentOpp.NF_Facilitator_User__c);
	 G3facilitatorId.put (currentOpp.Facilitator_Delegate_1__c,currentOpp.Facilitator_Delegate_1__c);
	 G3facilitatorId.put (currentOpp.Facilitator_Delegate_2__c,currentOpp.Facilitator_Delegate_2__c);
	 G3facilitatorId.put (currentOpp.Facilitator_Delegate_3__c,currentOpp.Facilitator_Delegate_3__c);
	 
	 for(Groupmember Groupmemid:[SELECT GroupId,Id,SystemModstamp,UserOrGroupId FROM GroupMember where (Group.name=:currentOpp.Queue_Name__c OR GroupId=:currentOpp.Queue_Id__c)])
	G3facilitatorId.put(Groupmemid.UserOrGroupId,Groupmemid.UserOrGroupId);
	
	return notifyFacilitator();
	}
 
   
	/**
	*   @description : Method used to fill FacilitatorUser and notify him.
	*   @return : PageReference
	*/
	public PageReference notifyFacilitator(){
	
	
	
   
		Savepoint sp = null;
		if(currentOpp.NF_Facilitator_Notified__c<>True){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please submit the Opportunity to G3 Facilitator'));
			isAlreadyNotified = true;
			hasNoSubmitForApproval=false;
			return null;
		}
		 
		//check if at least 1 record of OIF object should be created before opening G3
		else if(String.IsEmpty(G3facilitatorId.get(UserInfo.getUserId()))){
			//LeadBGNotFilled =True;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You are not allowed to Reject the G3 Facilitator Request'));
			isAlreadyNotified = true;
			hasNoSubmitForApproval=false;
			return null;
		} 
		
		else
		{
		 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Please enter your comments and click on reject'));
			isAlreadyNotified = true;
			hasNoSubmitForApproval=true;
			return null;
		
		}
		 
		}
		
		
	public PageReference Reject() {
	
	 Savepoint sp = null;
	  
	
	
	
	try{
	 currentOpp.NF_Facilitator_User__c = null;
	 currentOpp.G3_Recall__c=True;
	 currentOpp.G3_Recall_Commets__c=comments;
	  currentOpp.NF_Facilitator_Notified__c=false;
			currentOpp.Facilitator_Delegate_1__c = null;
			currentOpp.Facilitator_Backup__c = null;
			currentOpp.Facilitator_Delegate_2__c = null;
			currentOpp.Facilitator_Delegate_3__c = null;
			currentOpp.Queue_Name__c=Null;
			currentOpp.Queue_Id__c=Null;
			
	  if(String.IsEmpty(comments)){
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter your comments'));
		isAlreadyNotified = true;
		hasNoSubmitForApproval=true;
		return null;
		}
		else
	
		update currentOpp;

	}catch(DmlException e){
		isAlreadyNotified = true;
		if(sp != null) Database.rollback(sp);
		if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION){
			String requiredFields = 'Required Fields missing : '+e.getDmlFieldNames(0);
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,requiredFields));
		}
		return null;
	}
	hasPermissionToredirect = true;		
	return  new PageReference('/'+currentOppId); 
			
		 
	}	 
		
	

	/**
	*   @description : Method used to redirect back to the opportunity
	*   @return : PageReference
	*/
	public PageReference cancel() {
		return new PageReference('/'+currentOppId);
	}
	
	 
}