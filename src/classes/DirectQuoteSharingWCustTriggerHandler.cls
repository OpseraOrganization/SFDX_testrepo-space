public with sharing  class DirectQuoteSharingWCustTriggerHandler{

  public static void afterInsertDirectQuoteShares(List<Apttus_Proposal__Proposal__c > quoteList){
  try{
		if(!quoteList.isEmpty() && quoteList!=null){
			DirectQuoteSharingWCustTriggerHelper.shareDirectQuoteWithCustomer(quoteList);
		}
		}
		catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.quoteHandler,CSWXGlobalConstant.updateQuoteShare);
			   
		}
  
  }
 }