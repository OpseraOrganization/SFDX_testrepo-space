/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 09-19-2021
 * @last modified by  : Yashdeep Prajapati
 **/
Trigger LineItemTrigger on Apttus_Config2__LineItem__c(After Insert, After Delete){

	if(Trigger.isAfter && Trigger.isInsert) {
		system.debug('inside this');
		CPQLineItemTriggerHandler.afterInsert(Trigger.newMap);
	}
	//To delete the Site Phase Config if Any
	else if(Trigger.isAfter && Trigger.isDelete) {
		System.enqueueJob(new NokiaCPQ_LineItemQueueable(Trigger.old));
	}
}