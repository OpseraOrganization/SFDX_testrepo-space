/***********************************
Class Name: CampaignMemberTriggerHandler
Author: Accenture
Reason: 
Created Date:Sept / 2018 
******************************************/
public with sharing class CampaignMemberTriggerHandler{

	 /***********************
	* Method Name: afterInsertOperation
	* Description: 
	* Parameters: List of Campaign
	************************/	 
	public static void afterInsertOperation(List<CampaignMember> campMemberList){ 
		Set<Id> campaignIdSet = new Set<Id>();
		for(CampaignMember campM : campMemberList){
			campaignIdSet.add(campM.campaignId);	
		}
		CampaignMemberHelper.campaingMemberRollUp(campaignIdSet);
	}
	
	 /***********************
	* Method Name: afterUpdateOperation
	* Description: 
	* Parameters: List of Campaign
	************************/	 
	public static void afterUpdateOperation(List<CampaignMember> campMemberList,List<CampaignMember> oldCampMap){ 
	   Set<Id> campaignIdSet = new Set<Id>();
		for(CampaignMember campM : campMemberList){
			campaignIdSet.add(campM.campaignId);	
		}
		for(CampaignMember campM : oldCampMap){
			campaignIdSet.add(campM.campaignId);	
		}
		CampaignMemberHelper.campaingMemberRollUp(campaignIdSet);
	}
	/***********************
	* Method Name: afterDeleteOperation
	* Description: 
	* Parameters: List of Campaign
	************************/	 
	public static void afterDeleteOperation(List<CampaignMember> campMemberList){ 
		Set<Id> campaignIdSet = new Set<Id>();
		for(CampaignMember campM : campMemberList){
			campaignIdSet.add(campM.campaignId);	
		}
		CampaignMemberHelper.campaingMemberRollUp(campaignIdSet);
	}
	
	/***********************
	* Method Name: afterUnDeleteOperation
	* Description: 
	* Parameters: List of Campaign
	************************/	 
	public static void afterUnDeleteOperation(List<CampaignMember> campMemberList){ 
		Set<Id> campaignIdSet = new Set<Id>();
		for(CampaignMember campM : campMemberList){
			campaignIdSet.add(campM.campaignId);	
		}
		CampaignMemberHelper.campaingMemberRollUp(campaignIdSet);
	}
}