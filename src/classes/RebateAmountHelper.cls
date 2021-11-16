/**
* @description: Trigger helper to send email notifications
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION		   AUTHOR				DATE		   DETAIL				 FEATURES/CSR/TTP
* 1.0		  PRATEEK PRASOON		  01/09/2017	 Sprint 4 PRM
* ============================================================================ 
*/
public without sharing class RebateAmountHelper {
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Form__c rebatePeriod
* Return: void
* Description: Method to send notifications to PRMs
* High Level Process : 
**********************************************************************************************************************/ 
	public static void amountUpdate(Rebate_Amount__c rebateAmount) {
			try{
			boolean allAmountFilled = true;
			List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
			//List<Rebate_Amount__c> rebateAmountList = ;
			for(Rebate_Amount__c amount : [SELECT Rebate__c , Amount__c,Id FROM Rebate_Amount__c where Rebate__c =: rebateAmount.Rebate__c and Rebate_Status__c =: PRMGlobalConstants.StatusAccepted Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				if(amount.Amount__c == null){
					allAmountFilled = false;
					break;
				}
			}

			if(allAmountFilled == true){
				rebate_form__c form = [select Partner_Account__c from rebate_form__c where id =:rebateAmount.Rebate__c Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
				accountMemberList = [SELECT Account_Role__c,Account__r.Name,Id,Name__c,Name__r.Name,Type__c FROM Account_Member__c WHERE Account__c =: form.Partner_Account__c AND Account_Role__c =: PRMGlobalConstants.PARTNER_SALES_MANAGER  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
				if(!accountMemberList.IsEmpty()){
					EmailNotification.sendMailsForAmountFilling(accountMemberList,form );
				}
				
			}
		}
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.rebateAmountHelper,PRMGlobalConstants.amountUpdate);
		}
	}
}