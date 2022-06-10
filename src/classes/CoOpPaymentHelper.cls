/**
* @description: Payment Trigger Helper to handle complx logic called from Handler on specific event
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
public without sharing class CoOpPaymentHelper{

/**********************************************************************************************************************
* author: Accenture
* Date: May-2018
* Param: List<CoOp_Claim_Payment__c> ReimbursedPaymentList
* Return: void
* Description: Method to process Accrual-Claim junctin object status as reimburesed
* High Level Process : 
**********************************************************************************************************************/ 
public static void updateAccrualClaimForReimburdement(List<CoOp_Claim_Payment__c> ReimbursedPaymentList){
		try{
		//system.debug('>> in handler accrual asscoiation method . ReimbursedPaymentList :' + ReimbursedPaymentList);
		set<id> paymentId = new set<id>();
		set<id> claimId = new set<id>();
		list<Claim__c> reimburesdClaims = new list<Claim__c>();
		map<id, Decimal> claimAmount = new map<Id, Decimal>();
		
		for(CoOp_Claim_Payment__c payments : ReimbursedPaymentList){
				paymentId.add(payments.id);
				claimId.add(payments.Claim__c);
				claimAmount.put(payments.Claim__c, payments.Amount_Pending_for_Reimbursement__c);
			}
		//system.debug('>> paymentId : ' + paymentId);
			
		list<Accrual_junction__c> allAcrrualClaim = [Select id, name, Status__c from Accrual_junction__c 
													 where Payment__c in: paymentId 
													 Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		
		for(Claim__c claimsToUpdate : [select id, Claim_Status__c, Amount_Pending_for_Reimbursement__c, HFLOF_Amount__c from Claim__c 
									   where id in: claimId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			System.debug('ii::'+claimsToUpdate.Amount_Pending_for_Reimbursement__c);
										   System.debug('jj::'+claimAmount.get(claimsToUpdate.id));
										   if((claimsToUpdate.Amount_Pending_for_Reimbursement__c == claimAmount.get(claimsToUpdate.id)) && 
				claimsToUpdate.HFLOF_Amount__c == 0){
				
				claimsToUpdate.Claim_Status__c = PRMGlobalConstants.CoopReimbursed;
				
			}
			claimsToUpdate.Date_of_Reimbursement__c = system.today();
			reimburesdClaims.add(claimsToUpdate);
		}
			
		for(Accrual_junction__c accrualClaim : allAcrrualClaim){
				accrualClaim.Status__c = PRMGlobalConstants.CoopReimbursed;
		}
		//system.debug('  ... reimburesdClaims : ' + reimburesdClaims);
		If(!reimburesdClaims.IsEmpty()){
			database.update(reimburesdClaims);
		}
		
		If(!allAcrrualClaim.IsEmpty()){
			database.update(allAcrrualClaim);
		}
		
				  
		}catch(Exception e){
			ExceptionHandler.addException(e, PRMGlobalConstants.CoOpPaymentHelper, PRMGlobalConstants.CoOpPaymentHelper);
		}	
	}	
	
}