/*********************************************
 * Trigger Name: CQ_CustomerContactTrigger
 * Created by: Accenture
 * Created Date: 5th Apr 2019
 * Last modified by: Accenture
 * Description: This Trigger is Implemented on CQ_Customer_Contact__c object
 * ******************************************/
trigger CQ_CustomerContactTrigger on CQ_Customer_Contact__c (before insert, before update, before delete) {
	
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
	if(trigger.isBefore){
		if(trigger.isUpdate||trigger.isInsert){
			CQ_CustomerContactTriggerHandler.setPrimaryContact(trigger.new);   
		}
		if(trigger.isUpdate){
			CQ_CustomerContactTriggerHandler.checkPrimary(trigger.new,trigger.oldMap); 
		}
		if(trigger.isDelete){
			CQ_CustomerContactTriggerHandler.restrictDeleteOnPrimary(trigger.old);
		}
		
	 } 
	
	}	
	
}