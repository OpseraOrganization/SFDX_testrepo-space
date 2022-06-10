/***************************************
* Trigger Name : HWS_BulkUploadTrigger 
* Created Date: 14 June 2019
* Created By : TCS - HWS Team
* Description : Created for the userstory HWST-3679 - Identify part code using bulk file
* Last Modified by: 
* Last Modified Date: 
*****************************************/
trigger HWS_BulkUploadTrigger on HWS_BulkUpload__c (before insert, before update) {
	
	HWS_BulkUploadHandler.handleTrigger(Trigger.new, Trigger.operationType);
}