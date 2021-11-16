/*******************************
Class Name: DS_SWxItemTriggerHelper
Created By: Accenture
Created Date: 22 Nov 2018
Last Modified By: Accenture
Last Modified Date: 22 Nov 2018
Description: Helper Class for SWxItemTrigger 
*******************************/
public without sharing class DS_SWxItemTriggerHelper {
	
	/*****************************
*Method Name: updateEntitlementActiveQuantity
*Description: This method is used to update Entitlement Active Quantity when Status In Network Field is ON 
*Parameters: SWx Item List,SWx Item Map
*******************************/
 public static void updateEntitlementActiveQuantity(List<SWx_Upsell_Items__c> swxItemList,Map<Id,SWx_Upsell_Items__c>oldmap){
		  
		  try{
			  List<Commercial_Entitlement__c> entitlementList = new List<Commercial_Entitlement__c>();
			  Set<Id> entitlementIDset = new Set<Id>();
			  for(SWx_Upsell_Items__c swxItemObj : swxItemList){
				 entitlementIDset.add(swxItemObj.Commercial_Entitlement__c);
			  }
			  Map<ID, Commercial_Entitlement__c> entitlementMap = new Map<ID, Commercial_Entitlement__c>([select id, Activated_Quantity__c ,Sold_To_Party__c, Product_Code__c from Commercial_Entitlement__c where ID= :entitlementIDset LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
			  for(SWx_Upsell_Items__c swxItemObj : swxItemList){
				  System.debug('swxItemList---->'+swxItemList);
				  if(swxItemObj.Entitlement_Status__c.EqualsIgnoreCase(CSWXGlobalConstant.Entitled) && swxItemObj.Status_In_Network__c == true && oldmap.get(swxItemObj.Id).Status_In_Network__c != true){
					  System.debug('swxItemObj ---->'+swxItemObj);
					  System.debug('entitlementMap.get(swxItemObj.Commercial_Entitlement__c)---->'+entitlementMap.get(swxItemObj.Commercial_Entitlement__c));
					  
					  Commercial_Entitlement__c entitlementObj = entitlementMap.get(swxItemObj.Commercial_Entitlement__c);
					  System.debug('entitlementObj.Activated_Quantity__c---->'+entitlementObj.Activated_Quantity__c);
					  entitlementObj.Activated_Quantity__c = entitlementObj.Activated_Quantity__c + swxItemObj.Quantity__c;
					  entitlementList.add(entitlementObj);
					  System.debug('entitlementList---->'+entitlementList);
				  }
				  
			  }
			  
			  update entitlementList;
				  
		  }catch(Exception ex){
			   System.debug('ex----->'+ex);
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_SWxItemTriggerHelper,CSWXGlobalConstant.updateEntitlementActiveQuantity);
			   
		   }  
	
	}

	
}