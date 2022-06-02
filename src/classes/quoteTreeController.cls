/*********************************
  * Param: NA
  * Return: List of Proposal with Rebided Proposals.  
  * Calling comp: quoteTree LWC button
  **********************************/
public with sharing class quoteTreeController {
	@AuraEnabled(cacheable=true)
	public static List < Apttus_Proposal__Proposal__c > fetchQuote(Id recordId) {  
		   
		return [ Select  id,Quote_Type__c,Apttus_Proposal__Proposal_Name__c,Apttus_Proposal__Primary__c,Apttus_Proposal__Proposal_Expiration_Date__c,Parent_Rebid_Quote__r.Name,Parent_Rebid_Quote__c,Apttus_Proposal__Approval_Stage__c,NokiaCPQ_Proposal_Id__c,Name,(Select id,Apttus_Proposal__Proposal_Name__c,Apttus_Proposal__Primary__c,Apttus_Proposal__Proposal_Expiration_Date__c,Name,Parent_Rebid_Quote__r.Name,Parent_Rebid_Quote__c,Apttus_Proposal__Approval_Stage__c,NokiaCPQ_Proposal_Id__c from Quote_Proposal__r Where  Parent_Rebid_Quote__c!=null ORDER BY NokiaCPQ_Proposal_Id__c DESC) from Apttus_Proposal__Proposal__c Where Apttus_Proposal__Opportunity__c=:recordId and Parent_Rebid_Quote__c=null ORDER BY CreatedDate DESC]  ;
	}
}