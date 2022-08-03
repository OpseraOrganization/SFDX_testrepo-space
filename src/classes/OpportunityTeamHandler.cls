/***********************************************
*	Class Name : OpportunityTeamHandler
*	Created By : Accenture IDC
*	Created Date :23/Dec/2016
*	Description : This will give access or delete access to new opportunity Team member to the documents on that opportunity				  
*	Requirement : Doc Strategy Requirement 657
				   Sales Process Requirment 963
				   
*********************************************/
public with sharing class OpportunityTeamHandler {
	
	
	
	/****************************************
	*Method Name: afterUpdate
	*Description: This will handle the methods from OpportunityTeamHelper that will fire after Insert
	*Parameters: Old and New Opportunity Team Map 
	*****************************************/
	public static void afterUpdate(Map<id,OpportunityTeamMember> opportunityTeamMemberNewMap , Map<id,OpportunityTeamMember> opportunityTeamMemberOldMap){
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
		{
			OpportunityTeamHelper.changeOnOTMs(opportunityTeamMemberNewMap.Values());//method to stamp OTM update on Oppty.
			
			if(GlobalConstants.RUN_OPPORTUNITYTEAM_TRIGGER_ON_FILESHARING)
			{  
				//OpportunityTeamHelper.unshareFilesOnUpdate(opportunityTeamMemberNewMap,opportunityTeamMemberOldMap);
			}
		}
	}
	
	/****************************************
	*Method Name: beforeDelete
	*Description: This will handle the methods from OpportunityTeamHelper that will fire before Delete
	*Parameters: Opportunity Team  List
	*****************************************/	
	public static void beforeDelete(List<OpportunityTeamMember> optyTeamList){
		
		String profileName = [Select Id,Name from Profile where Id =: userinfo.getProfileId()].Name;
		system.debug('ProfileName'+profileName);
			
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		   OpportunityTeamHelper.changeOnOTMs(optyTeamList);//method to stamp OTM delete on Oppty.

			if(Admin_Profiles__c.getInstance(profileName) == null){
				OpportunityTeamHelper.restrictOTM(optyTeamList);
				system.debug('OpptyTeamErrorMessage>>Handler');
			}
		}
	}
	
	/****************************************
	*Method Name: afterDelete
	*Description: This will handle the methods from OpportunityTeamHelper that will fire after Delete
	*Parameters: Opportunity Team  List
	*****************************************/	
	public static void afterDelete(List<OpportunityTeamMember> opportunityTeamMemberOldList){
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			  //Sales process: Sprint 5 hypercare Req#963 
			 OpportunityTeamHelper.insertIntoDeleted_OTM(opportunityTeamMemberOldList);
		}
	}
	/***********************************************
*	Method Name: afterDeleteUnshareProposalRecords 
*	Added By : Puneet Gosain (Nokia CPQ)
*	Updated Date : 22/05/2017
*	Description : Calling the method of NokiaCPQShareProposalsWithOTM to unshare the proposal records with Opportunity team member when deleted.				 
*	Requirement : Open a quote from CPQ 2061
				   Manage Opportunity Teams 2071
				   View and edit Quotes 2087
*********************************************/
	public static void afterDeleteUnshareProposalRecords(Map<Id,OpportunityTeamMember> opportunityTeamMembersMap)  {
	   // NokiaCPQShareProposalsWithOTM.unshareProposalRecordAfterOTMTriggerDelete(opportunityTeamMembersMap.keySet());
	//NokiaCPQShareProposalsWithOTM.unshareProposalRecordAfterOTMTriggerDelete(opportunityTeamMembersMap);
	}
	
	/***************************************
	*Method Name: beforeInsert
	*Description: This will handle the methods from OpportunityTeamHelper that will fire before Update
	*Parameters: Opportunity Team  List
	*****************************************/  
	 public static void beforeInsert(List<OpportunityTeamMember> optyTeamList){ 
	  
	 //Added by HCL Team for User ristriction on OptyTeamMember
		// Modified on 4th July 2019
			OpportunityTeamHelper.restrictUser(optyTeamList, null);
		//End
	  
		String profileName = [Select Id,Name from Profile where Id =: userinfo.getProfileId()].Name;
		system.debug('ProfileName'+profileName);
		
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
		{
			OpportunityTeamHelper.changeOnOTMs(optyTeamList);//method to stamp OTM insert on Oppty.
	 OpportunityTeamHelper.restrictSameTeamandAdditionalTeamRole(optyTeamList);
	OpportunityTeamHelper.oppTeamPrMValidation(optyTeamList);
			
			if(Admin_Profiles__c.getInstance(profileName) == null)
			{
	OpportunityTeamHelper.restrictOTM(optyTeamList);
			}
			
			if(!GlobalConstants.RUN_OPPORTUNITYTEAM_TRIGGER_ON_NSACompliantAcc)
			{
	  OpportunityTeamHelper.CheckNSACompliantAccount(optyTeamList);
			}
		 
		}
	}
	
	/****************************************
	*Method Name: beforeUpdate
	*Description: This will handle the methods from OpportunityTeamHelper that will fire before Insert
	*Last modified By - HCL Team to update beforeUpdate() defination. Added a new parameter oldMapOpptyMember for oldMap value.
	*Parameters: Opportunity Team  List
	*****************************************/  
	public static void beforeUpdate(List<OpportunityTeamMember> optyTeamList, Map<Id,OpportunityTeamMember> oldMapOpptyMember){ 
		
		//Added by HCL Team for User ristriction on OptyTeamMember
		// Modified on 4th July 2019
		OpportunityTeamHelper.restrictUser(optyTeamList, oldMapOpptyMember);
		//End
		
		String profileName = [Select Id,Name from Profile where Id =: userinfo.getProfileId()].Name;
		system.debug('ProfileName'+profileName);
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			OpportunityTeamHelper.restrictSameTeamandAdditionalTeamRole(optyTeamList);
			OpportunityTeamHelper.oppTeamPrMValidation(optyTeamList);
		} 
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && Admin_Profiles__c.getInstance(profileName) == null){
				OpportunityTeamHelper.restrictOTM(optyTeamList);
				
		}
	}
	
	 /****************************************
	*Method Name: AfterInsert
	*Description: This will handle the methods from OpportunityTeamHelper that will fire after Insert
	*Parameters: Map of OpportunityTeamMember with Id
	*****************************************/  
	public static void AfterInsert(Map<Id,OpportunityTeamMember> optyTeamMap){ 
		//if(!System.isFuture() && !System.isBatch() && !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			   //Database.executeBatch(new Batch_NokiaCPQ_quoteShareToOTM(optyTeamList));
			   //OpportunityTeamHelper.quoteProposalShare(optyTeamMap.keySet());
		//} 
	}
}