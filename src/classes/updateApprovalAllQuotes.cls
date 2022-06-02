//Created by HCL for SF:00869261
public class updateApprovalAllQuotes {
  
	@InvocableMethod
		public static void executeBatchMethod(List<ID> opptyID) {
		
		   system.debug('opptyID=====invoc'+opptyID);
		   Database.executeBatch(new approvalQuotesOnOpportunity(opptyId),50);
		  
		}
		
}