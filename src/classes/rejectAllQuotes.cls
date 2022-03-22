// created by HCL for SF 00200149
public class rejectAllQuotes {
  
	@InvocableMethod
		public static void executeBatchMethod(List<ID> opptyID) {
		
		  system.debug('opptyID'+opptyID);
		  Database.executeBatch(new rejectQuotesOnOpportunity(opptyId), 50);
		}
}