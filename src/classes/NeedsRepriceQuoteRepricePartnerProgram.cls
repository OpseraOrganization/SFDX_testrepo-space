public class NeedsRepriceQuoteRepricePartnerProgram {
	
	@InvocableMethod(label='Needs Reprice Partner Program' description='Returns the list of account names corresponding to the specified account IDs.')
	 public static void updateQuotes(List<String> partnerProgramLevel)
	  {
	   String partnerProgramLevelValue = partnerProgramLevel.get(0);   
	   String query = 'SELECT Id,NokiaCPQ_Needs_Reprice__c FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Account__r.Partner_Program__c = \'' +String.escapeSingleQuotes(partnerProgramLevelValue) + '\'';  
	   NeedsRepriceBatch repriceBatch = new NeedsRepriceBatch(query);
	   Database.executeBatch(repriceBatch, 1);   
	  }
}