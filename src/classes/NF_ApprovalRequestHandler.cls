/**
* @Name	NF_ApprovalRequestHandler
* @Author  Najlae KHARBOUCH 
* @Since   Jan 30, 2017
* @Desc	This class  handles all trigger events on the Apttus_Approval__Approval_Request__c object.
* @History 
*/

public with sharing class NF_ApprovalRequestHandler extends NF_TriggerHandler {
	// Maps and list initialized from the Trigger context
	private Map<Id, Apttus_Approval__Approval_Request__c> oldMap;
	private List<Apttus_Approval__Approval_Request__c> oldList;
	private List<Apttus_Approval__Approval_Request__c> newList;
	
	/*
* @desc	Constructor
*/
	public NF_ApprovalRequestHandler() {
		this.oldMap = (Map<Id, Apttus_Approval__Approval_Request__c>) Trigger.oldMap;
		this.oldList = (List<Apttus_Approval__Approval_Request__c>) Trigger.old;
		this.newList = (List<Apttus_Approval__Approval_Request__c>) Trigger.new;	
	} 
	
	/*
* @desc beforeUpdate handle the Value before update event
*/
	public override void beforeUpdate(){
		List<Apttus_Approval__Approval_Request__c> lstAR_Delegates = new List<Apttus_Approval__Approval_Request__c>();
		List<Apttus_Approval__Approval_Request__c> lstAR_AssignedTo = new List<Apttus_Approval__Approval_Request__c>(); 
		List<Apttus_Approval__Approval_Request__c> lstAR_FindDelegatesBackup = new List<Apttus_Approval__Approval_Request__c>();
		
		for(Apttus_Approval__Approval_Request__c newApprovalReq : newList){
			Apttus_Approval__Approval_Request__c oldApprovalReq = oldMap.get(newApprovalReq.Id);
			if(newApprovalReq.Apttus_Approval__DelegateApproverIds__c != null  && oldApprovalReq.Apttus_Approval__DelegateApproverIds__c != newApprovalReq.Apttus_Approval__DelegateApproverIds__c){
	lstAR_Delegates.add(newApprovalReq);
			}
			
			if(((newApprovalReq.Apttus_Approval__DelegateApproverIds__c == null && oldApprovalReq.Apttus_Approval__DelegateApproverIds__c == null) || (newApprovalReq.Apttus_Approval__Backup_From_User__c == null || oldApprovalReq.Apttus_Approval__Backup_From_User__c ==null)) && 
	  (newApprovalReq.NF_Assignee_Type__c == GlobalConstants.APPROVER || newApprovalReq.NF_Assignee_Type__c == GlobalConstants.VALIDATOR || newApprovalReq.NF_Assignee_Type__c == GlobalConstants.STAKEHOLDER_INFORMATION) && newApprovalReq.Apttus_Approval__Approval_Status__c == GlobalConstants.STATUS_NOT_SUBMITTED ){
	   lstAR_FindDelegatesBackup.add(newApprovalReq);
	  }
			
			if(newApprovalReq.Apttus_Approval__Assigned_To_Id__c != null  && newApprovalReq.Approver_User__c != newApprovalReq.Apttus_Approval__Assigned_To_Id__c ){
	lstAR_AssignedTo.add(newApprovalReq);  
			}			
		}
		
		if(!lstAR_FindDelegatesBackup.isEmpty()){
			NF_ApprovalRequest.findDelegatesOrBackup(lstAR_FindDelegatesBackup);
			List<Apttus_Approval__Approval_Request__c> arDelegates = new List<Apttus_Approval__Approval_Request__c>(); 
			for(Apttus_Approval__Approval_Request__c req : lstAR_FindDelegatesBackup){
	if(req.Apttus_Approval__DelegateApproverIds__c != null){
		arDelegates.add(req);
	}
			}
			if(!arDelegates.isEmpty()){
				NF_ApprovalRequest.getDelegateApprovers(arDelegates);  
			}
		}
		
		if(!lstAR_Delegates.isEmpty()){
			NF_ApprovalRequest.getDelegateApprovers(lstAR_Delegates);  
		}
		
		if(!lstAR_AssignedTo.isEmpty()){
			NF_ApprovalRequest.getAssignedId(lstAR_AssignedTo);  
		}
		
	}
	
	
	public override void afterInsert(){
		List<Apttus_Approval__Approval_Request__c> Stakeholderinfo =new List<Apttus_Approval__Approval_Request__c>();
		
		for(Integer i=0; i< newList.size() ; i++){
			if(newList[i].Apttus_Approval__Assigned_To_Name__c<>NUll)
			{
	Stakeholderinfo.add(newList[i]);
			}   
		}
	}
	
	/*
* @desc beforeInsert handle the Value before insert event
*/
	public override void beforeInsert(){
		List<Apttus_Approval__Approval_Request__c> lstApprovalRequest = new List<Apttus_Approval__Approval_Request__c>();
		
		for(Apttus_Approval__Approval_Request__c appRequest : newList){
			if(appRequest.Apttus_Approval__DelegateApproverIds__c != null ){
	lstApprovalRequest.add(appRequest);
			}
		}
		
		if(!lstApprovalRequest.isEmpty()){
			NF_ApprovalRequest.getDelegateApprovers(lstApprovalRequest);  
		}
		
	}
	
	/*
* @desc afterInsert handle the Value after update event
*/
	public override void afterUpdate(){
		system.debug('INSIDE AFTER UPDATE'); 
		List<Apttus_Approval__Approval_Request__c> lstValidatorRequest = new List<Apttus_Approval__Approval_Request__c>();
		List<Apttus_Approval__Approval_Request__c> lstApprovalRequest = new List<Apttus_Approval__Approval_Request__c>();
		List<Apttus_Approval__Approval_Request__c> Delegatesharing= new List<Apttus_Approval__Approval_Request__c>();
		List<Apttus_Approval__Approval_Request__c> Stakeholder= new List<Apttus_Approval__Approval_Request__c>();
		
		Set<ID> Reminderid= new Set<ID>();
		Set<ID> StakeholderID= new Set<ID>();
		
		for(Integer i=0; i< newList.size() ; i++){
			if(newList[i].Apttus_Approval__Approval_Status__c!=oldList[i].Apttus_Approval__Approval_Status__c && newList[i].Apttus_Approval__Approval_Status__c<>NULL   && ( newList[i].Apttus_Approval__Approval_Status__c.equals('Approved'))){
	lstApprovalRequest.add(newList[i]);
			}
			
			if(!GlobalConstants.OPPORTUNITY_CHATTER_CHECK &&newList[i].Apttus_Approval__Step_Name__c<>Null &&newList[i].Apttus_Approval__Approval_Status__c!=oldList[i].Apttus_Approval__Approval_Status__c && newList[i].Apttus_Approval__Approval_Status__c<>NULL   && ( newList[i].Apttus_Approval__Approval_Status__c.equals('Approved')) &&  newList[i].Apttus_Approval__Step_Name__c.equalsignorecase(Label.G5_CT_Head_Check) && (newList[i].Oppty_LOA_Level__c<>Null && newList[i].Oppty_LOA_Level__c<>GlobalConstants.LOA_Level_A_Plus)){
	Stakeholder.add(newList[i]);  
			}
			
		}
		system.debug('List  lstApprovalRequest:' +lstApprovalRequest);
		
		
		for(Integer i=0; i< newList.size() ; i++){
			if(newList[i].Validator_Status__c!= oldList[i].Validator_Status__c &&newList[i].Validator_Status__c<>NULL   && ( newList[i].Validator_Status__c.equals('Validated') || newList[i].Validator_Status__c.equals('Rejected'))){
	lstValidatorRequest.add(newList[i]);
			}
		}
		system.debug('List lstValidatorRequest is:' +lstValidatorRequest);
		
		
		for(Integer i=0; i< newList.size() ; i++){
			if(newList[i].Apttus_Approval__DelegateApproverIds__c != null  && oldList[i].Apttus_Approval__DelegateApproverIds__c != newList[i].Apttus_Approval__DelegateApproverIds__c){
	Delegatesharing.add(newList[i]);
			}
		}
		
		for(Integer i=0; i< newList.size() ; i++){
			StakeholderID.add(newList[i].id);
			if(newList[i].NF_Remaindercount__c!= null  && oldList[i].NF_Remaindercount__c!= newList[i].NF_Remaindercount__c && newList[i].NF_Remaindercount__c==0){
	Reminderid.add(newList[i].id);
			}
		}
		
		if(!Reminderid.isEmpty()){
			NF_ApprovalRequest.Remindupdate(Reminderid);
		}
		if(!lstValidatorRequest.isEmpty()&&!GlobalConstants.Recursive_APPREq_CHECK){
			system.debug('INSIDE VALIDATOR REQ' );
			NF_ApprovalRequest.getNotificationUsersList(lstValidatorRequest);
			SYSTEM.DEBUG('VALUE : '+lstValidatorRequest);
		}
		
		if(!lstApprovalRequest.isEmpty()){
			NF_ApprovalRequest.getApproverNotification(lstApprovalRequest);
		}
		If(!Stakeholder.isEmpty()){
			NF_ApprovalRequest.ChatterPostToG5StakeHolders(Stakeholder);
		}
		if(!Delegatesharing.isEmpty()){
			NF_ApprovalRequest.Opptysharing(Delegatesharing);
		}
		ITA_IFM_PAD.deactivateTrigger('NF_ApprovalRequestTrigger');	
	}
}