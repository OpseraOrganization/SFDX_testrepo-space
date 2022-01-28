/****************************************
* Trigger Name : CustomerDocumentTrigger 
* Created Date: 09 July 2019
* Created By : Accenture
* Description : This trigger is for customer document object
***************************************/
trigger CustomerDocumentTrigger on Customer_Document__c (After update, After insert, before update) {
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		if(Trigger.isAfter){
			if(Trigger.isInsert) {
				System.debug('[Trigger.isAfter]>>>>>>>>>>[Trigger.isInsert]');
				CustomerDocumentTriggerHandler.checkValidationOnCreate(Trigger.New);
				CustomerDocumentTriggerHandler.updateCustomerDocument(Trigger.New);
			}
			if(Trigger.isUpdate) {
				System.debug(':::::isFirstTimeForUpdate:::::');
				//DSI-2146
				QTO_CustomerDocument_Helper.callLineItemEnrichment(Trigger.newMap, Trigger.oldMap);
				
				//DSI-2146
				QTO_CustomerDocument_Helper.createCPO(Trigger.newMap, Trigger.oldMap);
				
			   /* if(QTO_CustomerDocument_Helper.isFirstTimeForUpdate) {
					QTO_CustomerDocument_Helper.isFirstTimeForUpdate = false;
				}*/
				
				if(QTO_CustomerDocument_Helper.isFirstTime) {
					QTO_CustomerDocument_Helper.isFirstTime = false;
					CustomerDocumentTriggerHandler.checkValidationOnUpdate(Trigger.New, Trigger.oldMap);
					// DSI-2211
					QTO_CustomerDocument_Helper.afterUpdate(Trigger.New);
				
					// DSI-2216
					// This logic covered in CustomerDocumentTriggerHandler.updateCustomerDocumet 
					//QTO_CustomerDocument_Helper.checkDuplicate(Trigger.New);
				}
			}
		}
		
		if(Trigger.isBefore) {
			if(Trigger.isUpdate) {
			   if(QTO_CustomerDocument_Helper.isFirstTime) {
					QTO_CustomerDocument_Helper.isFirstTime = false;
					QTO_CustomerDocument_Helper.beforeUpdate(Trigger.new, Trigger.oldmap);
			  }
			}
		}
	}
}