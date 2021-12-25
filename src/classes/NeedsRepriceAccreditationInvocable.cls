/*************************************************************
@Name: NeedsRepriceAccreditationInvocable
@Author: Accenture
@Description: This class contains Logic for calling batch for quotes in case of accreditation changes 
******************************************************************/
public without sharing class NeedsRepriceAccreditationInvocable {
	/***************************************************
	* Description : method used to call batch for quotes affected by accreditation changes
	* @param accredtationId
	* @return NA
	* @throws NA
	***************************************************/  
	@InvocableMethod(label='Needs Reprice Accreditation' description='Returns the list of account names corresponding to the specified account IDs.')
	public static void updateQuotes(List<String> accredtationId) 
	{
		try{
			List<Apttus_Proposal__Proposal__c> quotesToUpdate = new List<Apttus_Proposal__Proposal__c>();
			List<Accreditation__c> accreditation = [Select  Account_ID__c,Portfolio__c from Accreditation__c where id in  :accredtationId Limit :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
			Accreditation__c acc = accreditation.get(0); 
			if(acc.Account_ID__c != null && acc.Portfolio__c != null)
			{	
				String accountId = acc.Account_ID__c;
				String portfolio = acc.Portfolio__c;
				
				String query = 'SELECT Id,NokiaCPQ_Needs_Reprice__c FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Account__c = \'' +String.escapeSingleQuotes(accountId) + '\' AND NokiaCPQ_Portfolio__c = \'' +String.escapeSingleQuotes(portfolio) + '\'';
				NeedsRepriceBatch repriceBatch = new NeedsRepriceBatch(query);
				Database.executeBatch(repriceBatch, 1); 
			}   
		}
		
		catch(Exception e)
		{
			ExceptionHandler.addException(e,NeedsRepriceAccreditationInvocable.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
		}
	}
	/***************************************************
	* Description : method used to call batch for quotes affected by accreditation changes
	* @param List<Accreditation__c> accredForRepricing
	* @return NA
	* @throws NA
	****************************************************/
	public static void updateQuotesInBulk(List<Accreditation__c> accredForRepricing){
		try{
			//system.debug('accredForRepricing---->'+accredForRepricing);
			set<id> quoteAccID = new set<id>();
			list<id> quotesToUpdate = new list<id>();
			map<id, map<string, list<id>>> quoteMap =  new map<id, map<string, list<id>>>();
			list<id> quotelist;
			map<string, list<id>> porttoQuote;
			
			
			for(Accreditation__c accred : accredForRepricing){
				quoteAccID.add(accred.partner__C);
			}
			
			for(Apttus_Proposal__Proposal__c quote : [SELECT Id, NokiaCPQ_Needs_Reprice__c, Apttus_Proposal__Account__c, NokiaCPQ_Portfolio__c FROM Apttus_Proposal__Proposal__c where Apttus_Proposal__Account__c in: quoteAccID Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())] ){
				quotelist = new list<id>();
				porttoQuote = new map<string, list<id>>();
				if(quoteMap.containsKey(quote.Apttus_Proposal__Account__c)){
					porttoQuote = quoteMap.get(quote.Apttus_Proposal__Account__c);
					if(quoteMap.get(quote.Apttus_Proposal__Account__c).containsKey(quote.NokiaCPQ_Portfolio__c)){
						quotelist = quoteMap.get(quote.Apttus_Proposal__Account__c).get(quote.NokiaCPQ_Portfolio__c);
					}
				}
				quotelist.add(quote.Id);
				porttoQuote.put(quote.NokiaCPQ_Portfolio__c, quotelist);
				quoteMap.put(quote.Apttus_Proposal__Account__c, porttoQuote);
				
			}
			
			for(Accreditation__c accr : accredForRepricing){
					quotesToUpdate.addall(quoteMap.get(accr.partner__C).get(accr.Portfolio__c));	
			} 
			
			//system.debug('quotesToUpdate--->'+quotesToUpdate);
			
			if (!quotesToUpdate.isEmpty() ){
			
				String query = 'SELECT Id,NokiaCPQ_Needs_Reprice__c FROM Apttus_Proposal__Proposal__c WHERE Id in (\'';
				Integer count = 0;
				//add quote Ids in IN query
				for(Id idStr: quotesToUpdate)
				{	
					if(count != quotesToUpdate.size()-1){
						query+= idStr+Nokia_CPQ_Constants.QUERY1;
					}
					else{
						query+= idStr+Nokia_CPQ_Constants.QUERY2;   
					}
	
					count++;
					
				}
				//system.debug('query ---->'+query);
				
				
				NeedsRepriceBatch repriceBatch = new NeedsRepriceBatch(query);
				//system.debug('repriceBatch ---->'+repriceBatch);
				Database.executeBatch(repriceBatch, 10); 
			}
			//system.debug('repriceBatch end ---->');
			
		}
		catch(Exception e)
		{
			ExceptionHandler.addException(e,NeedsRepriceAccreditationInvocable.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
		}
		
	}
	
}