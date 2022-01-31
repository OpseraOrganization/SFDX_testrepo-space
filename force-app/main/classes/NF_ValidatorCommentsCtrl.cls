/****************************************
 * Class Name : NF_ValidatorCommentsCtrl 
 * Created Date: 5th June 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : Class used to serve as a logic for custom button on the approval request related list to add a comment for VALIDATORS
 *****************************************/
public with sharing class NF_ValidatorCommentsCtrl {
	
	public Opportunity currentOpp {get;set;}
	private Id currentOppId {get;set;}
	 public List<WrapperClass> listWrapper {get;set;}
	public String approverComments {get;set;}
	 
	 Public Boolean Datacheck{get;set;}
	  
	 Public List<Apttus_Approval__Approval_Request__c> ValidatorRec =new List<Apttus_Approval__Approval_Request__c>();
	 
	private final String NOTIFIED = 'Notified';
	private final String VALIDATOR = 'Validator';
	public Boolean hideValidation {get;set;}

	/**
	*   @description : constructor to check whether it is illegible for approver comment or not.
	*/
	public NF_ValidatorCommentsCtrl() {
		hideValidation = false;
		currentOppId = ApexPages.currentPage().getParameters().get('oppId');
   
		String delegateApprovers = '%'+UserInfo.getUserId()+'%';
		currentOpp =[
					SELECT
						Id,
						Name,
						(
						SELECT
						Id,
						Apttus_Approval__Assigned_To_Type__c,
					   NF_Role_Name__c,
						NF_Assignee_Type__c,
						Apttus_Approval__Assigned_To_Id__c,
						Apttus_Approval__Approver_Comments__c,
						Apttus_Approval__Actual_Approver__c,
						Apttus_Approval__Step_Name__c,
						Validator_Status__c,
						Apttus_Approval__Assigned_To_Name__c
						 
						
						FROM 
							Apttus_Approval__R00N70000001lyBlEAI__r
						Where
						 
							(   Apttus_Approval__Assigned_To_Id__c =: UserInfo.getUserId()
							OR
								Apttus_Approval__DelegateApproverIds__c Like :delegateApprovers
							)
						AND
							NF_Assignee_Type__c = :VALIDATOR  AND( Validator_Status__c!='Validated' OR  Validator_Status__c!='Rejected')
					   AND
					   Validator_Status__c=Null
						)
					FROM
						Opportunity
					Where 
						Id =: currentOppId
					];
					
					System.debug('Looppp===='+currentOpp.Apttus_Approval__R00N70000001lyBlEAI__r);

		if(currentOpp.Apttus_Approval__R00N70000001lyBlEAI__r.isEmpty()){
			hideValidation = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Label.NF_NoValidatorRequestwaitingComment));
		}
		else  if(!currentOpp.Apttus_Approval__R00N70000001lyBlEAI__r.isEmpty())
		 {
		 Datacheck=true;
		 listWrapper = new List<WrapperClass>();
			for(Apttus_Approval__Approval_Request__c appRequ : currentOpp.Apttus_Approval__R00N70000001lyBlEAI__r){
			 if(appRequ<>NUll)
			 listWrapper.add(new WrapperClass(appRequ));
		 }

	}
	
  }  
	
	 /**
	*   @description : Method is used topass the records to wraper class
	*   @Use : PageReference
	*/
	
   @TestVisible  public class WrapperClass {
		public Boolean checked {get;set;}
		public Apttus_Approval__Approval_Request__c Rec {get;set;}
		public WrapperClass(Apttus_Approval__Approval_Request__c Rec) {
			this.Rec= Rec;
		}
	}

	/**
	*   @description : Method used to save the corresponding Approval Request record with the entered comment from the Page.
	*   @return : PageReference
	*/
	 public PageReference saveValidatorComments(){
	 PageReference myPAge;
		List<Apttus_Approval__Approval_Request__c> appRequestsToUpdate = new List<Apttus_Approval__Approval_Request__c>();
		Savepoint sp = Database.setSavepoint();
		
		 List<Apttus_Approval__Approval_Request__c> CommentsUpdate = new List<Apttus_Approval__Approval_Request__c>();
		List<WrapperClass> listTempWrapper = new List<WrapperClass>();
		for(WrapperClass w : listWrapper) {
			if(w.checked) {
				CommentsUpdate.add(w.Rec);
			} else {
				listTempWrapper.add(w);
			}
		}
		if(CommentsUpdate.size() > 0){
		   for(Apttus_Approval__Approval_Request__c appRequ : CommentsUpdate){
 
				appRequ.Validator_Status__c='Validated';
				appRequ.Apttus_Approval__Actual_Approver__c=UserInfo.getUserId();
				appRequestsToUpdate.add(appRequ);
				
			}
			if(!appRequestsToUpdate.isEmpty()){
				try{
					update appRequestsToUpdate;
					myPAge= new PageReference('/'+currentOppId);
				}catch(DmlException e){
					Database.rollback(sp);
					String Errorinfo=(e.getmessage().split(','))[1];
					system.debug('###Exception from Validator : '+e.getMessage() + 'Stack Trace : '+e.getStackTraceString());
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Errorinfo));
					return null;
				}
				
			}
		  }
		 else {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Select atleast one Task to update'));
			return null;
		}
		
	  return  myPAge;
	   
	}
	
	
	
	
	 /**
	*   @description : Method used to save the corresponding Approval Request record with the entered comment from the Page.
	*   @return : PageReference
	*/
	public PageReference RejectValidatorComments(){
		 PageReference myPAge;
		List<Apttus_Approval__Approval_Request__c> appRequestsToUpdate = new List<Apttus_Approval__Approval_Request__c>();
		Savepoint sp = Database.setSavepoint();
		
		 List<Apttus_Approval__Approval_Request__c> CommentsUpdate = new List<Apttus_Approval__Approval_Request__c>();
		List<WrapperClass> listTempWrapper = new List<WrapperClass>();
		for(WrapperClass w : listWrapper) {
			if(w.checked) {
				CommentsUpdate.add(w.Rec);
			} else {
				listTempWrapper.add(w);
			}
		}
		if(CommentsUpdate.size() > 0){
		   for(Apttus_Approval__Approval_Request__c appRequ : CommentsUpdate){
 
				appRequ.Validator_Status__c='Rejected';
				appRequ.Apttus_Approval__Actual_Approver__c=UserInfo.getUserId();
				appRequestsToUpdate.add(appRequ);
				
			}
			if(!appRequestsToUpdate.isEmpty()){
				try{
					update appRequestsToUpdate;
					myPAge= new PageReference('/'+currentOppId);
				}catch(DmlException e){
					Database.rollback(sp);
					String Errorinfo=(e.getmessage().split(','))[1];
					system.debug('###Exception from Validator : '+e.getMessage() + 'Stack Trace : '+e.getStackTraceString());
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Errorinfo));
					return null;
				}
				
			}
		  }
		 else {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Select atleast one Task to update'));
			return null;
		}
		
	  return  myPAge;
	   
	}


	/**
	*   @description : Method used to redirect back to the opportunity
	*   @return : PageReference
	*/
	public PageReference cancel() {
		return new PageReference('/'+currentOppId);
	}
}