public class NeedsRepriceAccountInvocable {
	@InvocableMethod(label='Needs Reprice' description='Returns the list of account names corresponding to the specified account IDs.')
	public static void updateQuotes(List<String> accountid) 
	{
	   String accountidValue = accountid.get(0);   
	   String query = 'SELECT Id,NokiaCPQ_Needs_Reprice__c,Direct_Price_List_Number__c,Price_List__c,Apttus_Proposal__Account__r.NokiaCPQ_Applicable_Price_Lists__c,CurrencyIsoCode,Quote_Type__c,Apttus_QPConfig__PriceListId__c,Apttus_QPConfig__PriceListId__r.Name,Apttus_Proposal__Approval_Stage__c FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Account__c = \'' +String.escapeSingleQuotes(accountidValue) + '\'';
	   
	   NeedsRepriceBatch repriceBatch = new NeedsRepriceBatch(query,Nokia_CPQ_Constants.OBJECT_ACCOUNT);
	   Database.executeBatch(repriceBatch, 1); 
	}
}