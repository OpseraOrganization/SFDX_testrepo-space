/******************************************************************************************************
Name : CustomerDocumentJunctionTriggerHanlder
Created Date: 7 July 2019
Created by: Accenture
Modified by: Györgyi Kovács, Nokia
Description : This class is a handler class for customerDocumentJunctionTrigger
*********************************************************************************************************/
public class CustomerDocumentJunctionTriggerHandler {
	
	/***********************************************
	 Name : deleteQuoteProposalAssociation
	 Descritpion: This method is used to delete NokiaCustomerDocumentID from Quote/Proposal when related customer document junction record is deleted
	 Parameter : List<Customer_Document__c> junctionRecords
	 *************************************************/
	public static void deleteQuoteProposalAssociation(List<Customer_Document_Junction__c> junctionRecords) {
		try {
			Set<String> quoteProposalIds = new Set<String>();
			List<Apttus_Proposal__Proposal__c> updateQuoteList = new List<Apttus_Proposal__Proposal__c>();

			for(Customer_Document_Junction__c cdj : junctionRecords) {
	if(cdj.Quote_Proposal__c != null) {
		quoteProposalIds.add(cdj.Quote_Proposal__c);
	}
			}

			for(Apttus_Proposal__Proposal__c quote : [SELECT Id, Nokia_Customer_Document_ID__c
				  FROM Apttus_Proposal__Proposal__c
				  WHERE Id = :quoteProposalIds ]) {
	quote.Nokia_Customer_Document_ID__c = null;
	updateQuoteList.add(quote);
			}

			if(!updateQuoteList.isEmpty() && checkRecursive.runOnce()) {
	Database.update(updateQuoteList, false);
			}
		} catch(Exception ex) {
			ExceptionHandler.addException(ex, CSWXGlobalConstant.CustomerDocumentJunctionTriggerHandler, CSWXGlobalConstant.deleteQuoteProposalAssociation);
		}
	}
}