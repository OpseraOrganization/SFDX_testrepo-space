/****************************************
 * Trigger Name : SWxItemTrigger
 * Created Date: 11 Nov 2018
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 11 Nov 2018
 * Description: All SWxItemTrigger events are handled here
 *****************************************/
trigger SWxItemTrigger on SWx_Upsell_Items__c (before update) {
	 if(Trigger.isBefore){ 
			if(Trigger.isUpdate){ 
				DS_SWxItemTriggerHandler.beforeUpdate(Trigger.new,Trigger.oldMap);
			}  
		  }
}