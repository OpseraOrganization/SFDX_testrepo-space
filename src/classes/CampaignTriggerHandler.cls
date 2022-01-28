/***********************************
Class Name: CampaignTriggerHandler
Author: Accenture
Reason: Sales Process : This is a handler which calls the helper class upon various trigger events.
Created Date:Feb / 2017 
******************************************/
public with sharing class CampaignTriggerHandler{

	 /***********************
	* Method Name: beforeInsertOperation
	* Description: Sales Process : lock relatedList of opportunity before update
	* Parameters: List of Campaign
	************************/	 
	public static void beforeInsertOperation(List<Campaign> campList){ 
		String profileName = [Select Id,Name from Profile where Id =: userinfo.getProfileId()].Name;
		system.debug('ProfileName'+profileName);
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && Admin_Profiles__c.getInstance(profileName) == null){
			CampaignTriggerHelper.retrictCampaign(campList);
		}
	}
	
	 /***********************
	* Method Name: beforeInsertOperation
	* Description: Sales Process : lock relatedList of opportunity before update
	* Parameters: List of Campaign
	************************/	 
	public static void beforeUpdateOperation(List<Campaign> campList){ 
		String profileName = [Select Id,Name from Profile where Id =: userinfo.getProfileId()].Name;
		system.debug('ProfileName'+profileName);
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && Admin_Profiles__c.getInstance(profileName) == null){
			CampaignTriggerHelper.retrictCampaign(campList);
		}
	}
	 /***********************
	* Method Name: beforeInsertOperation
	* Description: Sales Process : lock relatedList of opportunity before update
	* Parameters: List of Campaign
	************************/	 
	public static void beforeDeleteOperation(List<Campaign> campList){ 
		String profileName = [Select Id,Name from Profile where Id =: userinfo.getProfileId()].Name;
		system.debug('ProfileName'+profileName);
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && Admin_Profiles__c.getInstance(profileName) == null){
			CampaignTriggerHelper.retrictCampaign(campList);
		}
	}
}