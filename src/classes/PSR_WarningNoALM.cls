/****************************************
* Class Name : PSR_WarningNoALM
* Created Date: July 2017
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: April 2018
* Description : To show Error warning notification , if no opportunity team members are added 
*****************************************/
public without sharing class PSR_WarningNoALM {
	
	/**********************************************************************************************************************
	 * author: Accenture
	 * Date: July -2017
	 * Param: Opportuity Record ID
	 * Return: string
	 * Description: To show Error warning notification , if no opportunity team members are added
	 * High Level Process : 
	 **********************************************************************************************************************/
	@AuraEnabled
	public static String opptyNoALMErrorMessage(String recordId){
		String returnMessage = GlobalConstants.BLANK_VALUE;
		try
		{
		List<Opportunity> opportunityInPreparationStage = [select id, stagename from opportunity where 
														   id =: recordId and stagename =: GlobalConstants.PREPARATION
														   LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
		if(!opportunityInPreparationStage.isEmpty()){
			List<OpportunityTeamMember> opportunityTeamMembersWithALMRole =  [SELECT UserId, OpportunityId, Name, TeamMemberRole, Opportunity.StageName
																FROM OpportunityTeamMember
																WHERE OpportunityId =: recordId															
																LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
			if(opportunityTeamMembersWithALMRole.isEmpty()){
				returnMessage = GlobalConstants.ALM_ADD_ERROR;
			}
		}
			
		system.debug('returnMessage>>>>'+returnMessage);
		return returnMessage;
	}
	catch(Exception ex)
	{
		ExceptionHandler.addException(ex, PSR_WarningNoALM.class.getName(), GlobalConstants.UPDATEOPPORTUNITYBOMINSERT);
		return null;
	}
	}
}