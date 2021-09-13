//Created by HCL for SF:00338177
 
global class closedQuotesOnOpportunity implements Database.Batchable<sObject>, Database.Stateful {
	Public List<ID> oppID = new List<ID>(); 
	public List<Id> allQuotes = new List<Id>();
	
	public closedQuotesOnOpportunity(List<Id> setIds) {
		oppID.addAll(setIds);
	}
		
	global Database.QueryLocator start(Database.BatchableContext BC) {
		
		String query = 'select id,Quote_Type__c,Quote_Status__c,RecordTypeId,isCQ__c,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c=: oppID and Quote_Type__c != \'Direct DS\'';
		return Database.getQueryLocator(query);
		
	}
	
	global void execute(Database.BatchableContext BC, List<Apttus_Proposal__Proposal__c> quotes) {
	  
		List<Apttus_Proposal__Proposal__c> allQuotes = new List<Apttus_Proposal__Proposal__c>();
		
		for (Apttus_Proposal__Proposal__c quote : quotes)
		{ 
			quote.Apttus_Proposal__Approval_Stage__c = 'Closed(Not Won)';
			quote.Quote_Status__c = 'Closed';
			allQuotes.add(quote);
		}
		
		try  {
			if(allQuotes.size()>0)
				database.update(allQuotes);
		} catch(Exception e){
	 }  
	
	}   
	
	global void finish(Database.BatchableContext BC) {
	}
 }