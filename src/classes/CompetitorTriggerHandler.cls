/***********************************
Class Name: CompetitorTriggerHandler
Author: Accenture
Reason: Sales Process : Handler Class for Competitor Trigger
Created Date:Feb / 2017 
******************************************/
public with sharing class CompetitorTriggerHandler{
	
	/***********************
* Method Name: beforeInsertOperation
* Description: Sales Process : Handler method of CompetitorTrigger before insert
* Parameters: List of Competitor__c
************************/  
	public static void beforeInsertOperation(List<Competitor__c> compList){		
		Map<ID, Competitor__c> competitorOldMap = new Map<ID, Competitor__c>();
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) ){		  
			CompetitorTriggerHelper.preventDuplicateCompetitor(compList, competitorOldMap, true);
			CompetitorTriggerHelper.wonShareAllocationValidation(compList, competitorOldMap, true);
		}
	}
	
	/***********************
* Method Name: beforeUpdateOperation
* Description: Sales Process : Handler method of CompetitorTrigger before update
* Parameters: List of Competitor__c, Map<ID, Competitor__c>
************************/		
	public static void beforeUpdateOperation(List<Competitor__c> compList, Map<ID, Competitor__c> competitorOldMap){ 
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) ){		  
			CompetitorTriggerHelper.preventDuplicateCompetitor(compList, competitorOldMap,false);
			CompetitorTriggerHelper.wonShareAllocationValidation(compList, competitorOldMap, false);
		}
	}
	
	/***********************
* Method Name: beforeDeleteOperation
* Description: Sales Process : Handler method of CompetitorTrigger before delete
* Parameters: List of Competitor__c
************************/		
	public static void beforeDeleteOperation(Map<ID, Competitor__c> compOldMap){ 
		Map<ID, Competitor__c> compNewMap = new Map<ID, Competitor__c>();
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) ){			
			CompetitorTriggerHelper.onDeleteCompetitorUpdateOptyWinningCompetitor(compNewMap, compOldMap, true); 
		}
	} 
	/***********************
* Method Name: afterInsertOperation
* Description: Sales Process : Handler method of CompetitorTrigger after insert
* Parameters: List of Competitor__c
************************/  
	public static void afterInsertOperation(List<Competitor__c> compList){ 
		Map<ID, Competitor__c> competitorOldMap = new Map<ID, Competitor__c>();
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) ){ 
			CompetitorTriggerHelper.updateWinningCompetitorOnoppty(compList, competitorOldMap, true);
		}
	}
	/***********************
* Method Name: afterUpdateOperation
* Description: Sales Process : Handler method of CompetitorTrigger after update
* Parameters: List of Competitor__c, Map<ID, Competitor__c>
************************/		
	public static void afterUpdateOperation(Map<Id, Competitor__c> compNewMap, Map<ID, Competitor__c> competitorOldMap){ 
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) ){  
			CompetitorTriggerHelper.updateWinningCompetitorOnoppty(compNewMap.values(), competitorOldMap, false);		   
			CompetitorTriggerHelper.onDeleteCompetitorUpdateOptyWinningCompetitor(compNewMap, competitorOldMap, false);
		}
	}
}