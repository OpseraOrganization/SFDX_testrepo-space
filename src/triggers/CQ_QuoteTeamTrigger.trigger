/*****************************************
* Trigger Name : CQ_QuoteTeamTrigger 
* Created Date: 15 May 2019
* Created By : Accenture
* Description : This trigger routes the records to a helper class 
*****************************************/
trigger CQ_QuoteTeamTrigger on CQ_Quote_Team__c (after insert) {
	
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
	if(trigger.isAfter){
		if(trigger.isInsert){
			CQ_QuoteTeamTriggerHandler.AfterInsert(trigger.new);
		}				
	}
  }
}