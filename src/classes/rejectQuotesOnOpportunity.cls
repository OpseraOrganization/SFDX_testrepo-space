//Created by HCL for SF:00200149

global class rejectQuotesOnOpportunity implements Database.Batchable<sObject>, Database.Stateful {
	Public List<ID> oppID = new List<ID>(); 
	public List<Id> allQuotes = new List<Id>();
	
	public rejectQuotesOnOpportunity(List<Id> setIds) {
		oppID.addAll(setIds);
		system.debug('setIds'+setIds);
		system.debug('setParamsoppID'+oppID);
	}
		
	global Database.QueryLocator start(Database.BatchableContext BC) {
		system.debug('opptyID'+oppID);
		
		String query = 'select id,LOA_Status__c,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c=: oppID and Quote_Type__c = \'Direct DS\'';
		system.debug('Database.getQueryLocator(query)'+Database.getQueryLocator(query));
		return Database.getQueryLocator(query);
		
	}
	
	global void execute(Database.BatchableContext BC, List<Apttus_Proposal__Proposal__c> quotes) {
		system.debug('@@@@'+quotes);
	  
		List<Apttus_Proposal__Proposal__c> allQuotes = new List<Apttus_Proposal__Proposal__c>();
		
		for (Apttus_Proposal__Proposal__c quote : quotes)
		{ 
			system.debug('@@@@'+quote.id);
			quote.Apttus_Proposal__Approval_Stage__c = 'Rejected';
			quote.LOA_Status__c = 'Rejected';
			allQuotes.add(quote);
		}
		
		try  {
			if(allQuotes.size()>0)
				database.update(allQuotes);
		} catch(Exception e){
		   System.debug(e.getMessage());
	  }  
	
	}   
	
	global void finish(Database.BatchableContext BC) {
	}
 }