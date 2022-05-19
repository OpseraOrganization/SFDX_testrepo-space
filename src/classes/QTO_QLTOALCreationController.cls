/*********************************************************************
* Class Name  : QTO_QLTOALCreationController
* Created Date: 20 Dec 2021
* Created By  : Shaik Johny Basha
* Description : create Agreement Lines from QuoteLines 
*******************************************************************/
public with sharing class QTO_QLTOALCreationController {
	
	@AuraEnabled
	public static Boolean quoteStatus(Id quoteId) {
		Apttus_Proposal__Proposal__c proposal = [
			SELECT Apttus_Proposal__Approval_Stage__c 
			FROM Apttus_Proposal__Proposal__c
			WHERE Id=: quoteId];
		
		Boolean isApproved = proposal.Apttus_Proposal__Approval_Stage__c == 'Approved' ? true : false;
		return isApproved;
	}
	
	@AuraEnabled
	public static void createAgreementLines( String agrId, Id quoteId, Id cusDocId) {   
		System.debug('agrId -->'+agrId);
		System.debug('quoteId ...'+quoteId);
		System.debug('cusDocId ...'+cusDocId);
		QTO_QLTOALCreationHelper.createAgreementLines(agrId, quoteId, cusDocId);
	}
	
}