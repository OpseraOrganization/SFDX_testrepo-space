/****************************************
 * Trigger Name : PreApprovedCustomProductsTrigger   
 * Created Date: 6 June 2021
 * Created By : Christie JJ
 * Description : This trigger routes the records to a helper class 
 *****************************************/

trigger PreApprovedCustomProductsTrigger on Pre_Approved_Custom_Products__c (after insert,after update,after delete) {

	String Actions='';
	if(Trigger.isAfter){ 
	   
		if(Trigger.isInsert)
		Actions='Created';
		else if(Trigger.isUpdate)
		Actions='Update';
		else if(Trigger.isDelete)
		Actions='Deleted';
		
		PreApprovedCustomProductsTriggerHandler.handleBeforeInsertOrUpdateTrigger(Trigger.newMap, Trigger.oldMap,Actions);
		
	}

}