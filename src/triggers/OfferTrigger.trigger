/******************************
*Created Date: 17th October 2016
*Created By: Accenture
*Last Modified Date: 29 November 2016
*Last Modified By: Accenture 
******************************/
trigger OfferTrigger on Offer__c (before insert,before update, after Insert,after update, before Delete) {
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		//DHCT.DHC_StaticThresholdBreachCalculation.triggerFlow = DHCT.DHC_StaticThresholdBreachCalculation.triggerFlow('OfferTrigger', 'Offer__c');
	}
	if(Trigger.isInsert){
		if(Trigger.isBefore){
			OfferActivationHandler.onBeforeInsert(Trigger.new);
		}
		if(Trigger.isAfter){
			//CloneOfferTeam.cloneTeam(trigger.new);
			//updateActiveOffers
			OfferActivationHandler.onAfterInsert(Trigger.new);
			//clone Offer Team
			//OfferActivationHandler.cloneOfferTeamAfterInsert(Trigger.new);
			
			//Sales Process: SF Ticket: 2567
			OfferActivationHandler.UpdateHigestOfferNumberOnOppty(Trigger.new);
			 OfferActivationHandler.CQ_onAfterinsert(trigger.newmap);

		}
	}
	if(Trigger.isUpdate){
		if(Trigger.isBefore){
			OfferActivationHandler.onBeforeUpdate(Trigger.new,Trigger.oldMap);
			//OfferActivationHandler.onBeforeUpdateLoAByPass(Trigger.new,Trigger.old);
		}
		if(Trigger.isAfter){
			OfferActivationHandler.onAfterInsert(Trigger.new);
			// LoA req. #2289.
			OfferActivationHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
			// Sales Process: SF Ticket: 11462
			OfferActivationHandler.updateUpsellContainerCurrencyISOcode(Trigger.new);
		}
	}
	if(Trigger.isDelete){//REQ855
		if(Trigger.isBefore){
		system.debug('in offer Trigger.old'+Trigger.old);
			OfferActivationHandler.onBeforeDelete(Trigger.old);
		}
	}
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		//DHCT.DHC_StaticThresholdBreachCalculation.fetchRunTimeLimitStatus('OfferTrigger', 'Offer__c', DHCT.DHC_StaticThresholdBreachCalculation.triggerFlow);
	}
}