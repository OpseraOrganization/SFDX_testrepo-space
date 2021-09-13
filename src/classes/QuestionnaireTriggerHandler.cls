/***********************************
Class Name: QuestionnaireTriggerHandler
Author: Accenture
Reason: Sales Process : This is to lock relatedList of opportunity, this is handler class called from trigger.
Created Date: Feb / 2017 
Sales Process: Req 1381 Sprint 5 hypercare Fix 21/04/2017
******************************************/
public with sharing class QuestionnaireTriggerHandler{
	
	/***********************
	* Method Name: beforeInsertOperation
	* Description: Sales Process : lock relatedList of opportunity before update
	* Parameters: List of Questionnaire__c
	************************/	   
	public static void beforeInsertOperation(List<Questionnaire__c> QuesList){ 
		String profileName = [Select Id,Name from Profile where Id =: userinfo.getProfileId()].Name;
		system.debug('ProfileName'+profileName);
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && Admin_Profiles__c.getInstance(profileName) == null){
			QuestionnaireTriggerHelper.retrictQuestionnaire(QuesList);
		}
	}
	
	/***********************
	* Method Name: beforeUpdateOperation
	* Description: Sales Process : lock relatedList of opportunity before update
	* Parameters: List of Questionnaire__c
	************************/	   
	public static void beforeUpdateOperation(List<Questionnaire__c> QuesList){ 
		String profileName = [Select Id,Name from Profile where Id =: userinfo.getProfileId()].Name;
		system.debug('ProfileName'+profileName);
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && Admin_Profiles__c.getInstance(profileName) == null){
			QuestionnaireTriggerHelper.retrictQuestionnaire(QuesList);
		}
	}
	
	 /***********************
	* Method Name: beforeDeleteOperation
	* Description: Sales Process : lock relatedList of opportunity before update
	* Parameters: List of Questionnaire__c
	************************/	   
	public static void beforeDeleteOperation(List<Questionnaire__c> QuesList){ 
		String profileName = [Select Id,Name from Profile where Id =: userinfo.getProfileId()].Name;
		system.debug('ProfileName'+profileName);
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && Admin_Profiles__c.getInstance(profileName) == null){
			QuestionnaireTriggerHelper.retrictQuestionnaire(QuesList);
		}
	}
}