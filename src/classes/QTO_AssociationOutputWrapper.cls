/**
 * @description	   : Output wrapper for Auto Association Logic.
 * @author			: Raj Kamdar
 * @last modified on  : 12-11-2020
 * @last modified by  : Raj Kamdar
 * Modifications Log 
 * Ver   Date		 Author	   Modification
 * 1.0   11-25-2020   Raj Kamdar   Initial Version
**/
public class QTO_AssociationOutputWrapper {
	public Set<Id> setMatchedAgreementIds = new Set<Id>();
	public Set<Id> setManualAgreementIds = new Set<Id>();
	public Set<Id> setMatchedQuoteIds = new Set<Id>();
	public Boolean isManual = False;
	public List<String> listUnmatchedAgreementReferences = new List<String>();
	public List<String> listUnmatchedQuoteReferences = new List<String>();
	public List<Apttus_Proposal__Proposal__c> listMatchedQuotes = new List<Apttus_Proposal__Proposal__c>();
	public List<Apttus__APTS_Agreement__c> listMatchedAgreements = new List<Apttus__APTS_Agreement__c>();
	public List<Apttus__APTS_Agreement__c> listManualAgreements = new List<Apttus__APTS_Agreement__c>();
	public List<Customer_Document_Line_Items__c> listCDLIs = new List<Customer_Document_Line_Items__c>();
	public Map<Id,Customer_Document_Line_Items__c> mapCDLIs = new Map<Id,Customer_Document_Line_Items__c>();
	public Map<Id,String> mapMatchedQuoteReferences = new Map<Id,String>();
	public Map<Id,AgreementAssociationWrapper> mapAgreementsFetchedFromQuotes = new Map<Id,AgreementAssociationWrapper>();
	public Set<Id> setFinalQuotes = new Set<Id>();
	public Set<Id> setFinalAgreements = new Set<Id>();
	public List<Task> listTasks = new List<Task>();
	public String status;
	public List<QTO_Customer_Document_Issue_Log__c> listLogs = new List<QTO_Customer_Document_Issue_Log__c>();
	
	public class AgreementAssociationWrapper{
		public string source = '';
		public string reference = '';
	}
}