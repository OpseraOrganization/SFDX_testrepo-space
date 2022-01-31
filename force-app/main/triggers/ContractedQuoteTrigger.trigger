/****************************************
* Trigger Name : ContractedQuoteTrigger 
* Created Date: 24 May 2019
* Created By : Accenture
* Description : This trigger copies quote records updates from EAI and load it in to Contracted_Quote__c staging object
***************************************/
trigger ContractedQuoteTrigger on Contracted_Quote__c (after insert, after update )
{
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
	{
		 // Initiating ContractedQuoteTriggerHandler Class
		ContractedQuoteTriggerHandler contQtTrigHandler = new ContractedQuoteTriggerHandler();
		
		if(Trigger.isAfter)
		{
			GlobalConstants.IS_INBOUND = True;
			if(Trigger.isInsert)
			{
				contQtTrigHandler.checkSurroundCQ(Trigger.New, null);
			}
			if(Trigger.isUpdate)
			{
				contQtTrigHandler.checkSurroundCQ(Trigger.New, Trigger.OldMap);
			}
		}
	}
}