/****************************************
 * Trigger Name : PreApprovedCustomProductsTrigger   
 * Created Date: 6 June 2021
 * Created By : Christie JJ
 * Description : This trigger routes the records to a helper class 
 *****************************************/

trigger PreApprovedCustomProductsTrigger on Pre_Approved_Custom_Products__c (after insert,after update) {

	if(Trigger.isAfter){ 
	   
		if(Trigger.isInsert||Trigger.isUpdate){

			system.debug('[+] In Trigger');
			
			PreApprovedCustomProductsTriggerHandler.handleBeforeInsertOrUpdateTrigger(Trigger.newMap, Trigger.oldMap);

		}
		
	}

}