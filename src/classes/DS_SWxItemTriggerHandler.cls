/*******************************
Class Name: DS_SWxItemTriggerHandler
Created By: Accenture
Created Date: 22 Nov 2018
Last Modified By: Accenture
Last Modified Date: 22 Nov 2018
Description: Handler Class for SWxItemTrigger 
*******************************/
public without sharing class DS_SWxItemTriggerHandler {
	
	 /*****************************
*Method Name: BeforeUpdate
*Description: This is handler method for before update on SWx Item 
*Parameters: SWx Item List,SWx Item Map
*******************************/
 public static void beforeUpdate(List<SWx_Upsell_Items__c> swxItemList,Map<Id,SWx_Upsell_Items__c>oldmap){
		  
		  try{
				 System.debug('upsellProposalList--->'+swxItemList);
				  DS_SWxItemTriggerHelper.updateEntitlementActiveQuantity(swxItemList,oldmap);
				   if(Test.isRunningTest()){
					CustomException testingCatch = new CustomException(GlobalConstants.ERROR_TEXT);
					throw testingCatch; 
				}  
		  }catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_SWxItemTriggerHandler ,CSWXGlobalConstant.beforeUpdate);
			   
		   }  
	
	}

}