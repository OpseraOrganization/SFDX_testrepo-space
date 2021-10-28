/**
* @description: Coop Activity Helper 
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION	   AUTHOR				  DATE		   DETAIL				 FEATURES/CSR/TTP
* 1.0		   Sonali Kothavale		25/05/2018	 PRM Release 3
* ============================================================================ 
*/
public without sharing class CoOpActivityTriggerHelper {
	/**********************************************************************************************************************
* author: Accenture
* Date: May-2018
* Param: Map<ID, Co_Op_Activity__c> activityOldMap
* Description: This Method Validates Approval Process Enter Criteria
**********************************************************************************************************************/ 
	public static void validateApprovalProcessCriteria(Co_Op_Activity__c act ,Map<ID, Co_Op_Activity__c> activityOldMap ){
		try{
			if(act.Activity_Status__c.equals(PRMGlobalConstants.activityPending)
			   && activityOldMap.get(act.Id).Activity_Status__c != act.Activity_Status__c) {
				   if(act.Start_Date__c < Date.Today()+15 && (!act.Exception__c.contains(PRMGlobalConstants.pastDateException)) && 
					  activityOldMap.get(act.Id).Activity_Status__c != PRMGlobalConstants.On_Hold ) {
					   act.addError(PRMGlobalConstants.Validation_Error_Message_For_COOP_Approval);
				   }
			}
		}catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.CoOpActivityTriggerHelper ,PRMGlobalConstants.validateApprovalProcessCriteria);
		}
	}
	

}