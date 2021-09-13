/**
 * @description	   : This Class acts as Wrapper and Calls Logic that maps CustomerDocumentLineItem to QuoteLineItem. 
 *				This class is called from QTO_ManualAssociationControllerHelper.
 * @author			: Raj Kamdar
 * @group			 : 
 * @last modified on  : 11-25-2020
 * @last modified by  : Raj Kamdar
 * Modifications Log 
 * Ver   Date		 Author	   Modification
 * 1.0   11-25-2020   Raj Kamdar   Initial Version
**/
public class QTO_ManualCDItemToQuoteItemQueue implements Queueable{

	private Set<Id> quoteIdSet = new Set<Id>();
	private Customer_Document__c custDoc;
	public QTO_ManualCDItemToQuoteItemQueue(List<Apttus_Proposal__Proposal__c> records, Customer_Document__c cdObj) {
		system.debug('recored==='+records);
		for(Apttus_Proposal__Proposal__c quote :records){
			this.quoteIdSet.add(quote.id);
		}   
		this.custDoc = cdObj;
	}
	
	 /**
	* @description: Queueable method calls logic that maps CustomerDocumentLineItem to QuoteLineItem
	* @author: Raj Kamdar
	* 
	**/
	public void execute(QueueableContext context) {
		
		 QTO_AssociationDMLWrapper outputWrapper = new QTO_AssociationDMLWrapper(); 
		 List<Customer_Document__c> custDocList = new List<Customer_Document__c>();
		 // This method would initate Mapping of Customer-DocumentLineItem to QuoteLineItem
		 Set<ID> setAdditionalQuoteIds =  QTO_QuoteLineItemAssociationHelper.callAssociationCDToQuotes(custDoc.id, quoteIdSet);
		// This method would fetch existing mapping of CustomerDocumentLineITem with QuoteLineItem 
		// This is used to delete the existing mapping in Juntion Object (QTO_Customer_Document_Quote_Line__c)
		 outputWrapper.listExistingQLIJunction = QTO_AutomateAssociationController.fetchExistingQLIAssociations(custDoc.id);
		 // This method creates entry in Junction Object (QTO_Customer_Document_Quote_Line__c)
		 outputWrapper.listQLIJunction =  QTO_QuoteLineItemAssociationController.getCustDocLineItemQuoteLine(QTO_AutomateAssociationHelper.finalQLIForAssociationCDLIMap);
		 
		 // this method fetches existing logs.
		 outputWrapper.listExistingLogs = QTO_AutomateAssociationController.fetchExistingLogs(custDoc.id);
		 custDocList.add(custDoc);
		 // this method would get new logs.
		 outputWrapper.listLogs =QTO_QuoteLineItemAssociationController.getLogs(custDocList);
		
		try{
			if(outputWrapper.listExistingQLIJunction.size()>0){
			delete outputWrapper.listExistingQLIJunction;
			}
			if(outputWrapper.listQLIJunction.size()>0){
				insert outputWrapper.listQLIJunction;
			}
			if(outputWrapper.listExistingLogs.size()>0){
				delete outputWrapper.listExistingLogs;
			}
			if(outputWrapper.listLogs.size()>0){
				insert outputWrapper.listLogs;
			} 
			// Add Try/Catch
			Customer_Document__c doc = new Customer_Document__c();
			doc.QTO_InAssociationProcess__c = false;
			doc.id =custDoc.id;
			update doc;
		}catch(QTO_CustomException e){
			throw new QTO_CustomException('Error occurred while mapping CustomerDocumentLineItem to QuoteLineItem. \nDetails: '+e.getMessage());
		}
		
	}
	
   
}