/****************************************
* Class Name : BusinessPlanTriggerHandler
* Created Date: 1 Sep 2017
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description : Handle the sequence of the BusinessPlanTriggerHelper
* Test Class: 
*****************************************/
public without sharing class BusinessPlanTriggerHandler {
	/********************
*Method Name: beforeUpdateOperation
*Parameter: New Bp List, New Bp Map, Old Bp Map
*Description: Used to handle before Update activities
*******************/
	public static void beforeUpdateOperation(List<Business_Plan__c> newBpList,Map<ID, Business_Plan__c> bpNewMap, 
											 Map<ID, Business_Plan__c> bpOldMap) { 
		try{ 
			//Throw Error Before Submission of Approval
			BusinessPlanTriggerHelper.validateApprovalProcessCriteria(newBpList[0],bpOldMap);
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.BusinessPlanTriggerHandler,PRMGlobalConstants.beforeUpdateOperation);}
	} 
	/********************
*Method Name: afterUpdateOperation
*Parameter: New Bp List, Old Bp Map
*Description: Used to handle after Update activities
*******************/
	public static void afterUpdateOperation(List<Business_Plan__c> newBpList, Map<ID, Business_Plan__c> bpOldMap) {						
		list<Business_Plan__c> approvedBP = new list<Business_Plan__c>();
		try{
			for(Business_Plan__c newBP: newBpList){				   
				if(newBP.Business_Plan_Status__c != bpOldMap.get(newBP.id).Business_Plan_Status__c && 
					(newBP.Business_Plan_Status__c == PRMGlobalConstants.StatusRejected 
						 || newBP.Business_Plan_Status__c == PRMGlobalConstants.BPStatus_Approved 
						 	|| newBP.Business_Plan_Status__c == PRMGlobalConstants.BPStatus_Submitted)){
						approvedBP.add(newBP);
					}				   
			}
			if(!approvedBP.isEmpty()){
				BusinessPlanTriggerHelper.updateAccNAccreditation(approvedBP);
			}			   
			BusinessPlanTriggerHelper.createTaskForReviewEmail(newBpList, bpOldMap);
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.BusinessPlanTriggerHandler,PRMGlobalConstants.afterUpdateOperation);}
	} 
}