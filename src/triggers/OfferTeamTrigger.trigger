/***********************************************
*	Trigger Name : OfferTeamTrigger
*	Created By : Accenture IDC
*	Created Date :15/Dec/2016
*	Description : This will handle the Offer Team Actions
*	Requirement : Sales Process Requirement 649 
*********************************************/
Trigger OfferTeamTrigger on Offer_Team__c (after insert, before Update , before delete,after update) {
	
	if(Trigger.isInsert)
	{
		if(Trigger.isafter)
		{
			OfferTeamHandler.afterInsertUpdate(Trigger.new);
		}
	}
	else if(Trigger.isUpdate)
	{
		if(Trigger.isBefore)
		{
			OfferTeamHandler.afterInsertUpdate(Trigger.new);
		}
	}	
	else if(Trigger.isDelete)
	{
		if(Trigger.isBefore)
		{
			OfferTeamHandler.beforeDelete(Trigger.old);		 
		}
	}
}