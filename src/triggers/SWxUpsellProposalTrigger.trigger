/****************************************
 * Trigger Name : SWxUpsellProposalTrigger
 * Created Date: 5th June 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 5th June 2017
 * Description: All SWxUpsellProposal events are handled here
 *****************************************/
trigger SWxUpsellProposalTrigger on SWx_Upsell_Proposal__c (after update,after Insert,before update) {
	 
	  if(Trigger.isBefore){
			if(Trigger.isUpdate){
				SWxUpsellProposalTriggerHandler.beforeUpdate(Trigger.new,Trigger.oldMap);
			}  
		  }
	 
	  if(Trigger.isAfter){
			if(Trigger.isUpdate){
				SWxUpsellProposalTriggerHandler.afterUpdate(Trigger.new,Trigger.oldMap);
				//DSI-1255, Sprint 21 - logic to send json to eccenca 
				SWxUpsellProposalTriggerHandler.sendJsonToEccenca(Trigger.new,Trigger.oldMap);
			   
		}  
	}
	  
}