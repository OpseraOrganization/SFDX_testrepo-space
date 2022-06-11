/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:			CustomerPOItemTriggerHelper
Description:	 
Date		Version	  Author		Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
02/19/2019	  1.0		Sonali			Helper Class
----------------------------------------------------------------------------------------------------------------------------------------------------------*/
public with sharing class DS_CustomerPOItemTriggerHelper {
/*
-
* Description : Method for update entilement status, Queueable class is getting called for status updates
* @param : New CPO LI List, OLd CPO LI map
* @return 
* @throws NA
-*/
	public static void updateEntitlementStatus(set<ID> CPOLIs, List<Apttus_Config2__CustomerPOItem__c> CheckExpiry){
		try{
			//List<Apttus_Config2__CustomerPOItem__c> cPOLIToBeExpired = new List<Apttus_Config2__CustomerPOItem__c>();
			set<ID> toBeExpired = new set<ID>();
			for(Apttus_Config2__CustomerPOItem__c cpoli : CheckExpiry){
			   // System.debug('cpoli>>>'+cpoli);
				if(!CheckExpiry.isEmpty()){
					if(((cpoli.Authorised_Quantity__c- (cpoli.Consumed_Quantity__c- cpoli.Non_Consumed_Quantity__c) )== 0) 
			&& (cpoli.Pending_Quantity__c ==0))
					{
						//cPOLIToBeExpired.add(cpoli);
						CPOLIs.add(cpoli.Id);
						toBeExpired.add(cpoli.Id);
					}
				}  
			}
		   /* if(!CPOLIToBeExpired.isEmpty()){
				CPOLIToBeExpired = [select id, Commercial_Entitlement_Status__c from Apttus_Config2__CustomerPOItem__c where iD in : CPOLIToBeExpired];
				
				for(Apttus_Config2__CustomerPOItem__c CPOitem : CPOLIToBeExpired){
					System.debug('CPOitem.Commercial_Entitlement_Status__c>>>>'+CPOitem.Commercial_Entitlement_Status__c);
					CPOitem.Commercial_Entitlement_Status__c = CSWXGlobalConstant.Expired ; 
				}
				database.update(CPOLIToBeExpired,false);
				System.debug('CPOLIToBeExpired>>>>'+CPOLIToBeExpired);			 
			} */

			
			if(!CPOLIs.isEmpty()){
			//  callStatusUpdateMethod(CPOLIs);
			ID jobID = System.enqueueJob(new DS_updateComemrcialEntitlementStatus(CPOLIs, toBeExpired)); 
			//system.debug('----jobID -----' + jobID);
			}
		}
	   catch(System.Exception e){ExceptionHandler.addException(
		e,CSWXGlobalConstant.DS_CustomerPOItemTriggerHelper, 
		CSWXGlobalConstant.DS_CustomerPOItemTriggerHelper);
	   }
	}
	
	 
}