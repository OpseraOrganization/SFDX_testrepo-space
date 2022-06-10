public with sharing class DS_NewCDAssocBtnController {
	@AuraEnabled
	public static Apttus_Proposal__Proposal__c getQuoteProposalRecord(String quoteIdStr) {
		Apttus_Proposal__Proposal__c quoteProposal = null;
		if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) {
			List<Apttus_Proposal__Proposal__c> quoteProposalList = [SELECT Id, Nokia_Customer_Document_ID__c, Nokia_Customer_Document_ID__r.Name FROM Apttus_Proposal__Proposal__c WHERE Id = :quoteIdStr LIMIT 1];
			if(!quoteProposalList.isEmpty()) {
	quoteProposal = quoteProposalList[0];
			}
		}
		return quoteProposal;
	}

	@AuraEnabled
	public static void addAssociationToQuoteProposal(String quoteIdStr, String customerDocumentIdStr) {
		Apttus_Proposal__Proposal__c quoteProposalRecord = getQuoteProposalRecord(quoteIdStr);
		String errorMsg = '';
		try {
			if (quoteProposalRecord != null) {
	quoteProposalRecord.Nokia_Customer_Document_ID__c = customerDocumentIdStr;
	Database.update(quoteProposalRecord);
			} else {
	AuraHandledException e = new AuraHandledException('Invalid Quote/Proposal.');
	e.setMessage('Invalid Quote/Proposal.');
	throw e;
			}
		} catch (DMLException e) {
			for (Integer i = 0; i < e.getNumDml(); i++) {
	//Get Validation Rule & Trigger Error Messages
	errorMsg =+ e.getDmlMessage(i) + '\n' ;
			}
			//throw DML exception message
			throw new AuraHandledException(errorMsg);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
}