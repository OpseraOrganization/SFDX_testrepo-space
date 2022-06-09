/****************************************
* class Name : CampaignMemberHelper 
* Created Date: 
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description :
*****************************************/
public without sharing class CampaignMemberHelper{
/****************************************
* Method Name : campaingMemberRollUp 
* Created Date: 
* Created By : Accenture
* Parameters : Set<Id> tacticIdSet
* returns :  
* Description :
*****************************************/   
	public static void campaingMemberRollUp(Set<Id> tacticIdSet )
	{
		Set<Id> programIdSet = new Set<Id>();
		Set<Id> masterIdSet = new Set<Id>();
		
		List<Campaign> tacticList = new list<Campaign>();
		try{
		for(campaign cam : [SELECT Id,ParentId, Parent.ParentId FROM Campaign WHERE Id IN : tacticIdSet Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			tacticIdSet.add(cam.Id);
	   
			if(cam.ParentId!=NULL){ 
				programIdSet.add(cam.ParentId);
				
				if(cam.Parent.ParentId!=NULL) 
					masterIdSet.add(cam.Parent.ParentId);
			}
		}
		
		for(aggregateresult ar : [select Count(ID),campaignId from campaignMember WHERE campaignId IN : tacticIdSet group by campaignId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			Campaign tactic = new Campaign();
			tactic.Id= ar.get('CampaignId')+ '';
			tactic.Store_Summary__c  =  (Decimal) ar.get('expr0');
			tacticList.add(tactic);
		}
		update tacticList;
		if(!programIdSet.isEmpty() && programIdSet.size()>0){
			CampaignMemberHelper.updateparentCount(programIdSet);
		}
		if(!masterIdSet.isEmpty() && masterIdSet.size()>0){
			CampaignMemberHelper.updateparentCount(masterIdSet);
		}
		}catch(Exception e)
		{
			ExceptionHandler.addException(e,GlobalConstants.CampaignMemberHelper,GlobalConstants.CampaingMemberRollUp);
		}
   }
 /****************************************
* Method Name : updateparentCount 
* Created Date: 
* Created By : Accenture
* Parameters : Set<Id> parentIds
* returns : 
* Description :
*****************************************/	
   public static void updateparentCount(Set<Id> parentIds){
		List<Campaign> parentCampaignList = new list<Campaign>();
		try{
		for(aggregateresult ar : [select sum(Store_Summary__c),parentId from Campaign WHERE parentId IN : parentIds group by parentId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			Campaign parentCamp = new Campaign();
			parentCamp.Id= ar.get('parentId')+'';
			parentCamp.Store_Summary__c  =  (Decimal) ar.get('expr0');
			parentCampaignList.add(parentCamp);
		}
		database.update(parentCampaignList);
		}catch(Exception e)
		{
			ExceptionHandler.addException(e,GlobalConstants.CampaignMemberHelper,GlobalConstants.UpdateParentCount);
		}
	}
}