/**
 * @name	NF_ValidatorApproveorRejectController  
 * @author   
 * @since   July 08, 2017
 * @desc	Validator can able to reject /approve thier records

 * @history 
 */

public class NF_ValidatorApproveorRejectController  {

	

	public Apttus_Approval__Approval_Request__c ValidatorRec {get;set;}
	public boolean isQueueAssigned {get;set;}
	public Boolean isAlreadyNotified {get;set;}
	public Boolean hasPermissionToredirect {get;set;}
	public Boolean hasNoSubmitForApproval {get;set;}
	 public String currentId {get;set;}

	public string comments {get;set;}
	public static  map<id,id> ValidatorUsers= new map<id,id>();
	
 
	 

	 
   Public NF_ValidatorApproveorRejectController(ApexPages.StandardController controller)
   {
   currentId=controller.getRecord().Id;  
   this.init();
   
   }
	
	 
	 /*
	 * @desc	the method used to initiate the VF  NF_Validator Approve or Reject
	 * @return   PageReference: 
	 */
	public PageReference init(){
		//Following line used to check wheter current user and approver user information
 
		   
		 ValidatorRec=[
					SELECT  
						Id,
						 Apttus_Approval__Object_Id__c,
						 NF_Assignee_Type__c,
						 Apttus_Approval__Assigned_To_Id__c,
						 Apttus_Approval__Approver_Comments__c,
						 Apttus_Approval__Actual_Approver__c,
						 Validator_Status__c,
						 Apttus_Approval__DelegateApproverIds__c,
						 Aproval_Completion_days__c
					FROM 
						Apttus_Approval__Approval_Request__c
					WHERE 
						  ID=: currentId
					];
					
			 
			ValidatorUsers.put(ValidatorRec.Apttus_Approval__Assigned_To_Id__c,ValidatorRec.Apttus_Approval__Assigned_To_Id__c);
			
			 if (ValidatorRec.Apttus_Approval__DelegateApproverIds__c != null) {
			String[] delegateApproverIds = ValidatorRec.Apttus_Approval__DelegateApproverIds__c.split(',');
			for (string delegateapproverId: delegateApproverIds) {
				ValidatorUsers.put(delegateapproverId,delegateapproverId);
			}
		   }
		   
			
	   return notifyInfo();
	}
 
   
	/**
	*   @description : Method used to check the current user and approver user details
	*   @return : PageReference
	*/
	public PageReference notifyInfo(){
	
	
	
   
		Savepoint sp = null;
		
		if(String.IsEmpty(ValidatorUsers.get(UserInfo.getUserId())))
	   {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.label.NF_Validatior_ID_Not_Match_Error));
			isAlreadyNotified = true;
			hasNoSubmitForApproval=false;
			return null;
		}
		
		 else if(!String.isBlank(ValidatorRec.Validator_Status__c)) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.label.NF_Validation_Record_Completion_Status));
			isAlreadyNotified = true;
			hasNoSubmitForApproval=false;
			return null;
		} 
		else if(ValidatorRec.Aproval_Completion_days__c<>Null && ValidatorRec.Aproval_Completion_days__c>=7) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not leave validation comments after one week of approval decision'));
			isAlreadyNotified = true;
			hasNoSubmitForApproval=false;
			return null;
		}
		
		else
		{
		isAlreadyNotified = true;
			hasNoSubmitForApproval=true;
			return null;
		
		}
		
		
		 
		}
		
	/**
	*   @description : Method used to Update the Validator Status
	*   @return : PageReference
	*/
		
		
	public PageReference Reject() {
	
	 Savepoint sp = null;
		
				try{
				  
				 ValidatorRec.Apttus_Approval__Approver_Comments__c=comments;
				 ValidatorRec.Validator_Status__c='Rejected';
				 ValidatorRec.Apttus_Approval__Actual_Approver__c=UserInfo.getUserId();
				 
			   
			
			   if(String.IsEmpty(comments)){
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter the comments'));
					isAlreadyNotified = true;
					hasNoSubmitForApproval=true;
					return null;
					}
					else
				
					update ValidatorRec;

				}catch(DmlException e){
					isAlreadyNotified = true;
					if(sp != null) Database.rollback(sp);
						 String requiredFields = 'Required Fields missing : '+e.getDmlFieldNames(0);
						ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
					
					return null;
				}
				hasPermissionToredirect = true;							 
				return  new PageReference('/'+currentId ); 
			
		 
	}   
	
	
   /**
	*   @description : Method used to Update the Validator Status
	*   @return : PageReference
	*/
		
	
	 public PageReference Approve() {
	
	 Savepoint sp = null;
		
				try{
				  
				 ValidatorRec.Apttus_Approval__Approver_Comments__c=comments;
				 ValidatorRec.Validator_Status__c='Validated';
				  ValidatorRec.Apttus_Approval__Actual_Approver__c=UserInfo.getUserId();
				 
			   
			
			   if(String.IsEmpty(comments)){
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter your comments'));
					isAlreadyNotified = true;
					hasNoSubmitForApproval=true;
					return null;
					}
					else
				
					update ValidatorRec;

				}catch(DmlException e){
					isAlreadyNotified = true;
					if(sp != null) Database.rollback(sp);
					
						String requiredFields = 'Required Fields missing : '+e.getDmlFieldNames(0);
						ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,requiredFields));
					
					return null;
				}
				hasPermissionToredirect = true;							 
				return  new PageReference('/'+currentId ); 
			
		 
	}	   
		
	

	/**
	*   @description : Method used to redirect back to the Validator Rec Page
	*   @return : PageReference
	*/
	public PageReference cancel() {
		return new PageReference('/'+currentId );
	}
	
	 
}