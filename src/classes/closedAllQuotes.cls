//Created by HCL for SF:00338177
public class closedAllQuotes {
  
	@InvocableMethod
		public static void executeBatchMethod(List<ID> opptyID) {
		
		   system.debug('opptyID=====invoc'+opptyID);
		   Database.executeBatch(new closedQuotesOnOpportunity(opptyId),50);
		  
		}
		
}