/**
* @description: Coop payment Trigger Handler to check specific criteria and call helper methods before/after Payment update
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
public without sharing class CoOpPaymentHandler {

/**********************************************************************************************************************
* author: Accenture
* Date: May-2018
* Param: List<CoOp_Claim_Payment__c> PaymentList
* Return: void
* Description: Method for before Payment insert
* High Level Process : 
**********************************************************************************************************************/ 
/*public static void beforeInsertOperation(List<CoOp_Claim_Payment__c> PaymentList) { 
		try{ 
			 // 
		}
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CoOpPaymentHandler,PRMGlobalConstants.beforeInsertOperation);}
	}*/

/**********************************************************************************************************************
* author: Accenture
* Date: May-2018
* Param: List<CoOp_Claim_Payment__c> PaymentList, Map<Id,CoOp_Claim_Payment__c> paymentOldMap
* Return: void
* Description: Method for before Payment Update
* High Level Process : 
**********************************************************************************************************************/ 
/*public static void beforeUpdateOperation(List<CoOp_Claim_Payment__c> newPaymentList, Map<Id,CoOp_Claim_Payment__c> paymentOldMap) { 
		try{ 
		}
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CoOpPaymentHandler,PRMGlobalConstants.beforeUpdateOperation);}
	} */

/**********************************************************************************************************************
* author: Accenture 
* Date: May-2018
* Param: List<CoOp_Claim_Payment__c> PaymentList, Map<Id,CoOp_Claim_Payment__c> paymentOldMap
* Return: void
* Description: Method for After Payment Update
* High Level Process : 
**********************************************************************************************************************/ 
 public static void afterUpdateOperation(List<CoOp_Claim_Payment__c> newPaymentList, Map<Id,CoOp_Claim_Payment__c> paymentOldMap) { 
		try{
			//system.debug('>> in CoOpPaymentHandler - afterUpdateOperation method >>>>>>');
			List<CoOp_Claim_Payment__c> paymentReimbursed = new List<CoOp_Claim_Payment__c>();
			//system.debug('>> newPaymentList: '+ newPaymentList);
			for(CoOp_Claim_Payment__c updatedPayment: newPaymentList){
			// system.debug('>> updatedPayment- Status : '+ updatedPayment.Reimbursement_Reference_Number__c);
			if((updatedPayment.Reimbursement_Reference_Number__c!= paymentOldMap.get(updatedPayment.id).Reimbursement_Reference_Number__c) && updatedPayment.Reimbursement_Reference_Number__c!= Null){
				paymentReimbursed.add(updatedPayment);
			}
			}
			//system.debug('>> paymentReimbursed : '+ paymentReimbursed);
			If(!paymentReimbursed.IsEmpty()){
				CoOpPaymentHelper.updateAccrualClaimForReimburdement(paymentReimbursed);	  
			}
		  }		
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CoOpPaymentHandler,PRMGlobalConstants.afterUpdateOperation);}
	}
}