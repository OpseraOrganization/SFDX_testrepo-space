/**
* @description: Trigger Handler to send email notifications
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
public without sharing class RebateFormTriggerHandler {
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Form__c rebatePeriod
* Return: void
* Description: Method to send notifications to PRMs
* High Level Process : 
**********************************************************************************************************************/ 
	public static void afterInsert(Rebate_Form__c rebateForm) {
		try{
			rebateformTriggerHelper.sendEmailOnRebateSubmission(rebateForm);
		}catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.RebateFormHelper,PRMGlobalConstants.getCurrentUser);
		}
	}
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Form__c rebatePeriod
* Return: void
* Description: Method to send notifications to PRMs
* High Level Process : 
**********************************************************************************************************************/ 
	public static void afterUpdate(List<Rebate_Form__c> rebateNewForm , Map<Id,Rebate_Form__c> oldMap) {
		try{
			if(rebateNewForm[0].Rebate_Form_Status__c== PRMGlobalConstants.REJECTED_STATUS && oldMap.get(rebateNewForm[0].Id).Rebate_Form_Status__c!= PRMGlobalConstants.REJECTED_STATUS){
				
				rebateformTriggerHelper.sendMailsOnRejection(rebateNewForm[0]);
			}
			if(rebateNewForm[0].Partner_Acceptance_Status__c== PRMGlobalConstants.REJECTED_STATUS && oldMap.get(rebateNewForm[0].Id).Partner_Acceptance_Status__c!= PRMGlobalConstants.REJECTED_STATUS){
				
				rebateformTriggerHelper.sendEmailOnRejectionRebate(rebateNewForm[0]);
			}
		}catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.RebateFormHelper,PRMGlobalConstants.getCurrentUser);
		}
	}
}