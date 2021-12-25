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
public without sharing class RebateAmountHandler {
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Form__c rebatePeriod
* Return: void
* Description: Method to send notifications to PRMs
* High Level Process : 
**********************************************************************************************************************/ 
	public static void afterUpdate(Rebate_Amount__c rebateAmount,Map<id,Rebate_Amount__c> oldAmount) {
		if(rebateAmount.Amount__c != oldAmount.get(rebateAmount.id).Amount__c){
			RebateAmountHelper.amountUpdate(rebateAmount);
		}
	}
	
}