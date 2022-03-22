/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:			OpportunityTeamHandlerPRM
Description:	 Handler for opportunity team trigger
Date		Version	  Author		Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
04/04/2016	  1.0		Pooja			Handle class
----------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*******************************
	*Method name: afterInsert
	*Description: 
	*Parameter: 
	*******************************/
 
public with sharing class OpportunityTeamHandlerPRM {
/**
* Description : after insert trigger method 
* @param opportunityTeamMemberList
* @return NA
* @throws NA
**/
	public static void afterInsert(List<OpportunityTeamMember> opportunityTeamMemberList){
		try{
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){		   
		}   
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.OpportunityTeamHandlerPRM,PRMGlobalConstants.afterInsert); }
	}

	/**
* Description : afterDelete trigger method 
* @param opportunityTeamMemberOldList
* @return NA
* @throws NA
**/
	public static void afterDelete(List<OpportunityTeamMember> opportunityTeamMemberOldList){
		try{
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			OpportunityTeamHelper_PRM.unshareFilesOnDelete(opportunityTeamMemberOldList);
		}
		}
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.OpportunityTeamHandlerPRM,PRMGlobalConstants.afterInsert);
		}
	}
	
	/*******************************
	*Method name: beforeInsertOTM
	*Description: This method will stop user from adding non account partner in OTM
	*Parameter: Opportunity Values
	*******************************/
	public static void beforeInsertOTM(OpportunityTeamMember OTM){
		try{
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			OpportunityTeamHelper_PRM.deletePartnerFromDiffAccount(OTM);
		}
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.OpportunityTeamHandlerPRM,PRMGlobalConstants.beforeInsertOTM);}
	
	}
}