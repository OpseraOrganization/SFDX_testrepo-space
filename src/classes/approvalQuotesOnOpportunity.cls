//Created by HCL for SF:00869261
 
global class approvalQuotesOnOpportunity implements Database.Batchable<sObject>, Database.Stateful {
	Public List<ID> oppID = new List<ID>(); 
	public List<Id> allQuotes = new List<Id>();
	
	public approvalQuotesOnOpportunity(List<Id> setIds) {
		oppID.addAll(setIds);
	}
		
	global Database.QueryLocator start(Database.BatchableContext BC) {
		
		String query = 'select id,Quote_Type__c,Quote_Status__c,NokiaCPQ_Update_Quote_Record_Type__c,RecordTypeId,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c=:oppID';
		return Database.getQueryLocator(query);
		
	}
	
	global void execute(Database.BatchableContext BC, List<Apttus_Proposal__Proposal__c> quotes) {
	  
		List<Apttus_Proposal__Proposal__c> allQuotes = new List<Apttus_Proposal__Proposal__c>();
		
		for (Apttus_Proposal__Proposal__c quote : quotes)
		{	
			if(quote.Apttus_Proposal__Approval_Stage__c=='In Review' && quote.Quote_Type__c.contains('CPQ')){	   
				quote.Apttus_Proposal__Approval_Stage__c = 'Approved';
				quote.NokiaCPQ_Update_Quote_Record_Type__c= True;
				quote.Quote_Status__c='Submit';
			}	 
			if(quote.NokiaCPQ_Update_Quote_Record_Type__c==true){
				quote.NokiaCPQ_Update_Quote_Record_Type__c=false;
			}
			
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