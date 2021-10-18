/**
* @description: Coop Claim Trigger Handler to check specific criteria and call helper methods before/after Payment update
* @author:  Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION   AUTHOR	DATE   DETAIL  FEATURES/CSR/TTP
* 1.0	Sonali Kothavale	   25/05/2018   PRM Release 3
* ============================================================================ 
*/
public without sharing class CoOpClaimHandler {
/**********************************************************************************************************************
* author: Accenture
* Date: May-2018
* Param: List<Claim__c> ClaimList
* Return: void
* Description: Method for before Claim insert
* High Level Process : 
**********************************************************************************************************************/ 
/*public static void beforeInsertOperation(List<Claim__c> ClaimList) { 
		try{ 
	// 
		}
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CoOpClaimHandler, PRMGlobalConstants.beforeInsertOperation);}
	}*/

/**********************************************************************************************************************
* author: Accenture
* Date: May-2018
* Param: List<Claim__c> newClaimList, Map<Id,Claim__c> claimOldMap
* Return: void
* Description: Method for before Claim Update
* High Level Process : 
**********************************************************************************************************************/ 
   /* public static void beforeUpdateOperation(List<Claim__c> newClaimList, Map<Id,Claim__c> claimOldMap) { 
		try{ 
		}
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CoOpClaimHandler, PRMGlobalConstants.beforeUpdateOperation);}
	} */

/**********************************************************************************************************************
* author: Accenture
* Date: May-2018
* Param: List<Claim__c> newClaimList, Map<Id,Claim__c> claimOldMap
* Return: void
* Description: Method for After Claim Update
* High Level Process : 
**********************************************************************************************************************/ 
 public static void afterUpdateOperation(List<Claim__c> newClaimList, Map<Id,Claim__c> claimOldMap) { 
		try{
			// system.debug('>> in CoOpClaimTriggerHandler - afterUpdateOperation method >>>>>>');
			List<Claim__c> claimsPassedAudit = new List<Claim__c>();
			List<Claim__c> Pipelineclaims = new List<Claim__c>();
	/*  system.debug('>> Pipelineclaims : '+ Pipelineclaims);
			system.debug('>> newClaimList : '+ newClaimList); */
	 // system.debug('>> claimsPassedAudit : '+ claimsPassedAudit);  
			for(Claim__c newclaim : newClaimList){
	//   system.debug('>> newclaim - Status : '+ newclaim.Claim_Status__c);
	if(((newclaim.Claim_Status__c != claimOldMap.get(newclaim.id).Claim_Status__c) && (newclaim.Claim_Status__c == PRMGlobalConstants.CoopSubmitted)  &&
	   (claimOldMap.get(newclaim.id).Claim_Status__c != PRMGlobalConstants.CoopSubmitted)
		&& (claimOldMap.get(newclaim.id).Claim_Status__c != PRMGlobalConstants.CoopEscalated) && (claimOldMap.get(newclaim.id).Claim_Status__c != PRMGlobalConstants.CoopIncomplete))){
		Pipelineclaims.add(newclaim); 
	 //   system.debug('>> Pipelineclaims : '+ Pipelineclaims);
	 // system.debug('claimOldMap.get(newclaim.id).Claim_Status__c.....>>>>>....>>>>' +claimOldMap.get(newclaim.id).Claim_Status__c);   
	}		 
	 //  system.debug('claimOldMap.get(newclaim.id).Claim_Status__c.....>>>>>....>>>>' +claimOldMap.get(newclaim.id).Claim_Status__c);
	if((newclaim.Claim_Status__c != claimOldMap.get(newclaim.id).Claim_Status__c) && ((newclaim.Claim_Status__c == PRMGlobalConstants.CoopPassedAudit) ||(newclaim.Claim_Status__c == PRMGlobalConstants.CoopAwaitingReimbursement)) && newclaim.Claim_Amount_Passed_Audit__c != PRMGlobalConstants.Zero){
		claimsPassedAudit.add(newclaim);
	  //	system.debug('>> claimsPassedAudit : '+ claimsPassedAudit);
	}
	else if((newclaim.Claim_Status__c != claimOldMap.get(newclaim.id).Claim_Status__c) && (newclaim.Claim_Status__c == PRMGlobalConstants.coopRejected ) || (newclaim.Claim_Status__c == PRMGlobalConstants.EXPIRED )){
		claimsPassedAudit.add(newclaim);
	  //	system.debug('>> claimsPassedAudit : '+ claimsPassedAudit);
	}
	//system.debug('>> claimsPassedAudit : '+ claimsPassedAudit);
	
			
			}		   
			If(!claimsPassedAudit.IsEmpty()){
	// system.debug('>> claimsPassedAudit : '+ claimsPassedAudit);
	CoOpClaimTriggerHelper.accrualClaimAssociation(claimsPassedAudit);  
	 }
	If(!Pipelineclaims.IsEmpty()){
	//   system.debug('....accrualpipelineclaims>>>>>' +Pipelineclaims);
		CoOpClaimTriggerHelper.accrualpipelineclaims(Pipelineclaims);  
	}
	
	
			
	
			
		}
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CoOpClaimHandler,PRMGlobalConstants.afterUpdateOperation);}
	
}
	

  
}