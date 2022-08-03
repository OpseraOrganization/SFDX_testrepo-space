/****************************************
* Class Name : OfferActivationHandler 
* Created Date: 21st October 2016
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 10th November 2016
* Description : This class will check if more than one active offer is related to oppty and would update all offers as inactive except the latest one.
*****************************************/
public inherited sharing class OfferActivationHandler{
	/****************************************
*Method Name: onBeforeInsert
*Description: Method to make offer active on creation
*Parameters: Offer List
*****************************************/
	public static void onBeforeInsert(List<Offer__c> newOfferList){
		String profileName = [Select Id,Name from Profile where Id =: userinfo.getProfileId() Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())].Name;
		system.debug('ProfileName'+profileName);
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && Admin_Profiles__c.getInstance(profileName) == null){
			OfferActivationHelper.restrictOffer(newOfferList);
		}
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			//Make the new added offer as true
			System.debug('Before insert handler onBeforeInsert method');
			OfferActivationHelper.onBeforeInsert(newOfferList);  
			System.debug('Before insert handler');
			OfferActivationHelper.marketValidation(newOfferList); 
			//SF Ticket: 2567
			OfferActivationHelper.PopulateHigestOfferNumberOnOffer(newOfferList);
		}		 
	}
	/****************************************
*Method Name: onAfterInsert
*Description: Method to make offer active on update
*Parameters: Offer List
*****************************************/
	public static void onAfterInsert(List<Offer__c> newOfferList){
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){		
			//inactive the already active offer after new offer creation
			OfferActivationHelper.updateActiveOffers(newOfferList);		 
		}
	}
	/****************************************
*Method Name: onBeforeUpdate
*Description: This method will check the peobability to be zero on update
*Parameters: Offer List
*****************************************/
	public static void onBeforeUpdate(List<Offer__c> offerList, map<ID,Offer__c> offerOldMap){
		String profileName = [Select Id,Name from Profile where Id =: userinfo.getProfileId() Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())].Name;
		system.debug('ProfileName>>>'+profileName);
		
		Map<Id, Offer__c> offerNewMap = new Map<Id, Offer__c>();
		for(Offer__c objOfferNew : offerList)
		{
			offerNewMap.put(objOfferNew.Id, objOfferNew);
		}
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
		{
			system.debug('Before Calling Pricing Mgr Validation>>>'+offerNewMap);
			OfferSnapshotCreationHelper.validateLoABypassOfferConditionFieldValue(offerOldMap, offerNewMap);
			// Req. #3845 : Add error on update of Customer_and_Competitive_Situation__c after LoA upload.
			// by pass Excel Profile to perform update during LoA upload
			
			if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.System_Admin_Profile_ID) &&
	  !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Excel_Add_In_Profile_SF_Id) )
			{
	system.debug(UserInfo.getProfileId()+ 'testing work'+ system.Label.System_Admin_Profile_ID);
	Map<Id, Offer__c> mapOfferNew = new Map<Id, Offer__c>();
	for(Offer__c objOfferNew : offerList)
	{
		mapOfferNew.put(objOfferNew.Id, objOfferNew);
	}
	OfferSnapshotCreationHelper.validateOfferFieldsLoA(mapOfferNew,offerOldMap);
			} 
			OfferActivationHelper.validate(offerList,offerOldMap);
			OfferActivationHelper.updateLoAByPassDetails(offerList,offerOldMap);
			OfferActivationHelper.marketValidation(offerList);
			OfferActivationHelper.offerLoACurrenyConversion(offerList,offerOldMap);
			OfferActivationHelper.restrictManualChangingSSOTOAttached(offerNewMap,offerOldMap);//JOTATR
		}
	}
	
	/****************************************
*Method Name: onBeforeDelete
*Description: 
*Parameters: Offer List
*****************************************/
	public static void onBeforeDelete(List<Offer__c> offerList){
		// ignore trigger execution for Data Loader profile users....
		String profileName = [Select Id,Name from Profile where Id =: userinfo.getProfileId() Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())].Name;
		system.debug('ProfileName'+profileName);
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && Admin_Profiles__c.getInstance(profileName) == null){
			OfferActivationHelper.restrictOffer(offerList);
		}
	}
	
	/****************************************
*Method Name: onAfterInsert
*Description: Method to make offer active on update
*Parameters: Offer List
*****************************************/
	public static void updateHigestOfferNumberOnOppty(List<Offer__c> newOfferList){
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){	 
			//SF Ticket: 2567
			OfferActivationHelper.UpdateHigestOfferNumberOnOppty(newOfferList);
		}
	}
	
	
	/****************************************
*Method Name: onAfterUpdate
*Description: Method to update upsell container currency type
*Parameters: Offer List
*****************************************/
	public static void updateUpsellContainerCurrencyISOcode(List<Offer__c> offerList){
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){	 
			//SF Ticket: 11462
			OfferActivationHelper.updateUpsellContainerCurrencyISOcode(offerList);
		}
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: June-2017
* Param: None
* Return: void
* Description: Offer Trigger AfterUpdate method
* - Req : 4724 - Add conversion logic to custom validations
* High Level Process : 
**********************************************************************************************************************/
	public static void onAfterUpdate(Map<Id, Offer__c> newMap, Map<Id, Offer__c> oldMap)
	{
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
			OfferActivationHelper.OfferSync_ToEAI(newMap,oldMap);
	} 
	/**********************************************************************************************************************
* author: Accenture
* Param: None
* Return: void
* Description: Offer Trigger CQ_onAfterinsert method
* Add conversion logic to custom validations
* High Level Process : 
**********************************************************************************************************************/
	public static void CQ_onAfterinsert(Map<Id, Offer__c> newMap)
	{
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
		{
			OfferActivationHelper.OfferSync_ToEAI(newMap,null);
		}
	}
}