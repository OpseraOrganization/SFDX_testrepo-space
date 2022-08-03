/**
* @description: Coop Activity Trigger Handler to check specific criteria and call helper methods before/after Insert/ update
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
public without sharing class CoOpActivitHandler {
	/**********************************************************************************************************************
* author: Accenture
* Date: May-2018
* Param: List<Co_Op_Activity__c> activityList
* Return: void
* Description: beforeInsertOperation coop activity
**********************************************************************************************************************/ 
	/*public static void beforeInsertOperation(List<Co_Op_Activity__c> activityList) { 
		try{ 
			//CoOpActivityTriggerHelper.populateApprovers(activityList);
		   // CoOpActivityTriggerHelper.setProofOfPerformance(activityList);
		}
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CoOpActivitHandler,PRMGlobalConstants.beforeInsertOperation);}
	}*/
	/**********************************************************************************************************************
* author: Accenture
* Date: May-2018
* Param: List<Co_Op_Activity__c> activityList
* Return: void
* Description: beforeUpdateOperation coop activity
**********************************************************************************************************************/  
	public static void beforeUpdateOperation(List<Co_Op_Activity__c> newActivityList, Map<Id,Co_Op_Activity__c> activityOldMap) { 
		try{ 
			//Throw Error Before Submission of Approval
			CoOpActivityTriggerHelper.validateApprovalProcessCriteria(newActivityList[0],activityOldMap);
		}
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CoOpActivitHandler,PRMGlobalConstants.beforeUpdateOperation);}
	} 
	/**********************************************************************************************************************
* author: Accenture
* Date: May-2018
* Param: List<Co_Op_Activity__c> activityList
* Return: void
* Description: afterUpdateOperation coop activity
**********************************************************************************************************************/  
   /* public static void afterUpdateOperation(List<Co_Op_Activity__c> newActivityList, Map<Id,Co_Op_Activity__c> activityOldMap) { 
		try{ //Auto Reject 
			//CoOpActivityTriggerHelper.autoRejectActivity(newActivityList, activityOldMap);
		}
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CoOpActivitHandler,PRMGlobalConstants.afterUpdateOperation);}
	}*/
}