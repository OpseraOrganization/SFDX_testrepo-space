/****************************************
* Class Name : DS_EntitlementHeader
* Created Date: 17 Dec 2018
* Created By : Accenture
* Last Modified by: Accenture
* Description :  Controller Class for DS_EntitlementHeader.cmp(DSI-987 , Sprint 19)	
*****************************************/
Public  without sharing Class DS_EntitlementHeader{

   /* method to get entitlement record */
	@AuraEnabled
	public static Commercial_Entitlement__c GetEntitleRec(Id currentRecordId) 
	{ 
		Commercial_Entitlement__c  relatedData;
		try{
			if(currentRecordId !=null){
				relatedData = [SELECT Id,Name,Product_Name__r.Name,Product_Code__c,Technology__c,Use_Case__c,Sold_To_Party__c,
							   Sold_To_Party__r.Name,Consumed_Quantity__c, Available_Quantity__c FROM Commercial_Entitlement__c
						  where Id =: currentRecordId  Limit 1 ];
			 }
		}
		catch (Exception ex) {
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_EntitlementHeader,CSWXGlobalConstant.GetEntitleRec);
			return null;
		}		
		return relatedData;
	}


}