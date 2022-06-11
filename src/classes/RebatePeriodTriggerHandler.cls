/**
* @description: Trigger Handler
 to send email notifications
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION		   AUTHOR				DATE		   DETAIL				 FEATURES/CSR/TTP
* 1.0		  PRATEEK PRASOON		  16/08/2017	 Sprint 2 PRM
* ============================================================================ 
*/
public without sharing class RebatePeriodTriggerHandler {
	
	
	
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Period__c rebatePeriod
* Return: void
* Description: Method to send notifications to PRMs
* High Level Process : 
**********************************************************************************************************************/	
	public static void beforeInsert(List<Rebate_Period__c> newList ) {
		try{
			rebatePeriodTriggerHelper.avoidDuplicate(newList[0]);   
			
		}catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.RebatePeriodHelper,PRMGlobalConstants.getCurrentUser);
		}
	}
	
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Period__c rebatePeriod
* Return: void
* Description: Method to send notifications to PRMs
* High Level Process : 
**********************************************************************************************************************/	
	public static void afterInsert(List<Rebate_Period__c> newList ) {
		try{
			if(newList[0].Enrollment_Notification__c== true ){
				rebatePeriodTriggerHelper.sendEmails(newList[0]);   
			}else{
				
			}
		}catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.RebatePeriodHelper,PRMGlobalConstants.getCurrentUser);
		}
	}
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Period__c rebatePeriod
* Return: void
* Description: Method to send notifications to PRMs
* High Level Process : 
**********************************************************************************************************************/ 
	public static void afterUpdate(List<Rebate_Period__c> newList , Map<id,Rebate_Period__c> oldMap) {
		try{
			if(newList[0].Rebate_Notification__c == PRMGlobalConstants.Reminder && oldMap.get(newList[0].Id).Rebate_Notification__c == null){
				rebatePeriodTriggerHelper.sendReminders(newList[0]);
			}
			else if(newList[0].Rebate_Notification__c == PRMGlobalConstants.FinalReview && oldMap.get(newList[0].Id).Rebate_Notification__c == PRMGlobalConstants.Reminder){
				if(newList[0].partner_type__c == PRMGlobalConstants.ValueAddedReseller ){
					rebatePeriodTriggerHelper.sendEmailForExpiredContractVar(newList[0]);
				}else{
					rebatePeriodTriggerHelper.sendEmailForExpiredContract(newList[0]);
				}
			}
			else if(newList[0].Enrollment_Notification__c== true && oldMap.get(newList[0].Id).Enrollment_Notification__c== false){
				//rebatePeriodTriggerHelper.sendReminders(newList[0]);
				rebatePeriodTriggerHelper.sendEmails(newList[0]);
			}
			else{
				
			}
			
		}catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.RebatePeriodHelper,PRMGlobalConstants.getCurrentUser);
		}
	}
	
}