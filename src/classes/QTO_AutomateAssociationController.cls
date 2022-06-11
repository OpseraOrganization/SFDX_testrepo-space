/**
* @Name: QTO_AutomateAssociationController
* @Author: Raj Kamdar
* @CreateDate: 11/25/2020
* @Description: Controller for automatic association methods. 
* @CalledFrom : QTO_AutomaticAssociationScheduler
* @LastModifiedBy: Raj Kamdar
* @LastModifiedDate: 12/10/2020
* @ChangeDescription: Removed unused methods.
**/

public class QTO_AutomateAssociationController {


	/**
	* @description : Fetches existing quote lines associated with given Customer Document.
	* @author Raj Kamdar | 11-25-2020 
	* @param customerDocumentId 
	* @return List<QTO_Customer_Document_Quote_Line__c> 
	**/
	public static List<QTO_Customer_Document_Quote_Line__c> fetchExistingQLIAssociations(Id customerDocumentId){
		return QTO_AutomateAssociationHelper.fetchExistingQLIAssociations(customerDocumentId);
	}

	/**
	* @description : Fetches existing logs associated with given Customer Document.
	* @author Raj Kamdar | 11-25-2020 
	* @param customerDocumentId 
	* @return List<QTO_Customer_Document_Issue_Log__c> 
	**/
	public static List<QTO_Customer_Document_Issue_Log__c> fetchExistingLogs(Id customerDocumentId){
		return QTO_AutomateAssociationHelper.fetchExistingLogs(customerDocumentId);
	}
	
	/**
	* @description : Logic for auto-association of a customer document.
	* @author Raj Kamdar | 11-25-2020 
	* @param customerDocList 
	* @return Map<Id, QTO_AssociationDMLWrapper> 
	**/
	public static  QTO_AssociationDMLWrapper autoAssociateCustomerDocuments(List<Customer_Document__c> customerDocList){
		return QTO_AutomateAssociationHelper.autoAssociateCustomerDocuments(customerDocList);
	}
}