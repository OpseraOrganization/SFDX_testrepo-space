/**
 * @description	   : Final DML wrapper for Auto Association.
 * @author			: Raj Kamdar
 * @group			 : 
 * @last modified on  : 12-08-2020
 * @last modified by  : Raj Kamdar
 * Modifications Log 
 * Ver   Date		 Author	   Modification
 * 1.0   11-25-2020   Raj Kamdar   Initial Version
**/
public class QTO_AssociationDMLWrapper {
	public List<Customer_Document_Junction__c> listQuoteJunction = new List<Customer_Document_Junction__c>();
	 public List<QTO_Customer_Document_Agreement__c> listAgreementJunction = new List<QTO_Customer_Document_Agreement__c>();
	 public List<QTO_Customer_Document_Quote_Line__c> listQLIJunction = new List<QTO_Customer_Document_Quote_Line__c>();
	
	 public List<sObject> listCDLIs = new List<sObject>();

	 public List<Customer_Document_Junction__c> listExistingQuoteJunction = new List<Customer_Document_Junction__c>();
	 public List<QTO_Customer_Document_Agreement__c> listExistingAgreementJunction = new List<QTO_Customer_Document_Agreement__c>();
	 public List<QTO_Customer_Document_Quote_Line__c> listExistingQLIJunction = new List<QTO_Customer_Document_Quote_Line__c>();
	 public List<QTO_Customer_Document_Issue_Log__c> listLogs = new List<QTO_Customer_Document_Issue_Log__c>();
	 public List<Apttus_Proposal__Proposal__c> listQuotesToUpdate = new List<Apttus_Proposal__Proposal__c>();
		public List<QTO_Customer_Document_Issue_Log__c> listExistingLogs = new List<QTO_Customer_Document_Issue_Log__c>();
	 public Customer_Document__c customerDocument = new Customer_Document__c();
	 public List<Task> listTasks = new List<Task>();
	 public List<Task> listExistingTasks = new List<Task>();
}