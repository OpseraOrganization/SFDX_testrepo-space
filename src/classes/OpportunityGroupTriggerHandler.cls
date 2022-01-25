/*******************************
Class Name: OpportunityGroupTriggerHandler
Created By: Accenture
Last Modified By: Accenture 
Description: Handler Class for OpportunityGroupTrigger
*******************************/
public class OpportunityGroupTriggerHandler 
{
	 /*****************************
*Method Name: beforeInsert
*Description: This is handler method for before insert on Deal-Opportunity Grouping
*Parameters: Deal-Opportunity Grouping List, Deal-Opportunity Grouping Map
*******************************/
	public static void beforeInsert(List<Opportunity_Group__c> opptyGroupList)
	{
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
		{
	//Req 4943
	OpportunityGroupTriggerHelper.populateUnweightedValueofGroupingObject(opptyGroupList);
	//Req 4557
	OpportunityGroupTriggerHelper.validateCorrectDealOpptyCombination(opptyGroupList);
	OpportunityGroupTriggerHelper.checkIfDealHasAlreadyMasterOppty(opptyGroupList);
	OpportunityGroupTriggerHelper.restrictOpptyAssociationWithSameDeal(opptyGroupList);	   
		}
	}
	 /*****************************
*Method Name: beforeUpdate
*Description: This is handler method for before update on Deal-Opportunity Grouping
*Parameters: Deal-Opportunity Grouping List, Deal-Opportunity Grouping Map
*******************************/
	public static void beforeUpdate(List<Opportunity_Group__c> opptyGroupList, Map<ID, Opportunity_Group__c> opptyGroupOldMap)
	{  if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
		{
			//Req 4557
			OpportunityGroupTriggerHelper.checkIfDealHasMasterOpptyOnAssociationUpdate(new map<Id,Opportunity_Group__c>(opptyGroupList),opptyGroupOldMap);
			//OpportunityGroupTriggerHelper.associationChangeFromMasterToSubordinate(new map<Id,Opportunity_Group__c>(opptyGroupList),opptyGroupOldMap);		
		}
	}
	/*****************************
*Method Name: beforeDelete
*Description: This is handler method for before delete on Deal-Opportunity Grouping
*Parameters:  Deal-Opportunity Grouping Map
*******************************/
	public static void beforeDelete(Map<ID, Opportunity_Group__c> opptyGroupOldMap)
	{  if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
		{
			//Req 4943
			OpportunityGroupTriggerHelper.beforeDeleteCheckOpptyRecordType(opptyGroupOldMap);
		}
	}
}