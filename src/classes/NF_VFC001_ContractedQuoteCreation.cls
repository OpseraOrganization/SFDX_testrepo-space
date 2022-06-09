/**
 * @name	NF_VFC001_ContractedQuoteCreation 
 * @author  Abdallah Dahjou 
 * @since   Jan 03, 2017
 * @desc	This class used as extension controller of NF_VF001_ContractedQuoteCreation visualforce
 * @history 
 */
public with sharing class NF_VFC001_ContractedQuoteCreation {
	
	// attributes declaration
	List<PermissionSetAssignment> permissionsetAssignment {get;set;}
	public Boolean IscanvasDisplayed {get;set;}
	public Opportunity currentOpp {get;set;}
	public Boolean isError {get;set;}
   
	/*
	*   @description : the constructor.
	*   @param : opportunity standard controller
	*/
	public NF_VFC001_ContractedQuoteCreation(ApexPages.StandardController stdController) {
		  if(!test.isRunningTest()) {
		  stdController.addFields(new List<String>{'isOpportunitySync__c','StageName','Business_Type__c'});
		  }
		 currentOpp = (Opportunity) stdController.getRecord();
		 permissionsetAssignment = new List<PermissionSetAssignment>();
		 permissionsetAssignment = [SELECT AssigneeId
									FROM PermissionSetAssignment
									WHERE (PermissionSet.Name = :Label.NF_CQ_Permission_Set_Admin OR  PermissionSet.Name=:Label.NF_CQ_Permission_Set_Management_User)
									AND AssigneeId =: UserInfo.getUserId()
								   ];
	}
	
	/*
	*   @description : this method check if the connected user have a permission set to manage Contracted Quote.
	*   @return : PageReference
	*/
	public PageReference init(){
		if (permissionsetAssignment.isEmpty()){
			isError = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'You don\'t have the permission to create contracted quote.'));
		}
		if (!currentOpp.isOpportunitySync__c){
			isError = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'The Opportunity is not yet synchronized.'));
		}
		
		if ( currentOpp.StageName==Label.NF_OppStage_Completed ||((currentOpp.StageName!=Label.NF_OppStage_Handover && currentOpp.StageName!=Label.NF_OppStage_Execute && currentOpp.StageName!=Label.NF_OppStage_CreateOffer && currentOpp.StageName!=Label.NF_OppStage_WintheCase ) && currentOpp.Business_Type__c !=Label.NF_BusinessTypeOpp_PP_AccountManagers) || (currentOpp.Business_Type__c==Label.NF_BusinessTypeOpp_PP_AccountManagers && currentOpp.StageName==Label.NF_OppStage_Identify)){
			isError = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Quote creation is not allowed at this stage on SCRM.'));
		}
		else{
			IscanvasDisplayed = true;
		}
		return null;
	}
	
	public pageReference cancel(){
		return new PageReference('/'+currentOpp.Id);
	}
}