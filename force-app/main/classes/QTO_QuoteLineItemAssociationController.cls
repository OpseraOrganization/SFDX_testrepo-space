/**
* @Name: QTO_AutomateAssociationController
* @Author: Akanksha Trivedi
* @CreateDate: 10/19/2020
* @Description: Controller for QLI association methods. 
* @CalledFrom : QTO_AutomaticAssociationScheduler
* @LastModifiedBy: Raj Kamdar
* @LastModifiedDate: 12/10/2020
* @ChangeDescription: Removed unused methods.
**/

public class QTO_QuoteLineItemAssociationController {
	
	/**
	* @description 
	* @author Akanksha Trivedi | 12-10-2020 
	* @param Customer Document ID 
	* @param List of agreement IDs 
	* @param Map of ID and agreement association wrapper.
	* @return List<QTO_Customer_Document_Agreement__c> 
	**/
	public static List<QTO_Customer_Document_Agreement__c> associateAgreementWithCD( Id customerDocId, Set<Id> agreementIdList,Map<Id,QTO_AssociationOutputWrapper.AgreementAssociationWrapper> mapAgreementWrapper){
		 return QTO_QuoteLineItemAssociationHelper.associateAgreementWithCD(customerDocId,agreementIdList,mapAgreementWrapper);
	 }

	 /**
	 * @description 
	 * @author Akanksha Trivedi | 12-10-2020 
	 * @param Customer Document ID
	 * @param Set of Quote IDs
	 * @param Map of Matched Quote References 
	 * @return List<Customer_Document_Junction__c> 
	 **/
	 public static List<Customer_Document_Junction__c> associateQuoteWithCD( Id custId ,Set<Id> quoteIdSet,Map<Id,String> mapMatchedQuoteReferences){
		return QTO_QuoteLineItemAssociationHelper.associateQuoteWithCD(custId,quoteIdSet,mapMatchedQuoteReferences);
	}

	/**
	* @description 
	* @author Akanksha Trivedi | 12-10-2020 
	* @param Customer Document ID 
	* @param Quote Ids 
	* @return Set<Id> 
	**/
	public static Set<Id> callAssociationCDToQuotes(Id custDocId,Set<Id> quoteIds){
		return QTO_QuoteLineItemAssociationHelper.callAssociationCDToQuotes(custDocId,quoteIds);
	}
	   
	/**
	* @description 
	* @author Akanksha Trivedi | 12-10-2020 
	* @param Set of Customer Document IDs 
	* @return Map<Id, List<Customer_Document_Line_Items__c>> 
	**/
	public static Map<Id,List<Customer_Document_Line_Items__c>> getAllCDLIfromCD(Set<Id> objCDOIdSet){
		return QTO_QuoteLineItemAssociationHelper.getAllCDLIfromCD(objCDOIdSet);
	}

	/**
	* @description 
	* @author Akanksha Trivedi | 12-10-2020 
	* @param Map of CDLI to QLI mappings. 
	* @return List<QTO_Customer_Document_Quote_Line__c> 
	**/
	public static List<QTO_Customer_Document_Quote_Line__c> getCustDocLineItemQuoteLine(Map<Id,List<Apttus_Proposal__Proposal_Line_Item__c>> qLICDLIMap){
		return QTO_QuoteLineItemAssociationHelper.getCustDocLineItemQuoteLine(qLICDLIMap);   
	}

	/**
	* @description 
	* @author Akanksha Trivedi | 12-10-2020 
	* @param List of customer documents. 
	* @return List<QTO_Customer_Document_Issue_Log__c> 
	**/
	public static List<QTO_Customer_Document_Issue_Log__c> getLogs(List<Customer_Document__c> customerDocList){
		return QTO_Utility.getLogs(customerDocList);
	}

	 
}