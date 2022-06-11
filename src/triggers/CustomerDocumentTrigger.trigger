/****************************************
* Trigger Name : CustomerDocumentTrigger 
* Created Date: 09 July 2019
* Created By : Accenture
* Description : This trigger is for customer document object
***************************************/
trigger CustomerDocumentTrigger on Customer_Document__c (After update, After insert, before update) {
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		if(Trigger.isAfter) {
			if(Trigger.isInsert) {
	System.debug('[Trigger.isAfter]>>>>>>>>>>[Trigger.isInsert]');
	//CustomerDocumentTriggerHandler.checkValidationOnCreate(Trigger.New);
	CustomerDocumentTriggerHandler.updateCustomerDocument(Trigger.New);
			}
			if(Trigger.isUpdate) {
	
	if(QTO_CustomerDocument_Helper.isFirstTime) {
		QTO_CustomerDocument_Helper.isFirstTime = false;
		//CustomerDocumentTriggerHandler.checkValidationOnUpdate(Trigger.New, Trigger.oldMap);
		// DSI-2211
		//QTO_CustomerDocument_Helper.afterUpdate(Trigger.New);
	
	}
				System.debug(':::::isFirstTimeForUpdate:::::');
	QTO_CustomerDocument_Helper.afterUpdate(Trigger.New);
	QTO_CustomerDocument_Helper.checkCustomerDocumentHeader(Trigger.newMap, Trigger.oldMap);

	//DSI-2146
	QTO_CustomerDocument_Helper.createCPO(Trigger.newMap, Trigger.oldMap);
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