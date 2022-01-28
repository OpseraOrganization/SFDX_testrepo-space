/***********************************
Class Name: CampaignTriggerHelper
Author: Accenture
Reason: Sales Process : This is to lock relatedList of opportunity helper class.
Created Date: Feb / 2017 
******************************************/
public with sharing class CampaignTriggerHelper{
	/***********************
	* Method Name: retrictCampaign
	* Description: Sales Process : lock relatedList of opportunity before update when opty stage = Identify Opportunity/Win the Case/Create Offer/ Develop Opportunity and Sales_Outcome = Cancelled by Customer/Lost to Competitor/Withdrawn by Nokia/Obsolete						   
	* Parameters: List of Campaign
	************************/ 
	public static void retrictCampaign(List<Campaign> campList){ 
		//Adding logic as per D-1687: opportunity will be locked based on Phase Status
		try{
			Map<ID,ID> campOppIDMap = new Map<ID,ID>();
			//Getting campaign related Opportunity record 
			for(Campaign camp : campList){
				if(camp.Marketing_Campaign_Opportunity__c != null){
					campOppIDMap.put(camp.Id,camp.Marketing_Campaign_Opportunity__c);
				}  
			}
			if(campOppIDMap.size() > 0){
				Map<ID,Opportunity> oppMap = new Map<ID,Opportunity>([Select id, StageName, Phase_Status__c, Sales_Outcome__c from Opportunity where Id IN: campOppIDMap.Values()]);
				for(Campaign camp : campList){
					if(camp.Marketing_Campaign_Opportunity__c != null){
						Opportunity opp = oppMap.get(campOppIDMap.get(camp.id));
						//if(opp.StageName != null && opp.Sales_Outcome__c != null){
							if(opp.Phase_Status__c.equalsIgnoreCase(GlobalConstants.PHASE_STATUS_CLOSED) || opp.Phase_Status__c.equalsIgnoreCase(GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON)){
								camp.addError(System.Label.Campaign_Error_Message);
							}
						//}
					}
				}
			}
			
			
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CAMPAIGNTRIGGERHELPER, GlobalConstants.RETRICTCAMPAIGN);
		}
	}
}