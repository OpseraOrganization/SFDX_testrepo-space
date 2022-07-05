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
		List<Accreditation__c> accreditation = [Select Account_ID__c,Portfolio__c from Accreditation__c where id in  :accredtationId Limit :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
		Accreditation__c acc = accreditation.get(0);
		if(acc.Account_ID__c != null && acc.Portfolio__c != null)
		{
			String accountId = acc.Account_ID__c;
			String portfolio = acc.Portfolio__c;

			//Modified for FN restructuring by Christie JJ
			//Start
			//String query = 'SELECT Id,NokiaCPQ_Needs_Reprice__c FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Account__c = \'' +String.escapeSingleQuotes(accountId) + '\' AND NokiaCPQ_Portfolio__c = \'' +String.escapeSingleQuotes(portfolio) + '\'';
			String query = 'SELECT Id,NokiaCPQ_Needs_Reprice__c FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Account__c = \'' +String.escapeSingleQuotes(accountId) + '\' AND (NokiaCPQ_Portfolio__c = \'' +String.escapeSingleQuotes(portfolio) + '\' OR CPQ_SubPortfolio__c INCLUDES (\''+String.escapeSingleQuotes(portfolio)+'\'))';
			//End

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
		set<id> quoteAccID = new set<id>();
		set<string> portfolioSet = new Set<string>();
		Map<string, set<string> > accPortfolioMap = new Map<string, set<string> >();
		for(Accreditation__c accr : accredForRepricing) {
			quoteAccID.add(accr.Partner__c);
			portfolioSet.add(accr.Portfolio__c);
			if(!accPortfolioMap.containsKey(accr.Partner__c)) {
	accPortfolioMap.put(accr.Partner__c, new set<string>());
			}
			accPortfolioMap.get(accr.Partner__c).add(accr.Portfolio__c);
		}

		Set<string> quoteApprovalStages = new Set<string> {Nokia_CPQ_Constants.QUOTEAPPROVED,Nokia_CPQ_Constants.QUOTEEXPIRED,Nokia_CPQ_Constants.ACCEPTED_STRING, Nokia_CPQ_Constants.Closed_Not_Won};
		String queryString = 'SELECT Id,Quote_Type__c, NokiaCPQ_Needs_Reprice__c, Apttus_Proposal__Account__c, NokiaCPQ_Portfolio__c,CPQ_SubPortfolio__c FROM Apttus_Proposal__Proposal__c WHERE NokiaCPQ_Needs_Reprice__c = false AND Quote_Type__c = \'Indirect CPQ\' AND Apttus_Proposal__Account__c IN : quoteAccID AND Apttus_Proposal__Approval_Stage__c NOT IN :quoteApprovalStages AND (NokiaCPQ_Portfolio__c IN :portfolioSet OR CPQ_SubPortfolio__c INCLUDES (';
		for(string port : portfolioSet) {
			queryString += '\'' + port + '\',';
		}
		Integer remainingRows = (Limits.getLimitQueryRows() - Limits.getQueryRows());
		queryString = queryString.removeEnd(',') +')) Limit :remainingRows';
		system.debug('updateQuotesInBulk>>>' + queryString);
		String query = '';
		for(Apttus_Proposal__Proposal__c quote : (List<Apttus_Proposal__Proposal__c>)Database.query(queryString) ) {
			for (string portfolio : Nokia_CPQ_Utility.getPortfolio(quote)) {
	if(accPortfolioMap.get(quote.Apttus_Proposal__Account__c).contains(portfolio)) {
		query+= quote.Id + Nokia_CPQ_Constants.QUERY1;
		break;
	}
			}
		}
		if(string.isNotBlank(query)) {
			query+= Nokia_CPQ_Constants.QUERY2;
			NeedsRepriceBatch repriceBatch = new NeedsRepriceBatch('SELECT Id,NokiaCPQ_Needs_Reprice__c FROM Apttus_Proposal__Proposal__c WHERE Id in (\'' + query);
			system.debug('updateQuotesInBulk>>> SELECT Id,NokiaCPQ_Needs_Reprice__c FROM Apttus_Proposal__Proposal__c WHERE Id in (\'' + query);
			Database.executeBatch(repriceBatch, 10);
		}

	}
	catch(Exception e)
	{
		ExceptionHandler.addException(e,NeedsRepriceAccreditationInvocable.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	}

}

}