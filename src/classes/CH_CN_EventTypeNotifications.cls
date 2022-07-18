/*************************************************************************************************
* Class Name : CH_CN_EventTypeNotifications
* Created Date: 28 July 2020
* Created By : TCS
* Description: Batch class for Case Notifications
* Last Modified by: 
* Last Modified Date: 
* Description : 
*************************************************************************************************/
global class CH_CN_EventTypeNotifications implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{
	
	string newCaseQuery;
	Map<Id,Integer> caseEventMap = new Map<Id,Integer>();
  
	global CH_CN_EventTypeNotifications(Map<Id,Integer> caseEventMap){
		this.caseEventMap= caseEventMap;
	
	}
	global Database.QueryLocator Start(Database.BatchableContext BC){
		
		set<Id> caseId = caseEventMap.keySet();
		newCaseQuery = Label.CH_CN_SubscriptionNotification;
		newCaseQuery = newCaseQuery+' AND Id IN :caseId';
		Database.QueryLocator d;
		d =Database.getQueryLocator(newCaseQuery);	  
		return d;
	}
	global void execute(Database.BatchableContext BC, List<Case> newCaseList){}
	
	global void finish(Database.BatchableContext BC){}
}