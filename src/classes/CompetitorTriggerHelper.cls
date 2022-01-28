/***********************************
Class Name: CompetitorTriggerHelper
Author: Accenture
Reason: Sales Process : This class will handle the logic implemented on Competitor.
Created Date: Feb / 2017 
******************************************/
public with sharing class CompetitorTriggerHelper{
	
	/***********************
* Method Name: preventDuplicateCompetitor
* Description: Sales Process : Restrict adding the same competitor twice
* Req : 5252
* Parameters: List<Competitor__c> , Map <Id,Competitor__c> , Boolean
************************/
	public static void preventDuplicateCompetitor(List<Competitor__c> competitorList, Map <Id,Competitor__c> competitorOldMap,Boolean isInsertFlag)
	{
		Map<Id,List<String>> OpptyIdAndCompetitorsMap = new Map<Id,List<String>>();
		Map<Id,List<String>> OpptyIdAndCompetitorsMapOld = new Map<Id,List<String>>();
		List<String> CompetitorsList = new List<String>();
		List<String> CompetitorsListOld = new List<String>();
		List<Competitor__c> CompErrorList = new List<Competitor__c>();
		try
		{
			for(Competitor__c CompetitorObj : competitorList) {
				if (CompetitorObj.Competitor_New__c != null && (isInsertFlag == true || 
																competitorOldMap.get(CompetitorObj.Id).Competitor_New__c != CompetitorObj.Competitor_New__c))
				{									   
					if(OpptyIdAndCompetitorsMap.containsKey(CompetitorObj.Opportunity__c))
					{
						CompetitorsList = OpptyIdAndCompetitorsMap.get(CompetitorObj.Opportunity__c);
						CompetitorsList.add(CompetitorObj.Competitor_New__c);
						OpptyIdAndCompetitorsMap.put(CompetitorObj.Opportunity__c,CompetitorsList);
					}
					else
					{
						CompetitorsList.clear();
						CompetitorsList.add(CompetitorObj.Competitor_New__c);
						OpptyIdAndCompetitorsMap.put(CompetitorObj.Opportunity__c,CompetitorsList);
					}
				}
			}
			if(!OpptyIdAndCompetitorsMap.isEmpty())
			{
				for(Competitor__c compObject : [select id, Opportunity__c, Competitor_New__c from Competitor__c 
												where Opportunity__c in: OpptyIdAndCompetitorsMap.keySet()
												LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
				{
					if(OpptyIdAndCompetitorsMapOld.containsKey(compObject.Opportunity__c))
					{
						CompetitorsListOld = OpptyIdAndCompetitorsMapOld.get(compObject.Opportunity__c);
						CompetitorsListOld.add(compObject.Competitor_New__c);
						OpptyIdAndCompetitorsMapOld.put(compObject.Opportunity__c,CompetitorsListOld);
					}
					else
					{
						CompetitorsListOld.clear();
						CompetitorsListOld.add(compObject.Competitor_New__c);
						OpptyIdAndCompetitorsMapOld.put(compObject.Opportunity__c,CompetitorsListOld);
					}							   
				}
			}
			if(!OpptyIdAndCompetitorsMapOld.isEmpty())
			{
				for(Competitor__c CompetitorObj : competitorList) {
					if(OpptyIdAndCompetitorsMapOld.containsKey(CompetitorObj.Opportunity__c) && OpptyIdAndCompetitorsMap.containsKey(CompetitorObj.Opportunity__c))
					{  
						for(String comp : OpptyIdAndCompetitorsMap.get(CompetitorObj.Opportunity__c))
						{
							if(OpptyIdAndCompetitorsMapOld.get(CompetitorObj.Opportunity__c).contains(comp))
								CompErrorList.add(CompetitorObj);
						}
					}
				}
			}
			if(!CompErrorList.isEmpty())
			{
				for(Competitor__c ComptObj : CompErrorList)
					ComptObj.addError(System.Label.Duplicate_Competitor);
			}
			
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex,GlobalConstants.COMPETITORTRIGGERHELPER,GlobalConstants.PREVENT_DUPLICATE_COMPETITOR);
		}
	}
	
	/***********************
* Method Name: wonShareAllocationValidation
* Description: Sales Process : Won Share allocation Sum cannot be greater than 100
* Req : 5783
* Parameters: List<Competitor__c> , Map <Id,Competitor__c>
************************/
	public static void wonShareAllocationValidation(List<Competitor__c> competitorList, Map <Id,Competitor__c> competitorOldMap,Boolean isInsertFlag){
		set<Id> optyIdSet = new set<Id>();
		map<Id, Decimal> mappOppToSum = new map<Id, Decimal>();
		try
		{
			System.debug('wonShareAllocationValidation>>Complist'+ competitorList);
			for (Competitor__c competitor : competitorList){
				if ((competitor.Opportunity_Won__c == true && competitor.Won_Share_Allocation_in__c > 0) && 
					(isInsertFlag == true ||
					 competitorOldMap.get(competitor.Id).Opportunity_Won__c != competitor.Opportunity_Won__c ||
					 competitorOldMap.get(competitor.Id).Won_Share_Allocation_in__c != competitor.Won_Share_Allocation_in__c))
				{
					optyIdSet.add(competitor.Opportunity__c);
				}
			}
			if(!optyIdSet.isEmpty())
			{
				for(AggregateResult objAgg : [select  Opportunity__c, sum(Won_Share_Allocation_in__c) from Competitor__c 
											  where Opportunity__c IN:optyIdSet and Opportunity_Won__c = true 
											  group by Opportunity__c
											  LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
				{
					mappOppToSum.put((Id)objAgg.get(GlobalConstants.Opportunity_c), (Decimal)objAgg.get(GlobalConstants.EXPR0));	  
				}
				for(Competitor__c competitor : competitorList)
				{
					Decimal wonShareSum = 0;
					if(mappOppToSum.containskey(competitor.Opportunity__c))
					{
						wonShareSum = mappOppToSum.get(competitor.Opportunity__c) + competitor.Won_Share_Allocation_in__c ;
						if(isInsertFlag == false && 
						   competitorOldMap.get(competitor.Id).Opportunity_Won__c ==  true &&
						   competitorOldMap.get(competitor.Id).Won_Share_Allocation_in__c != competitor.Won_Share_Allocation_in__c && 
						   competitorOldMap.get(competitor.Id).Won_Share_Allocation_in__c > 0 
						   )
						{
							 wonShareSum = wonShareSum - competitorOldMap.get(competitor.Id).Won_Share_Allocation_in__c ;
						}
						if(wonShareSum > decimal.valueOf(System.Label.Hundred))
							competitor.addError(System.Label.Won_Share_Error);					   
					}
				}
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex,GlobalConstants.COMPETITORTRIGGERHELPER,GlobalConstants.WONSHAREALLOCATIONVALIDATION);
		}
	}
	/***********************
* Method Name: onDeleteCompetitorUpdateOptyWinningCompetitor
* Description: Sales Process : When competitor is deleted from related list or winning competitor checkbox is unchecked or name of comp is updated then update the winning competitor field on opportunity.
* Req Sales Process: 5073, 5784(Feb Hyper Care Requirement)
* Parameters: List<Competitor__c> , List<Competitor__c>, Boolean 
************************/
	public static void onDeleteCompetitorUpdateOptyWinningCompetitor(Map <Id,Competitor__c> newCompetitorMap,
																	 Map <Id,Competitor__c> competitorOldMap,Boolean isDeleteFlag)
	{
		set<Id> optyIdSet = new Set<Id>();
		List<Opportunity> optyToUpdate = new List<Opportunity>();
		List<String> compList = new List<String>();
		Set<String> compSet = new Set<String>();
		Map<String, String> oldNewCompNameMap ;
		Map<id, Map<String, String>> OpptyIdAndCompNameMap = new Map<id, Map<String, String>>();
		Map<Id, Opportunity> relatedOptyMap;
		try
		{
			for(Competitor__c CompetitorObj : competitorOldMap.values()) {
				if(isDeleteFlag == true ||
				   (newCompetitorMap.get(CompetitorObj.id).Opportunity_Won__c != CompetitorObj.Opportunity_Won__c &&
					newCompetitorMap.get(CompetitorObj.id).Opportunity_Won__c == false)) 
				{
					optyIdSet.add(CompetitorObj.Opportunity__c);	   
				} 
				else if(newCompetitorMap.get(CompetitorObj.id).Competitor_New__c != CompetitorObj.Competitor_New__c &&
						newCompetitorMap.get(CompetitorObj.id).Opportunity_Won__c == true)			  
				{
					optyIdSet.add(CompetitorObj.Opportunity__c);
					if(OpptyIdAndCompNameMap.containsKey(CompetitorObj.Opportunity__c))
					{
						oldNewCompNameMap = new Map<String, String>(); 
						oldNewCompNameMap = OpptyIdAndCompNameMap.get(CompetitorObj.Opportunity__c);
						oldNewCompNameMap.put(CompetitorObj.Competitor_New__c,newCompetitorMap.get(CompetitorObj.id).Competitor_New__c);
						OpptyIdAndCompNameMap.put(CompetitorObj.Opportunity__c,oldNewCompNameMap);
					}
					else
					{
						oldNewCompNameMap = new Map<String, String>(); 
						oldNewCompNameMap.put(CompetitorObj.Competitor_New__c,newCompetitorMap.get(CompetitorObj.id).Competitor_New__c);
						OpptyIdAndCompNameMap.put(CompetitorObj.Opportunity__c,oldNewCompNameMap);
					}
				}
			}
			if(!optyIdSet.isEmpty()){
				relatedOptyMap =  new Map<Id,Opportunity>([select Id, Winning_Competitor__c from Opportunity where Id in:optyIdSet 
														   LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);			
				for(Competitor__c CompetitorObj : competitorOldMap.values()) 
				{
					String newComp = null;
					Opportunity opty = relatedOptyMap.get(CompetitorObj.Opportunity__c);
					compList = opty.Winning_Competitor__c.split(GlobalConstants.SEMICOLON);
					compSet.addAll(compList);
					if(compSet.contains(CompetitorObj.Competitor_New__c))
					{
						if(!OpptyIdAndCompNameMap.isEmpty() && OpptyIdAndCompNameMap.containsKey(CompetitorObj.Opportunity__c)
						   && OpptyIdAndCompNameMap.get(CompetitorObj.Opportunity__c).containsKey(CompetitorObj.Competitor_New__c))
						{
							if(compSet.size() > 1)
								compSet.add(OpptyIdAndCompNameMap.get(CompetitorObj.Opportunity__c).get(CompetitorObj.Competitor_New__c));
							else if(compSet.size() == 1)
								opty.Winning_Competitor__c = OpptyIdAndCompNameMap.get(CompetitorObj.Opportunity__c).get(CompetitorObj.Competitor_New__c);
						}
						else{  
							if(compSet.size() == 1 )
								opty.Winning_Competitor__c = GlobalConstants.UNKNOWN;
						} 
						compSet.remove(CompetitorObj.Competitor_New__c);
						if(!compSet.isEmpty())
						{
							for(String str:compSet)
							{
								if(newComp != Null)
									newComp = newComp + str + GlobalConstants.SEMICOLON;
								else
									newComp = str + GlobalConstants.SEMICOLON;
							}
							newComp.remove(GlobalConstants.SEMICOLON);
							opty.Winning_Competitor__c = newComp;
						}
					}
					optyToUpdate.add(opty); 
				}
			}
			if(!optyToUpdate.isEmpty())
			{
				Database.update(optyToUpdate);
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex,GlobalConstants.COMPETITORTRIGGERHELPER,GlobalConstants.PREVENT_DUPLICATE_COMPETITOR);
		}
	}
	/***********************
* Method Name: updateWinningCompetitorOnoppty
* Description: If competitor is added/ updated on closed oppty, winning comp field on oppty will be updated
* Req : 5684 sales process
* Parameters: List<Competitor__c> , Map <Id,Competitor__c> 
************************/
	public static void updateWinningCompetitorOnoppty(List<Competitor__c> competitorList, Map <Id,Competitor__c> competitorOldMap,Boolean isInsertFlag)
	{
		Map<Id, Id> CompIdAndOpptyIdMap = new Map<Id, Id>();
		Map<Id, String> compMap = new Map<Id, String>();
		Map<Id, Opportunity>  opptyMap = new Map<Id, Opportunity>();
		List<Opportunity> updateList = new List<Opportunity>();
		Set<String> allCompetitors ;
		String str = '';
		try
		{ 
			for(Competitor__c CompetitorObj : competitorList)
			{
				if (CompetitorObj.Opportunity_Won__c == true &&
					(isInsertFlag == true ||
					 competitorOldMap.get(CompetitorObj.Id).Opportunity_Won__c != CompetitorObj.Opportunity_Won__c))
				{
					CompIdAndOpptyIdMap.put(CompetitorObj.id, CompetitorObj.Opportunity__c);
					compMap.put(CompetitorObj.id,CompetitorObj.Competitor_New__c);
				}
			}
			if(!CompIdAndOpptyIdMap.isEmpty())
			{
				for(Opportunity oppObject : [select id,Winning_Competitor__c,StageName  from Opportunity 
											 where id in: CompIdAndOpptyIdMap.values() AND
											 StageName =: GlobalConstants.LOST_TO_COMPETITOR
											 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
				{
					if(!opptyMap.containsKey(oppObject.id))
						opptyMap.put(oppObject.id,oppObject);
				}
			}
			if(!opptyMap.isEmpty())
			{
				for(id compId : CompIdAndOpptyIdMap.keyset())
				{
					id oppid = CompIdAndOpptyIdMap.get(compId);
					str = opptyMap.get(oppid).Winning_Competitor__c;
		allCompetitors = new Set<String>(str.split(GlobalConstants.SEMICOLON));
					if(!allCompetitors.contains(compMap.get(compId)))
					{
						opptyMap.get(oppid).Winning_Competitor__c = opptyMap.get(oppid).Winning_Competitor__c + GlobalConstants.SEMICOLON + compMap.get(compId);
						updateList.add(opptyMap.get(oppid));
					}
				}
			}
			if(!updateList.isEmpty()){
				Database.update(updateList);
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex,GlobalConstants.COMPETITORTRIGGERHELPER,GlobalConstants.UPDATEWINNINGCOMPETITORONOPPTY);
		}
	}
}