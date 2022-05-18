/****************************************
* Class Name : CH_CaseCommentTriggerHandler
* Created Date: 20 Dec 2018
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 
* Description : 
* Test Class:
*****************************************/
public class CH_CaseCommentTriggerHandler {
	
	public static boolean doNotNotifyForNAIPAttachment = true;
	
	/********************
	*Method Name: beforeInsertOperation
	*Parameter: New Case List
	*Description: Used to handle before insert operation
	*******************/
  
	public static void beforeInsertOperation(List<CaseComment> newCaseCommentList) { 
		
	  CH_CaseCommentTriggerHelper.scramblingLogic(newCaseCommentList);
		
	}
	 /********************
	*Method Name: beforeupdateOperation
	*Parameter: New Case List
	*Description: Used to handle before update operation
	*******************/
	 public static void beforeupdateOperation(List<CaseComment> newCaseCommentList) { 
		
	  CH_CaseCommentTriggerHelper.scramblingLogic(newCaseCommentList);
		
	}

	/********************
	*Method Name: afterInsertOperation
	*Parameter: New Case List
	*Description: Used to handle after insert operation
	*******************/
	public static void afterInsertOperation(List<CaseComment> newCaseCommentList) {
		if(CH_CaseCommentTriggerHandler.doNotNotifyForNAIPAttachment){//Added to fix NOKIASC-26225
			CH_CaseCommentTriggerHelper.sendNotificationToExternalSystem(newCaseCommentList, 'NOKIA comment added', 'Insert'); 
			CH_CaseCommentTriggerHelper.calculatePlannedAutomaticDateTimer(newCaseCommentList); //Added to NOKIASC-36637
		}	
	}

	/********************
	*Method Name: afterDeleteOperation
	*Parameter: New Case List
	*Description: Used to handle after insert operation
	*******************/
	public static void afterDeleteOperation(List<CaseComment> oldCaseCommentList) { 
		CH_CaseCommentTriggerHelper.sendNotificationToExternalSystem(oldCaseCommentList, 'NOKIA comment deleted', 'Delete');   
	}
}