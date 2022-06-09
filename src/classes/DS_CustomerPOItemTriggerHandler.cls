/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:			CustomerPOItemTriggerHandler
Description:	 
Date		Version	  Author		Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
02/19/2019	  1.0		Sonali			Handler Class
----------------------------------------------------------------------------------------------------------------------------------------------------------*/
public with sharing class DS_CustomerPOItemTriggerHandler {
/*---
* Description : Method for after update action
* @param : New CPO LI List, OLd CPO LI map
* @return 
* @throws NA
---*/
	public static void afterUpdate(list<Apttus_Config2__CustomerPOItem__c> newCPOLI, 
									Map<id,Apttus_Config2__CustomerPOItem__c> oldMapCPOLI){
		try{
			set<ID> cPOLIEntitlStatusUpdated = new set<ID>();
			List<Apttus_Config2__CustomerPOItem__c> cPOLICheckforExpiry = new List<Apttus_Config2__CustomerPOItem__c>();
			for(Apttus_Config2__CustomerPOItem__c CPOLI : newCPOLI){
				if(CPOLI.Commercial_Entitlement_Status__c != oldMapCPOLI.get(CPOLI.Id).Commercial_Entitlement_Status__c 
					||
				 (( CPOLI.Commercial_Entitlement__c != oldMapCPOLI.get(CPOLI.Id).Commercial_Entitlement__c)&& 
					CPOLI.Commercial_Entitlement__c != null)){
					 
					cPOLIEntitlStatusUpdated.add(CPOLI.id);
				  }
				
				if((CPOLI.Consumed_Quantity__c != oldMapCPOLI.get(CPOLI.Id).Consumed_Quantity__c) || 
				   (CPOLI.Authorised_Quantity__c != oldMapCPOLI.get(CPOLI.Id).Authorised_Quantity__c) 
				  ){
					  cPOLICheckforExpiry.add(CPOLI);
				  } 
			}
			if((!cPOLIEntitlStatusUpdated.isempty() || !cPOLICheckforExpiry.isEmpty())&& CSWXGlobalConstant.Recursivecheck_CPOlI == CSWXGlobalConstant.FalseVal ){
				CSWXGlobalConstant.Recursivecheck_CPOlI = CSWXGlobalConstant.TrueVal;
				DS_CustomerPOItemTriggerHelper.updateEntitlementStatus(cPOLIEntitlStatusUpdated,cPOLICheckforExpiry );
				
			}
		}
	   catch(System.Exception e){ExceptionHandler.addException(
								e,CSWXGlobalConstant.DS_CustomerPOItemTriggerHandler , 
								CSWXGlobalConstant.afterUpdate);
	   }
	}
}