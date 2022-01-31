/**
* @description: CustomerPOItemTrigger
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION	   AUTHOR				  DATE		   DETAIL				 FEATURES/CSR/TTP
* 1.0		   Sonali Kothavale		18/02/2019	 DS Feb Release
* ============================================================================ 
**/
trigger CustomerPOItemTrigger on Apttus_Config2__CustomerPOItem__c (after update) {
	try{
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		if(Trigger.isAfter){
			if(Trigger.isUpdate) {
				DS_CustomerPOItemTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
			}
				  
		}
	}
	}
	catch(System.Exception e){ExceptionHandler.addException(e, CSWXGlobalConstant.DS_updateComemrcialEntitlementStatus,CSWXGlobalConstant.DS_updateComemrcialEntitlementStatus);}
}